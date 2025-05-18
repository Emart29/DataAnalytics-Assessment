-- Categorize customers based on their average number of transactions per month 
-- and compute the number of customers in each category along with the average transactions per month.

SELECT 
    -- Defining the frequency category based on average monthly transactions
    CASE
        WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
        WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,

    -- Count of customers in each frequency category
    COUNT(*) AS customer_count,

    -- Calculating the average number of transactions per month for the category
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month

FROM (
    -- Subquery to Calculate transaction statistics per customer
    SELECT 
        UC.id,  -- Customer ID

        -- Total number of transactions for the customer
        COUNT(*) AS total_transactions,

        -- Number of active months based on the difference between first and last transaction
        GREATEST(TIMESTAMPDIFF(MONTH, MIN(SSA.transaction_date), MAX(SSA.transaction_date)), 1) AS active_months,

        -- Average transactions per month (ensuring division by at least 1 month)
        COUNT(*) / GREATEST(TIMESTAMPDIFF(MONTH, MIN(SSA.transaction_date), MAX(SSA.transaction_date)), 1) AS avg_txn_per_month

    FROM 
        adashi_staging.savings_savingsaccount AS SSA

        -- Join to get customer details
        INNER JOIN adashi_staging.users_customuser AS UC 
            ON SSA.owner_id = UC.id 

    GROUP BY UC.id  -- Group by each customer
) AS monthly_summary

-- Group results by frequency category
GROUP BY frequency_category

-- Order the categories in a logical order: High, Medium, Low
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');

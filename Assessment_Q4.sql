-- Estimate Customer Lifetime Value (CLV) for each user based on their transaction history

SELECT 
    UC.id AS customer_id,  -- Unique customer identifier

    -- Concatenate first and last name for customer full name
    CONCAT(UC.first_name, ' ', UC.last_name) AS name,

    -- Customer tenure in months since the date they joined
    TIMESTAMPDIFF(MONTH, UC.date_joined, CURDATE()) AS tenure_months,

    -- Total number of transactions made by the customer
    COUNT(SSA.id) AS total_transactions,

    -- Estimate of customer lifetime value (CLV)
	ROUND(
        (COUNT(SSA.id) / GREATEST(TIMESTAMPDIFF(MONTH, UC.date_joined, CURDATE()), 1))  -- Average transactions per month
        * 12
        * (AVG(SSA.confirmed_amount) * 0.001 / 100.0),  -- Adjusted average transaction amount and converting from kobo to naira
        2
    ) AS estimated_clv

FROM
    adashi_staging.users_customuser AS UC

    -- Left join to include users even with no transactions
    LEFT JOIN adashi_staging.savings_savingsaccount AS SSA 
        ON UC.id = SSA.owner_id

-- Filter to consider only transactions with confirmed amounts
WHERE 
    SSA.confirmed_amount IS NOT NULL

-- Group results by customer
GROUP BY 
    UC.id

-- Order customers by their estimated CLV in descending order
ORDER BY 
    estimated_clv DESC;

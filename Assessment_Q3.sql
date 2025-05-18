-- Retrieve savings or investment plans that have been inactive for at least 365 days

SELECT 
    PP.id AS plan_id,  -- Unique identifier for the plan
    PP.owner_id,  -- Owner of the plan

-- Determine the plan type based on flags
    CASE
        WHEN PP.is_regular_savings = 1 THEN 'Savings'
        WHEN PP.is_a_fund = 1 THEN 'Investment'
        ELSE 'Unknown'
    END AS type,

-- Most recent transaction date associated with the plan
    MAX(SSA.transaction_date) AS last_transaction_date,

-- Number of days since the last transaction
    DATEDIFF(CURDATE(), MAX(SSA.transaction_date)) AS inactivity_days

FROM
    adashi_staging.plans_plan AS PP

-- Left join to include plans even if they have no transactions
    LEFT JOIN adashi_staging.savings_savingsaccount AS SSA 
        ON PP.id = SSA.plan_id

-- Filter to only include savings or investment plans
WHERE
    PP.is_regular_savings = 1
    OR PP.is_a_fund = 1

-- Group by plan and owner to aggregate transaction history per plan
GROUP BY 
    PP.id, 
    PP.owner_id, 
    type

-- Only include plans that have been inactive for 365 days or more
HAVING 
    DATEDIFF(CURDATE(), MAX(SSA.transaction_date)) >= 365

-- Sort the results by number of inactivity days in descending order
ORDER BY 
    inactivity_days DESC;

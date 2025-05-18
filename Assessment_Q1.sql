-- Query to find customers with at least one funded savings plan and one funded investment plan, sorted by total deposits.

SELECT 
    UC.id AS owner_id, -- customer ID
    CONCAT(UC.first_name, ' ', UC.last_name) AS name, -- combining customer first_name and last_name to get their full name
    
-- Count the number of saving plan
    COUNT(DISTINCT CASE
            WHEN PP.is_regular_savings = 1 THEN PP.id END) AS savings_count,
            
-- count the number of investment plan
    COUNT(DISTINCT CASE
            WHEN PP.is_a_fund = 1 THEN PP.id END) AS investment_count,
            
-- sum of all confirmed deposit and converting the total deposits from kobo to naira
    SUM(SSA.confirmed_amount) / 100.0 AS total_deposits
FROM
    adashi_staging.users_customuser AS UC
    
-- Using Join function to get user plan
        LEFT JOIN
    adashi_staging.plans_plan AS PP ON UC.id = PP.owner_id
    
-- Join savings transactions (assumes all transactions—savings & investments—are here)
        LEFT JOIN
    adashi_staging.savings_savingsaccount AS SSA ON PP.id = SSA.plan_id
GROUP BY owner_id, name

-- Filter user the have at least one savings plan and one investment plan
-- Also exclude customers with no funding
HAVING COUNT(DISTINCT CASE
        WHEN PP.is_regular_savings = 1 THEN PP.id END) >= 1
    AND COUNT(DISTINCT CASE
        WHEN PP.is_a_fund = 1 THEN PP.id END) >= 1
    AND total_deposits IS NOT NULL
    
-- Sort by total deposit amount in descending order
ORDER BY total_deposits DESC;
# DataAnalytics-Assessment

This repository contains my solutions to a SQL proficiency assessment aimed at testing practical data analysis skills using real business data.

## HOW I APPROACH EACH QUESTION

### Question 1: High-Value Customers

I started by combining data from the users, plans, and savings tables. To identify high-value customers, I counted how many savings and investment plans each person had but only if those plans actually had deposits. Then I filtered for users who had at least one of both, added up their total deposits, and ranked them by value.

### Question 2: Transaction Frequency

I started by calculating how often each customer transacts by figuring out their total and average number of transactions per month. Based on that, I grouped them into "High", "Medium", or "Low" frequency categories using a simple CASE statement.

### Question 3: Inactivity Alert

Here, I looked for savings and investment plans that haven’t had any activity in the last year. I used the last recorded transaction date to calculate how many days have passed and filtered for plans with 365+ days of inactivity.

### Question 4: Customer Lifetime Value (CLV)

To estimate CLV, I calculated how long each customer has been with us (in months), figured out how many transactions they’ve made, and estimated their yearly contribution using a fixed profit margin. Then I ranked them by their potential value.

## CHALLENGES ENCOUNTERED

Handling missing values (like NULL transaction dates or amounts) was a bit tricky, so I used defensive checks like IS NOT NULL and GREATEST() to avoid errors.

If a customer has only been active for a very short time like a few days but made several transactions in that time, their average transaction per month could look much higher than normal. This could give a false impression that they're a frequent user. To avoid this, I made sure the calculation always assumes at least one full month, even if the actual time is less. I made sure that customers who just started using the platform didn’t appear more active than they really are by always counting at least one full month when calculating their average transactions.

Also, since all amounts were stored in kobo, I had to convert them to naira accurately for all financial calculations.

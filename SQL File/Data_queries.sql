CREATE TABLE gender (
    gender_id INT PRIMARY KEY,
    gender VARCHAR(20)
);

CREATE TABLE banking_relationship (
    br_id INT PRIMARY KEY,
    banking_relationship VARCHAR(100)
);

CREATE TABLE investment_advisor (
    ia_id INT PRIMARY KEY,
    investment_advisor VARCHAR(100)
);

CREATE TABLE clients (
    "Client ID" VARCHAR(20),
    "Name" VARCHAR(100),
    "Age" INT,
    "Location ID" INT,
    "Joined Bank" DATE,
    "Banking Contact" VARCHAR(100),
    "Nationality" VARCHAR(100),
    "Occupation" VARCHAR(100),
    "Fee Structure" VARCHAR(50),
    "Loyalty Classification" VARCHAR(50),
    "Estimated Income" NUMERIC,
    "Superannuation Savings" NUMERIC,
    "Amount of Credit Cards" INT,
    "Credit Card Balance" NUMERIC,
    "Bank Loans" NUMERIC,
    "Bank Deposits" NUMERIC,
    "Checking Accounts" NUMERIC,
    "Saving Accounts" NUMERIC,
    "Foreign Currency Account" NUMERIC,
    "Business Lending" NUMERIC,
    "Properties Owned" INT,
    "Risk Weighting" NUMERIC,
    "BRId" INT,
    "GenderId" INT,
    "IAId" INT
);


SELECT COUNT(*) FROM clients;

/*Total Customers that is 3000 */
SELECT COUNT(*) AS total_customers
FROM clients;


/* First 10 Rows */
SELECT *
FROM clients
LIMIT 10;


/* Checking Null values */
SELECT
COUNT(*) FILTER (WHERE "Estimated Income" IS NULL) AS missing_income,
COUNT(*) FILTER (WHERE "Bank Deposits" IS NULL) AS missing_deposits,
COUNT(*) FILTER (WHERE "Bank Loans" IS NULL) AS missing_loans
FROM clients;


/* Checking For Duplicate IDs */
SELECT
"Client ID",
COUNT(*) AS duplicate_count
FROM clients
GROUP BY "Client ID"
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


/* Data knowledge with help of SQL Queries */

/* Q1.How many customers does the bank serve?  */

SELECT COUNT(*) AS total_customers
FROM clients;

/* Q2.What is the average estimated income of the bank's customers? */

SELECT
ROUND(AVG("Estimated Income"),2) AS average_income
FROM clients;

/* Q3.Who are the top 10 customers by total bank deposits? */

SELECT
"Client ID",
"Name",
"Bank Deposits"
FROM clients
ORDER BY "Bank Deposits" DESC
LIMIT 10;

/* Q4.Which occupations have the highest average income? */

SELECT
    "Occupation",
    ROUND(AVG("Estimated Income"), 2) AS average_income
FROM clients
GROUP BY "Occupation"
ORDER BY average_income DESC;

/* Q5.Which nationality has the highest total bank deposits? */

SELECT
    "Nationality",
    ROUND(SUM("Bank Deposits"), 2) AS total_deposits
FROM clients
GROUP BY "Nationality"
ORDER BY total_deposits DESC;

/* Q6.What is the average loan amount by loyalty classification? */

SELECT
    "Loyalty Classification",
    ROUND(AVG("Bank Loans"), 2) AS average_loan
FROM clients
GROUP BY "Loyalty Classification"
ORDER BY average_loan DESC;

/* Q7.Which customers have both high deposits and high loans? */

SELECT
    "Client ID",
    "Name",
    "Bank Deposits",
    "Bank Loans"
FROM clients
WHERE "Bank Deposits" > (
    SELECT AVG("Bank Deposits") FROM clients
)
AND "Bank Loans" > (
    SELECT AVG("Bank Loans") FROM clients
)
ORDER BY "Bank Deposits" DESC;

/* Q8.Which age group contributes the highest deposits? */

SELECT
CASE
    WHEN "Age" < 30 THEN '18-29'
    WHEN "Age" BETWEEN 30 AND 45 THEN '30-45'
    WHEN "Age" BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
END AS age_group,

ROUND(SUM("Bank Deposits"),2) AS total_deposits

FROM clients

GROUP BY age_group

ORDER BY total_deposits DESC;

/* Q9.Who are the wealthiest customers based on deposits and savings? */

SELECT

"Client ID",

"Name",

ROUND(("Bank Deposits" + "Saving Accounts"),2) AS total_wealth

FROM clients

ORDER BY total_wealth DESC

LIMIT 10;

/* Q10.Which banking relationship type has the highest deposits? */

SELECT

b.banking_relationship,

ROUND(SUM(c."Bank Deposits"),2) AS total_deposits

FROM clients c

JOIN banking_relationship b

ON c."BRId" = b.br_id

GROUP BY b.banking_relationship

ORDER BY total_deposits DESC;

/* Q11.Top Investment Advisors by Assets Managed */

SELECT

i.investment_advisor,

ROUND(SUM(c."Bank Deposits"),2) AS assets_managed

FROM clients c

JOIN investment_advisor i

ON c."IAId" = i.ia_id

GROUP BY i.investment_advisor

ORDER BY assets_managed DESC;
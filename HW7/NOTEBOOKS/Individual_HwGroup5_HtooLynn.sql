--------------------------------------------------------------------------------------
-- CSCI 331- Chapter 7 SQL Propositions 
-- Medium.com Article Sources (2 TOTAL):
-- 1. SQL Window Functions Explained with Real Interview Questions - Ankur Gupta

-- 2. SQL Window Functions for Analysts (How I Leveraged Advanced SQL to Uncover Hidden Insights) - Maximilian Oliver

--------------------------------------------------------------------------------------

--1 : Customer Spending Rank
--Proposition: Which customers generate the most total revenue, and how do they rank relative to all other customers?
WITH OrderAmounts AS (
    SELECT
        o.CustomerID AS customer_id,
        SUM(od.UnitPrice * od.Quantity * (1 - od.DiscountPercentage)) AS total_spent
    FROM Sales.[Order] AS o
    JOIN Sales.OrderDetail AS od
        ON o.OrderID = od.OrderID
    GROUP BY
        o.CustomerID
)
SELECT
    customer_id,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS rank_by_spending
FROM OrderAmounts
ORDER BY
    rank_by_spending,
    customer_id;

    
--2 : Product Revenue Over Time + YoY Trends
--Proposition: How has each product’s revenue evolved over time, and how does its performance change year-over-year?

WITH OrderLines AS (
    SELECT
        p.ProductID,
        p.ProductName,
        YEAR(o.OrderDate) AS order_year,
        od.UnitPrice * od.Quantity * (1 - od.DiscountPercentage) AS line_amount
    FROM Sales.[Order] AS o
    JOIN Sales.OrderDetail AS od
        ON o.OrderID = od.OrderID
    JOIN Production.Product AS p
        ON od.ProductID = p.ProductID
),
YearlyProductRevenue AS (
    SELECT
        ProductID,
        ProductName,
        order_year,
        SUM(line_amount) AS yearly_revenue
    FROM OrderLines
    GROUP BY
        ProductID,
        ProductName,
        order_year
)
SELECT
    ProductID,
    ProductName,
    order_year,
    yearly_revenue,

    -- total revenue for this product across all years
    SUM(yearly_revenue) OVER (
        PARTITION BY ProductID
    ) AS total_revenue_all_years,

    -- this year's share of that product's total revenue
    CAST(
        yearly_revenue * 1.0 /
        NULLIF(SUM(yearly_revenue) OVER (PARTITION BY ProductID), 0)
        AS DECIMAL(6,4)
    ) AS share_of_product_revenue,

    -- previous year's revenue for this product
    LAG(yearly_revenue) OVER (
        PARTITION BY ProductID
        ORDER BY order_year
    ) AS prev_year_revenue,

    -- absolute change vs previous year
    yearly_revenue
        - LAG(yearly_revenue) OVER (
            PARTITION BY ProductID
            ORDER BY order_year
        ) AS yoy_change,

    -- % change vs previous year
    CASE
        WHEN LAG(yearly_revenue) OVER (
                 PARTITION BY ProductID
                 ORDER BY order_year
             ) IS NULL THEN NULL
        WHEN LAG(yearly_revenue) OVER (
                 PARTITION BY ProductID
                 ORDER BY order_year
             ) = 0 THEN NULL
        ELSE
            (yearly_revenue
             - LAG(yearly_revenue) OVER (
                   PARTITION BY ProductID
                   ORDER BY order_year
               )
            )
            * 100.0
            / LAG(yearly_revenue) OVER (
                  PARTITION BY ProductID
                  ORDER BY order_year
              )
    END AS yoy_change_percent
FROM YearlyProductRevenue
ORDER BY
    ProductName,
    order_year;


--3 : Top 3 Products Per Category
--Proposition: Which three products generate the most revenue within each category?

WITH ProductSales AS (
    SELECT 
        p.ProductID     AS product_id,
        c.CategoryName  AS category,
        p.ProductName   AS product,
        SUM(od.UnitPrice * od.Quantity * (1 - od.DiscountPercentage)) AS total_sales
    FROM Production.Category AS c
    JOIN Production.Product AS p
        ON p.CategoryID = c.CategoryID
    JOIN Sales.OrderDetail AS od
        ON od.ProductID = p.ProductID
    GROUP BY 
        p.ProductID,
        c.CategoryName,
        p.ProductName
),
Ranked AS (
    SELECT
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_sales DESC
        ) AS row_num,
        product_id,
        category,
        product,
        total_sales
    FROM ProductSales
)
SELECT
    row_num,
    product_id,
    category,
    product,
    total_sales
FROM Ranked
WHERE row_num <= 3
ORDER BY
    category,
    row_num;

--4: Customer Retention Gaps
--   Proposition: Which customers make purchases frequently, defined as ordering on average every 30 days or less?

    SELECT 
    o.CustomerID AS customer_id,
    o.OrderDate  AS order_date,
    LAG(o.OrderDate, 1) OVER (
        PARTITION BY o.CustomerID 
        ORDER BY o.OrderDate
    ) AS previous_order,
    DATEDIFF(
        DAY,                    
        LAG(o.OrderDate, 1) OVER (
            PARTITION BY o.CustomerID 
            ORDER BY o.OrderDate
        ),
        o.OrderDate
    ) AS days_between_orders
FROM Sales.[Order] AS o
ORDER BY
    o.CustomerID,
    o.OrderDate;


-- 5: High-Frequency Customers
-- Proposition: Which customers make purchases frequently, defined as ordering on average every 30 days or less?

WITH OrderGaps AS (
    SELECT
        o.CustomerID,
        o.OrderID,
        o.OrderDate,
        LAG(o.OrderDate) OVER (
            PARTITION BY o.CustomerID
            ORDER BY o.OrderDate
        ) AS prev_order_date
    FROM Sales.[Order] AS o
),
GapCalc AS (
    SELECT
        CustomerID,
        DATEDIFF(DAY, prev_order_date, OrderDate) AS days_between
    FROM OrderGaps
    WHERE prev_order_date IS NOT NULL
),
AvgGap AS (
    SELECT
        CustomerID,
        AVG(CAST(days_between AS DECIMAL(10,2))) AS avg_days_between_orders
    FROM GapCalc
    GROUP BY
        CustomerID
)
SELECT
    a.CustomerID,
    c.CustomerCompanyName,
    a.avg_days_between_orders
FROM AvgGap AS a
JOIN Sales.Customer AS c
    ON a.CustomerID = c.CustomerID
WHERE
    a.avg_days_between_orders <= 30
ORDER BY
    a.avg_days_between_orders;
       

--6: High-Value Customers Using Percentiles
--Proposition: How can customers be ranked by spending using percentiles?

WITH CustomerAmounts AS (
    SELECT 
        o.CustomerID AS customer_id,
        SUM(od.UnitPrice * od.Quantity * (1 - od.DiscountPercentage)) AS amount
    FROM Sales.[Order] AS o
    JOIN Sales.OrderDetail AS od
        ON o.OrderID = od.OrderID
    GROUP BY 
        o.CustomerID
)
SELECT 
    customer_id,
    amount,
    PERCENT_RANK() OVER (ORDER BY amount) AS percentile_rank
FROM CustomerAmounts
ORDER BY 
    amount DESC;

--7: Revenue Segmentation Using NTILE
-- Proposition: How can customers be segmented into Small, Medium, and Large revenue groups?

WITH CustomerRevenue AS (
    SELECT
        o.CustomerID,
        SUM(od.UnitPrice * od.Quantity * (1 - od.DiscountPercentage)) AS total_revenue
    FROM Sales.[Order] AS o
    JOIN Sales.OrderDetail AS od
        ON o.OrderID = od.OrderID
    GROUP BY
        o.CustomerID
),
Segmented AS (
    SELECT
        CustomerID,
        total_revenue,
        NTILE(3) OVER (ORDER BY total_revenue) AS revenue_bucket
    FROM CustomerRevenue
)
SELECT
    s.CustomerID,
    c.CustomerCompanyName,
    s.total_revenue,
    CASE s.revenue_bucket
        WHEN 1 THEN 'Small'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'Large'
    END AS revenue_segment
FROM Segmented AS s
JOIN Sales.Customer AS c
    ON s.CustomerID = c.CustomerID
ORDER BY
    s.total_revenue DESC;

--8: Product Share of Category Revenue
-- Proposition: How much does each product contribute to its category’s total revenue?

WITH ProductSales AS (
    SELECT
        p.ProductID,
        p.ProductName,
        c.CategoryName,
        SUM(od.UnitPrice * od.Quantity * (1 - od.DiscountPercentage)) AS product_revenue
    FROM Production.Product AS p
    JOIN Production.Category AS c
        ON p.CategoryID = c.CategoryID
    JOIN Sales.OrderDetail AS od
        ON od.ProductID = p.ProductID
    GROUP BY
        p.ProductID,
        p.ProductName,
        c.CategoryName
),
WithCategoryTotal AS (
    SELECT
        ProductID,
        ProductName,
        CategoryName,
        product_revenue,
        SUM(product_revenue) OVER (
            PARTITION BY CategoryName
        ) AS category_revenue
    FROM ProductSales
)
SELECT
    CategoryName,
    ProductID,
    ProductName,
    product_revenue,
    category_revenue,
    CAST(product_revenue * 100.0 / category_revenue AS DECIMAL(5,2)) AS pct_of_category_revenue
FROM WithCategoryTotal
ORDER BY
    pct_of_category_revenue DESC,
    CategoryName
    
--9: Compute each customer’s average order value (AOV) 
--Proposition: Which customers have the highest average order values?

WITH OrderAmounts AS (
    SELECT
        o.CustomerID,
        o.OrderID,
        SUM(od.UnitPrice * od.Quantity * (1 - od.DiscountPercentage)) AS order_amount
    FROM Sales.[Order] AS o
    JOIN Sales.OrderDetail AS od
        ON o.OrderID = od.OrderID
    GROUP BY
        o.CustomerID,
        o.OrderID
),
CustomerAOV AS (
    SELECT
        CustomerID,
        AVG(order_amount) AS avg_order_value
    FROM OrderAmounts
    GROUP BY
        CustomerID
)
SELECT
    c.CustomerID,
    c.CustomerCompanyName,
    ca.avg_order_value,
    PERCENT_RANK() OVER (ORDER BY ca.avg_order_value) AS aov_percentile_rank
FROM CustomerAOV AS ca
JOIN Sales.Customer AS c
    ON ca.CustomerID = c.CustomerID
ORDER BY
    ca.avg_order_value DESC;

--10:Customer LTV (Lifetime summary) + Revenue Contribution Percentile + Rank 3 CATEGORIES 
--Customer Lifetime Value and Contribution Segments
WITH CustomerOrders AS (
    SELECT
        o.CustomerID,
        o.OrderID,
        o.OrderDate,
        SUM(od.UnitPrice * od.Quantity * (1 - od.DiscountPercentage)) AS order_amount
    FROM Sales.[Order] AS o
    JOIN Sales.OrderDetail AS od
        ON o.OrderID = od.OrderID
    GROUP BY
        o.CustomerID,
        o.OrderID,
        o.OrderDate
),
CustomerLTV AS (
    SELECT
        c.CustomerID,
        c.CustomerCompanyName,
        COUNT(co.OrderID)     AS total_orders,
        SUM(co.order_amount)  AS total_revenue,
        MIN(co.OrderDate)     AS first_order_date,
        MAX(co.OrderDate)     AS last_order_date
    FROM Sales.Customer AS c
    LEFT JOIN CustomerOrders AS co
        ON c.CustomerID = co.CustomerID
    GROUP BY
        c.CustomerID,
        c.CustomerCompanyName
),
WithRevenueContribution AS (
    SELECT
        CustomerID,
        cUSTOMERCompanyName,
        total_orders,
        total_revenue,
        first_order_date,
        last_order_date,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,

        SUM(total_revenue) OVER () AS grand_total_revenue
    FROM CustomerLTV
),
WithScore AS (
    SELECT
        CustomerID,
        CustomerCompanyName,
        total_orders,
        total_revenue,
        first_order_date,
        last_order_date,
        cumulative_revenue,
        grand_total_revenue,
        CAST(
            1.0 - (cumulative_revenue * 1.0 / grand_total_revenue)
            AS DECIMAL(6,4)
        ) AS flipped_revenue_contribution_score
    FROM WithRevenueContribution
)
SELECT
    CustomerID,
    CustomerCompanyName,
    total_orders,
    total_revenue,
    first_order_date,
    last_order_date,
    cumulative_revenue,
    grand_total_revenue,
    flipped_revenue_contribution_score,
    CASE
        WHEN flipped_revenue_contribution_score >= 0.66 THEN 'Top'
        WHEN flipped_revenue_contribution_score >= 0.33 THEN 'Mid'
        ELSE 'Low'
    END AS revenue_segment
FROM WithScore
ORDER BY
    total_revenue DESC;


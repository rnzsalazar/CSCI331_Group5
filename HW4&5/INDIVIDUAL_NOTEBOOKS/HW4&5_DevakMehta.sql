/*=========================================================
  Proposition 1 — Stock Items with the Color 'Red'

  Outer Query:
    Retrieves each item's StockItemID, StockItemName, SupplierID,
    and TaxRate from Warehouse.StockItems.
    Filters items based on the ColorID column.

  Inner Query:
    Looks up the ColorID from Warehouse.Colors where ColorName = 'Red'.
    Because ColorName is unique, this returns exactly one value.
    This makes it a scalar subquery.

  Overall Result:
    Lists all stock items whose ColorID matches that of 'Red'.
    The subquery does not reference the outer query — an uncorrelated
    scalar subquery, which is a classic Chapter 4 example.
=========================================================*/


SELECT StockItemID, StockItemName, SupplierID, TaxRate
FROM Warehouse.StockItems
WHERE ColorID=
(
  SELECT c.ColorID
  FROM Warehouse.Colors AS c
  WHERE c.ColorName='Red'
)

/*=========================================================
  Proposition 2 — People Who Have Listed Other Languages

  Outer Query:
    Selects PersonID, FullName, and OtherLanguages from Application.People
    to display details for each person.

  Inner Query:
    Returns every PersonID from Application.People where OtherLanguages IS NOT NULL.
    This produces a multi-row result set.

  Overall Result:
    The outer query returns people whose PersonID appears in that set,
    meaning they have at least one language recorded.
    This is a multi-row IN subquery, uncorrelated — a standard Chapter 4 pattern.
=========================================================*/

SELECT p.PersonID, p.FullName, p.OtherLanguages
FROM Application.People AS p
WHERE p.PersonID IN (
  SELECT x.PersonID
  FROM Application.People AS x
  WHERE x.OtherLanguages IS NOT NULL
);

/*=========================================================
  Proposition 3 — Cities Starting with 'A' in StateProvinceID = 1

  Outer Query:
    Retrieves CityName, StateProvinceID, and LatestRecordedPopulation
    from Application.Cities, filtering by name prefix 'A%'.

  Inner Query:
    Returns the StateProvinceID from Application.StateProvinces where
    StateProvinceID = 1. Because it produces one value, it is scalar.

  Overall Result:
    Displays all cities that begin with 'A' and belong to
    StateProvinceID = 1.
    This is an uncorrelated scalar subquery — firmly Chapter 4.
=========================================================*/

SELECT cityName, StateProvinceID, LatestRecordedPopulation
FROM Application.Cities 
WHERE StateProvinceID =
(
    SELECT StateProvinceID -- scalar subquery can return just one value
    FROM Application.StateProvinces
    WHERE StateProvinceID = 1

)
AND CityName LIKE 'A%';

/*=========================================================
  Proposition 4 — Cities Starting with 'A' in StateProvinces 1, 2, or 3

  Outer Query:
    Retrieves CityName, StateProvinceID, and LatestRecordedPopulation
    from Application.Cities and filters by name prefix 'A%'.

  Inner Query:
    Selects the list of StateProvinceIDs from Application.StateProvinces
    where StateProvinceID is in (1, 2, 3). This yields multiple values.

  Overall Result:
    Returns all cities beginning with 'A' that belong to provinces 1–3.
    A multi-row IN subquery that is independent of the outer query —
    another Chapter 4 example.
=========================================================*/


SELECT CityName, StateProvinceID, LatestRecordedPopulation
FROM Application.Cities
WHERE StateProvinceID IN (
    SELECT StateProvinceID
    FROM Application.StateProvinces
    WHERE StateProvinceID NOT IN (1, 2, 3)
)
AND LatestRecordedPopulation < 10;


/*=========================================================
  Proposition5 — Cities Above Average Population in StateProvinceID = 1

**Outer Query:**  
The outer query retrieves the city name and latest recorded population from the `Application.Cities` table.  
It also limits the results to only those cities where `StateProvinceID = 1`, meaning the query focuses on a single province or state.

**Inner Query:**  
For each city returned by the outer query, the inner (correlated) subquery calculates the **average population** of all cities that share the same `StateProvinceID`.  
It compares this calculated average to the outer city’s population using the condition  
`c.LatestRecordedPopulation > (average population of that state)`.

**Overall Result:**  
The query lists all cities within `StateProvinceID = 1` whose populations are **greater than the average population** of all other cities in that same province.  
Because the inner query references the outer query’s `StateProvinceID`, it is a **correlated subquery** — the inner query runs once for each row in the outer query.
=========================================================*/

SELECT c.CityName, c.LatestRecordedPopulation
FROM Application.Cities AS c
WHERE c.LatestRecordedPopulation >
(
  SELECT AVG(c2.LatestRecordedPopulation)
  FROM Application.Cities AS c2
  WHERE c2.StateProvinceID = c.StateProvinceID
)
AND c.StateProvinceID = 1;




/*=========================================================
  CHAPTER 5 — Proposition 1
  Customers Using 'Delivery Van' Whose Names Begin with 'A'

  Outer Query:
    Reads from Sales.Customers and displays CustomerName
    and BillToCustomerID.

  Inner Query:
    Looks up DeliveryMethodID from Application.DeliveryMethods
    where DeliveryMethodName = 'Delivery Van'.

  Overall Result:
    Returns all customers whose names start with 'A' and who
    use the 'Delivery Van' delivery method.
    This is an uncorrelated multi-row subquery — fits Chapter 5
    because it applies subqueries for filtering business conditions.
=========================================================*/

SELECT CustomerName, BillToCustomerID
FROM Sales.Customers
WHERE DeliveryMethodID IN (
  SELECT DeliveryMethodID
  FROM Application.DeliveryMethods
  WHERE DeliveryMethodName = N'Delivery Van'
) AND CustomerName LIKE 'A%';

/*=========================================================
  CHAPTER 5 — Proposition 2 (Derived Table)
  People with 'NO LOGON' and PersonID below 100

  Inner Query:
    Selects PersonID and FullName from Application.People
    filtering rows with LogonName = 'NO LOGON' and PersonID < 100.

  Outer Query:
    Treats the inner result as a derived table named NoLogonPeople.

  Overall Result:
    Demonstrates a Chapter 5 derived table (nested SELECT ... AS alias)
    returning the same result set as a normal query but with encapsulation.
=========================================================*/

SELECT *
FROM (
  SELECT PersonID, FullName
  FROM Application.People
  WHERE LogonName = 'NO LOGON' AND PersonID < 100
) AS NoLogonPeople;


/*=========================================================
  CHAPTER 5 — Proposition 2 (CTE Version)
  Same result as above but implemented using a CTE.

  CTE:
    Defines NoLogonPeople once, then queried directly below.

  Overall Result:
    Cleaner and more maintainable than nested derived tables.
=========================================================*/

WITH NoLogonPeople AS (
  SELECT PersonID, FullName
  FROM Application.People
  WHERE LogonName='NO LOGON' AND FullName like 'Ar%'
)
SELECT * FROM NoLogonPeople;

/*=========================================================
  CHAPTER 5 — Proposition 3
  Orders per Delivery Year (Derived Table)

  Inner Query:
    Extracts DeliveryYear from ExpectedDeliveryDate.

  Outer Query:
    Groups by DeliveryYear and counts orders per year.

  Overall Result:
    Demonstrates a derived table with column aliasing used
    for grouping — a hallmark Chapter 5 pattern.
=========================================================*/


SELECT DeliveryYear, COUNT(*) AS OrdersPerYear
FROM
(SELECT YEAR(ExpectedDeliveryDate) AS DeliveryYear FROM Sales.Orders)
AS S
GROUP BY DeliveryYear


/*=========================================================
  CHAPTER 5 — Proposition 4
  Multiple CTEs for People With and Without Logon

  CTEs:
    NoLogonPeople → LogonName = 'NO LOGON'
    LogonPeople   → LogonName IS NOT NULL

  Outer Query:
    Uses UNION ALL to combine counts from both sets.

  Overall Result:
    Demonstrates multiple CTE definitions and set union logic.
=========================================================*/
*/

WITH NoLogonPeople AS (
  SELECT PersonID, FullName
  FROM Application.People
  WHERE LogonName='NO LOGON'
),
LOGONPeople AS (
    SELECT PersonID, FullName
    FROM Application.People
    WHERE LogonName IS NOT NULL
)
SELECT 
    'No Logon' AS Category, COUNT(*) AS NumPeople
FROM NOLogonPeople 
UNION ALL
SELECT 
    'Has Logon' AS Category, COUNT(*) AS NumPeople
FROM LOGONPeople ;

/*=========================================================
  CHAPTER 5 — Proposition 5
  Derived Table with Parameterized Filter (per Salesperson)

  Variable:
    @SalesPersonID declares which salesperson to filter by.

  Inner Query:
    Filters Sales.Orders by SalespersonPersonID and extracts
    DeliveryYear using YEAR().

  Outer Query:
    Groups by DeliveryYear to count orders per year.

  Overall Result:
    Demonstrates combining a variable with a derived table —
    an applied Chapter 5 technique.
=========================================================*/

DECLARE @SalesPersonID INT = 2;
SELECT D.DeliveryYear, COUNT(*) AS OrdersPerYear
FROM (
  SELECT YEAR(ExpectedDeliveryDate) AS DeliveryYear
  FROM Sales.Orders
  WHERE SalespersonPersonID = @SalesPersonID
) AS D
GROUP BY D.DeliveryYear;



/*=========================================================
## 💼 NACE Competencies Reflection — Group 5 Collaboration  
**Group Leader:** Renzo  **Co-Leader:** Devak Mehta  

During the completion of this SQL project, our group demonstrated multiple **NACE Career Readiness Competencies**, including **Communication, Teamwork, Critical Thinking, Technology, Leadership, Equity & Inclusion, Career & Self-Development, and Professionalism**.

---

### 🗣️ Communication  
We maintained consistent contact through our **WhatsApp group chat**, where we discussed query logic, shared screenshots, and clarified assignment requirements.  
Before each chapter’s work session, we set a **specific date and time** to meet and review progress.  
Whenever one member faced an SQL or Jupyter issue, others immediately responded with guidance and tested solutions collaboratively.

---

### 🤝 Teamwork & Collaboration  
Tasks were divided evenly, and everyone contributed to the group’s success.  
When someone was busy or ran into an error, another teammate stepped in to help.  
We also met on **TeamSpeak voice sessions** for quick discussions on query results, ensuring everyone stayed synchronized and informed.

---

### 💭 Critical Thinking & Problem Solving  
Each proposition required logical reasoning and analytical review of query results.  
We debugged syntax issues together, re-evaluated subquery structures, and optimized conditions when outputs didn’t match expectations.  
This strengthened our shared problem-solving approach and collective SQL fluency.

---

### 💻 Technology  
We utilized **DBeaver** for SQL testing, **Jupyter Notebook** for documentation and visualization, and **shared drives** for version control.  
When the `DECLARE` command failed inside Jupyter, we adapted by passing parameters through Python variables, showing technical agility and persistence.

---

### 🧭 Leadership  
**Renzo**, as the group leader, coordinated deadlines, structured discussions, and ensured everyone was on track.  
**Devak**, as co-leader, helped manage the technical side — verifying outputs, cleaning query formatting, and maintaining the notebook.  
Leadership was collaborative, emphasizing direction, accountability, and encouragement.

---

### ⚖️ Equity & Inclusion  
Each member’s ideas were heard and respected.  
We created an inclusive environment by explaining SQL logic step-by-step and ensuring all voices contributed equally to both design and review phases.

---

### 🌱 Career & Self-Development  
The project allowed us to apply classroom concepts in a practical setting.  
We improved both our technical and interpersonal skills — from writing professional SQL code to communicating effectively in a remote, team-based workflow.

---

### 🕒 Professionalism & Work Ethic  
We consistently met our deadlines and maintained clear documentation of progress within our WhatsApp chat.  
Our teamwork reflected accountability, mutual respect, and time management, as we checked in regularly and ensured all deliverables were completed **before the deadline**.

---

### ✅ Summary  
Through effective communication, teamwork, and leadership, our group completed the assignment smoothly and on schedule.  
By documenting discussions, using technology efficiently, and supporting one another, we demonstrated all **eight NACE competencies** — mirroring the professionalism expected in real-world computing and collaborative environments.

=========================================================*/






















--Step 1: Viewing table as a whole (Data Exploration)
SELECT * FROM EmployeeAttrition


--Step 2: Listing columns not needed (Data Exploration)
---Age, EmployeeCount, JobLevel, NumCompaniesWorked, StandardHours, TrainingTimesLastYear, YearsSinceLastPromotion, YearsWithCurrManager


--Step 3: Removing columns not needed (Data Cleaning)
ALTER TABLE EmployeeAttrition
DROP COLUMN Age, EmployeeCount, JobLevel, NumCompaniesWorked, StandardHours, TrainingTimesLastYear, YearsSinceLastPromotion, YearsWithCurrManagerDailyRate, MonthlyRate

--Step 4: Reviewing updated columns (Data Exploration)
SELECT * FROM EmployeeAttrition

--Step 5: Reviewing data types for all columns (Data Exploration)
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'EmployeeAttrition'

--Step 6: Listing updated data types for updated columns (Data Exploration)
--- All columns outside of Attrition, BusinessTravel, Gender, JobRole, OverTime will be updated to 'int'

--Step 7: Changing data types for all needed columns (Data Cleaning)
ALTER TABLE EmployeeAttrition
ALTER COLUMN DistanceFromHome int;

ALTER TABLE EmployeeAttrition
ALTER COLUMN EmployeeNumber int;

ALTER TABLE EmployeeAttrition
ALTER COLUMN EnvironmentSatisfaction int;

ALTER TABLE EmployeeAttrition
ALTER COLUMN JobInvolvement int;

ALTER TABLE EmployeeAttrition
ALTER COLUMN JobSatisfaction int;

ALTER TABLE EmployeeAttrition
ALTER COLUMN MonthlyIncome int;

ALTER TABLE EmployeeAttrition
ALTER COLUMN PercentSalaryHike int;

ALTER TABLE EmployeeAttrition
ALTER COLUMN PerformanceRating int;

ALTER TABLE EmployeeAttrition
ALTER COLUMN RelationshipSatisfaction int;

ALTER TABLE EmployeeAttrition
ALTER COLUMN TotalWorkingYears int;

ALTER TABLE EmployeeAttrition
ALTER COLUMN WorkLifeBalance int;

--Step 8: Viewing data types (Data Exploration)
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'EmployeeAttrition'

--Step 9: Removing underscore from BusinessTravel column and space from JobRole column (Data Cleaning)
UPDATE EmployeeAttrition
SET BusinessTravel = REPLACE(BusinessTravel,'_' ,' ')

UPDATE EmployeeAttrition
SET JobRole = REPLACE(JobRole,' ', '')


--Step 10: Viewing final table with all changes within columns and data types (Data Exploration)
SELECT * FROM EmployeeAttrition


--Analysis Questions:

---Question 1: How many employees are still with the company?

SELECT COUNT(*) AS CurrentEmployees
FROM EmployeeAttrition
WHERE Attrition = 'No'

---Question 2: How many employees are no longer with the company?
SELECT COUNT(*) AS NoLongerEmployees
FROM EmployeeAttrition
WHERE Attrition = 'Yes'

---Question 3: What is the attrition rate?
	----Total number of employees
		SELECT COUNT(*) AS TotalEmployees
		FROM EmployeeAttrition
	----Taking the results of the first two tasks to find the percentage
		SELECT (NoLongerEmployees * 100) / TotalEmployees AS AttritionRate
		FROM 
		(
		SELECT COUNT(*) AS TotalEmployees
		FROM EmployeeAttrition
		) AS a,
		(
		SELECT COUNT(*) AS NoLongerEmployees
		FROM EmployeeAttrition
		WHERE Attrition = 'Yes'
		) AS b

--- Question 4: Top departments with highest attrition rate?
----Find the highest attrition per department
	SELECT Department, COUNT(*) AS DepartmentAttrition
	FROM EmployeeAttrition
	WHERE Attrition = 'Yes'
	GROUP BY Department
	ORDER BY DepartmentAttrition DESC

----Finding the attrition rate for each department

SELECT Department, ROUND((COUNT(*) * 100) / (SELECT COUNT(*) FROM EmployeeAttrition WHERE Attrition = 'Yes'), 1) AS AttritionRate
FROM EmployeeAttrition
WHERE Attrition = 'Yes'
GROUP BY Department
ORDER BY AttritionRate DESC


--- Question 5: What is the attrition rate between the job roles?

SELECT TOP(5) JobRole, ROUND((COUNT(*) * 100) / (SELECT COUNT(*) FROM EmployeeAttrition WHERE Attrition = 'Yes'), 1) AS JobRoleAttritionRate
FROM EmployeeAttrition
WHERE Attrition = 'Yes'
GROUP BY JobRole
ORDER BY JobRoleAttritionRate DESC


--- Question 6: What is the average tenure of those who left the company?

SELECT AVG(TotalWorkingYears) AS AverageTenureAttrition
FROM EmployeeAttrition
WHERE Attrition = 'Yes'

--- Questions 7: What is the average monthly income of those who left the company?

SELECT AVG(MonthlyIncome) AS MonthlyIncomeAttrition
FROM EmployeeAttrition
WHERE Attrition = 'Yes'

--- Questions 8: What is the rate of business travel frequency of those who left the company?

SELECT BusinessTravel, (COUNT(*) * 100) / (SELECT COUNT(*) FROM EmployeeAttrition WHERE Attrition = 'Yes') AS BusinessTravelRate
FROM EmployeeAttrition
WHERE Attrition = 'Yes'
GROUP BY BusinessTravel
ORDER BY BusinessTravelRate DESC

--- Question 9: What is the average distance from home for those who left the company?

SELECT AVG(DistanceFromHome) AS AverageAttritionDistance
FROM EmployeeAttrition
WHERE Attrition = 'Yes'

--- Question 10: What was the average salary hike percentage of those who left the company?

SELECT AVG(PercentSalaryHike) AS AverageSalaryHike
FROM EmployeeAttrition
WHERE Attrition = 'Yes'

--- Question 11: What is the average job satisfaction for those in the departments with the highest attrition?
SELECT Department, AVG(JobSatisfaction) AS SatisfactionAvg
FROM EmployeeAttrition
WHERE Attrition = 'Yes'
GROUP BY Department
ORDER BY SatisfactionRate DESC

--- Question 12: What is the average relationship satisfaction for those in the departments with the highest attrition?
SELECT Department, AVG(RelationshipSatisfaction) AS RelationshipSatisfactionAvg
FROM EmployeeAttrition
WHERE Attrition = 'Yes'
GROUP BY Department
ORDER BY RelationshipSatisfactionAvg DESC

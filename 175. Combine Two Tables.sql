-- Write your PostgreSQL query statement below
SELECT firstname, lastname, city, state FROM Person
LEFT JOIN Address on Person.personID = Address.personID
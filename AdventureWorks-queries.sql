-- cw1
BEGIN
	SELECT HumanResources.EmployeePayHistory.BusinessEntityID, FirstName, LastName, Rate
	FROM HumanResources.EmployeePayHistory INNER JOIN Person.Person
	ON HumanResources.EmployeePayHistory.BusinessEntityID = Person.Person.BusinessEntityID
	WHERE Rate < (SELECT AVG(Rate)FROM HumanResources.EmployeePayHistory);
END;

GO

-- cw2

CREATE OR ALTER FUNCTION ShipmentDate(@id INT)
RETURNS DATETIME
AS
BEGIN
	DECLARE @date DATETIME;
	SELECT @date = ShipDate FROM Sales.SalesOrderHeader WHERE SalesOrderID = @id;

	RETURN @date
END;

GO

DECLARE @sale_id INT = 53625;
SELECT @sale_id AS SalesID, dbo.ShipmentDate(@sale_id) AS Shipment_Date;

GO

-- cw3

CREATE OR ALTER PROCEDURE ProductData(@name VARCHAR(50))
AS
BEGIN
    DECLARE @prod_id INT= (SELECT ProductID FROM Production.Product WHERE Name = @name);
    DECLARE @quant INT = (SELECT SUM(Quantity) FROM Production.ProductInventory WHERE ProductID = @prod_id);
	IF @quant > 0
		SELECT  Name, ProductID, ProductNumber, 'Available' AS Product_Availability
		FROM Production.Product WHERE Name = @name;
	ELSE
		SELECT  Name, ProductID, ProductNumber, 'Unavailable' AS Product_Availability
		FROM Production.Product  WHERE Name = @name;
END;

GO

DECLARE @name VARCHAR(50) = 'Freewheel';
EXEC ProductData @name;

GO

-- cw4

CREATE OR ALTER FUNCTION CardNumber(@order INT)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @number VARCHAR(20);

	SELECT @number = Sales.CreditCard.CardNumber 
	FROM Sales.CreditCard INNER JOIN Sales.SalesOrderHeader 
	ON Sales.CreditCard.CreditCardID = Sales.SalesOrderHeader.CreditCardID 
	WHERE Sales.SalesOrderHeader.SalesOrderID = @order;

	RETURN @number
END;

GO

DECLARE @order INT = 54328;
SELECT @order AS order_number, dbo.CardNumber(@order) AS Card_Number;

GO

-- cw5

CREATE OR ALTER PROCEDURE Divide(@num1 FLOAT, @num2 FLOAT)
AS 
BEGIN
	DECLARE @result FLOAT;

	IF @num1 < @num2
	SELECT 'Wrong input data' AS WARNING;
	ELSE
	BEGIN
		SET @result = @num1/@num2 
		SELECT @num1 AS num1, @num2 AS num2, @result AS Result
	END;
END;

GO

DECLARE @num1 FLOAT = 36;
DECLARE @num2 FLOAT = 9;
EXEC Divide @num1, @num2;

GO

-- cw6

CREATE OR ALTER PROCEDURE DaysOff(@id VARCHAR(20))
AS
BEGIN
	SELECT JobTitle, VacationHours / 8 AS Vacation_Days, SickLeaveHours / 8 AS SickLeave_Days
	FROM AdventureWorks2019.HumanResources.Employee
	WHERE NationalIDNumber = @id; 
END;

GO

DECLARE @worker_id VARCHAR(20);
SET @worker_id = 95958330
EXEC DaysOff @worker_id;

GO

-- cw7

CREATE OR ALTER PROCEDURE Exchange(@amount FLOAT, @input VARCHAR(10), @output VARCHAR(10), @date DATETIME)
AS
BEGIN
	DECLARE @rate FLOAT;
	DECLARE @result FLOAT;
	IF @input = 'USD'
		BEGIN
			SELECT @rate = AverageRate FROM Sales.CurrencyRate WHERE ToCurrencyCode = @output AND CurrencyRateDate = @date;
			SET @result = @rate * @amount;
		END;
	ELSE
		BEGIN
			SELECT @rate = AverageRate FROM Sales.CurrencyRate WHERE ToCurrencyCode = @input AND CurrencyRateDate = @date;
			SET @result = @amount/@rate;
		END;
	SELECT @input AS currency_from, @output AS currency_to, @amount AS amount, @rate AS rate, @result AS amount_after;
END;

GO

DECLARE @input_currency VARCHAR(5) = 'EUR';
DECLARE @output_currency VARCHAR(5) = 'USD';
DECLARE @amount FLOAT = 2500;
DECLARE @date DATETIME = '2012-12-21 00:00:00.000'
EXEC Exchange @amount, @input_currency, @output_currency, @date;
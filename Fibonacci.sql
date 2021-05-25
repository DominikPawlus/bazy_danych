-- cw1
CREATE OR ALTER FUNCTION Fib(@n INT)
RETURNS @table TABLE(result INT)
AS
BEGIN 
	DECLARE @i INT = 0
    DECLARE @n0 INT = 0
    DECLARE @n1 INT = 1
    

    INSERT INTO @table VALUES(@n0),(@n1)

    WHILE (@i <= @n-2)
    BEGIN
            INSERT INTO @table VALUES(@n1 + @n0)
            SET @n1 = @n1 + @n0
            SET @n0 = @n1 - @n0
            SET @i += 1
        END
RETURN

END;

GO

CREATE OR ALTER PROCEDURE Fib_procedure(@n INT)
AS 
BEGIN
    SELECT * FROM AdventureWorks2019.dbo.Fibonacci(@n)
END;

GO


DECLARE @n INT;
SET @n = 10;

EXECUTE Fib_procedure @n;
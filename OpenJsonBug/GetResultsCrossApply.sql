CREATE PROCEDURE dbo.GetResultsCrossApply
AS
BEGIN 
	SELECT JSON_VALUE(x.[value], '$.Id') AS ID
	FROM dbo.Result e
	CROSS APPLY OPENJSON(e.JsonResults, '$.Response.Results') AS x
END

/*

	This does not compile, it throws:-

	SQL46010: Incorrect syntax near e.	OpenJsonBug	C:\dbgit\OpenJsonBug\OpenJsonBug\GetResultsCrossApply.sql	6	

	It seems to be a problem with the cross apply passing a column instead of varibale, SSDT will throw an error.

	If this code is deployed within SSMS the DDL does infact complile and gives me the correct results when executing 	
	this SQL:-

	CREATE TABLE dbo.Result
	(
		ID INT IDENTITY(1,1) PRIMARY KEY,
		JsonResults NVARCHAR(MAX) NOT NULL
	)
	GO

	CREATE PROCEDURE dbo.GetResultsCrossApply
		 @json nvarchar(max)
	AS
	BEGIN 
		SELECT JSON_VALUE(x.[value], '$.Id') AS ID
		FROM OPENJSON(@json, '$.Response.Results') AS x
	END

	GO

	DECLARE @json NVARCHAR(MAX) = '{
		"Response": {
			"Results": [{
				"Id": 1
			}, {
				"Id": 2
			}, {
				"Id": 3
			}]
		}
	}';

	INSERT INTO dbo.Result (JsonResults)
	VALUES (@json)
	GO

	EXEC dbo.GetResultsCrossApply

*/
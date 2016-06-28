CREATE PROCEDURE dbo.GetResultsFrom
	 @json nvarchar(max)
AS
BEGIN 
	SELECT JSON_VALUE(x.[value], '$.Id') AS ID
	FROM OPENJSON(@json, '$.Response.Results') AS x
END


/*

	This seems to compile OK SSDT, however it does throw a warning:-

	SQL71005: The reference to the column x.[value] could not be resolved

	I'm unsure why the above column is unresolved as the below script compiles 
	file in SSMS:

	CREATE PROCEDURE dbo.GetResultsFrom
		@json NVARCHAR(MAX)
	AS
	BEGIN 
		SELECT JSON_VALUE(x.[value], '$.Id') AS ID
		FROM OPENJSON(@json, '$.Response.Results') AS x
	END

	GO

	DECLARE @JSON NVARCHAR(MAX) = '{
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

	EXEC dbo.GetResultsFrom
		 @json

*/
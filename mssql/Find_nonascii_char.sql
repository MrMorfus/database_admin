USE SOMETHING

SELECT [DESC], -- Your column name. Make sure to replace all references in the query.
  PATINDEX('%[!"#$%&''()*+,-./:;<=>?]%' COLLATE Latin1_General_BIN, [DESC]) AS [Position],
  SUBSTRING([DESC],PATINDEX('%[!"#$%&''()*+,-./:;<=>?]%' COLLATE Latin1_General_BIN,[DESC]),1) AS [InvalidCharacter],
  ASCII(SUBSTRING([DESC],PATINDEX('%[!"#$%&''()*+,-./:;<=>?]%' COLLATE Latin1_General_BIN,[DESC]),1)) AS [ASCIICode]
FROM  wrkuva -- Your table you are using.
WHERE PATINDEX('%[!"#$%&''()*+,-./:;<=>?]%' COLLATE Latin1_General_BIN,[DESC]) > 0

/**
CREATE FUNCTION [RemoveNonAlphaCharacters](@Temp VARCHAR(1000)) 
RETURNS VARCHAR(1000) 
AS 
BEGIN
 
    WHILE PATINDEX('%[!"#$%&''()*+,-./:;<=>?]%', @Temp) > 0 
       SET @Temp = STUFF(@Temp, PATINDEX('%[!"#$%&''()*+,-./:;<=>?]%', @Temp), 1, '')
    RETURN @Temp
End
**/


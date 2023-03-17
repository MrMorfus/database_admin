DECLARE @json NVARCHAR(MAX) = (SELECT T.JSON FROM [eForms].[Template] T WHERE [Id] = 73548 AND [TenantID] = 11111 AND [RevisionNumber] = 24);
SELECT Question, Answer, Question2, Answer2 FROM OpenJson(@json)
WITH
	(
	Children NVARCHAR(MAX) '$.children' AS JSON
	) AS Child1
	CROSS APPLY OpenJson (child1.children)
WITH
	(
	Children NVARCHAR(MAX) '$.children' AS JSON
	) AS Child2
	CROSS APPLY OpenJson (child2.children)
WITH
	(
	Children NVARCHAR(MAX) '$.children' AS JSON,
	Question NVARCHAR(MAX) '$.text'
	) AS Child3
	CROSS APPLY OpenJson (Child3.Children)
WITH
	(
	Children NVARCHAR(MAX) '$.children' AS JSON,
	Answer NVARCHAR(MAX) '$.text'
	) AS Child4
	CROSS APPLY OpenJson (Child4.Children)
WITH
	(
	Children NVARCHAR(MAX) '$.children' AS JSON,
	Question2 NVARCHAR(MAX) '$.text'
	) AS Child5
	CROSS APPLY OpenJson (Child5.Children)
WITH
	(
	Children NVARCHAR(MAX) '$.children' AS JSON,
	Answer2 NVARCHAR(MAX) '$.text'
	) AS Child6
	CROSS APPLY OpenJson (Child6.Children)
WITH
	(
	Children NVARCHAR(MAX) '$.children' AS JSON,
	Question3 NVARCHAR(MAX) '$.text'
	) AS Child7
	CROSS APPLY OpenJson (Child7.Children)
WITH
	(
	Children NVARCHAR(MAX) '$.children' AS JSON,
	Answer3 NVARCHAR(MAX) '$.text'
	)
IF EXISTS(SELECT * FROM sys.objects WHERE [name] = 'Store' AND [type] = 'U') BEGIN
	DROP TABLE Store
END
IF EXISTS(SELECT * FROM sys.objects WHERE [name] = 'StoreSync' AND [type] = 'U') BEGIN
	DROP TABLE StoreSync
END

CREATE TABLE Store (
	StoreCode VARCHAR(50) NOT NULL,
	StoreName VARCHAR(50) NULL,
	StoreCity VARCHAR(50) NULL
)

CREATE TABLE StoreSync (
	StoreCode VARCHAR(50) NOT NULL,
	StoreName VARCHAR(50) NULL,
	StoreCity VARCHAR(50) NULL
)

INSERT INTO Store VALUES ('Code1', 'Name 1', 'Ankara')
INSERT INTO Store VALUES ('Code2', 'Name 2', 'İstanbul')
INSERT INTO Store VALUES ('ToDelete', 'Name X', 'City X')

INSERT INTO StoreSync VALUES ('Code1', 'Name 1', 'Ankara')
INSERT INTO StoreSync VALUES ('Code2', 'Name New 2', 'İstanbul')
INSERT INTO StoreSync VALUES ('Code3', 'Name 3', 'İzmir')


DELETE s
--SELECT s.*
FROM Store s 
	LEFT JOIN StoreSync sync ON sync.StoreCode = s.StoreCode
WHERE sync.StoreCode IS NULL


INSERT INTO Store (StoreCode, StoreName, StoreCity)
SELECT sync.StoreCode, sync.StoreName, sync.StoreCity
FROM StoreSync sync
	LEFT JOIN Store s ON s.StoreCode = sync.StoreCode 
WHERE s.StoreCode IS NULL

--SELECT sync.*, s.*
UPDATE s
SET 
	s.StoreName = sync.StoreName
	,s.StoreCity = sync.StoreCity
FROM Store s
	INNER JOIN StoreSync sync ON sync.StoreCode = s.StoreCode
WHERE
HASHBYTES('SHA2_256',
	CONCAT(
		ISNULL(s.StoreName, '')
		,ISNULL(s.StoreCity, '')
	)
) != 
HASHBYTES('SHA2_256',
	CONCAT(
		ISNULL(sync.StoreName, '')
		,ISNULL(s.StoreCity, '')
	)
)

SELECT * FROM Store
SELECT * FROM StoreSync
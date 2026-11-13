USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'salmaa')
BEGIN
    CREATE LOGIN salmaa
        WITH PASSWORD = N'salmaa_Tugas2026!',
             DEFAULT_DATABASE = review_kantin;
END
GO

USE review_kantin;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'salmaa')
BEGIN
    CREATE USER salmaa FOR LOGIN salmaa;
END
GO

ALTER ROLE db_datareader ADD MEMBER salmaa;
ALTER ROLE db_datawriter ADD MEMBER salmaa;
GO

SELECT name, type_desc, authentication_type_desc
FROM sys.database_principals
WHERE name = 'salmaa';
GO

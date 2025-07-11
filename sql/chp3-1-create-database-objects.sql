CREATE TABLE
    dbo.Sales_LOAD (
        RowId INT NOT NULL IDENTITY (1, 1),
        Retailer NVARCHAR (255) NULL,
        SalesMonth DATE NULL,
        Product NVARCHAR (255) NULL,
        ManufacturerProductCode NVARCHAR (50) NULL,
        SalesValueUSD DECIMAL(18, 2) NULL,
        UnitsSold INT NULL,
        CONSTRAINT PK__dbo_Sales_LOAD PRIMARY KEY (RowId)
    );
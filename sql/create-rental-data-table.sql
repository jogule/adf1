-- Create table for rental property data from CSV files like r0500min-customer1-07052025183634.csv
-- This table accommodates the full schema of the rental data CSV files

CREATE TABLE rental_data (
    property_code VARCHAR(50) NOT NULL,
    unit VARCHAR(10) NOT NULL,
    tenant_code VARCHAR(50),
    tenant VARCHAR(255),
    market_rent DECIMAL(10,2),
    actual_rent DECIMAL(10,2),
    total_rent DECIMAL(10,2),
    total_concessions DECIMAL(10,2),
    net_effective_rent DECIMAL(10,2),
    total_lease_value DECIMAL(10,2),
    tenant_status VARCHAR(50),
    application_date DATE,
    lease_sign_date DATE,
    lease_from DATE,
    lease_to DATE,
    notice_date DATE,
    move_in DATE,
    move_out DATE,
    reason_for_move_out VARCHAR(255),
    application_approved DATE,
    application_canceled DATE,
    application_denied DATE
    
    -- Index for better query performance
    INDEX IX_rental_data_property_unit (property_code, unit),
    INDEX IX_rental_data_tenant_status (tenant_status),
    INDEX IX_rental_data_dates (lease_from, lease_to)
);

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Create function to compute checksum
CREATE OR REPLACE FUNCTION compute_checksum(VARIADIC columns TEXT[])
RETURNS BYTEA AS $$
DECLARE
    concatenated_text TEXT := '';
    i INT;
BEGIN
    -- Concatenate all input values into a string
    FOR i IN array_lower(columns, 1)..array_upper(columns, 1)
    LOOP
        concatenated_text := concatenated_text || COALESCE(columns[i], '');
    END LOOP;

    -- Compute the SHA-256 checksum
    RETURN digest(concatenated_text, 'sha256');
END;
$$ LANGUAGE plpgsql;

-- Create the trigger function to compute the checksum on insert
CREATE OR REPLACE FUNCTION add_checksum_on_insert()
RETURNS TRIGGER AS $$
BEGIN
    -- Directly pass the values to the compute_checksum function
    NEW.checksum := compute_checksum(NEW.product_id::TEXT, NEW.series, NEW.sales_price::TEXT);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to create checksum before insert
CREATE TRIGGER add_checksum_on_insert_trigger
BEFORE INSERT ON crm_sales_pipeline_staging.products_staging
FOR EACH ROW
EXECUTE FUNCTION add_checksum_on_insert();


-- Create the trigger function to compute the checksum on insert
CREATE OR REPLACE FUNCTION add_checksum_on_insert_sales_teams()
RETURNS TRIGGER AS $$
BEGIN
    -- Directly pass the values to the compute_checksum function
    NEW.checksum := compute_checksum(NEW.agent_id::TEXT, NEW.sales_agent::TEXT, NEW.manager::TEXT,NEW.regional_office::Text);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--create a trigger to compute checksum on sales_teams_staging table before insert
CREATE TRIGGER add_checksum_on_insert_trigger_sales_teams
BEFORE INSERT ON crm_sales_pipeline_staging.sales_teams_staging
FOR EACH ROW
EXECUTE FUNCTION add_checksum_on_insert_sales_teams();



--create the tigger function for the accounts data
CREATE OR REPLACE FUNCTION add_checksum_on_insert_accounts()
RETURNS TRIGGER AS $$
BEGIN
    NEW.checksum := compute_checksum(NEW.account::TEXT, NEW.sector::TEXT, NEW.year_established::TEXT, NEW.revenue::TEXT,NEW.employees::TEXT,NEW.office_location,NEW.subsidiary_of);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--create a trigger to compute checksum of each row
CREATE TRIGGER add_checksum_on_insert_trigger_accounts
BEFORE INSERT ON crm_sales_pipeline_staging.accounts_staging
FOR EACH ROW
EXECUTE FUNCTION add_checksum_on_insert_accounts();
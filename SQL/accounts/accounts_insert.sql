--first insert the new script
INSERT INTO crm_sales_pipeline_warehouse.accounts
SELECT
    i.account_id,
    i.account,
    i.sector,
    i.year_established,
    i.revenue,
    i.employees,
    i.office_location,
    'i.subsidairy_of',
    i.checksum,
    null --end_date,
FROM crm_sales_pipeline_staging.accounts_insert i;



--update the records that already exist but need to be updated
UPDATE crm_sales_pipeline_warehouse.accounts s
SET end_date = current_date
FROM
    crm_sales_pipeline_staging.accounts_update w
WHERE s.account_id = w.account_id  AND s.end_date is null;


--insert the new record from the update table
INSERT INTO crm_sales_pipeline_warehouse.accounts
SELECT
    i.account_id,
    i.account,
    i.sector,
    i.year_established,
    i.revenue,
    i.employees,
    i.office_location,
    'i.subsidairy_of',
    i.checksum,
    null --end_date,
FROM crm_sales_pipeline_staging.accounts_update i;
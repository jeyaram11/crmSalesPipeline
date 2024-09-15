 --first insert the new records into data warehouse
INSERT INTO
  crm_sales_pipeline_warehouse.sales_teams
SELECT
  agent_id,
  sales_agent manager,
  regional_office,
  checksum,
  null --end_date
FROM
  crm_sales_pipeline_staging.sales_teams_insert;

----update the records that already exist but need to be updated
UPDATE
  crm_sales_pipeline_warehouse.sales_teams s
SET
  end_date = current_date
FROM
  crm_sales_pipeline_staging.sales_teams_update p
WHERE
  s.agent_id = p.agent_id
  and s.end_date is null;

--insert the new record from the update table
INSERT INTO
  crm_sales_pipeline_warehouse.sales_teams
SELECT
  agent_id,
  sales_agent,
  manager,
  regional_office,
  checksum,
  null --end_date
FROM
  crm_sales_pipeline_staging.sales_teams_staging;
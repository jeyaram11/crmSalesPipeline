--delete the records that already exists as we need to insert the update records
DELETE FROM crm_sales_pipeline_warehouse.sales_data
    WHERE oppoturnity_id IN (SELECT DISTINCT oppoturnity_id FROM crm_sales_pipeline_staging.sales_data_staging);

--insert the new records
INSERT INTO crm_sales_pipeline_warehouse.sales_data
      SELECT
     oppoturnity_id,
     agent_id,
     product_id,
     account_id,
     deal_stage,
     engage_date,
     close_date,
     close_value,
     created_at,
     updated_at
   FROM crm_sales_pipeline_staging.sales_data_staging
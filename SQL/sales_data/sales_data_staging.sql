CREATE TABLE IF NOT EXISTS crm_sales_pipeline_loading.sales_data_loading(
  oppoturnity_id varchar(50),
  sales_agent varchar(50),
  product varchar(50),
  account varchar(50),
  deal_stage varchar(50),
  engage_date varchar(50),
  close_date timestamp,
  close_value varchar(50),
  created_at timestamp,
  updated_at timestamp
);

CREATE TABLE IF NOT EXISTS crm_sales_pipeline_staging.sales_data_staging(
  oppoturnity_id varchar(50),
  agent_id int,
  product_id int,
  account_id int,
  deal_stage TEXT,
  engage_date date,
  close_date date,
  close_value int,
  created_at timestamp,
  updated_at timestamp
);

CREATE TABLE IF NOT EXISTS crm_sales_pipeline_warehouse.sales_data(
  oppoturnity_id varchar(50),
  agent_id int,
  product_id int,
  account_id int,
  deal_stage TEXT,
  engage_date date,
  close_date date,
  close_value int,
  created_at timestamp,
  updated_at timestamp
);




--insert the data into the staging table with the correct data type
INSERT INTO crm_sales_pipeline_staging.sales_data_staging
    SELECT
     l.oppoturnity_id::TEXT,
     st.agent_id,
     p.product_id,
     a.account_id,
     l.deal_stage::TEXT,
     l.engage_date::date,
     l.close_date::date,
     l.close_value::int,
     l.created_at::timestamp,
     l.updated_at::timestamp
   FROM crm_sales_pipeline_loading.sales_data_loading l
   LEFT JOIN crm_sales_pipeline_warehouse.sales_teams st ON replace(lower(l.sales_agent),' ','') = replace(lower(st.sales_agent),' ','')
   LEFT JOIN crm_sales_pipeline_warehouse.products p ON replace(lower(l.product),' ','') = replace(lower(p.product),' ','')
   LEFT JOIN crm_sales_pipeline_warehouse.accounts a ON replace(lower(l.account),' ','') = replace(lower(a.account),' ','')




TRUNCATE TABLE crm_sales_pipeline_staging.products_staging;

INSERT INTO crm_sales_pipeline_staging.products_staging
    SELECT
        product_id::int,
        product::varchar(30),
        series::varchar(30),
        sales_price::numeric
    FROM
        crm_sales_pipeline_loading.products_loading;
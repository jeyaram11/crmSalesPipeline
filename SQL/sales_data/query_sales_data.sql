SELECT
  oppoturnity_id,
  sales_agent,
  product,
  account,
  deal_stage,
  engage_date,
  close_date,
  close_value,
  created_at,
  updated_at
FROM
  sales_data
--WHERE created_at::timestamp >= current_timestamp - interval '30 day' or
--updated_at >= current_timestamp - interval '30 day';
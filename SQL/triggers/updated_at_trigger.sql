--function to update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--trigger to call the update function
CREATE TRIGGER update_employee_updated_at
BEFORE UPDATE ON sales_data
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();


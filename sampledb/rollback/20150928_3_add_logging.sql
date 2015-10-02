DROP TRIGGER users_updated_at_modtime ON TABLE users;
DROP FUNCTION update_updated_at_column();

ALTER TABLE users DROP COLUMN created_at;
ALTER TABLE users DROP COLUMN updated_at;


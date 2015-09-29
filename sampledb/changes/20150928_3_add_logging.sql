CREATE FUNCTION update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
  END;
$$;

ALTER TABLE users ADD COLUMN created_at timestamptz NOT NULL DEFAULT NOW();
ALTER TABLE users ADD COLUMN updated_at timestamptz;

CREATE TRIGGER users_updated_at_modtime BEFORE UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

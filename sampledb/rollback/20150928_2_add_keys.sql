ALTER TABLE users DROP COLUMN username;
ALTER TABLE users DROP CONSTRAINT users_pkey;
DROP INDEX users_username_idx;

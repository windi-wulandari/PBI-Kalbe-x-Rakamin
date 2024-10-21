-- create Schema 
CREATE SCHEMA app AUTHORIZATION postgres;

-- Create a new user named 'windi' with a password
CREATE USER windi WITH PASSWORD 'your_secure_password';

-- Grant DML (SELECT, INSERT, UPDATE, DELETE) permissions on all tables in the 'app' schema
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA app TO windi;
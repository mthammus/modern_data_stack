/*created this role for just for some testing purposes to verify the usage of init.sql file*/
CREATE DATABASE fnb;
CREATE USER data WITH ENCRYPTED PASSWORD 'data';
GRANT ALL PRIVILEGES ON DATABASE fnb TO data;

CREATE DATABASE mydb;
CREATE USER myuser WITH ENCRYPTED PASSWORD 'mypassword';
GRANT ALL PRIVILEGES ON DATABASE mydb TO myuser;

CREATE DATABASE airbyte;
CREATE USER airbyte WITH ENCRYPTED PASSWORD 'airbyte';
GRANT ALL PRIVILEGES ON DATABASE airbyte TO airbyte;

CREATE DATABASE nessie;
CREATE USER nessie WITH ENCRYPTED PASSWORD 'nessie';
GRANT ALL PRIVILEGES ON DATABASE nessie TO nessie;
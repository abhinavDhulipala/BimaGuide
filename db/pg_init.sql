CREATE USER "bimaguide_dev" WITH PASSWORD 'dev';
CREATE DATABASE "bima_dev_pg" OWNER "bimaguide_dev";
CREATE DATABASE "bima_test_pg";
GRANT ALL PRIVILEGES ON DATABASE "bima_dev_pg" TO "bimaguide_dev";

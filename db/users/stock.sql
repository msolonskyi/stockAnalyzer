-- Create the user 
create user STOCK
  identified by "stock"
  default tablespace DATA
  temporary tablespace TEMP
  profile DEFAULT;
-- Grant/Revoke role privileges 
grant select_catalog_role to STOCK;
-- Grant/Revoke system privileges 
grant alter session to STOCK;
grant create database link to STOCK;
grant create materialized view to STOCK;
grant create procedure to STOCK;
grant create sequence to STOCK;
grant create session to STOCK;
grant create table to STOCK;
grant create trigger to STOCK;
grant create type to STOCK;
grant create view to STOCK;
grant debug connect session to STOCK;
grant restricted session to STOCK;
grant select any dictionary to STOCK;
grant select any table to STOCK;
grant unlimited tablespace to STOCK;

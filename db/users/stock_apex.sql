-- Create the user 
create user stock_apex
  identified by "apexstock"
  default tablespace DATA
  temporary tablespace TEMP
  profile DEFAULT;
-- Grant/Revoke role privileges 
grant select_catalog_role to stock_apex;
-- Grant/Revoke system privileges 
grant alter session to stock_apex;
grant create database link to stock_apex;
grant create materialized view to stock_apex;
grant create procedure to stock_apex;
grant create sequence to stock_apex;
grant create session to stock_apex;
grant create table to stock_apex;
grant create trigger to stock_apex;
grant create type to stock_apex;
grant create view to stock_apex;
grant debug connect session to stock_apex;
grant restricted session to stock_apex;
grant select any dictionary to stock_apex;
grant select any table to stock_apex;
grant unlimited tablespace to stock_apex;
grant unlimited tablespace to STOCK_APEX;

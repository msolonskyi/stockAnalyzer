-- Create the user 
create user COMMON
  identified by "common"
  default tablespace DATA
  temporary tablespace TEMP
  profile DEFAULT;
-- Grant/Revoke role privileges 
grant select_catalog_role to COMMON;
-- Grant/Revoke system privileges 
grant alter session to COMMON;
grant create materialized view to COMMON;
grant create procedure to COMMON;
grant create sequence to COMMON;
grant create session to COMMON;
grant create table to COMMON;
grant create trigger to COMMON;
grant create type to COMMON;
grant create view to COMMON;
grant debug connect session to COMMON;
grant restricted session to COMMON;
grant select any dictionary to COMMON;
grant select any table to COMMON;
grant unlimited tablespace to COMMON;

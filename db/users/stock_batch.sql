-- Create the user 
create user stock_batch
  identified by "batchstock"
  default tablespace DATA
  temporary tablespace TEMP
  profile DEFAULT;
-- Grant/Revoke system privileges 
grant alter session to stock_batch;
grant create session to stock_batch;

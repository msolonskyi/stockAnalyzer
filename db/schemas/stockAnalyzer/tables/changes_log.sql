-- Create table
create table CHANGES_LOG
(
  id          NUMBER(8) not null,
  table_name  VARCHAR2(30) not null,
  column_name VARCHAR2(30) not null,
  row_id      NUMBER(8) not null,
  new_value   VARCHAR2(1024),
  old_value   VARCHAR2(1024),
  create_dtm  DATE default sysdate not null
)
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 64K
    minextents 1
    maxextents unlimited
    pctincrease 0
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table CHANGES_LOG
  add constraint PK_CHANGES_LOG primary key (ID)
  using index 
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 64K
    minextents 1
    maxextents unlimited
    pctincrease 0
  );

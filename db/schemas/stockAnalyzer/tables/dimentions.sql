-- Create table
create table DIMENTIONS
(
  id         NUMBER(8) not null,
  name       VARCHAR2(64) not null,
  short_name VARCHAR2(64) not null
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
-- Add comments to the table 
comment on table DIMENTIONS
  is 'размерности';
-- Create/Recreate primary, unique and foreign key constraints 
alter table DIMENTIONS
  add constraint PK_DIMENSIONS primary key (ID)
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
alter table DIMENTIONS
  add constraint UNQ_DIMENSIONS unique (NAME)
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

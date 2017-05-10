-- Create table
create table STOCKS
(
  id   NUMBER(8) not null,
  name VARCHAR2(1000) not null,
  url  VARCHAR2(1000) not null,
  code VARCHAR2(1000) not null
)
tablespace DATA
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
alter table STOCKS
  add constraint PK_STOCKS primary key (ID)
  using index 
  tablespace INDX
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
alter table STOCKS
  add constraint UNQ_STOCKS unique (CODE)
  using index 
  tablespace INDX
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

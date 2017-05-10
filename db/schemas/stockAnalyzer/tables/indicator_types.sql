-- Create table
create table INDICATOR_TYPES
(
  id       NUMBER(8) not null,
  name     VARCHAR2(256) not null,
  priority NUMBER(1) not null,
  name_rus VARCHAR2(256) not null
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
alter table INDICATOR_TYPES
  add constraint PK_INDICATOR_TYPES primary key (ID)
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
alter table INDICATOR_TYPES
  add constraint UNQ_INDICATOR_TYPES unique (NAME)
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

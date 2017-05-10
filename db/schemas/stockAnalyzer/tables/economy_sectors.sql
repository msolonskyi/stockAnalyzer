-- Create table
create table ECONOMY_SECTORS
(
  id       NUMBER(8) not null,
  name     VARCHAR2(64) not null,
  owner_id NUMBER(8),
  name_rus VARCHAR2(128) not null
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
alter table ECONOMY_SECTORS
  add constraint PK_ECONOMY_SECTORS primary key (ID)
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
alter table ECONOMY_SECTORS
  add constraint FK_ECONOMY_SECTORS$OWNER_ID foreign key (OWNER_ID)
  references ECONOMY_SECTORS (ID);

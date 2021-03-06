-- Create table
create table SETTINGS
(
  name  VARCHAR2(128) not null,
  value VARCHAR2(1024) not null
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
    buffer_pool keep
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table SETTINGS
  add constraint PK_SETTINGS primary key (NAME)
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

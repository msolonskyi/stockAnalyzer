-- Create table
create table MULTIPLIERS
(
  id          NUMBER(8) not null,
  name        VARCHAR2(8),
  multiplier  NUMBER(16) not null,
  description VARCHAR2(128)
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
alter table MULTIPLIERS
  add constraint PK_MULTIPLIERS primary key (ID)
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
alter table MULTIPLIERS
  add constraint UNQ_MULTIPLIERS unique (NAME)
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

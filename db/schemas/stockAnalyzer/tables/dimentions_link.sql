-- Create table
create table DIMENTIONS_LINK
(
  id            NUMBER(8) not null,
  dimention_id  NUMBER(8) not null,
  multiplier_id NUMBER(8) not null
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
alter table DIMENTIONS_LINK
  add constraint PK_DIMENTIONS_LINK primary key (ID)
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
alter table DIMENTIONS_LINK
  add constraint UNQ_DIMENTIONS_LINK unique (DIMENTION_ID, MULTIPLIER_ID)
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
alter table DIMENTIONS_LINK
  add constraint FK_DIMENTIONS_LINK$DIM_ID foreign key (DIMENTION_ID)
  references DIMENTIONS (ID);
alter table DIMENTIONS_LINK
  add constraint FK_DIMENTIONS_LINK$MULT_ID foreign key (MULTIPLIER_ID)
  references MULTIPLIERS (ID);

-- Create table
create table INDICATORS_LINK
(
  id                 NUMBER(8) not null,
  indicator_group_id NUMBER(8) not null,
  indicator_id       NUMBER(8) not null,
  dimention_link_id  NUMBER(8) not null
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
alter table INDICATORS_LINK
  add constraint PK_INDICATOR_LINKS primary key (ID)
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
alter table INDICATORS_LINK
  add constraint UNQ_INDICATOR_LINKS unique (INDICATOR_GROUP_ID, INDICATOR_ID, DIMENTION_LINK_ID)
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
alter table INDICATORS_LINK
  add constraint FK_IND_LINKS$DIMENTION_LINK_ID foreign key (DIMENTION_LINK_ID)
  references DIMENTIONS_LINK (ID);
alter table INDICATORS_LINK
  add constraint FK_IND_LINKS$INDICATOR_ID foreign key (INDICATOR_ID)
  references INDICATORS (ID);
alter table INDICATORS_LINK
  add constraint FK_IND_LINKS$IND_GROUP_ID foreign key (INDICATOR_GROUP_ID)
  references INDICATOR_GROUPS (ID);

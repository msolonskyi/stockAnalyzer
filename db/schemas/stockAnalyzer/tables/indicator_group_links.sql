-- Create table
create table INDICATOR_GROUP_LINKS
(
  id                 NUMBER(8) not null,
  indicator_group_id NUMBER(8) not null,
  indicator_id       NUMBER(8) not null
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
alter table INDICATOR_GROUP_LINKS
  add constraint PK_INDICATOR_GROUPS_LINK primary key (ID)
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
alter table INDICATOR_GROUP_LINKS
  add constraint UNQ_INDICATOR_GROUPS_LINK unique (INDICATOR_GROUP_ID, INDICATOR_ID)
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
alter table INDICATOR_GROUP_LINKS
  add constraint FK_IND_GR_LINKS$INDICATOR_ID foreign key (INDICATOR_ID)
  references INDICATORS (ID);
alter table INDICATOR_GROUP_LINKS
  add constraint FK_IND_GR_LINKS$IND_GROUP_ID foreign key (INDICATOR_GROUP_ID)
  references INDICATOR_GROUPS (ID);

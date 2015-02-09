-- Create table
create table INDICATOR_VALUES
(
  id                      NUMBER(8) not null,
  indicator_group_link_id NUMBER(8) not null,
  period_id               NUMBER(8) not null,
  value                   NUMBER(24,4) not null,
  ticker                  VARCHAR2(10) not null,
  dimention_id            NUMBER(8) default 501
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
-- Add comments to the table 
comment on table INDICATOR_VALUES
  is 'Значение индикаторов';
-- Create/Recreate primary, unique and foreign key constraints 
alter table INDICATOR_VALUES
  add constraint PK_INDICATOR_VALUES primary key (ID)
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
alter table INDICATOR_VALUES
  add constraint UNQ_INDICATOR_VALUES unique (INDICATOR_GROUP_LINK_ID, PERIOD_ID, TICKER, DIMENTION_ID)
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
alter table INDICATOR_VALUES
  add constraint FK_IND_VALUES$DIMENTION_ID foreign key (DIMENTION_ID)
  references DIMENTIONS (ID);
alter table INDICATOR_VALUES
  add constraint FK_IND_VALUES$IND_GR_LNK_ID foreign key (INDICATOR_GROUP_LINK_ID)
  references INDICATOR_GROUP_LINKS (ID);
alter table INDICATOR_VALUES
  add constraint FK_IND_VALUES$PERIOD_ID foreign key (PERIOD_ID)
  references PERIODS (ID);
alter table INDICATOR_VALUES
  add constraint FK_IND_VALUES$TICKER foreign key (TICKER)
  references ENTERPRISES (TICKER);

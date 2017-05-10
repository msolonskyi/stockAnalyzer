-- Create table
create table INDICATOR_VALUES
(
  id                NUMBER(8) not null,
  indicator_link_id NUMBER(8) not null,
  period_id         NUMBER(8) not null,
  value             NUMBER(24,4) not null,
  ticker            VARCHAR2(10) not null
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
alter table INDICATOR_VALUES
  add constraint PK_INDICATOR_VALUES primary key (ID)
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
alter table INDICATOR_VALUES
  add constraint UNQ_INDICATOR_VALUES unique (INDICATOR_LINK_ID, PERIOD_ID, TICKER)
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
alter table INDICATOR_VALUES
  add constraint FK_IND_VALUES$IND_LINK_ID foreign key (INDICATOR_LINK_ID)
  references INDICATORS_LINK (ID);
alter table INDICATOR_VALUES
  add constraint FK_IND_VALUES$PERIOD_ID foreign key (PERIOD_ID)
  references PERIODS (ID);
alter table INDICATOR_VALUES
  add constraint FK_IND_VALUES$TICKER foreign key (TICKER)
  references ENTERPRISES (TICKER);

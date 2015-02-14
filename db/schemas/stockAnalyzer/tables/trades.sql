-- Create table
create table TRADES
(
  id           NUMBER(8) not null,
  ticker       VARCHAR2(10) not null,
  dtm          DATE not null,
  price        NUMBER(12,4) not null,
  vol          NUMBER(12) not null,
  type         CHAR(1) default 'A' not null,
  dimention_id NUMBER(8) default 501 not null
)
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 512K
    next 512K
    minextents 1
    maxextents unlimited
    pctincrease 0
  );
-- Create/Recreate indexes 
create index INDX_TRADES$DTM on TRADES (DTM)
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
create index INDX_TRADES$TICKER on TRADES (TICKER)
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 512K
    next 512K
    minextents 1
    maxextents unlimited
    pctincrease 0
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table TRADES
  add constraint PK_TRADES primary key (ID)
  using index 
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 512K
    next 512K
    minextents 1
    maxextents unlimited
    pctincrease 0
  );
alter table TRADES
  add constraint FK_TRADES$DIMENTION_ID foreign key (DIMENTION_ID)
  references DIMENTIONS (ID);
alter table TRADES
  add constraint FK_TRADES$ENTERPRISES$TICKER foreign key (TICKER)
  references ENTERPRISES (TICKER);

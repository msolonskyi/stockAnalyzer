-- Create table
create table TICKES_BLACK_LIST
(
  ticker   VARCHAR2(10) not null,
  stock_id NUMBER(8) not null
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table TICKES_BLACK_LIST
  add constraint PK_TICKES_BLACK_LIST primary key (TICKER, STOCK_ID)
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
alter table TICKES_BLACK_LIST
  add constraint FK_TICKES_BLACK_LIST$STOCK_ID foreign key (STOCK_ID)
  references STOCKS (ID);
alter table TICKES_BLACK_LIST
  add constraint FK_TICKES_BLACK_LIST$TICKER foreign key (TICKER)
  references ENTERPRISES (TICKER);

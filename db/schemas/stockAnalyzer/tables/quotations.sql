-- Create table
create table QUOTATIONS
(
  id                NUMBER(8) not null,
  ticker            VARCHAR2(10) not null,
  dtm               DATE not null,
  dimention_link_id NUMBER(8) not null,
  open              NUMBER(12,4) not null,
  high              NUMBER(12,4) not null,
  low               NUMBER(12,4) not null,
  close             NUMBER(12,4) not null,
  vol               NUMBER(12) not null,
  trades_qty        NUMBER(12) not null
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
-- Create/Recreate indexes 
create index INDX_QUOTATIONS on QUOTATIONS (TICKER)
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table QUOTATIONS
  add constraint PK_QUOTATIONS primary key (ID)
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
alter table QUOTATIONS
  add constraint UNQ_QUOTATIONS unique (TICKER, DTM, DIMENTION_LINK_ID)
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
alter table QUOTATIONS
  add constraint FK_QUOTATIONS$ENT$DIM_LINK_ID foreign key (DIMENTION_LINK_ID)
  references DIMENTIONS_LINK (ID);
alter table QUOTATIONS
  add constraint FK_QUOTATIONS$ENT$TICKER foreign key (TICKER)
  references ENTERPRISES (TICKER);

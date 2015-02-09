-- Create table
create table ENTERPRISES
(
  ticker            VARCHAR2(10) not null,
  name              VARCHAR2(2000) not null,
  short_name        VARCHAR2(200) not null,
  okpo              VARCHAR2(10) not null,
  economy_sector_id NUMBER(8) not null,
  web_address       VARCHAR2(256),
  owner             VARCHAR2(256),
  comments          VARCHAR2(1024)
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
comment on table ENTERPRISES
  is 'Предприятия';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ENTERPRISES
  add constraint PK_ENTERPRISES primary key (TICKER)
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
alter table ENTERPRISES
  add constraint FK_ENTERPRISES$ES_ID foreign key (ECONOMY_SECTOR_ID)
  references ECONOMY_SECTORS (ID);

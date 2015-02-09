-- Create table
create table INDICATORS
(
  id       NUMBER(8) not null,
  name     VARCHAR2(64) not null,
  priority NUMBER(2) not null,
  type_id  NUMBER(8) not null
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
comment on table INDICATORS
  is 'Индикаторы ';
-- Create/Recreate primary, unique and foreign key constraints 
alter table INDICATORS
  add constraint PK_INDICATORS primary key (ID)
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
alter table INDICATORS
  add constraint UNQ_INDICATORS unique (NAME)
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
alter table INDICATORS
  add constraint FK_INDICATORS$TYPE_ID foreign key (TYPE_ID)
  references INDICATOR_TYPES (ID);

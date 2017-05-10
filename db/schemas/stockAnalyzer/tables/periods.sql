-- Create table
create table PERIODS
(
  id        NUMBER(8) not null,
  name      VARCHAR2(64) not null,
  type      CHAR(1) default 'Y' not null,
  begin_dtm DATE not null,
  end_dtm   DATE not null
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
-- Add comments to the columns 
comment on column PERIODS.type
  is 'Y=year,Q=quarter,L=last 12 month';
-- Create/Recreate primary, unique and foreign key constraints 
alter table PERIODS
  add constraint PK_PERIODS primary key (ID)
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
-- Create/Recreate check constraints 
alter table PERIODS
  add constraint CHK_PERIODS
  check ((TYPE='Y'or TYPE='Q' or TYPE='L'));

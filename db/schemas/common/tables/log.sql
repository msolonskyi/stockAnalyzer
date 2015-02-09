-- Create table
create table LOG
(
  DTM     TIMESTAMP(6) default systimestamp not null,
  TEXT    VARCHAR2(4000) not null,
  PROGRAM VARCHAR2(256) not null,
  TYPE    VARCHAR2(1) default 'I' not null,
  SID     VARCHAR2(20) not null,
  QTY     NUMBER(16)
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
-- Add comments to the columns 
comment on column LOG.TYPE
  is 'I - info, W - warning, E - error';
-- Create/Recreate check constraints 
alter table LOG
  add constraint CHK_LOG
  check (TYPE in ('I', 'W', 'E'));

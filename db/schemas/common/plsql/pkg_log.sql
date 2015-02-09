create or replace package pkg_log is

  -- Author  : N.I.SOLONSKY
  -- Created : 18.03.2008 19:00:13
  -- Purpose : переход на единую таблицу лога

  procedure sp_log_message(pv_text in varchar2, pv_program in varchar2);
  procedure sp_log_message(pv_text in varchar2, pv_program in varchar2, pv_type in varchar2);
  procedure sp_log_message(pv_text in varchar2, pv_program in varchar2, pn_qty in number);
  procedure sp_log_message(pv_text in varchar2, pv_program in varchar2, pv_type in varchar2, pn_qty in number);

end pkg_log;
/
create or replace package body pkg_log is

procedure sp_log_message(pv_text in varchar2, pv_program in varchar2, pv_type in varchar2, pn_qty in number)
as
    PRAGMA AUTONOMOUS_TRANSACTION;
    vv_sid varchar2(20);
Begin
    select sid into vv_sid from v$mystat where rownum = 1;
    insert into common.log (text, program, type, sid, qty)
    values(pv_text, pv_program, upper(pv_type), nvl(vv_sid, 0), pn_qty);
    commit;
Exception
    when others then rollback;
End sp_log_message;

procedure sp_log_message(pv_text in varchar2, pv_program in varchar2, pn_qty in number)
as
Begin
    pkg_log.sp_log_message(pv_text, pv_program, 'I', pn_qty);
Exception
    when others then rollback;
End sp_log_message;

procedure sp_log_message(pv_text in varchar2, pv_program in varchar2, pv_type in varchar2)
as
Begin
    pkg_log.sp_log_message(pv_text, pv_program, pv_type, null);
Exception
    when others then rollback;
End sp_log_message;

procedure sp_log_message(pv_text in varchar2, pv_program in varchar2)
as
Begin
    pkg_log.sp_log_message(pv_text, pv_program, 'I', null);
End sp_log_message;

end pkg_log;
/

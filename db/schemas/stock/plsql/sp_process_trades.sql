create or replace procedure sp_process_trades
as
    vv_module_name common.log.program%type := '��������� ���';
    vn_rowcount    number(8) := 0;
begin
    common.pkg_log.sp_log_message('������.', vv_module_name);
    -- 1. ���������������� ���� �����
    merge into indicator_values iv
    using (select trades.ticker, periods.id as period_id, periods.name,
                  round(max(price * vol) / max(vol), 4) value
           from trades, periods
           where trades.dtm between periods.begin_dtm and periods.end_dtm
           group by trades.ticker, periods.id, periods.name) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_group_link_id = 3001)
    when matched then 
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_group_link_id, iv.period_id, iv.value, iv.ticker)
        values (3001, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    common.pkg_log.sp_log_message('���������������� ���� �����', vv_module_name, vn_rowcount);
    -- 2. ����������� ���� �����
    merge into indicator_values iv
    using (select trades.ticker, periods.id as period_id, periods.name,
                  min(price) value
           from trades, periods
           where trades.dtm between periods.begin_dtm and periods.end_dtm
           group by trades.ticker, periods.id, periods.name) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_group_link_id = 3002)
    when matched then 
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_group_link_id, iv.period_id, iv.value, iv.ticker)
        values (3002, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    common.pkg_log.sp_log_message('����������� ���� �����', vv_module_name, vn_rowcount);
    -- 3. ������������ ���� �����
    merge into indicator_values iv
    using (select trades.ticker, periods.id as period_id, periods.name,
                  max(price) value
           from trades, periods
           where trades.dtm between periods.begin_dtm and periods.end_dtm
           group by trades.ticker, periods.id, periods.name) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_group_link_id = 3003)
    when matched then 
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_group_link_id, iv.period_id, iv.value, iv.ticker)
        values (3003, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    common.pkg_log.sp_log_message('������������ ���� �����', vv_module_name, vn_rowcount);
    -- 4. ��������� ���� �����
    merge into indicator_values iv
    using (select trades.ticker, periods.id as period_id, periods.name,
                  max(price) keep (dense_rank last order by trades.dtm, trades.price) value
           from trades, periods
           where trades.dtm between periods.begin_dtm and periods.end_dtm
           group by trades.ticker, periods.id, periods.name) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_group_link_id = 3004)
    when matched then 
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_group_link_id, iv.period_id, iv.value, iv.ticker)
        values (3004, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    common.pkg_log.sp_log_message('��������� ���� �����', vv_module_name, vn_rowcount);
    -- 5. commit
    commit;
    common.pkg_log.sp_log_message('��������� �������.', vv_module_name);
exception
    when others then
        rollback;
        common.pkg_log.sp_log_message('��������� � �������. ' || sqlcode || ': ' || sqlerrm, vv_module_name, 'e');
end sp_process_trades;

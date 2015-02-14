create or replace procedure sp_process_trades
as
    vv_module_name stockAnalyzer.log.program%type := 'обработка цен';
    vn_rowcount    number(8) := 0;
begin
    pkg_log.sp_log_message('начало.', vv_module_name);
    -- 1. средневзвешенная цена акции
    merge into indicator_values iv
    using (select /*+ use_nl (trades, periods) index (trades, indx_trades$dtm) */
                  trades.ticker, periods.id as period_id, periods.name,
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
    pkg_log.sp_log_message('средневзвешенная цена акции', vv_module_name, vn_rowcount);
    -- 2. минимальная цена акции
    merge into indicator_values iv
    using (select /*+ use_nl (trades, periods) index (trades, indx_trades$dtm) */
                  trades.ticker, periods.id as period_id, periods.name,
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
    pkg_log.sp_log_message('минимальная цена акции', vv_module_name, vn_rowcount);
    -- 3. максимальная цена акции
    merge into indicator_values iv
    using (select /*+ use_nl (trades, periods) index (trades, indx_trades$dtm) */
                  trades.ticker, periods.id as period_id, periods.name,
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
    pkg_log.sp_log_message('максимальная цена акции', vv_module_name, vn_rowcount);
    -- 4. последняя цена акции
    merge into indicator_values iv
    using (select /*+ use_nl (trades, periods) index (trades, indx_trades$dtm) */
                  trades.ticker, periods.id as period_id, periods.name,
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
    pkg_log.sp_log_message('последняя цена акции', vv_module_name, vn_rowcount);
    -- 5. commit
    commit;
    pkg_log.sp_log_message('завершено успешно.', vv_module_name);
exception
    when others then
        rollback;
        pkg_log.sp_log_message('завершено с ошибкой. ' || sqlcode || ': ' || sqlerrm, vv_module_name, 'e');
end sp_process_trades;

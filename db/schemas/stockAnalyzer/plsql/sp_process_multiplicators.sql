create or replace procedure sp_process_multiplicators
as
    vv_module_name stockAnalyzer.log.program%type := 'расчёт мультипликаторов';
    vn_rowcount    number(8) := 0;
    vn_indicator_group_link_id indicator_values.indicator_group_link_id%type;
    vn_dimention_id            indicator_values.dimention_id%type;
begin
    pkg_log.sp_log_message('начало.', vv_module_name);
    -- 1. p/e 3057
    vn_indicator_group_link_id := 3057;
    vn_dimention_id            := 517;
    merge into indicator_values iv
    using  (select lp.ticker, lp.period_id, case when e.value != 0 then round(lp.value * sc.value / (1000 * e.value), 4) else 0 end as value
            from (select id period_id from periods where type = 'Y') p inner join  
                 (select value, ticker, period_id -- последняя цена акции
                  from indicator_values
                  where indicator_group_link_id = 3004) lp on (p.period_id = lp.period_id) inner join
                 (select value, ticker, period_id -- количество акций в обращении
                  from indicator_values
                  where indicator_group_link_id = 3050) sc on (lp.ticker = sc.ticker and lp.period_id = sc.period_id) inner join
                 (select value, ticker, period_id -- чистая прибыль
                  from indicator_values
                  where indicator_group_link_id = 3035) e on (lp.ticker = e.ticker and lp.period_id = e.period_id)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_group_link_id = vn_indicator_group_link_id)
    when matched then 
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_group_link_id, iv.period_id, iv.value, iv.ticker, iv.dimention_id)
        values (vn_indicator_group_link_id, tr.period_id, tr.value, tr.ticker, vn_dimention_id);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('p/e', vv_module_name, vn_rowcount);
    -- 2. p/s 3058
    vn_indicator_group_link_id := 3058;
    vn_dimention_id            := 517;
    merge into indicator_values iv
    using  (select lp.ticker, lp.period_id, case when e.value != 0 then round(lp.value * sc.value / (1000 * e.value), 4) else 0 end as value
            from (select id period_id from periods where type = 'Y') p inner join  
                 (select value, ticker, period_id -- последняя цена акции
                  from indicator_values
                  where indicator_group_link_id = 3004) lp on (p.period_id = lp.period_id) inner join
                 (select value, ticker, period_id -- количество акций в обращении
                  from indicator_values
                  where indicator_group_link_id = 3050) sc on (lp.ticker = sc.ticker and lp.period_id = sc.period_id) inner join
                 (select value, ticker, period_id -- выручка
                  from indicator_values
                  where indicator_group_link_id = 3030) e on (lp.ticker = e.ticker and lp.period_id = e.period_id)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_group_link_id = vn_indicator_group_link_id)
    when matched then 
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_group_link_id, iv.period_id, iv.value, iv.ticker, iv.dimention_id)
        values (vn_indicator_group_link_id, tr.period_id, tr.value, tr.ticker, vn_dimention_id);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('p/s', vv_module_name, vn_rowcount);
    -- 3. p/bv 3059
    vn_indicator_group_link_id := 3059;
    vn_dimention_id            := 517;
    merge into indicator_values iv
    using  (select lp.ticker, lp.period_id, case when e.value != 0 then round(lp.value * sc.value / (1000 * e.value), 4) else 0 end as value
            from (select id period_id from periods where type = 'Y') p inner join  
                 (select value, ticker, period_id -- последняя цена акции
                  from indicator_values
                  where indicator_group_link_id = 3004) lp on (p.period_id = lp.period_id) inner join
                 (select value, ticker, period_id -- количество акций в обращении
                  from indicator_values
                  where indicator_group_link_id = 3050) sc on (lp.ticker = sc.ticker and lp.period_id = sc.period_id) inner join
                 (select value, ticker, period_id -- собственный капитал
                  from indicator_values
                  where indicator_group_link_id = 3034) e on (lp.ticker = e.ticker and lp.period_id = e.period_id)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_group_link_id = vn_indicator_group_link_id)
    when matched then 
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_group_link_id, iv.period_id, iv.value, iv.ticker, iv.dimention_id)
        values (vn_indicator_group_link_id, tr.period_id, tr.value, tr.ticker, vn_dimention_id);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('p/bv', vv_module_name, vn_rowcount);
    -- 4. дивиденды на акцию 3060
    vn_indicator_group_link_id := 3060;
    vn_dimention_id            := 518;
    merge into indicator_values iv
    using  (select lp.ticker, lp.period_id, case when lp.value * sc.value != 0 then round(100000 * dv.value / (lp.value * sc.value), 4) else 0 end as value
            from (select id period_id from periods where type = 'Y') p inner join  
                 (select value, ticker, period_id -- последняя цена акции
                  from indicator_values
                  where indicator_group_link_id = 3004) lp on (p.period_id = lp.period_id) inner join
                 (select value, ticker, period_id -- количество акций в обращении
                  from indicator_values
                  where indicator_group_link_id = 3050) sc on (lp.ticker = sc.ticker and lp.period_id = sc.period_id) inner join
                 (select value, ticker, period_id -- дивиденды
                  from indicator_values
                  where indicator_group_link_id = 3031) dv on (lp.ticker = dv.ticker and lp.period_id = dv.period_id)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_group_link_id = vn_indicator_group_link_id)
    when matched then 
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_group_link_id, iv.period_id, iv.value, iv.ticker, iv.dimention_id)
        values (vn_indicator_group_link_id, tr.period_id, tr.value, tr.ticker, vn_dimention_id);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('дивиденды на акцию', vv_module_name, vn_rowcount);
    -- 5. рентабильность 3061
    vn_indicator_group_link_id := 3061;
    vn_dimention_id            := 519;
    merge into indicator_values iv
    using  (select lp.ticker, lp.period_id, case when sc.value != 0 then round(100 * lp.value / sc.value, 4) else 0 end as value
            from (select id period_id from periods where type = 'Y') p inner join  
                 (select value, ticker, period_id -- чистая прибыль
                  from indicator_values
                  where indicator_group_link_id = 3035) lp on (p.period_id = lp.period_id) inner join
                 (select value, ticker, period_id -- выручка
                  from indicator_values
                  where indicator_group_link_id = 3030) sc on (lp.ticker = sc.ticker and lp.period_id = sc.period_id)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_group_link_id = vn_indicator_group_link_id)
    when matched then 
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_group_link_id, iv.period_id, iv.value, iv.ticker, iv.dimention_id)
        values (vn_indicator_group_link_id, tr.period_id, tr.value, tr.ticker, vn_dimention_id);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('рентабильность', vv_module_name, vn_rowcount);
    -- 6. commit
    commit;
    pkg_log.sp_log_message('завершено успешно.', vv_module_name);
exception
    when others then
        rollback;
        pkg_log.sp_log_message('завершено с ошибкой. ' || sqlcode || ': ' || sqlerrm, vv_module_name, 'e');
end sp_process_multiplicators;

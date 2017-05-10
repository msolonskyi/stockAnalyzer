create or replace procedure sp_process_gpw_quotations
as
    cv_module_name  constant stockAnalyzer.log.program%type := 'process GPW quotations';
    vn_rowcount     number(8) := 0;
    vn_indicator_id indicators.id%type;
    vn_L_period_id  periods.id%type;
    cn_52_week      constant number := 7*52-1/24;
    cn_ind_group_id constant number := 1;
begin
    pkg_log.sp_log_message('start.', cv_module_name);
    --
    select id
    into vn_L_period_id
    from periods
    where type = 'L'
      and rownum < 2;
    -- 1. average share price
    vn_indicator_id := 1001;
    merge into indicator_values iv
    using  (select q.ticker, p.id as period_id, i.id as indicator_link_id,
                   round(sum(((q.high + q.low) / 2) * q.vol) / sum(q.vol), 4) value
            from quotations q, indicators_link i, periods p,
                 enterprises e, stocks s
            where e.stock_id = s.id
              and e.ticker = q.ticker
              and i.dimention_link_id = q.dimention_link_id
              and q.dtm between p.begin_dtm and p.end_dtm
              and s.code = 'GPW'
              and i.indicator_id = vn_indicator_id
              and i.indicator_group_id = cn_ind_group_id
            group by q.ticker, p.id, i.id) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('average share price.', cv_module_name, vn_rowcount);
    -- 1.1. average share price last 52 weeks
    merge into indicator_values iv
    using  (with last_dtm as (select nvl(max(dtm), sysdate) as mdtm
                  from quotations q, enterprises e, stocks s
                  where e.ticker = q.ticker
                    and e.stock_id = s.id 
                    and s.code = 'GPW')
            select q.ticker, vn_L_period_id as period_id, i.id as indicator_link_id,
                   round(sum(((q.high + q.low) / 2) * q.vol) / sum(q.vol), 4) value
            from quotations q, indicators_link i,
                 enterprises e, stocks s
            where e.stock_id = s.id
              and e.ticker = q.ticker
              and i.dimention_link_id = q.dimention_link_id
              and q.dtm between (select mdtm from last_dtm) - cn_52_week and (select mdtm from last_dtm)
              and s.code = 'GPW'
              and i.indicator_id = vn_indicator_id
              and i.indicator_group_id = cn_ind_group_id
            group by q.ticker, i.id) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('average share price last 52 weeks.', cv_module_name, vn_rowcount);
    -- 2. minimum share price
    vn_indicator_id := 1002;
    merge into indicator_values iv
    using  (select q.ticker, p.id as period_id, i.id as indicator_link_id,
                   min(q.low) value
            from quotations q, indicators_link i, periods p,
                 enterprises e, stocks s
            where e.stock_id = s.id
              and e.ticker = q.ticker
              and i.dimention_link_id = q.dimention_link_id
              and q.dtm between p.begin_dtm and p.end_dtm
              and s.code = 'GPW'
              and i.indicator_id = vn_indicator_id
              and i.indicator_group_id = cn_ind_group_id
            group by q.ticker, p.id, i.id) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('minimum share price.', cv_module_name, vn_rowcount);
    -- 2.1. minimum share price last 52 weeks
    merge into indicator_values iv
    using  (with last_dtm as (select nvl(max(dtm), sysdate) as mdtm
                  from quotations q, enterprises e, stocks s
                  where e.ticker = q.ticker
                    and e.stock_id = s.id 
                    and s.code = 'GPW')
            select q.ticker, vn_L_period_id as period_id, i.id as indicator_link_id,
                   min(q.low) value
            from quotations q, indicators_link i,
                 enterprises e, stocks s
            where e.stock_id = s.id
              and e.ticker = q.ticker
              and i.dimention_link_id = q.dimention_link_id
              and q.dtm between (select mdtm from last_dtm) - cn_52_week and (select mdtm from last_dtm)
              and s.code = 'GPW'
              and i.indicator_id = vn_indicator_id
              and i.indicator_group_id = cn_ind_group_id
            group by q.ticker, i.id) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('minimum share price last 52 weeks.', cv_module_name, vn_rowcount);
    -- 3. maximum share price
    vn_indicator_id := 1003;
    merge into indicator_values iv
    using  (select q.ticker, p.id as period_id, i.id as indicator_link_id,
                   max(q.high) value
            from quotations q, indicators_link i, periods p,
                 enterprises e, stocks s
            where e.stock_id = s.id
              and e.ticker = q.ticker
              and i.dimention_link_id = q.dimention_link_id
              and q.dtm between p.begin_dtm and p.end_dtm
              and s.code = 'GPW'
              and i.indicator_id = vn_indicator_id
              and i.indicator_group_id = cn_ind_group_id
            group by q.ticker, p.id, i.id) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('maximum share price.', cv_module_name, vn_rowcount);
    -- 3.1. maximum share price last 52 weeks
    merge into indicator_values iv
    using  (with last_dtm as (select nvl(max(dtm), sysdate) as mdtm
                  from quotations q, enterprises e, stocks s
                  where e.ticker = q.ticker
                    and e.stock_id = s.id 
                    and s.code = 'GPW')
            select q.ticker, vn_L_period_id as period_id, i.id as indicator_link_id,
                   max(q.high) value
            from quotations q, indicators_link i,
                 enterprises e, stocks s
            where e.stock_id = s.id
              and e.ticker = q.ticker
              and i.dimention_link_id = q.dimention_link_id
              and q.dtm between (select mdtm from last_dtm) - cn_52_week and (select mdtm from last_dtm)
              and s.code = 'GPW'
              and i.indicator_id = vn_indicator_id
              and i.indicator_group_id = cn_ind_group_id
            group by q.ticker, i.id) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('maximum share price last 52 weeks.', cv_module_name, vn_rowcount);
    -- 4. current share price
    vn_indicator_id := 1004;
    merge into indicator_values iv
    using  (select q.ticker, p.id as period_id, i.id as indicator_link_id,
                   max(q.close) keep (dense_rank last order by q.dtm) value
            from quotations q, indicators_link i, periods p,
                 enterprises e, stocks s
            where e.stock_id = s.id
              and e.ticker = q.ticker
              and i.dimention_link_id = q.dimention_link_id
              and q.dtm between p.begin_dtm and p.end_dtm
              and s.code = 'GPW'
              and i.indicator_id = vn_indicator_id
              and i.indicator_group_id = cn_ind_group_id
            group by q.ticker, p.id, i.id) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('current share price.', cv_module_name, vn_rowcount);
    -- 4.1 current share price
    merge into indicator_values iv
    using  (with last_dtm as (select nvl(max(dtm), sysdate) as mdtm
                  from quotations q, enterprises e, stocks s
                  where e.ticker = q.ticker
                    and e.stock_id = s.id 
                    and s.code = 'GPW')
            select q.ticker, vn_L_period_id as period_id, i.id as indicator_link_id,
                   max(q.close) keep (dense_rank last order by q.dtm) value
            from quotations q, indicators_link i,
                 enterprises e, stocks s
            where e.stock_id = s.id
              and e.ticker = q.ticker
              and i.dimention_link_id = q.dimention_link_id
              and q.dtm between (select mdtm from last_dtm) - cn_52_week and (select mdtm from last_dtm)
              and s.code = 'GPW'
              and i.indicator_id = vn_indicator_id
              and i.indicator_group_id = cn_ind_group_id
            group by q.ticker, i.id) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('current share price last 52 weeks.', cv_module_name, vn_rowcount);
    -- 5. commit
    commit;
    pkg_log.sp_log_message('completed successfully.', cv_module_name);
exception
    when others then
        rollback;
        pkg_log.sp_log_message('completed with error. ' || sqlcode || ': ' || sqlerrm, cv_module_name, 'E');
end sp_process_gpw_quotations;
/

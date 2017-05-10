create or replace procedure sp_process_snapshot_values
as
    cv_module_name    constant stockAnalyzer.log.program%type := 'process snapshot values';
    cn_ind_group_id   constant number := 1;
    cn_month_duration constant number := 6;
    vn_rowcount       number(8) := 0;
    vn_L_period_id    periods.id%type;
begin
    pkg_log.sp_log_message('start.', cv_module_name);
    select id
    into vn_L_period_id
    from periods
    where type = 'L'
      and rownum < 2;
    -- 1. Shares Outstanding 1022, 3022 (Snapshot)
    merge into indicator_values iv
    using  (select value, ticker, vn_L_period_id as period_id, indicator_link_id -- Shares Outstanding
            from (select value, row_number() over (partition by ticker order by period_name desc) as rn, ticker, indicator_link_id
                  from vw_indicator_values where indicator_link_id = 3022 and period_type = 'Y')
            where rn <= 1) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value and tr.value > 0
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Shares Outstanding (Snapshot)', cv_module_name, vn_rowcount);
    -- 2. Market Cap 3072 (Snapshot)
    merge into indicator_values iv
    using  (select lp.ticker, lp.period_id, il.id as indicator_link_id,
                   round(sc.value * lp.value, 4) as value
            from (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Latest share price
                  from vw_indicator_values
                  where indicator_id = 1004
                   and period_id = vn_L_period_id
                   and indicator_group_id = cn_ind_group_id) lp inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Shares Outstanding
                  from vw_indicator_values
                  where indicator_id = 1022
                   and period_id = vn_L_period_id
                   and indicator_group_id = cn_ind_group_id) sc on (lp.ticker = sc.ticker) inner join
                 vw_indicators_link il on (il.indicator_id = 1072 and indicator_group_id = cn_ind_group_id and il.dimention_id = lp.dimention_id)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value and tr.value > 0
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Market Cap (Snapshot)', cv_module_name, vn_rowcount);
    -- 3. Earning [Net income] 3045 (Snapshot)
    merge into indicator_values iv
    using  (select e.ticker, vn_L_period_id as period_id, 3045 as indicator_link_id, e.value
            from (select sum(value) value, ticker, dimention_id, multiplier_multiplier -- Net income
                  from (select value, ticker, period_name, period_id, dimention_id, multiplier_multiplier,
                               row_number() over (partition by ticker order by period_name desc) as rn
                        from vw_indicator_values
                        where indicator_id = 1045
                          and indicator_group_id = cn_ind_group_id
                          and period_type = 'Q')
                  where rn <= 4
                    and period_id in (select id
                                      from (select id
                                            from periods
                                            where type = 'Q'
                                              and name <= (select max(period_name)
                                                           from vw_indicator_values
                                                           where indicator_id = 1045
                                                             and indicator_group_id = cn_ind_group_id
                                                             and period_type = 'Q')
                                            order by name desc)
                                      where rownum <= cn_month_duration)
                  group by ticker, dimention_id, multiplier_multiplier) e) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Calculate Earning [Net income] (Snapshot)', cv_module_name, vn_rowcount);
    -- 4. Revenue [Sales] 3010 (Snapshot)
    merge into indicator_values iv
    using  (select e.ticker, vn_L_period_id as period_id, 3010 as indicator_link_id, e.value
            from (select sum(value) value, ticker, dimention_id, multiplier_multiplier -- Revenue
                  from (select value, ticker, period_name, period_id, dimention_id, multiplier_multiplier,
                               row_number() over (partition by ticker order by period_name desc) as rn
                        from vw_indicator_values
                        where indicator_id = 1010
                          and indicator_group_id = cn_ind_group_id
                          and period_type = 'Q')
                  where rn <= 4
                    and period_id in (select id
                                      from (select id
                                            from periods
                                            where type = 'Q'
                                              and name <= (select max(period_name)
                                                           from vw_indicator_values
                                                           where indicator_id = 1010
                                                             and indicator_group_id = cn_ind_group_id
                                                             and period_type = 'Q')
                                            order by name desc)
                                      where rownum <= cn_month_duration)
                  group by ticker, dimention_id, multiplier_multiplier) e) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value and tr.value > 0
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Calculate Revenue [Sales] (Snapshot)', cv_module_name, vn_rowcount);
    -- 5. Equity [Book Value] 3037 (Snapshot)
    merge into indicator_values iv
    using  (select e.ticker, vn_L_period_id as period_id, 3037 as indicator_link_id, e.value
            from (select value, ticker, dimention_id, multiplier_multiplier -- Equity
                  from (select value, ticker, period_name, period_id, dimention_id, multiplier_multiplier,
                               row_number() over (partition by ticker order by period_name desc) as rn
                        from vw_indicator_values
                        where indicator_id = 1037
                          and indicator_group_id = cn_ind_group_id
                          and period_type in ('Q', 'Y'))
                  where rn <= 1
                    and period_id in (select id
                                      from (select id
                                            from periods
                                            where type  in ('Q', 'Y')
                                              and name <= (select max(period_name)
                                                           from vw_indicator_values
                                                           where indicator_id = 1037
                                                             and indicator_group_id = cn_ind_group_id
                                                             and period_type  in ('Q', 'Y'))
                                            order by name desc)
                                      where rownum <= cn_month_duration)) e) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Calculate Equity [Book Value] (Snapshot)', cv_module_name, vn_rowcount);
    -- 11. P/E Ratio 3057 (Snapshot)
    merge into indicator_values iv
    using  (select mc.ticker, mc.period_id, 3057 as indicator_link_id,
                   case when ni.value != 0 then round(mc.value * mc.multiplier_multiplier / (ni.value * ni.multiplier_multiplier), 4) else 0 end as value
            from (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Market Cap
                  from vw_indicator_values
                  where indicator_id = 1072
                    and period_id = vn_L_period_id
                    and indicator_group_id = cn_ind_group_id) mc inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Net income
                  from vw_indicator_values
                  where indicator_id = 1045
                    and period_id = vn_L_period_id
                    and indicator_group_id = cn_ind_group_id) ni on (mc.ticker = ni.ticker)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Calculate P/E Ratio (Snapshot)', cv_module_name, vn_rowcount);
    -- 12. Price/Book 3059 (Snapshot)
    merge into indicator_values iv
    using  (select mc.ticker, mc.period_id, 3059 as indicator_link_id,
                   case when bv.value != 0 then round(mc.value * mc.multiplier_multiplier / (bv.value * bv.multiplier_multiplier), 4) else 0 end as value
            from (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Market Cap
                  from vw_indicator_values
                  where indicator_id = 1072
                    and period_id = vn_L_period_id
                    and indicator_group_id = cn_ind_group_id) mc inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Book Value
                  from vw_indicator_values
                  where indicator_id = 1037
                    and period_id = vn_L_period_id
                    and indicator_group_id = cn_ind_group_id) bv on (mc.ticker = bv.ticker)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Calculate Price/Book (Snapshot)', cv_module_name, vn_rowcount);
    -- 13. Price/Sale 3058 (Snapshot)
    merge into indicator_values iv
    using  (select mc.ticker, mc.period_id, 3058 as indicator_link_id,
                   case when s.value != 0 then round(mc.value * mc.multiplier_multiplier / (s.value * s.multiplier_multiplier), 4) else 0 end as value
            from (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Market Cap
                  from vw_indicator_values
                  where indicator_id = 1072
                    and period_id = vn_L_period_id
                    and indicator_group_id = cn_ind_group_id) mc inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Sales
                  from vw_indicator_values
                  where indicator_id = 1010
                    and period_id = vn_L_period_id
                    and indicator_group_id = cn_ind_group_id) s on (mc.ticker = s.ticker)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value and tr.value > 0
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Calculate Price/Sale (Snapshot)', cv_module_name, vn_rowcount);
    -- 14. Earnings Per Share 3071 (Snapshot)
    merge into indicator_values iv
    using  (select so.ticker, so.period_id, 3071 as indicator_link_id,
                   case when so.value != 0 then round(ni.value * ni.multiplier_multiplier / (so.value * so.multiplier_multiplier), 4) else 0 end as value
            from (select id period_id from periods where type = 'L') p inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Shares Outstanding
                  from vw_indicator_values
                  where indicator_id = 1022
                    and period_id = vn_L_period_id
                    and indicator_group_id = 1) so on (p.period_id = so.period_id) inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Net income
                  from vw_indicator_values
                  where indicator_id = 1045
                    and period_id = vn_L_period_id
                    and indicator_group_id = 1) ni on (so.ticker = ni.ticker and so.period_id = ni.period_id)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Calculate Earnings Per Share (Snapshot)', cv_module_name, vn_rowcount);
    -- 111. commit
    commit;
    pkg_log.sp_log_message('completed successfully.', cv_module_name);
exception
    when others then
        rollback;
        pkg_log.sp_log_message('completed with error. ' || sqlcode || ': ' || sqlerrm, cv_module_name, 'E');
end sp_process_snapshot_values;
/

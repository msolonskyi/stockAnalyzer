create or replace procedure sp_process_multiplicators
as
    cv_module_name  constant stockAnalyzer.log.program%type := 'process multiplicators';
    cn_ind_group_id constant number := 1;
    vn_rowcount     number(8) := 0;
begin
    pkg_log.sp_log_message('start.', cv_module_name);
    -- 1. Liabilities 1031
    merge into indicator_values iv
    using  (select iv.ticker, iv.period_id, ils.id as indicator_link_id,
                   sum(value) value
            from indicator_values iv, indicators_link il, indicators_link ils
            where iv.indicator_link_id = il.id
              and il.indicator_id in (1068, 1067) -- Current liabilities 1067, Fixed liabilities 1068
              and il.dimention_link_id = ils.dimention_link_id
              and il.indicator_group_id = ils.indicator_group_id
              and ils.indicator_id = 1031
              and il.indicator_group_id = cn_ind_group_id
            group by iv.ticker, iv.period_id, ils.id) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Calculate Liabilities', cv_module_name, vn_rowcount);
    -- 2. P/E Ratio 1057, 3057
    merge into indicator_values iv
    using  (select lp.ticker, lp.period_id, 3057 as indicator_link_id,
                   case when e.value != 0 then round(lp.value * lp.multiplier_multiplier * sc.value * sc.multiplier_multiplier / (e.value * e.multiplier_multiplier), 4) else 0 end as value
            from (select id period_id from periods where type = 'Y') p inner join  
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Latest share price
                  from vw_indicator_values
                  where indicator_id = 1004
                    and indicator_group_id = cn_ind_group_id) lp on (p.period_id = lp.period_id) inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Shares Outstanding
                  from vw_indicator_values
                  where indicator_id = 1022
                    and indicator_group_id = cn_ind_group_id) sc on (lp.ticker = sc.ticker and lp.period_id = sc.period_id) inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Net income
                  from vw_indicator_values
                  where indicator_id = 1045
                    and indicator_group_id = cn_ind_group_id) e on (lp.ticker = e.ticker and lp.period_id = e.period_id and lp.dimention_id = e.dimention_id)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value and tr.value > 0
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Calculate P/E Ratio', cv_module_name, vn_rowcount);
    -- 3. Price/Sale 1058, 3058
    merge into indicator_values iv
    using  (select lp.ticker, lp.period_id, 3058 as indicator_link_id,
                   case when e.value != 0 then round(lp.value * lp.multiplier_multiplier * sc.value * sc.multiplier_multiplier / (e.value * e.multiplier_multiplier), 4) else 0 end as value
            from (select id period_id from periods where type = 'Y') p inner join  
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Latest share price
                  from vw_indicator_values
                  where indicator_id = 1004
                    and indicator_group_id = cn_ind_group_id) lp on (p.period_id = lp.period_id) inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Shares Outstanding
                  from vw_indicator_values
                  where indicator_id = 1022
                    and indicator_group_id = cn_ind_group_id) sc on (lp.ticker = sc.ticker and lp.period_id = sc.period_id) inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Revenue
                  from vw_indicator_values
                  where indicator_id = 1010
                    and indicator_group_id = cn_ind_group_id) e on (lp.ticker = e.ticker and lp.period_id = e.period_id and lp.dimention_id = e.dimention_id)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value and tr.value > 0
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Calculate Price/Sale', cv_module_name, vn_rowcount);
    -- 4. Price/Book 3059
    merge into indicator_values iv
    using  (select lp.ticker, lp.period_id, 3059 as indicator_link_id,
                   case when e.value != 0 then round(lp.value * lp.multiplier_multiplier * sc.value * sc.multiplier_multiplier / (e.value * e.multiplier_multiplier), 4) else 0 end as value
            from (select id period_id from periods where type = 'Y') p inner join  
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Latest share price
                  from vw_indicator_values
                  where indicator_id = 1004
                    and indicator_group_id = cn_ind_group_id) lp on (p.period_id = lp.period_id) inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Shares Outstanding
                  from vw_indicator_values
                  where indicator_id = 1022
                    and indicator_group_id = cn_ind_group_id) sc on (lp.ticker = sc.ticker and lp.period_id = sc.period_id) inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Equity
                  from vw_indicator_values
                  where indicator_id = 1037
                    and indicator_group_id = cn_ind_group_id) e on (lp.ticker = e.ticker and lp.period_id = e.period_id and lp.dimention_id = e.dimention_id)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value and tr.value > 0
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Calculate Price/Book', cv_module_name, vn_rowcount);
    -- 5. Dividends per share 1060
    merge into indicator_values iv
    using  (select sc.ticker, sc.period_id, il.id as indicator_link_id,
                   case when sc.value != 0 then round(e.value * e.multiplier_multiplier / (sc.value * sc.multiplier_multiplier), 4) else 0 end as value
            from (select id period_id from periods where type = 'Y') p inner join  
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Shares Outstanding
                  from vw_indicator_values
                  where indicator_id = 1022
                    and indicator_group_id = cn_ind_group_id) sc on (p.period_id = sc.period_id) inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Dividends
                  from vw_indicator_values
                  where indicator_id = 1014
                    and indicator_group_id = cn_ind_group_id) e on (sc.ticker = e.ticker and p.period_id = e.period_id) inner join
                 vw_indicators_link il on (il.indicator_id = 1060 and indicator_group_id = cn_ind_group_id and il.dimention_id = e.dimention_id)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value and tr.value > 0
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Calculate Dividends per share', cv_module_name, vn_rowcount);
    -- 6. Retained earnings/Share 1074
    merge into indicator_values iv
    using  (select sc.ticker, sc.period_id, il.id as indicator_link_id,
                   case when sc.value != 0 then round(e.value * e.multiplier_multiplier / (sc.value * sc.multiplier_multiplier), 4) else 0 end as value
            from (select id period_id from periods where type = 'Y') p inner join  
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Shares Outstanding
                  from vw_indicator_values
                  where indicator_id = 1022
                    and indicator_group_id = cn_ind_group_id) sc on (p.period_id = sc.period_id) inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Retained earnings
                  from vw_indicator_values
                  where indicator_id = 1029
                    and indicator_group_id = cn_ind_group_id) e on (sc.ticker = e.ticker and p.period_id = e.period_id) inner join
                 vw_indicators_link il on (il.indicator_id = 1074 and indicator_group_id = cn_ind_group_id and il.dimention_id = e.dimention_id)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value and tr.value > 0
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Calculate Retained earnings/Share', cv_module_name, vn_rowcount);
    -- 7. Profitability 3061
    merge into indicator_values iv
    using  (select lp.ticker, lp.period_id, 3061 as indicator_link_id,
                   case when sc.value != 0 then round(100 * lp.value * lp.multiplier_multiplier / (sc.value * sc.multiplier_multiplier), 4) else 0 end as value
            from (select id period_id from periods where type = 'Y') p inner join  
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Net income
                  from vw_indicator_values
                  where indicator_id = 1045
                    and indicator_group_id = cn_ind_group_id) lp on (p.period_id = lp.period_id) inner join
                 (select value, ticker, period_id, dimention_id, multiplier_multiplier -- Revenue
                  from vw_indicator_values
                  where indicator_id = 1010
                    and indicator_group_id = cn_ind_group_id) sc on (lp.ticker = sc.ticker and lp.period_id = sc.period_id and lp.dimention_id = sc.dimention_id)) tr
    on (iv.period_id = tr.period_id and iv.ticker = tr.ticker and iv.indicator_link_id = tr.indicator_link_id)
    when matched then
        update set iv.value = tr.value where iv.value != tr.value and tr.value > 0
    when not matched then
        insert (iv.indicator_link_id, iv.period_id, iv.value, iv.ticker)
        values (tr.indicator_link_id, tr.period_id, tr.value, tr.ticker);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('Calculate Profitability', cv_module_name, vn_rowcount);
    -- 8. commit
    commit;
    pkg_log.sp_log_message('completed successfully.', cv_module_name);
exception
    when others then
        rollback;
        pkg_log.sp_log_message('completed with error. ' || sqlcode || ': ' || sqlerrm, cv_module_name, 'E');
end sp_process_multiplicators;
/

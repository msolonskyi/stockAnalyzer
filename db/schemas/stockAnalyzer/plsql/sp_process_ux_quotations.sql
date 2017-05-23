create or replace procedure sp_process_ux_quotations
as
    cv_module_name    constant stockAnalyzer.log.program%type := 'process UX quotations';
    vn_rowcount       number(8) := 0;
begin
    pkg_log.sp_log_message('start.', cv_module_name);
    -- 1. merge
    merge into quotations q
    using (select ticker, trim(dtm) as dtm, dimention_link_id,
                  min(price) keep (dense_rank first order by dtm) open,
                  max(price) high,
                  min(price) low,
                  max(price) keep (dense_rank last order by dtm) close,
                  sum(vol) vol, count(vol) trades_qty
           from trades
           group by ticker, trim(dtm), dimention_link_id) tr
    on (q.ticker = tr.ticker and q.dimention_link_id = tr.dimention_link_id and trim(q.dtm) = trim(tr.dtm))
    when matched then
        update set open       = tr.open,
                   high       = tr.high,
                   low        = tr.low,
                   close      = tr.close,
                   vol        = tr.vol,
                   trades_qty = tr.trades_qty
        where open       != tr.open
          and high       != tr.high
          and low        != tr.low
          and close      != tr.close
          and vol        != tr.vol
          and trades_qty != tr.trades_qty
    when not matched then
        insert (ticker, dtm, dimention_link_id, open, high, low, close, vol, trades_qty)
        values (tr.ticker, tr.dtm, tr.dimention_link_id, tr.open, tr.high, tr.low, tr.close, tr.vol, tr.trades_qty);
    vn_rowcount := SQL%rowcount;
    pkg_log.sp_log_message('processed', cv_module_name, vn_rowcount);
    -- 111. commit
    commit;
    pkg_log.sp_log_message('completed successfully.', cv_module_name);
exception
    when others then
        rollback;
        pkg_log.sp_log_message('completed with error. ' || sqlcode || ': ' || sqlerrm, cv_module_name, 'E');
end sp_process_ux_quotations;
/

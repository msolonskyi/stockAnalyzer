create or replace procedure sp_insert_quotations(
    p_ticker            in quotations.ticker%type,
    p_dtm               in quotations.dtm%type,
    p_dimention_link_id in quotations.dimention_link_id%type default 531, -- PLN
    p_open              in quotations.open%type,
    p_high              in quotations.high%type,
    p_low               in quotations.low%type,
    p_close             in quotations.close%type,
    p_vol               in quotations.vol%type,
    p_trades_qty        in quotations.trades_qty%type)
is
    cv_module_name  constant stockAnalyzer.log.program%type := 'insert quotations';
Begin
    merge into quotations q
    using (select p_ticker            ticker,
                  p_dtm               dtm,
                  p_dimention_link_id dimention_link_id,
                  p_open              open,
                  p_high              high,
                  p_low               low,
                  p_close             close,
                  p_vol               vol,
                  p_trades_qty        trades_qty
           from dual) s
    on (s.ticker = q.ticker and s.dtm = q.dtm and s.dimention_link_id = q.dimention_link_id)
    when matched then
        update set
            open       = nvl(s.open,       open),
            high       = nvl(s.high,       high),
            low        = nvl(s.low,        low),
            close      = nvl(s.close,      close),
            vol        = nvl(s.vol,        vol),
            trades_qty = nvl(s.trades_qty, trades_qty)
    when not matched then
        insert (ticker, dtm, dimention_link_id, open, high, low, close, vol, trades_qty)
        values (p_ticker, p_dtm, p_dimention_link_id, p_open, p_high, p_low, p_close, p_vol, p_trades_qty);
    --
    commit;
exception
    when others then
        rollback;
        pkg_log.sp_log_message('completed with error. ' || sqlcode || ': ' || sqlerrm, cv_module_name, 'E');
        raise;
end sp_insert_quotations;
/

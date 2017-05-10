create or replace procedure sp_load_ux_Q_trades
as
    cv_module_name  constant stockAnalyzer.log.program%type := 'load trades from ux.ua (Q)';
    vn_days         constant number(8) := 200; -- duration in days
    --
    va_arr          apex_application_global.vc_arr2;
    --
    vt_req          utl_http.req;
    vt_resp         utl_http.resp;
    vv_value        varchar2(1024);
    --
    vv_end_dtm      varchar2(8);
    type t_ent is
        record (ticker enterprises.ticker%type,
                db date);
    type t_ent_table is table of t_ent;
    vt_ent_table t_ent_table;
    --
    type t_trades is
        record (ticker trades.ticker%type,
                dtm trades.dtm%type,
                price trades.price%type,
                vol trades.vol%type);
    type t_trades_table is table of t_trades;
    vt_trades_table t_trades_table;
Begin
    pkg_log.sp_log_message('begin.', cv_module_name);
    -- 1. tickers list
    select e.ticker, max(trades.dtm) db
    bulk collect into vt_ent_table
    from enterprises e left outer join trades on (e.ticker = trades.ticker and trades.type = 'Q')
    where e.ticker not in (select ticker from tickes_black_list b inner join stocks s on (b.stock_id = s.id) where s.code = 'UX')
      and e.stock_id = (select id from stocks where code = 'UX')
    group by e.ticker;
    -- 2. loop for tickers
    for indx in 1 .. vt_ent_table.count
    loop
        if ((sysdate - nvl(vt_ent_table(indx).db, pkg_const.sf_get_const_first_price_date())) >= 1) then
            begin
                -- 3. HTTP request
                -- proxy
                select 'http://'||(select value from settings where name = 'proxy_user')||':'||(select value from settings where name = 'proxy_password')||'@'||(select value from settings where name = 'proxy_server')||':'||(select value from settings where name = 'proxy_port')
                into vv_value
                from dual;
                if (vv_value != 'http://:@:') then -- if settings table is empty (there is no proxy)
                    utl_http.set_proxy(vv_value);
                end if;
                --
                vt_trades_table := t_trades_table();
                if ((sysdate - nvl(vt_ent_table(indx).db, pkg_const.sf_get_const_first_price_date())) >= 10) then
                    vv_end_dtm := to_char(nvl(vt_ent_table(indx).db, pkg_const.sf_get_const_first_price_date()) + vn_days, 'yyyymmdd');
                else
                    vv_end_dtm := to_char(sysdate, 'yyyymmdd');
                end if;
                vv_value := 'http://www.ux.ua/ru/marketdata/issueresults-csv.aspx?day1='||to_char(nvl(vt_ent_table(indx).db, pkg_const.sf_get_const_first_price_date()) + 1, 'yyyymmdd')||'&'||'day2='||vv_end_dtm||'&'||'iss='||vt_ent_table(indx).ticker||'&'||'frmDataType=2'||'&'||'type=2';
                vt_req := utl_http.begin_request(vv_value);
                vt_resp := utl_http.get_response(vt_req);
                -- first row contain colunm names
                utl_http.read_line(vt_resp, vv_value, true);
                loop
                    utl_http.read_line(vt_resp, vv_value, true);
                    -- 4. insert into plsql table
                    if (vv_value in (pkg_const.em_over_20000, pkg_const.em_no_data_found)) then
                        pkg_log.sp_log_message('ticker '||vt_ent_table(indx).ticker||' '||vv_value, cv_module_name, 'W');
                        exit;
                    else
                        va_arr := apex_util.string_to_table(vv_value, ';');
                        if (va_arr(6) = 'Q') then
                            vt_trades_table.extend;
                            vt_trades_table(vt_trades_table.last).ticker := va_arr(1);
                            vt_trades_table(vt_trades_table.last).dtm    := to_date(va_arr(2), 'dd.mm.yyyy hh24:mi:ss');
                            vt_trades_table(vt_trades_table.last).price  := to_number(replace(va_arr(3), ',', '.'));
                            vt_trades_table(vt_trades_table.last).vol    := va_arr(5);
                        end if;
                    end if;
                end loop;
                utl_http.end_response(vt_resp);
            exception when utl_http.end_of_body then
                utl_http.end_response(vt_resp);
            end;
            -- 5. bulk insert into table
            forall i in vt_trades_table.first..vt_trades_table.last
                insert into trades(ticker, dtm, price, vol, type)
                values(vt_trades_table(i).ticker, vt_trades_table(i).dtm, vt_trades_table(i).price, vt_trades_table(i).vol, 'Q');
            pkg_log.sp_log_message('ticker '||vt_ent_table(indx).ticker || ' loaded', cv_module_name, vt_trades_table.count);
            -- 6. commit
            commit;
        end if;
    end loop;
    pkg_log.sp_log_message('completed successfully.', cv_module_name);
exception
    when others then
        rollback;
        pkg_log.sp_log_message('completed with error. ' || sqlcode || ': ' || sqlerrm, cv_module_name, 'E');
end sp_load_ux_Q_trades;
/

create or replace procedure sp_load_A_trades
as
    vv_module_name stockAnalyzer.log.program%type := 'load trades from ux.ua (A)';
    vn_days        number(8) := 200; -- глубина запроса в днях
    --
    va_arr         apex_application_global.vc_arr2;
    --
    vt_req         utl_http.req;
    vt_resp        utl_http.resp;
    vv_value       varchar2(1024);
    --
    vv_end_dtm     varchar2(8);
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
    pkg_log.sp_log_message('начало.', vv_module_name);
    -- 1. список тикеров
    select enterprises.ticker, max(trades.dtm) db
    bulk collect into vt_ent_table
    from enterprises left outer join trades on (enterprises.ticker = trades.ticker and trades.type = 'A')
    group by enterprises.ticker;
    -- 2. цикл по предприятиям
    for indx in 1 .. vt_ent_table.count
    loop
        if ((sysdate - nvl(vt_ent_table(indx).db, pkg_const.sf_get_const_first_price_date())) >= 1) then
            begin
                -- 3. HTTP запрос
                -- proxy
                select 'http://'||(select value from settings where name = 'proxy_user')||':'||(select value from settings where name = 'proxy_password')||'@'||(select value from settings where name = 'proxy_server')||':'||(select value from settings where name = 'proxy_port')
                into vv_value
                from dual;
                if (vv_value != 'http://:@:') then -- если если значения в табличке настроек
                    utl_http.set_proxy(vv_value);
                end if;
                --
                vt_trades_table := t_trades_table();
                if ((sysdate - nvl(vt_ent_table(indx).db, pkg_const.sf_get_const_first_price_date())) >= 10) then
                    vv_end_dtm := to_char(nvl(vt_ent_table(indx).db, pkg_const.sf_get_const_first_price_date()) + vn_days, 'ddmmyyyy');
                else
                    vv_end_dtm := to_char(sysdate, 'ddmmyyyy');
                end if;
                vv_value := 'http://mdata.ux.ua/qdata.aspx?code='||vt_ent_table(indx).ticker||'&'||'pb='||to_char(nvl(vt_ent_table(indx).db, pkg_const.sf_get_const_first_price_date()) + 1, 'ddmmyyyy')||'&'||'pe='||vv_end_dtm||'&'||'p=0'||'&'||'mk=1'||'&'||'ext=0'||'&'||'sep=2'||'&'||'div=2'||'&'||'df=5'||'&'||'tf=2'||'&'||'ih=0';
                --pkg_log.sp_log_message(vv_value, vv_module_name);
                vt_req := utl_http.begin_request(vv_value);
                vt_resp := utl_http.get_response(vt_req);
                loop
                    utl_http.read_line(vt_resp, vv_value, true);
                    -- 4. insert into plsql table
                    if (vv_value in ('В результате запроса превышено максимальное количество записей = 20000', 'Записей не найдено')) then
                        pkg_log.sp_log_message('тикер '||vt_ent_table(indx).ticker||' '||vv_value, vv_module_name, 'W');
                        exit;
                    else
                        va_arr := apex_util.string_to_table(vv_value, ',');
                        vt_trades_table.extend;
                        vt_trades_table(vt_trades_table.last).ticker := va_arr(1);
                        vt_trades_table(vt_trades_table.last).dtm    := to_date(va_arr(3)||va_arr(4), 'yyyymmddhh24miss');
                        vt_trades_table(vt_trades_table.last).price  := to_number(va_arr(5));
                        vt_trades_table(vt_trades_table.last).vol    := va_arr(6);
                    end if;
                end loop;
                utl_http.end_response(vt_resp);
            exception when utl_http.end_of_body then
                utl_http.end_response(vt_resp);
            end;
            -- 5. bulk insert into table
            forall i in vt_trades_table.first..vt_trades_table.last
                insert into trades(ticker, dtm, price, vol)
                values(vt_trades_table(i).ticker, vt_trades_table(i).dtm, vt_trades_table(i).price, vt_trades_table(i).vol);
            pkg_log.sp_log_message('тикер '||vt_ent_table(indx).ticker || ' обработан', vv_module_name, vt_trades_table.count);
            -- 6. commit
            commit;
        end if;
    end loop;
    pkg_log.sp_log_message('завершено успешно.', vv_module_name);
exception
    when others then
        rollback;
        pkg_log.sp_log_message('завершено с ошибкой. ' || sqlcode || ': ' || sqlerrm, vv_module_name, 'E');
end sp_load_A_trades;

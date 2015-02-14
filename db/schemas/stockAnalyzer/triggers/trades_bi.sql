create or replace trigger trades_BI 
                          before insert on trades
                          for each row
begin
    :new.ticker := trim(:new.ticker);
    if :new.ID is null then
        select seq_stock.nextval
        into :new.ID
        From Dual;
    end if;
end deals_bi;
/

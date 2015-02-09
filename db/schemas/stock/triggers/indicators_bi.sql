create or replace trigger indicators_bi
                          before insert on stock.indicators
                          for each row
begin
    if :new.ID is null then
        select stock.seq_stock.nextval
        into :new.ID
        From Dual;
    end if;
end indicators_bi;
/

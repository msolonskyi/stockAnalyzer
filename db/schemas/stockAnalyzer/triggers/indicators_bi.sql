create or replace trigger indicators_bi
                          before insert on indicators
                          for each row
begin
    if :new.ID is null then
        select seq_stock.nextval
        into :new.ID
        From Dual;
    end if;
end indicators_bi;
/

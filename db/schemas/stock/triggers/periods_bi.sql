create or replace trigger periods_bi
                          before insert on stock.periods
                          for each row
begin
    if :new.ID is null then
        select stock.seq_stock.nextval
        into :new.ID
        From Dual;
    end if;
end periods_bi;
/

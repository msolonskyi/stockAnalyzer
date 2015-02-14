create or replace trigger periods_bi
                          before insert on periods
                          for each row
begin
    if :new.ID is null then
        select seq_stock.nextval
        into :new.ID
        From Dual;
    end if;
end periods_bi;
/

create or replace trigger indicator_values_bi
                          before insert on indicator_values
                          for each row
begin
    if :new.ID is null then
        select seq_stock.nextval
        into :new.ID
        From Dual;
    end if;
end indicator_values_bi;
/

create or replace trigger quotations_BI
                          before insert on quotations
                          for each row
begin
    if :new.ID is null then
        select seq_stock.nextval
        into :new.ID
        From Dual;
    end if;
end quotations_BI;
/

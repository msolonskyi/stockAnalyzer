create or replace trigger indicator_types_BI 
                          before insert on indicator_types
                          for each row
begin
    if :new.ID is null then
        select seq_stock.nextval
        into :new.ID
        From Dual;
    end if;
end indicator_types_BI;
/

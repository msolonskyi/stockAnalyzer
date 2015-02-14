create or replace trigger dimentions_bi
                          before insert on dimentions
                          for each row
begin
    if :new.ID is null then
        select seq_stock.nextval
        into :new.ID
        From Dual;
    end if;
end dimentions_bi;
/

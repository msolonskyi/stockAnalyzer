create or replace trigger dimentions_bi
                          before insert on stock.dimentions
                          for each row
begin
    if :new.ID is null then
        select stock.seq_stock.nextval
        into :new.ID
        From Dual;
    end if;
end dimentions_bi;
/

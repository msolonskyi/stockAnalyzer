create or replace trigger indicator_groups_bi
                          before insert on indicator_groups
                          for each row
begin
    if :new.ID is null then
        select seq_stock.nextval
        into :new.ID
        From Dual;
    end if;
end indicator_groups_bi;
/

create or replace trigger indicator_group_links_bi
                          before insert on indicator_group_links
                          for each row
begin
    if :new.ID is null then
        select seq_stock.nextval
        into :new.ID
        From Dual;
    end if;
end indicator_group_links_bi;
/

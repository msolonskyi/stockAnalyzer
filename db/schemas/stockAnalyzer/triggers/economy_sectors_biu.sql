create or replace trigger economy_sectors_biu
                          before insert or update on economy_sectors
                          for each row
begin
    :new.name := trim(:new.name);
    if :new.ID is null then
        select seq_stock.nextval
        into :new.ID
        From Dual;
    end if;
end economy_sectors_biu;
/

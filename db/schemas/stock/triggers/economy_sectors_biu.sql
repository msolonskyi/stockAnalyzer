create or replace trigger economy_sectors_biu
                          before insert or update on stock.economy_sectors
                          for each row
begin
    :new.name := trim(:new.name);
    if :new.ID is null then
        select stock.seq_stock.nextval
        into :new.ID
        From Dual;
    end if;
end economy_sectors_biu;
/

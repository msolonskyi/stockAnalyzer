create or replace trigger settings_biu
                          before insert or update on settings
                          for each row
begin
    :new.name := lower(:new.name);
end settings_biu;
/

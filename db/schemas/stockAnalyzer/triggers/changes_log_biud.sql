create or replace trigger changes_log_biud
                          before insert or update or delete on changes_log
                          for each row
begin
    if inserting then
        if :new.ID is null then
            select seq_stock.nextval
            into :new.ID
            From Dual;
        end if;
    end if;
    if inserting or updating then
        :new.table_name := upper(trim(:new.table_name));
        :new.column_name := upper(trim(:new.column_name));
        :new.new_value := trim(:new.new_value);
        :new.old_value := trim(:new.old_value);
    end if;
end changes_log_biud;
/

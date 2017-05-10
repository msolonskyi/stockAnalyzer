create or replace trigger indicator_values_aiud
                          after insert or update or delete on indicator_values
                          for each row
begin
    if nvl(:new.indicator_link_id, 0) != nvl(:old.indicator_link_id, 0) then
        insert into changes_log (table_name, column_name, row_id, new_value, old_value)
        values ('indicator_values', 'indicator_link_id', nvl(:new.ID, :old.ID), :new.indicator_link_id, :old.indicator_link_id);
    end if;
    if nvl(:new.period_id, 0) != nvl(:old.period_id, 0) then
        insert into changes_log (table_name, column_name, row_id, new_value, old_value)
        values ('indicator_values', 'period_id', nvl(:new.ID, :old.ID), :new.period_id, :old.period_id);
    end if;
    if nvl(:new.value, 0) != nvl(:old.value, 0) then
        insert into changes_log (table_name, column_name, row_id, new_value, old_value)
        values ('indicator_values', 'value', nvl(:new.ID, :old.ID), :new.value, :old.value);
    end if;
    if nvl(:new.ticker, '0') != nvl(:old.ticker, '0') then
        insert into changes_log (table_name, column_name, row_id, new_value, old_value)
        values ('indicator_values', 'ticker', nvl(:new.ID, :old.ID), :new.ticker, :old.ticker);
    end if;
end indicator_values_aiud;
/

create or replace trigger enterprises_biu
                          before insert or update on stock.enterprises
                          for each row
declare
    n number;
begin
    :new.okpo := trim(:new.okpo);
    :new.ticker := trim(:new.ticker);
    n := to_number(:new.okpo);
exception when others then
    raise_application_error(-20001, '���� '||:new.okpo||' �������� ���������� �������');
end enterprises_biu;
/

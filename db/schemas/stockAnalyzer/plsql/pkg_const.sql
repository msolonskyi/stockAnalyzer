create or replace package pkg_const is

  -- Author  : N.I.SOLONSKY
  -- Created : 18.03.2008 18:31:43
  -- Purpose : пакет констант

  -- дата первой цены на ux.ua
  const_first_price_date constant date := to_date('01.04.2009', 'dd.mm.yyyy');
  -- error during loading data from ux.ua
  em_over_20000          constant varchar2(128) := 'В результате запроса превышено максимальное количество записей = 20000';
  em_no_data_found       constant varchar2(128) := 'Записей не найдено';
  --
  function sf_get_const_first_price_date return date RESULT_CACHE;

end pkg_const;
/
create or replace package body pkg_const is

function sf_get_const_first_price_date
    return date
    RESULT_CACHE
is
begin
    return pkg_const.const_first_price_date;
end sf_get_const_first_price_date;

end pkg_const;
/

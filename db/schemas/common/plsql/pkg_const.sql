create or replace package common.pkg_const is

  -- Author  : N.I.SOLONSKY
  -- Created : 18.03.2008 18:31:43
  -- Purpose : пакет констант

  -- дата первой цены на ux.ua
  const_first_price_date   constant date := to_date('01.04.2009', 'dd.mm.yyyy');
  --
  function sf_get_const_first_price_date return date;

end pkg_const;
/
create or replace package body common.pkg_const is

function sf_get_const_first_price_date
    return date
is
begin
    return common.pkg_const.const_first_price_date;
end sf_get_const_first_price_date;

end pkg_const;
/

create or replace view vw_indicator_values as
select indicator_values.id,
       indicator_values.ticker,
       indicator_values.value,
       indicator_values.period_id,
       periods.name as period_name,
       periods.type as period_type,
       periods.begin_dtm as period_begin_dtm,
       periods.end_dtm as period_end_dtm,
       indicator_values.indicator_group_link_id,
       vw_indicator_group_links.indicator_group_id,
       vw_indicator_group_links.indicator_group_name,
       vw_indicator_group_links.indicator_id,
       vw_indicator_group_links.indicator_name,
       vw_indicator_group_links.indicator_priority,
       vw_indicator_group_links.indicator_type_id,
       vw_indicator_group_links.indicator_type_name,
       vw_indicator_group_links.indicator_type_priority,
       dimentions.id as dimention_id,
       dimentions.name as dimention_name,
       dimentions.short_name as dimention_short_name
from indicator_values, vw_indicator_group_links, periods, enterprises, dimentions
where indicator_values.indicator_group_link_id = vw_indicator_group_links.id
  and indicator_values.period_id = periods.id
  and indicator_values.ticker = enterprises.ticker
  and indicator_values.dimention_id = dimentions.id;

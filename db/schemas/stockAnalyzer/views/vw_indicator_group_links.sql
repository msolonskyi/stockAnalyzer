create or replace view vw_indicator_group_links as
select indicator_group_links.id,
       indicator_group_links.indicator_group_id,
       indicator_groups.name as indicator_group_name,
       indicator_group_links.indicator_id,
       indicators.name as indicator_name,
       indicators.priority as indicator_priority,
       indicators.type_id as indicator_type_id,
       indicator_types.name as indicator_type_name,
       indicator_types.priority as indicator_type_priority
from indicator_groups, indicators, indicator_group_links, indicator_types
where indicator_group_links.indicator_group_id = indicator_groups.id
  and indicator_group_links.indicator_id = indicators.id
  and indicator_types.id = indicators.type_id;

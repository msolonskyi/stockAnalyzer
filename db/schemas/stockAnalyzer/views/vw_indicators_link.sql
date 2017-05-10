create or replace view vw_indicators_link as
select indicators_link.id,
       indicators_link.indicator_group_id,
       indicator_groups.name as indicator_group_name,
       indicators_link.indicator_id,
       indicators.name as indicator_name,
       indicators.name_rus as indicator_name_rus,
       indicators.priority as indicator_priority,
       indicators.type_id as indicator_type_id,
       indicator_types.name as indicator_type_name,
       indicator_types.priority as indicator_type_priority,
       vw_dimentions_link.dimention_link_id,
       vw_dimentions_link.dimention_id,
       vw_dimentions_link.dimention_name,
       vw_dimentions_link.dimention_short_name,
       vw_dimentions_link.multiplier_id,
       vw_dimentions_link.multiplier_name,
       vw_dimentions_link.multiplier_multiplier,
       vw_dimentions_link.multiplier_description
from indicators_link inner join indicators on (indicators_link.indicator_id = indicators.id) inner join
     indicator_groups on (indicators_link.indicator_group_id = indicator_groups.id) inner join
     indicator_types on (indicator_types.id = indicators.type_id) inner join
     vw_dimentions_link on (indicators_link.dimention_link_id = vw_dimentions_link.dimention_link_id);

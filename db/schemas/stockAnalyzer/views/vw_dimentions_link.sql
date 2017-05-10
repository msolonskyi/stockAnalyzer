create or replace view vw_dimentions_link as
select dimentions_link.id as dimention_link_id,
       dimentions.id as dimention_id,
       dimentions.name as dimention_name,
       dimentions.short_name as dimention_short_name,
       multipliers.id as multiplier_id,
       multipliers.name as multiplier_name,
       multipliers.multiplier as multiplier_multiplier,
       multipliers.description as multiplier_description
from dimentions inner join dimentions_link on (dimentions.id = dimentions_link.dimention_id) inner join
     multipliers on (multipliers.id = dimentions_link.multiplier_id);

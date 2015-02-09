create or replace view vw_prices as
select trades.ticker, periods.id as period_id, periods.name as period_name,
       min(trades.price) keep (dense_rank first order by trades.dtm, trades.price) as open,
       max(trades.price) as high,
       min(trades.price) as low,
       max(trades.price) keep (dense_rank last order by trades.dtm, trades.price) as close,
       sum(trades.vol) as vol,
       round(sum(trades.price * trades.vol) / sum(trades.vol), 4) as avg
from trades, periods
where trades.dtm between periods.begin_dtm and periods.end_dtm
group by trades.ticker, periods.id, periods.name;

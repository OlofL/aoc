--bigquery
with recursive s as (
  SELECT string_field_0 as c FROM `olofl-labandlearn.labb.4-real`
), cards as (
  select 
    cast(trim(replace(SPLIT(c, ':')[offset(0)], 'Card', '')) as int) as cardno,
    split(split(split(c, ':')[offset(1)],'|')[offset(0)], ' ') as winners_array,
    split(split(split(c, ':')[offset(1)],'|')[offset(1)], ' ') as mynumbers_array
  from s
), exploded as (
  select cardno, winners, mynumbers from cards
  inner join unnest(winners_array) as winners
  inner join unnest(mynumbers_array) as mynumbers
), winners as (
  select distinct
    mynumbers.cardno,
    winners.winners,
    mynumbers.mynumbers
  from exploded as winners
  inner join exploded as mynumbers on mynumbers.cardno = winners.cardno and mynumbers.mynumbers = winners.winners
), numberofwinners as (
  select
    cardno,
    count(1) as cnt,
    1 as winner
  from winners
  where length(winners.winners)>0
  group by
    cardno
), numberofwinners2 as (
  select
    c.cardno,
    coalesce(now.cnt, 0) as worth,
    coalesce(now.winner, 0) as winner
  from
    cards c
  left join numberofwinners now on now.cardno = c.cardno
), rdups as (
  select cardno, worth, winner,  1 AS iteration
  from numberofwinners2
  union all
  select
    dups.cardno, dups.worth, dups.winner, org.iteration + 1 as iteration
  from rdups org
  inner join numberofwinners2 dups
  on dups.cardno > org.cardno and dups.cardno <= org.cardno+org.worth
  where iteration<201
)
select count(1) from rdups

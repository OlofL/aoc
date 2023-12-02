--bigquery sql
--import the data into a table first, bigquery doesn't handle linebreaks in source code
with game as (
SELECT string_field_0 as c FROM `olofl-labandlearn.labb.aoc-dag2-del1`
),
gameno as (
  select 
    cast(trim(replace(SPLIT(c, ':')[offset(0)], 'Game', '')) as int) as gameno,
    split(c, ':')[offset(1)] as results,
    split(split(c, ':')[offset(1)],';') as result_array
  from game
),
subgameno as (
  select
    gameno, 
    row_number() over (partition by gameno order by gameno) as subgameno,
    split(flattened_gamleresult, ',') as subgame_result_array
  from gameno g
  cross join unnest(result_array) as flattened_gamleresult
),
colors as (
  select gameno, subgameno.subgameno,
    colors
  from subgameno
  cross join unnest(subgame_result_array) as colors
), number_of_colors as (
  select
    gameno,
    subgameno,
  cast(split(trim(colors), ' ')[offset(0)] as int) as number_of_color,
  split(trim(colors), ' ')[offset(1)] as color
  from colors c
), max_number_of_color as (
  select
    gameno,
    color,
    max(number_of_color) as max_number_of_color
  from number_of_colors
  group by
    gameno,
    color
), cubepower as (
select gameno, mc_red*mc_green*mc_blue as cubepower from max_number_of_color
pivot(max(max_number_of_color.max_number_of_color) as mc for color in ('red', 'green', 'blue'))
)
select sum(cubepower.cubepower) from cubepower

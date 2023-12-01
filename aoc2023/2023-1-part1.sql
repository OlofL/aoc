with calib as (
    select '1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet' as c
), x as (
select 
value,
least(
    nullif(patindex('%0%', value), 0),
    nullif(patindex('%1%', value), 0),
    nullif(patindex('%2%', value), 0),
    nullif(patindex('%3%', value), 0),
    nullif(patindex('%4%', value), 0),
    nullif(patindex('%5%', value), 0),
    nullif(patindex('%6%', value), 0),
    nullif(patindex('%7%', value), 0),
    nullif(patindex('%8%', value), 0),
    nullif(patindex('%9%', value), 0)
) as p1,
least(
    nullif(patindex('%0%', reverse(value)), 0),
    nullif(patindex('%1%', reverse(value)), 0),
    nullif(patindex('%2%', reverse(value)), 0),
    nullif(patindex('%3%', reverse(value)), 0),
    nullif(patindex('%4%', reverse(value)), 0),
    nullif(patindex('%5%', reverse(value)), 0),
    nullif(patindex('%6%', reverse(value)), 0),
    nullif(patindex('%7%', reverse(value)), 0),
    nullif(patindex('%8%', reverse(value)), 0),
    nullif(patindex('%9%', reverse(value)), 0)
) as p2
from calib
cross apply string_split(c, char(10))
)
select
sum(cast(concat(substring(value, p1, 1),substring(reverse(value), p2, 1)) as int))
from x

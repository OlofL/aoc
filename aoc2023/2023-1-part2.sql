with calib as (
    select 'two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen' as c
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
    nullif(patindex('%9%', value), 0),
    nullif(patindex('%zero%', value), 0),
    nullif(patindex('%one%', value), 0),
    nullif(patindex('%two%', value), 0),
    nullif(patindex('%three%', value), 0),
    nullif(patindex('%four%', value), 0),
    nullif(patindex('%five%', value), 0),
    nullif(patindex('%six%', value), 0),
    nullif(patindex('%seven%', value), 0),
    nullif(patindex('%eight%', value), 0),
    nullif(patindex('%nine%', value), 0)
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
    nullif(patindex('%9%', reverse(value)), 0),
    nullif(patindex(reverse('%zero%'), reverse(value)), 0),
    nullif(patindex(reverse('%one%'), reverse(value)), 0),
    nullif(patindex(reverse('%two%'), reverse(value)), 0),
    nullif(patindex(reverse('%three%'), reverse(value)), 0),
    nullif(patindex(reverse('%four%'), reverse(value)), 0),
    nullif(patindex(reverse('%five%'), reverse(value)), 0),
    nullif(patindex(reverse('%six%'), reverse(value)), 0),
    nullif(patindex(reverse('%seven%'), reverse(value)), 0),
    nullif(patindex(reverse('%eight%'), reverse(value)), 0),
    nullif(patindex(reverse('%nine%'), reverse(value)), 0)
) as p2
from calib
cross apply string_split(c, char(10))
),
numbers as (
select 0 as n, 'zero' as nt union all
select 1 as n, 'one' as nt union all
select 2 as n, 'two' as nt union all
select 3 as n, 'three' as nt union all
select 4 as n, 'four' as nt union all
select 5 as n, 'five' as nt union all
select 6 as n, 'six' as nt union all
select 7 as n, 'seven' as nt union all
select 8 as n, 'eight' as nt union all
select 9 as n, 'nine' as nt
),
calcs as (
select
substring(value, p1, 1) as a,
substring(reverse(value), p2, 1) as b,
--sum(cast(concat(substring(value, p1, 1),substring(reverse(value), p2, 1)) as int))
coalesce(replace(value, n1.nt, n1.n), value) as c,
coalesce(replace(value, n2.nt, n2.n), value) as d,
coalesce(replace(coalesce(replace(value, n1.nt, n1.n), value), n2.nt, n2.n), coalesce(replace(value, n1.nt, n1.n), value)) as ccc,
substring(coalesce(replace(coalesce(replace(value, n1.nt, n1.n), value), n2.nt, n2.n), coalesce(replace(value, n1.nt, n1.n), value)), p1, 1) as cc2,
substring(reverse(coalesce(replace(coalesce(replace(value, n1.nt, n1.n), value), n2.nt, n2.n), coalesce(replace(value, n1.nt, n1.n), value))), p2, 1) as zzz,
n1.nt as nt1, n2.nt as nt2
from x as x
left join numbers as n1 on substring(value, p1, len(n1.nt)) = n1.nt
left join numbers as n2 on substring(reverse(value), p2, len(n2.nt)) = reverse(n2.nt)
)
select sum(concat(cc2, zzz)) from calcs
 select distinct
	(case 
		when id in('LINK', 'LINK CONSULTING') then 'LINK CONSULTING'
		when id in('SONDA', 'SONDA IT') then 'SONDA'
		when id in('TRIAD SYSTEM', 'TRIAD SYSTEMS') then 'TRIAD SYSTEMS'
		else id
	end) as Id
from
    (select distinct fabrica_teste as id from alm_cts where fabrica_teste is not null

     union all

     select distinct fabrica_teste as id from alm_defeitos where fabrica_desenvolvimento is not null
	) aux
where
    id <> '' 
order by
    1

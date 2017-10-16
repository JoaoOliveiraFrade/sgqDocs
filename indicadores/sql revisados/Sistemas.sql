select distinct
	id,
	(case 
		when testManufacturing in('LINK', 'LINK CONSULTING') then 'LINK CONSULTING'
		when testManufacturing in('SONDA', 'SONDA IT') then 'SONDA'
		when testManufacturing in('TRIAD SYSTEM', 'TRIAD SYSTEMS') then 'TRIAD SYSTEMS'
		else testManufacturing
	end) as testManufacturing
from
    (select distinct
        sistema as id,
        fabrica_teste as testManufacturing
    from
        alm_cts
    where
        sistema is not null and
        fabrica_teste is not null

    union all

    select distinct
        sistema_defeito as id,
        fabrica_teste as testManufacturing
    from
        alm_defeitos
    where
        sistema_defeito is not null and
        fabrica_teste is not null
    ) aux
where
    id <> '' and
    testManufacturing <> ''
order by
    1


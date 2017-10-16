select
	month + '/' + year as date,
	cts.fabrica_teste as testManufacturing,
	cts.sistema as system,
	convert(varchar, cast(substring(cts.subprojeto,4,8) as int)) + ' ' + convert(varchar,cast(substring(cts.entrega,8,8) as int)) as project,
	cts.subprojeto as subproject,
	cts.entrega as delivery,
	sum(ex.productivity) as productivity 
from 
	(select 
		ex.subprojeto,
		ex.entrega,
		ex.ct,
		substring(ex.dt_execucao,4,2) as month,
		substring(ex.dt_execucao,7,2) as year,
		count(*) as productivity
	from alm_execucoes ex WITH (NOLOCK)
	where 
		ex.status in ('PASSED', 'FAILED') and
		ex.dt_execucao <> ''
	group by
		ex.subprojeto,
		ex.entrega,
		ex.ct,
		substring(ex.dt_execucao,4,2),
		substring(ex.dt_execucao,7,2)
	) ex
	inner join
	alm_cts cts WITH (NOLOCK)
		on 	cts.subprojeto = ex.subprojeto and
			cts.entrega = ex.entrega and
			cts.ct = ex.ct
where
	cts.ciclo like '%TI%'
group by
	year,
	month,
	cts.fabrica_teste,
	cts.sistema,
	cts.subprojeto,
	cts.entrega
order by
	year,
	month,
	cts.fabrica_teste,
	cts.sistema,
	cts.subprojeto,
	cts.entrega
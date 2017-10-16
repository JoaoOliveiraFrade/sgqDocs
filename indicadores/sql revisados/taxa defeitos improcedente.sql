select 
	month + '/' + year as date,
	testManufacturing,
	convert(varchar, cast(substring(subproject,4,8) as int)) + ' ' + convert(varchar,cast(substring(delivery,8,8) as int)) as project,
	subproject,
	delivery,
	system,
	sum(defeito) as defeitos,
	sum(defeito_improcedente) as defeitos_improcedentes
from
	(select 

		(case when fabrica_teste is null or fabrica_teste = '' then 'NÃO IDENTIFICADA' else fabrica_teste end) as testManufacturing,
		subprojeto as subproject,
		entrega as delivery,
		sistema_ct as system,
		substring(dt_ultimo_status,4,2) as month,
		substring(dt_ultimo_status,7,2) as year,

		1 as defeito,

		case when	
			status_atual in ('CANCELLED') and
			origem = 'IMPROCEDENTE' and
			Ciclo like '%TI%' then 1 else 0
		end defeito_improcedente

	from 
		alm_defeitos 
	) aux
group by
	year,
	month,
	testManufacturing,
	system,
	subproject,
	delivery
order by
	year,
	month,
	testManufacturing, 
	system,
	subproject,
	delivery

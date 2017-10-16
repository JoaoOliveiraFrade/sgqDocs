select
	month + '/' + year as monthYear,
	year + '/' + month as yearMonth,
	testManufacturing,
	system,
	convert(varchar, cast(substring(subproject,4,8) as int)) + ' ' + convert(varchar,cast(substring(delivery,8,8) as int)) as subprojectDelivery,
	subproject,
	delivery,
	sum(qte_evid_TI ) as tiEvidences,
	sum(qte_evid_rej_TI) as tiRejections,

	sum(qte_evid_UAT) as uatEvidences,
	sum(qte_evid_rej_UAT) as uatRejections,

	sum(qte_evid_TI + qte_evid_UAT) as totalEvidences,
	sum(qte_evid_rej_TI + qte_evid_rej_UAT) as totalRejections

	--round(convert(float,sum(qte_evid_rej) ) / (case when sum(qte_evid_TI) = 0 then 1 else sum(qte_evid_TI) end) * 100,2) as rejection_rate
from
	( select
		cts.fabrica_teste as testManufacturing,
		cts.subprojeto as subproject,
		cts.entrega as delivery,
		cts.sistema as system,
		substring(dt_execucao,4,2) as month,
		substring(dt_execucao,7,2) as year,

		(case when cts.evidencia_validacao_tecnica <> 'N/A' then 1 else 0 end) as qte_evid_TI,
		(case when cts.evidencia_validacao_tecnica <> 'N/A' and cts.UAT = 'SIM' then 1 else 0 end) as qte_evid_UAT,

		(select count(*) 
		from ALM_Historico_Alteracoes_Campos ac
		where cts.subprojeto = ac.subprojeto and
			    cts.entrega = ac.entrega and
			    cts.ct = ac.Tabela_id and
			    ac.campo = '(EVIDÊNCIA) VALIDAÇÃO TÉCNICA'  and
				ac.novo_valor = 'REJEITADO'
		) as qte_evid_rej_TI,

		(select count(*) 
		from ALM_Historico_Alteracoes_Campos ac
		where cts.subprojeto = ac.subprojeto and
			    cts.entrega = ac.entrega and
			    cts.ct = ac.Tabela_id and
			    ac.campo = '(EVIDÊNCIA) VALIDAÇÃO CLIENTE'  and
				ac.novo_valor = 'REJEITADO'
		) as qte_evid_rej_UAT

	from 
		alm_cts cts WITH (NOLOCK)
	where
		status_exec_ct = 'PASSED' and
		cts.massa_Teste <> 'SIM' and
		cts.ciclo like '%TI%' and
		cts.dt_execucao <> '' 
	) Aux
group by
	testManufacturing,
	subproject,
	delivery, 
	system,
	month,
	year
having
	sum(qte_evid_TI) > 0 or sum(qte_evid_UAT) > 0
order by
	2, 3, 4, 6,7

select
	                monthExecution + '/' + yearExecution as date,
	                testManufacturing,
	                system,
	                convert(varchar, cast(substring(subproject,4,8) as int)) + ' ' + convert(varchar,cast(substring(delivery,8,8) as int)) as project,
	                subproject,
	                delivery,
					sum(qte_evid) as evidences,
					sum(qte_evid_rej_ti) as rejections_ti,
					round(convert(float,sum(qte_evid_rej_ti) ) / (case when sum(qte_evid) = 0 then 1 else sum(qte_evid) end) * 100,2) as rejection_rate_ti
                from
	                ( select
					    cts.fabrica_teste as testManufacturing,
		                cts.subprojeto as subproject,
		                cts.entrega as delivery,
		                cts.sistema as system,
		                substring(dt_execucao,4,2) as monthExecution,
		                substring(dt_execucao,7,2) as yearExecution,
		                (
		                select count(*) 
		                from alm_cts ct 
		                where cts.subprojeto = ct.subprojeto and
			                    cts.entrega = ct.entrega and
			                    cts.ct = ct.ct and
			                    ct.evidencia_validacao_tecnica <> 'N/A'  
		                ) as qte_evid,
						(
		                select count(*) 
		                from ALM_Historico_Alteracoes_Campos ac
		                where cts.subprojeto = ac.subprojeto and
			                    cts.entrega = ac.entrega and
			                    cts.ct = ac.Tabela_id and
			                    ac.campo = '(EVIDÊNCIA) VALIDAÇÃO TÉCNICA' and
								ac.novo_valor = 'REJEITADO'
		                ) as qte_evid_rej_ti
	                from 
		                alm_cts cts WITH (NOLOCK)
					
	                where
		                status_exec_ct = 'PASSED' and
		                cts.fabrica_teste is not null and
		                cts.massa_Teste <> 'SIM' and
		                (cts.ciclo like '%TI%' or cts.ciclo like '%UAT%') and
						cts.dt_execucao <> '' 
				
	                ) Aux
                group by
	                testManufacturing,
	                subproject,
	                delivery, 
	                system,
	                monthExecution,
	                yearExecution
                order by
	                yearExecution,
	                monthExecution,
	                testManufacturing, 
	                system,
	                subproject,
	                delivery
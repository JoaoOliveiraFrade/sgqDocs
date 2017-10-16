select 
	                monthExecution + '/' + yearExecution as date,
	                testManufacturing,
	                system,
	                convert(varchar, cast(substring(subproject,4,8) as int)) + ' ' + convert(varchar,cast(substring(delivery,8,8) as int)) as project,
	                subproject,
	                delivery,
	                sum(qte_defeitos) as qtyDefects,
	                sum(qte_defeitos_uat) as qtyDefectsUat,
	                round(convert(float,sum(qte_defeitos_uat)) / (case when sum(qte_defeitos) = 0 then 1 else sum(qte_defeitos) end) * 100,2) as rateUAT
                from
	                (select 
		                cts.fabrica_teste as testManufacturing,
		                cts.subprojeto as subproject,
		                cts.entrega as delivery,
		                cts.sistema as system,
		                substring(cts.dt_execucao,4,2) as monthExecution,
		                substring(cts.dt_execucao,7,2) as yearExecution,
						(
		                select count(*) 
		                from alm_defeitos df 
		                where df.subprojeto = cts.subprojeto and
			                    df.entrega = cts.entrega and
			                    df.ct = cts.ct and
			                    df.status_atual <> 'CANCELLED' and
		                        (df.Ciclo like '%TI%' or df.Ciclo like '%UAT%')
		                ) as qte_defeitos,
		                (
		                select count(*) 
		                from ALM_Historico_Alteracoes_Campos ac
		                where cts.subprojeto = ac.subprojeto and
			                    cts.entrega = ac.entrega and
			                    cts.ct = ac.Tabela_id and
								TABELA = 'BUG'
			                    ac.campo in ('(EVIDÊNCIA) VALIDAÇÃO CLIENTE','(EVIDÊNCIA) VALIDAÇÃO TÉCNICA')  and
								ac.novo_valor = 'REJEITADO'
		                ) as qte_evid_rej
	                from 
		                alm_cts cts
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


					--select * from alm_defeitos

					--case when sum(qte_evid_rej) = 0 then sum(qte_evid_ti) else sum(qte_evid_rej) end

					(
					select count(*) 
		                from 
						ALM_Historico_Alteracoes_Campos ac
						inner join alm_defeitos df
		                ON df.subprojeto = ac.subprojeto and
			                    df.entrega = ac.entrega and
			                    df.defeito = ac.Tabela_id 
								WHERE
								TABELA = 'BUG' AND
			                    campo = 'STATUS'  and
								ac.novo_valor = 'ON_RETEST'
								) as qtd_reteste

								select * from ALM_Historico_Alteracoes_Campos where TABELA = 'BUG'
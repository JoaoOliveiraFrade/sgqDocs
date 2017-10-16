select
	                monthExecution + '/' + yearExecution as date,
	                testManufacturing,
	                system,
	                convert(varchar, cast(substring(subproject,4,8) as int)) + ' ' + convert(varchar,cast(substring(delivery,8,8) as int)) as project,
	                subproject,
	                delivery,
					count(*) as qtyCTs,
					sum(qtd_reteste) as retests,
					round(convert(float,sum(qtd_reteste) ) / (case when count(*) = 0 then 1 else count(*) end) * 100,2) as retest_rate
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
								from 
								ALM_Historico_Alteracoes_Campos ac
								inner join alm_defeitos df
								ON df.subprojeto = ac.subprojeto and
			                    df.entrega = ac.entrega and
			                    df.defeito = ac.Tabela_id 
								WHERE
								cts.subprojeto = df.subprojeto and
			                    cts.entrega = df.entrega AND
								CTS.CT = df.ct and
			                    campo = 'STATUS'  and
								ac.novo_valor = 'ON_RETEST'
								) as qtd_reteste
	                from 
		                alm_cts cts WITH (NOLOCK)
					
	                where
		                status_exec_ct <> 'CANCELLED' and
		                cts.fabrica_teste is not null and
		                cts.massa_Teste <> 'SIM' and
		                (cts.ciclo like '%TI%' or cts.ciclo like '%UAT%') and
                        dt_execucao <> ''
				
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
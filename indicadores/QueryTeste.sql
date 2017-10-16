select 
	                dayExecution + '/' + monthExecution + '/' + yearExecution as date,
					convert(int,yearExecution  + monthExecution + dayExecution) as dateOrder,
	                devManufacturing,
	                system,
	                convert(varchar, cast(substring(subproject,4,8) as int)) + ' ' + convert(varchar,cast(substring(delivery,8,8) as int)) as project,
	                subproject,
	                delivery,
	                sum(qte_defeitos) as qtyDefects,
	                count(*) as qtyCTs,
	                round(convert(float,sum(qte_defeitos)) / (case when count(*) = 0 then 1 else count(*) end) * 100,2) as density
                from
	                (select 
		                cts.fabrica_desenvolvimento as devManufacturing,
		                cts.subprojeto as subproject,
		                cts.entrega as delivery,
		                cts.sistema as system,
						substring(cts.dt_execucao,1,2) as dayExecution,
		                substring(cts.dt_execucao,4,2) as monthExecution,
		                substring(cts.dt_execucao,7,2) as yearExecution,
		                (
		                select count(*) 
		                from alm_defeitos df 
		                where df.subprojeto = cts.subprojeto and
			                    df.entrega = cts.entrega and
			                    df.ct = cts.ct and
			                    df.status_atual = 'CLOSED' and
			                    df.Origem like '%CONSTRUÇÃO%' and
		                        (df.Ciclo like '%TI%' or df.Ciclo like '%UAT%')
		                ) as qte_defeitos
	                from 
		                alm_cts cts
	                where
		                status_exec_ct = 'PASSED' and
		                cts.fabrica_desenvolvimento is not null and
		                cts.massa_Teste <> 'SIM' and
		                (cts.ciclo like '%TI%' or cts.ciclo like '%UAT%') and
						cts.dt_execucao <> ''
	                ) Aux
					where 
					convert(int,yearExecution  + monthExecution + dayExecution) >= 170427 and
					convert(int,yearExecution  + monthExecution + dayExecution) <= 170427
                group by
	                devManufacturing,
	                subproject,
	                delivery,
	                devManufacturing, 
	                system,
					dayExecution,
	                monthExecution,
	                yearExecution
                order by
	                yearExecution,
	                monthExecution,
					dayExecution,
	                devManufacturing, 
	                system,
	                subproject,
	                delivery
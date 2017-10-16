select 
	                monthExecution + '/' + yearExecution as date,
	                testManufacturing,
	                system,
	                convert(varchar, cast(substring(subproject,4,8) as int)) + ' ' + convert(varchar,cast(substring(delivery,8,8) as int)) as project,
	                subproject,
	                delivery,
	                sum(qte_defeitos) as qtyDefects,
	                sum(qte_defeitos_improcedentes) as qtyDefectsUnfounded,
	                round(convert(float,sum(qte_defeitos_improcedentes)) / (case when sum(qte_defeitos) = 0 then 1 else sum(qte_defeitos) end) * 100,2) as rateUnfounded
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
			                    df.status_atual in ('CLOSED', 'CANCELLED') and
		                        (df.Ciclo like '%TI%' or df.Ciclo like '%UAT%')
		                ) as qte_defeitos,
		                (
		                select count(*) 
		                from alm_defeitos df 
		                where df.subprojeto = cts.subprojeto and
			                    df.entrega = cts.entrega and
			                    df.ct = cts.ct and
			                    df.status_atual = 'CANCELLED' and
		                        (df.Ciclo like '%TI%' or df.Ciclo like '%UAT%')
		                ) as qte_defeitos_improcedentes
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




					--case when sum(qte_evid_rej) = 0 then sum(qte_evid_ti) else sum(qte_evid_rej) end
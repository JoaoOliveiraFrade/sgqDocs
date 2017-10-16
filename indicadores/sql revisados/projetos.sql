select distinct
    testManufacturing,
    Sistema as system,
    re.Subprojeto as subproject,
    re.Entrega as delivery
from 
    SGQ_Releases_Entregas re WITH (NOLOCK)
    inner join 
        (
        select distinct
            Subprojeto, Entrega, testManufacturing, sistema
        from
            (
            select distinct 
                cts.Subprojeto,
                cts.Entrega,
                (case 
                    when cts.fabrica_teste in('LINK', 'LINK CONSULTING') then 'LINK CONSULTING'
                    when cts.fabrica_teste in('SONDA', 'SONDA IT') then 'SONDA'
                    when cts.fabrica_teste in('TRIAD SYSTEM', 'TRIAD SYSTEMS') then 'TRIAD SYSTEMS'
                    else cts.fabrica_teste
                end) as testManufacturing,
                cts.sistema
            from 
                alm_cts cts WITH (NOLOCK)
                
			union all

            select distinct 
                d.Subprojeto,
                d.Entrega,
                (case 
                    when d.fabrica_teste in('LINK', 'LINK CONSULTING') then 'LINK CONSULTING'
                    when d.fabrica_teste in('SONDA', 'SONDA IT') then 'SONDA'
                    when d.fabrica_teste in('TRIAD SYSTEM', 'TRIAD SYSTEMS') then 'TRIAD SYSTEMS'
                    else d.fabrica_teste
                end) as testManufacturing,
                d.sistema_defeito as sistema
            from 
                alm_defeitos d WITH (NOLOCK)
            ) aux
        ) cts 
        on cts.Subprojeto = re.Subprojeto and
           cts.Entrega = re.Entrega
where
    re.id = (select top 1 re2.id 
	         from SGQ_Releases_Entregas re2 
			 where re2.subprojeto = re.subprojeto and 
			       re2.entrega = re.entrega 
			 order by re2.release_ano desc, re2.release_mes desc)




USE [BDGestaoTestes]
GO
/****** Object:  StoredProcedure [dbo].[sp_projects]    Script Date: 18/05/2017 15:04:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_filtered_projects]
as
select
    p.id,
    p.subprojeto as subproject,
    p.entrega as delivery
from 
	alm_projetos p WITH (NOLOCK)
    inner join SGQ_Releases_Entregas WITH (NOLOCK)
    on SGQ_Releases_Entregas.subprojeto = p.subprojeto and
        SGQ_Releases_Entregas.entrega = p.entrega and
        SGQ_Releases_Entregas.id = (select top 1 re2.id from SGQ_Releases_Entregas re2 WITH (NOLOCK)
                                    where re2.subprojeto = SGQ_Releases_Entregas.subprojeto and 
                                        re2.entrega = SGQ_Releases_Entregas.entrega 
                                    order by re2.release_ano desc, re2.release_mes desc)
where 
	p.ativo = 'Y'
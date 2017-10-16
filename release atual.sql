-- vw_filtered_projects
select
	p.Id,
	p.Subprojeto as subproject,
	p.Entrega as delivery,
	(select Sigla from SGQ_Meses as m where (Id = SGQ_Releases_Entregas.Release_Mes)) + ' ' + convert(varchar, SGQ_Releases_Entregas.Release_Ano) as release 
from
	ALM_Projetos as p with (NOLOCK) 
	inner join SGQ_Releases_Entregas with (NOLOCK) 
		on SGQ_Releases_Entregas.Subprojeto = p.Subprojeto and
		   SGQ_Releases_Entregas.Entrega = p.Entrega and
		   SGQ_Releases_Entregas.Id = 
			(select top (1) Id 
			from SGQ_Releases_Entregas as re2 with (NOLOCK) 
			where Subprojeto = SGQ_Releases_Entregas.Subprojeto and 
			      Entrega = SGQ_Releases_Entregas.Entrega
			order by
				Release_Ano desc,
				Release_Mes desc)
where
	(
		p.Ativo = 'Y'
	)
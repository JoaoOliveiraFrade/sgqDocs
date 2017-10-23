decode(substr('%',1,3),
'001',
'FI "'||trim(isc.product_id||':'||isc.obj_id||'.'||isc.variant||'-'||ot.type_name||';'||ic.revision)||'" /USER_FILENAME="'||substr('%',4,200)||decode(upper(trim('%')),cmc1.ch_doc_id, '\'||trim(cmc1.ch_doc_id)||'\'||trim(cmc2.ch_doc_id), cmc2.ch_doc_id, '\'||trim(cmc2.ch_doc_id))||'\'||wf.filename||'"',
'002',
'FI "'||trim(isc.product_id||':'||isc.obj_id||'.'||isc.variant||'-'||ot.type_name||';'||ic.revision)||'" /USER_FILENAME="'||substr('%',4,200)||decode(upper(trim('%')),cmc1.ch_doc_id, '/'||trim(cmc1.ch_doc_id)||'/'||trim(cmc2.ch_doc_id), cmc2.ch_doc_id, '/'||trim(cmc2.ch_doc_id))||'/'||wf.filename||'"',
'003',
'FI "'||trim(isc.product_id||':'||isc.obj_id||'.'||isc.variant||'-'||ot.type_name||';'||ic.revision)||'" /USER_FILENAME="'||substr('%',4,200)||'/'||wf.filename||'"',
'098',
trim(isc.product_id||':'||isc.obj_id||'.'||isc.variant||'-'||ot.type_name||';'||ic.revision)||'|'||replace(wd.dir_fullpath,chr(10),'')||'|'||wf.filename||'|'||(select wsc.product_id||':'||wsc.obj_id	from dis.ws_spec_catalogue wsc, dis.ws_catalogue wc, dis.cm_impacts cmi3 where cmi3.ch_uid=cmc2.ch_uid and cmi3.impact_type='W' and cmi3.affect_uid=wc.obj_uid and wc.obj_spec_uid=wsc.obj_spec_uid),
replace(
    rpad(nvl(trim(up.user_name||':'||up.full_user_name),' '),50)||'|'||
    rpad(nvl(trim(cma.attr_32),' '),10)||'|'||
    rpad(nvl(trim(cma.attr_20),' '),25)||'|'||
    rpad(nvl(trim(cmc1.ch_doc_id),' '),30)||'|'||
    rpad(nvl(trim(cmc2.ch_doc_id),' '),30)||'|'||
    rpad(nvl(trim(isc.product_id||':'||isc.obj_id||'.'||isc.variant||'-'||ot.type_name||';'||ic.revision),' '),150)||'|'||
    rpad(nvl(replace(wd.dir_fullpath,chr(10),'')||wf.filename,' '),250)||'|'||
    rpad(nvl(trim(cma.attr_33)||' '||trim(cma.attr_34),' '),20)||'|'||
    rpad(nvl(trim(to_char(ic.update_date,'DD/MM/YYYY HH24:MI')),' '),20)||'|'||
    rpad(nvl(trim(cmc1.status),' '),20)||'|'||
    rpad(nvl(trim(cmc2.status),' '),20)||'|'||
    rpad(nvl(trim(ic.status),' '),20)||'|'||
    rpad(nvl(trim((select wa.attr_17
	from dis.ws_attributes wa, dis.cm_impacts cmi3
	where cmi3.ch_uid = cmc1.ch_uid 
	and cmi3.impact_type = 'W'
	and cmi3.affect_uid = wa.obj_uid
	)),' '),10)||'|'||
    rpad(nvl(trim(cma.attr_36),' '),50)||'|'||
    rpad(nvl(trim(cma.attr_38),' '),20)||'|'||
    rpad(nvl(trim(replace(cma.attr_37,chr(10), chr(32))),' '),80) ||'|'|| 
    (select rpad(nvl(trim(pscx.obj_id), ' '),30)
            from dis.part_item_rels pirx, 
	    dis.part_catalogue pcx, 
            dis.part_spec_catalogue pscx
     where pcx.obj_spec_uid = pscx.obj_spec_uid
     and   pcx.obj_uid      = pirx.obj_uid
     and   pirx.related_uid = ic.obj_uid)||'|'||
    rpad(nvl(trim((select wsc.product_id||':'||wsc.obj_id
	from dis.ws_spec_catalogue wsc, dis.ws_catalogue wc, dis.cm_impacts cmi3
	where cmi3.ch_uid = cmc2.ch_uid 
	and cmi3.impact_type = 'W'
	and cmi3.affect_uid = wc.obj_uid
	and wc.obj_spec_uid=wsc.obj_spec_uid 
	)),' '),30)||
        decode('%','005','|'||(select max(rpad(user_name,8)||'|'||action_note) from dis.cm_history cmh where cmh.history_type='A' and cmh.ch_uid=cmc2.ch_uid and cmh.action_no=cmc2.action_no)||'|'||cma.attr_47)
,chr(10),' '))
    as linha
from
    dis.users_profile up,
    dis.cm_attributes cma,
    dis.cm_catalogue cmc1,
    dis.cm_impacts cmi1,
    dis.cm_catalogue cmc2,
    dis.cm_impacts cmi2,
    dis.item_catalogue ic,
    dis.item_spec_catalogue isc,
    dis.obj_types ot,
    dis.ws_files wf,
    dis.ws_dirs wd
where
    cmc2.originator = up.user_name 
and cmc1.ch_uid = cma.ch_uid
and cmi1.ch_uid = cma.ch_uid  
and cmi1.impact_type = 'C'
and cmc2.ch_uid = cmi1.affect_uid
and cmi1.ch_uid = cmc1.ch_uid (+)
and cmi2.ch_uid = cmc2.ch_uid 
and cmi2.impact_type = 'I'
and cmi2.affect_uid = (select max(cmi_s.affect_uid)
                       from dis.cm_impacts cmi_s, dis.item_catalogue ic_s
                       where 
                            cmi_s.affect_uid = ic_s.obj_uid 
                        and ic_s.obj_spec_uid = ic.obj_spec_uid
                        and cmi_s.ch_uid = cmc2.CH_UID
                        and cmi_s.impact_type = 'I')
and cmi2.affect_uid = ic.obj_uid
and isc.obj_spec_uid = ic.obj_spec_uid
and ot.type_uid = isc.type_uid
and cmc1.ch_doc_type = 'RN'
AND wf.obj_uid=ic.obj_uid
AND wf.workset_uid=wd.workset_uid
AND wf.dir_uid=wd.dir_uid
AND wf.workset_uid=1
 and cmc1.product_id=upper('ARBOR')
and cmc1.status <> 'IMPLANTADO'
and cmc2.status <> 'IMPLANTADO'
and ic.status <> 'CANCELADO'
and cmc1.status <> 'CANCELADO'
and cmc2.status <> 'CANCELADO'
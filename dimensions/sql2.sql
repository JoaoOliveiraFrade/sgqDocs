select distinct
    rpad(nvl(trim(up.user_name||':'||up.full_user_name),' '),50)||'|'||
    rpad(nvl(trim(cma.attr_32),' '),10)||'|'||
    rpad(nvl(trim(cma.attr_20),' '),25)||'|'||
    rpad(nvl(trim(cmc1.ch_doc_id),' '),30)||'|'||
    rpad(nvl(trim(cmc2.ch_doc_id),' '),30)||'|'||
    rpad(' ',150)||'|'||
    rpad(' ',250)||'|'||
    rpad(nvl(trim(cma.attr_33)||' '||trim(cma.attr_34),' '),20)||'|'||
    rpad(' ',20)||'|'||
    rpad(nvl(trim(cmc1.status),' '),20)||'|'||
    rpad(nvl(trim(cmc2.status),' '),20)||'|'||
    rpad(' ',20)||'|'||
    rpad(nvl(trim((select wa.attr_17
                        from dis.ws_attributes wa, dis.cm_impacts cmi3
                        where cmi3.ch_uid = cmc1.ch_uid 
                        and cmi3.impact_type = 'W'
                        and cmi3.affect_uid = wa.obj_uid)),' '),10)||'|'||
    rpad(nvl(trim(cma.attr_36),' '),50)||'|'||
    rpad(nvl(trim(cma.attr_38),' '),20)||'|'||
    rpad(nvl(trim(replace(cma.attr_37,chr(10),chr(32))),' '),80) ||'|'||
    rpad(' ',30) ||'|'||
    rpad(' ',30) ||
    decode('%','005','|        |'||'|'||cma.attr_47)
from
    dis.users_profile up,
    dis.cm_attributes cma,
    dis.cm_catalogue cmc1,
    dis.cm_catalogue cmc2,
    dis.cm_impacts cmi1
where
        cmc1.originator = up.user_name 
    and cmc1.ch_uid = cma.ch_uid
    and cmc2.ch_uid(+) = cmi1.affect_uid
    and cmi1.ch_uid = cmc1.ch_uid(+)
    and cmc1.ch_doc_type = 'RN'
    and cmc1.product_id=upper('ARBOR')
    and nvl(cmc1.status,'NULO') <> 'IMPLANTADO'
    and nvl(cmc1.status,'NULO')<> 'CANCELADO'
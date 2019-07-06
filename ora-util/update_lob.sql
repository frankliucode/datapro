declare
    l_text clob;
    l_line varchar2(20);
begin
    DBMS_LOB.CREATETEMPORARY(l_text, TRUE);
    DBMS_LOB.OPEN(l_text, DBMS_LOB.LOB_READWRITE);
    for i in 1..1000
    loop
        DBMS_LOB.WRITEAPPEND(l_text, 10, '0123456789');
    end loop;
    DBMS_LOB.CLOSE(l_text);
    update sales.customers set bio = l_text where cust_id = 1;
    commit;
end;
/


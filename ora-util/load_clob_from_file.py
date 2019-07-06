import sys

def print_header():
    print("SPO load_xml.log")
    print("SET ECHO ON TERM ON LIN 2000 TRIMS ON NUMF 99999999999999999999")
    print("WHENEVER SQLERROR EXIT SQL.SQLCODE;")
    print("REM")
    print("DECLARE")
    print("  l_text clob;")
    print("  l_line varchar2(32000);")
    print("BEGIN")
    print("DBMS_LOB.CREATETEMPORARY(l_text, TRUE);")
    print("DBMS_LOB.OPEN(l_text, DBMS_LOB.LOB_READWRITE);")

def print_footer():
    print("DBMS_LOB.CLOSE(l_text);")
    print("-- insert into sales.customer values (4, 'test', sysdate, content);")
    print("-- update sales.customer set bio = content where customer_id = 31;");
    print("commit;")
    print("")
    print("END;")
    print("/")
    print("SPOOL OFF")

def generate_dml(filename):
    print_header()
    f = open(filename, "r")
    lines = f.readlines()
    for line in lines:
        line = line.rstrip()
        count = len(line)        
        print("DBMS_LOB.WRITEAPPEND(l_text, %d, q'~%s~'%s);" % (count + 1, line, "|| CHR(10)" ))
    print_footer()

if (len(sys.argv) == 2):
    filename = sys.argv[1]
    generate_dml(filename)
else:
    print("usage: %s filename" % sys.argv[0])


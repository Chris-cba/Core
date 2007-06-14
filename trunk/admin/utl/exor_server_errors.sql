DROP MATERIALIZED VIEW EXOR_SERVER_ERRORS;
CREATE MATERIALIZED VIEW EXOR_SERVER_ERRORS
REFRESH START WITH sysdate+(15/1440) NEXT sysdate+(15/1440) AS
select  b.type
       ,b.name
       ,b.line
       ,SUBSTR(DECODE(instr(text,'-20',1,1)
                     ,0,Null
                     ,substr(text,instr(text,'-20',1,1),DECODE(instr(text,',',instr(text,'-20',1,1),1)
                                                              ,0,DECODE(instr(text,';',instr(text,'-20',1,1),1)
                                                                       ,0, LENGTH(text)
                                                                       ,instr(text,';',instr(text,'-20',1,1),1)
                                                                       )
                                                              ,instr(text,',',instr(text,'-20',1,1),1)
                                                              )-instr(text,'-20',1,1)
                            )
                     )
              ,1,6) errcode
       ,ltrim(ltrim(b.text),'	') text
from   user_source b
where  substr(ltrim(b.text),1,2) <> '--'
  and  (b.text like '%-20%'
        or (b.line-1 IN (SELECT c.line
                         FROM user_source c
                         WHERE c.text like '%-20%'
                         and   c.type = b.type
                         and   c.name = b.name
                         and   UPPER(c.text) NOT LIKE '%RAISE_APPLICATION_ERROR%'
                        )
           )
       )
 and b.type != 'PACKAGE'
 and upper(b.text) not like '%EXCEPTION_INIT%'
/

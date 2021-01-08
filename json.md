

1. 支持提取： `.a.b.c`, `c.d.e.[*]`: 采用awk进行语法分析；或者直接采用bash。json.extract "**" c d e "*abc" ""
2. 修改值，采用 json.set "**" c d e "*abc" "" -- "3"
3. 汇总，直接采用awk的语法，提供搜索


```bash
json.vars \
    :a '.key1.key2.*.3' \
    :b '.key1.key2.*3'


json.extract '*.key1.key.3'

json._extract key1 key2 \* 3

json.modify \
    a.b.3 = '.key1.key.3' \
    a.b.4 = '.key1.key.3'

json.cmd '
    get .key1.key2.key3 => :a
    set .key1.key2.key3 => :a
    cal :a + :c + :d => :f

    
'


```

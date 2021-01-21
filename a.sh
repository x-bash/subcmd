jq . '.[] | { url: .html_url, state: .state }'


json.query "c.*./(html_url)|(id)/"  | json.attrlist id url | json.color 


for i in $(jo c.*); do
    jo url= i.html_url
    jo state= i.state
done


for i in $(jo c.*); do
    jo  url=i.html.url \
        state=i.state

    jo <<<'
        a = { 1: 2, 3: 4, c: 5 }
        d = { 
            a: 3
            b: 4
            c: {
                t: 1
            }
        }
        b = [ 1, 2, 3 ]
        url = i.html_url
        state = i.state
    '
done

# jo.start
# jo <<<''
# jo.stop


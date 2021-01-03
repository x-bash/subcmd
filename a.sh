


awk "$(cat utils)"'

function fib(n){
    if (n == 1) return 1;
    if (n == 0) return 1;
    return fib(n-1) + fib(n-2)
}

function cb(a){ 
    print "hi " a; 
};

function work(a, b){
    print a b
}


BEGIN{
    print "hi";
    cb()
    parse_array_exit(1, 2)
    for (i=0; i< 10; i++) {
       print fib(i)
    }

    debug("awk process exit.")

    work(3, 4)
    print "hi" d b

    _[1] = 1
    _[1, 2] = "1,2"
    _[1 "," 2] = 13
    _[12]=12
    
    print _[1] " " _[1,2]

    print  "---------------"

    for (c in _) {
        print "hi: " c
    }

    print _[1, 2], _[12]

    print "----------"

    print _value(1, 1, 1)

    
}
' <<< ""

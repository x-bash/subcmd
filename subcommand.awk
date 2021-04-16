function handle(subcmd, text){

}

BEGIN {
    out_subcmd_desc = "\033[1;34m"
    out_title = "\033[1;37m"
    out_subcmd = "\033[1;32m"

    start = 0
}


start==2{
    help = help "\n" $0
}

start==1{
    if (match($0, /^Example:/)) {
        start=2
        help = help "\n" out_title $0 "\033[0m"
    } else {

        keyword=$1
        if (match($1, "^:")) {
            aaa=$0
            pat=$1
            gsub(/\|/, "\\|", pat)
            sub(pat, out_subcmd substr($1, 2) "\033[0m" out_subcmd_desc, aaa)
            help = help "\n" aaa "\033[0m"

            handle(subcmd, text)
            subcmd=substr($1, 1)
            match($0, /^\s+[^\s]+\s+/)
            text = text "\n" substr($0, RLENGTH)
        } else {
            help = help "\n" substr($0, 2) 
            text = text "\n" $0
        }
    }
}



start==0{
    # if (match($0, /^\s*$/)) {
    #     # ignore
    #     help = help "\n" $0
    # } 

    if (match($0, /^Subcommand:/)) {
        help = help "\n" out_title $0 "\033[0m"
        start = 1
    } else {
        help = help "\n" $0
    }
}

END {
    print help > "/dev/stderr"
}

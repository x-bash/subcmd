function handle(subcmd, text,
    arr, arrlen, full_subcmd){
    
    arrlen = split(subcmd, arr, /\|/)
    if (subcmd != "") {

        full_subcmd = prefix "_" substr(arr[1], 2)

        code = code "\n    " substr(subcmd, 2) ")\t\t" full_subcmd "  ${1:+\"$@\"}  ;;"

        gsub(/\|/, ":", subcmd)
        if (json == "") {
            json = json "\n   \""  subcmd ":\"" ": {}"  # {} => $(full_subcmd --advise-json)
        } else {
            json = json ",\n   \""  subcmd ":\""  ": {}"
        }
    }
}

BEGIN {
    out_subcmd_desc = "\033[1;34m"
    out_title = "\033[1;37m"
    out_subcmd = "\033[1;32m"

    start = 0
    code = "local op=\"${1:?Provide op}\"\n"
    code = code "shift" "\n"
    code = code "case \"$op\" in"

    json = ""
}

start==1{
    keyword=$1
    if (match($1, "^:")) {
        aaa=$0
        pat=$1
        gsub(/\|/, "\\|", pat)
        sub(pat, out_subcmd substr($1, 2) "\033[0m" out_subcmd_desc, aaa)
        help_str = help_str "\n" aaa "\033[0m"

        handle(subcmd, text)
        subcmd=substr($1, 1)
        match($0, /^\s+[^\s]+\s+/)
        text = text "\n" substr($0, RLENGTH)
    } else {
        help_str = help_str "\n" substr($0, 2) 
        text = text "\n" $0
    }
}

start==0{
    if (match($0, /^Subcommand:/)) {
        # help_str = help_str "\n" out_title $0 "\033[0m"
        help_str = out_title $0 "\033[0m"
        start = 1
    } else {
        # help_str = help_str "\n" $0
    }
}

END {
    print prefix "_subcmd() {"

    gsub(/\"/, "\\\"", json)


    code = code "\n    advise-json-items)\t\tprintf \"" json "\n\" ;;"
    code = code "\n    advise-json)\t\tprintf \"{" "$(" prefix "_subcmd advise-json-items)" "\n}\n\" ;;"

    code = code "\n    help)\t\tprintf \"" help_str "\n\" ;;"
    print code "\nesac"

    print "}"
}

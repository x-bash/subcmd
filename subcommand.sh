
subcommand(){
    printf "%s" "$1" | awk -f ./subcommand.awk
}

subcommand "
json    json utilities
        Uasge:  json subcommand [...arguments]
        Please visit following hosting repository for more information:
            https://gitee.com/x-bash/json
            https://github.com/x-bash/json
            https://gitlab.com/x-bash/json
            https://bitbucket.com/x-bash/json

Subcommand:
        :var                json var <variable-name> <data>
                            Regulate the data to standard json, then putting into variable
        :color|c            json color <variable-name>
                            Colorize the formated json stored in variable
        :push|append        json push [variable-name].<pattern> <element>
                            Putting the element at the end of the specified list in variable 
        :unshift|prepend    json unshift [variable-name].<pattern> <element>
                            Putting the element at the begin of the specified list in variable 
        :keys|k             json keys [variable-name].<pattern>
                            Printing the keys of the specified dictionary in variable 
        :values|v           json values [variable-name].<pattern>
                            Printing the values of the specified dictionary in variable 
        :shift|sh           json shift [variable-name].<pattern>
                            Shift the values of the specified list in variable 
        :pop|po             json pop [variable-name].<pattern>
                            Pop the values of the specified list in variable 
        :length|len         json len [variable-name].<pattern>
                            Print the length of the specified list or object in variable 
        :unescape            
        :<none>

Example:
        os='{ author:l, email:l@x-cmd.com, modules:[xrc, list, dict, jo, cache, yml] }'
        json color os
        json keys os
        json values os.modules
        echo "\$os" | json values .modules
        json shift os.modules
        json push os.modules json
        json os.modules
"
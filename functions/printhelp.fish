function printhelp --description 'Helps build -h/--help messages for fish functions'
    set __name (string split '.' (basename (status -f)))[1]
    set __version '0.1.2'
    set __description 'Helps build -h/--help messages for fish functions'

    set opts (fish_opt --short d --long debug)
    set opts $opts (fish_opt --short h --long help)
    argparse $opts -- $argv

    function _log --description 'Log messages (Levels: ERR, INF, WARN, DEBUG, OK, QUESTION)'
        if functions -q log
            log $argv && return
        end

        set opts $opts (fish_opt --short l --long level --required-val)
        set opts $opts (fish_opt --short t --long timestamp)
        argparse $opts -- $argv

        set msg
        if set --query _flag_t
            set msg (set_color -d)(printf '[%s]' (date +'%H:%M:%S.%N'))(set_color --reset)
        end

        set --query _flag_l && set level $_flag_l
        switch $level
            case dbg debug DBG DEBUG
                set msg $msg (set_color -o cyan)DBG(set_color --reset) $argv
            case inf info INF INFO
                set msg $msg (set_color --bold --dim white)INF(set_color --reset) $argv
            case wrn warn WRN WARN
                set msg $msg (set_color -o yellow)WARN(set_color --reset) $argv
            case err error ERR ERROR
                set msg $msg (set_color -o red)ERR(set_color --reset) $argv
            case ok OK
                set msg $msg (set_color -o green)OK(set_color --reset) $argv
            case question QUESTION
                set msg $msg (set_color -o cyan)'???'(set_color --reset) $argv
            case '*'
                set msg $msg $argv
        end

        echo $msg
    end

    # Constants.
    set --global TAB '  '
    set --global FLAG_DELIM ', '

    # Variables to describe the calling function.
    set --global fn_name
    set --global fn_version
    set --global fn_description

    function _title --description 'Print title' \
        --argument-names _name _version _description
        set fn_name $_name
        set fn_version $_version
        set fn_description $_description

        set name (set_color --bold green)$fn_name(set_color --reset)
        set description (set_color --italic)$fn_description(set_color --reset)

        # The title.
        printf '%s %s - %s.\n' $name $_version $description
    end

    function _usage_title --description 'Print usage title'
        printf '%s\n' (set_color --bold green)'Usage:'(set_color --reset)
    end

    function _usage --description 'Print usage example with description' \
        --argument-names _example _description
        # We need _example at least
        if not set --query _example
            _log --level ERR 'Not enough arguments passed to `printhelp usage <EXAMPLE> <DESCRIPTION>`'
            return 1
        end

        set example (set_color --bold cyan)$fn_name(set_color --reset)" $_example"
        if set --query _description
            set description (set_color --dim brwhite)$_description(set_color --reset)
        end

        printf '  %s %s\n' $example $description
    end

    function _options_title --description 'Print options title'
        printf '%s\n' (set_color --bold green)'Options:'(set_color --reset)
    end

    function _option --description 'Print option example with description' \
        --argument-names _flags _args _description
        # We need _flags at least
        if not set --query _flags
            _log --level ERR 'Not enough arguments passed to `printhelp option <FLAGS> <ARGS> <DESCRIPTION>`'
            return 1
        end

        # Combine the _flags, which should be given as a string like: '-h --help'
        set flags (string join -- $FLAG_DELIM $_flags)

        set example (set_color --bold cyan)"$flags $_args"(set_color --reset)
        if set --query _description
            set description $_description
        end

        printf "  %s\n    %s\n" $example $description
    end

    if set --query _flag_h || not argparse --min-args=1 -- $argv &>/dev/null
        _title $__name $__version $__description

        echo
        _usage_title
        _usage '[ARGS] ...'
        _usage "title 'my_func' '0.1.0' 'My custom function'" 'Prints title, version and description of your function.'
        _usage usage_title "Prints usage title. Use this after `title`."
        _usage "usage '-h/--help' 'Prints help message.'" 'Prints a usage example, here using the -h/--help flags.'
        _usage options_title "Prints options title. Use this after `usage` examples."
        _usage "option '-f/--file' '<FILE>' 'Use this file.'" 'Print an option with description (see options for examples).'

        echo
        _options_title
        _option '-h, --help' '' 'Prints help message.'
        _option '-d, --debug' '' 'Debug output, very verbose.'

        return
    end

    switch $argv[1]
        case title
            _title $argv[2..]
        case usage_title
            _usage_title
        case usage
            _usage $argv[2..]
        case options_title
            _options_title
        case option
            _option $argv[2..]
        case '*'
            _log --level ERR "Must pass one of title, usage_title, usage, options_title, title to fnhelp"
    end
end

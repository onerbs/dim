#!/bin/bash

[[ -z $1 || $1 == -h || $1 == --help ]] && {
    echo -e '\n  dim  (c) 2020  Alejandro Elí

    Usage:
    $ dim FILE [-o OUTF] [-plu MODS] [-dmd DFGS] [-u | -r] [-t ARGS | -n]

    Where:
        FILE    Is the file to compile
        OUTF    Is the name of the compiled file
        MODS    Are the `plu` module names
        DFGS    Are the extra flags to pass to DMD
        ARGS    Are the arguments to pass to the binary to test

    Flags:
        -u )    Run the unit tests
        -r )    Create a release build
        -n )    Do not execute the resulting binary
        -t )    This flag *MUST* be the last

        -h, --help )   Print this help and exit
        -e, --debug )  Print debug info and exit
'; exit
}

[ "$DIM" ] || {
    echo -e "\e[31mERROR\e[m  The \e[1mDIM\e[m environment variable is \e[37mundefined\e[m"
    exit 1
}

declare _file=${1%.*} _runafter=True _debug=False

while (( $# > 0 )); do
    case $1 in
        -o ) shift;_outfile=$1 ;;
        -plu ) _type=libs ;;
        -dmd ) _type=flags ;;
        -u ) U=(-main -unittest) ;;
        -r ) R=(-O -release -inline -boundscheck=off) ;;
        -n ) _runafter=False ;;
        -t ) shift; break ;;
        -e | --debug ) _debug=True ;;
        *  )
        case $_type in
            libs ) _libs+=($1) ;;
            flags ) _flags+=($1) ;;
        esac ;;
    esac; shift
done

[ $_outfile ] || _outfile=$_file
for lib in ${_libs[@]}; do
    _files+=($(find $DIM -type f -exec grep -l $lib {} \;))
done
_files=($(echo ${_files[@]} | tr ' ' "\n" | sort | uniq))
_command="dmd ${R[@]} -de -w ${U[@]} -of=$_outfile ${_flags[@]} ${_files[@]} $_file.d"

[[ $_debug == True ]] && {
    echo "
    file:      $_file
    outfile:   $_outfile
    include:   ${_libs[@]}
    dmdflags:  ${_flags[@]}
    testargs:  $@
    unittest:  $U
    release:   ${R[@]}
    runafter:  $_runafter
    command:   $_command
";  exit
}

$_command && { [[ $_runafter == True && -x $_outfile ]] && $_outfile $@ || true; }

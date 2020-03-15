#!/bin/bash

[ "$IMPORT_D" ] || {
  echo -e '\e[01;31mError:\e[0m environment variable \e[01mIMPORT_D\e[0m is not set'
  exit 34
}

# Usage:
# dim FILE[.d] [-plu MODULES] [-u|-r] [-o OUTFILE] [-t ARGS|-q]

_file=$(fst -d . $1)
_run=yes

while (( $# > 0 )); do
  case $1 in
    -plu) type=module   ;;
    -t)   type=testargs ;;
    -o)   type=outfile  ;;
    -u)   U=-unittest ;;
    -r)   R=(-release -inline -boundscheck=off) ;;
    -q)   _run=no ;;
    *) case $type in
      module) _modules+=($1) ;;
      testargs) _testargs+=($1) ;;
      outfile) _outfile=$1 ;;
    esac ;;
  esac; shift
done

[ "$_outfile" ] || _outfile=$_file

for _module in ${_modules[@]}; do
  _paths+=($IMPORT_D/plu/$_module.d)
  [ -d $IMPORT_D/lib/$_module ] && \
  for __file in $(find $IMPORT_D/lib/$_module -type f); do
    # Q: this verification is necessary?
    [[ $__file == *.*.d ]] || _paths+=($__file)
  done
done

# # DEBUG
# echo file:     $_file
# echo outfile:  $_outfile
# echo testargs: ${_testargs[@]}
# echo modules:  ${_modules[@]}
# echo unittest: $U
# echo release:  ${R[@]}
# echo paths:    ${_paths[@]}
# echo run:      $_run
# exit

# Q: set the output dir to dist/ ? :: -od=dist
dmd -O -de -w $U ${R[@]} -of=$_outfile $_file.d ${_paths[@]} || \
rm $_outfile 2>/dev/null; rm $_outfile.o 2>/dev/null

[[ $_run == yes ]] && [ -x $_outfile ] && { clear; $_outfile ${_testargs[@]}; }

unset __file _file _modules _outfile _paths _run _testargs

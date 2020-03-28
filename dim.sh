#!/bin/bash

[ "$DIM" ] || {
	echo -e '\e[01;31mError:\e[0m environment variable \e[DIM\e[0m is not set'
	exit 34
}

# Usage:
# dim FILE[.d] [-plu MODULES] [-u|-r] [-o OUTFILE] [-t ARGS|-q]

_file_=$(echo $1 | cut -d. -f1)
_run_=yes

while (( $# > 0 )); do
	case $1 in
		-plu|-lib) _type_=module; _pkg_=${1:1}   ;;
		-t)   _type_=testargs ;;
		-o)   _type_=outfile  ;;
		-u)   U=-unittest ;;
		-r)   R=(-release -inline -boundscheck=off) ;;
		-q)   _run_=no ;;
		*) case $_type_ in
			module) _mods_+=($_pkg_/$1) ;;
			testargs) _test_args_+=($1) ;;
			outfile) _outf_=$1 ;;
		esac ;;
	esac; shift
done

[ "$_outf_" ] || _outf_=$_file_


__imports_of () {
	grep -F import $1 |
	cut -dt -f2- |
	cut -d\  -f2 |
	sed s:\;:: |
	grep '^[^s]' |
	sed 's_\._:_'
}

echo
for _module_ in ${_mods_[@]}; do
	__file__=$DIM/$_module_.d # what if _module_ is a dir ?
	_paths_+="$__file__ "
	echo "import $_module_"
	for __pair__ in $(__imports_of $__file__); do
		__pkg__=$(echo $__pair__ | cut -d: -f1)
		__mod__=$(echo $__pair__ | cut -d: -f2 | sed 's:\.:/:g')
		echo " - dep: $__pkg__/$__mod__"
		case $__pkg__ in
			lib) [ -d $DIM/$__pkg__/$__mod__ ] && \
				_paths_+="$(find $DIM/$__pkg__/$__mod__ -type f) " || \
				_paths_+="$DIM/$__pkg__/$__mod__.d " ;;
			*)
				# load deps of dep
				_paths_+="$DIM/$__pkg__/$__mod__.d " ;;
		esac
	done
done

declare -a _clean_paths_=()
for e in $_paths_; do
	case $e in
		${_clean_paths_[@]}) ;;
		*) _clean_paths_+=($e) ;;
	esac
done

unset __pair__ __imports_of __file__

# # DEBUG
# echo file:     $_file_
# echo outfile:  $_outf_
# echo testargs: ${_test_args_[@]}
# echo modules:  ${_mods_[@]}
# echo unittest: $U
# echo release:  ${R[@]}
# echo paths:    ${_clean_paths_[@]}
# echo run:      $_run_
# exit

# Q: set the output dir to dist/ ? :: -od=dist
dmd -O -de -w $U ${R[@]} -of=$_outf_ $_file_.d ${_clean_paths_[@]} || \
rm $_outf_ 2>/dev/null; rm $_outf_.o 2>/dev/null

[[ $_run_ == yes ]] && [ -x $_outf_ ] && { clear; $_outf_ ${_test_args_[@]}; }

unset _file_ _mods_ _outf_ _paths_ _clean_paths_ _run_ _test_args_

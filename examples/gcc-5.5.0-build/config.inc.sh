
GCC_DIST_HOME=${HOME}/last-class/gcc

cat_any(){
    file=${1}
    case "${file}" in
        *.gz) cmd='gzip -dc';;
        *.tgz) cmd='gzip -dc';;
        *.bz2) cmd='bzip2 -dc';;
        *.xz) cmd='xz -dc';;
        *.lz) cmd='lzip -dc';;
        *)
	    echo "error: unknown file extension \"${file}\"" 1>&2
	    false
	    ;;
    esac
    case "${file}" in
        http://*|https://*)
            curl -sk "${file}" | $cmd -
            ;;
        *)
            $cmd "${file}"
            ;;
    esac
}

extract(){
    case "${1}" in
        http://*|https://*)
            echo "extracting \"${1}\""
            ;;
        *)
            test -f "${1}" || die 1 "ERROR: file \"${1}\" does not exist"
            test -r "${1}" || die 1 "ERROR: file \"${1}\" is not readable"
            ;;
    esac
    mkdir -p "${2}"
    cat_any "${1}" | tar -C "${2}" -xf -
}

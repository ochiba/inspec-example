#!/usr/bin/env bash

[ -n "$DEBUG" ] && set -x

PROGNAME=$(basename $0)
BASE_DIR=$(cd $(dirname $0)/..; pwd)
INVENTORY=${BASE_DIR}/inventories/stg/nodes.yml
INSPEC_DIR=${BASE_DIR}/test/inspec
INSPEC_REMOTE_HOST='127.0.0.1'
INSPEC_REMOTE_USER='vagrant'
INSPEC_ATTRS_FILE=''

usage() {
   cat <<EOS 1>&2
Usage: $PROGNAME [OPTIONS] PROFILE
  Wrapper for 'inspec exec'

Options:
  -h, --help            Show this help message and exit.
  -i INVENTORY, --inventory INVENTORY
                        Specify inventory host path.
  --host=HOST           Specify a remote host which is tested.
  --user=USER           The login user for a remote scan.
  --input-file INPUT_FILE
                        Load input file, a YAML file with values for the profile to use
EOS
}

for OPT in "$@"
do
    case "${OPT}" in
        '-h'|'--help')
            usage
            exit 1
            ;;
        '-i'|'--inventory')
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]] ; then
                echo "${PROGNAME}: Option requires an argument -- $1" 1>&2
                exit 1
            fi
            INVENTORY="$2"
            shift 2
            ;;
        '--host')
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]] ; then
                echo "${PROGNAME}: Option requires an argument -- $1" 1>&2
                exit 1
            fi
            INSPEC_REMOTE_HOST="$2"
            shift 2
            ;;
        '--user')
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]] ; then
                echo "${PROGNAME}: Option requires an argument -- $1" 1>&2
                exit 1
            fi
            INSPEC_REMOTE_USER="$2"
            shift 2
            ;;
        '--input-file')
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]] ; then
                echo "${PROGNAME}: Option requires an argument -- $1" 1>&2
                exit 1
            fi
            INSPEC_ATTRS_FILE="$2"
            shift 2
            ;;
        -*)
            echo "${PROGNAME}: Illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
            exit 1
            ;;
        *)
            if [[ -n "$1" ]] && [[ ! "$1" =~ ^-+ ]] ; then
                param+=( "$1" )
                shift 1
            fi
            ;;
    esac
done

if [ -z $param ]; then
    echo "$PROGNAME: too few arguments" 1>&2
    exit 1
fi

# Construct InSpec arguments
INSPEC_PROFILE="${param[0]}"
INSPEC_TARGET="ssh://${INSPEC_REMOTE_USER}@${INSPEC_REMOTE_HOST}"

# Make attributes file with ansible-inventory
if [[ -z "${INSPEC_ATTRS_FILE}" ]] ; then
    INSPEC_ATTRS_FILE=${INSPEC_DIR}/attributes/${INSPEC_REMOTE_HOST}.yml
    if [[ -f "${INSPEC_ATTRS_FILE}" ]] ; then
        # Backup old attributes file
        INSPEC_ATTRS_FILE_OLD="${INSPEC_ATTRS_FILE}.$(date '+%Y%m%d-%H%M%S')"
        echo "Move old attributes file to ${INSPEC_ATTRS_FILE_OLD}" 1>&2
        mv -f ${INSPEC_ATTRS_FILE} ${INSPEC_ATTRS_FILE_OLD}
    fi
    echo "Make attributes file as ${INSPEC_ATTRS_FILE}" 1>&2
    ansible-inventory -i ${INVENTORY} --yaml --host=${INSPEC_REMOTE_HOST} > ${INSPEC_ATTRS_FILE}
fi

# Run inspec exec
inspec exec ${INSPEC_PROFILE} \
    --target=${INSPEC_TARGET} \
    --input-file=${INSPEC_ATTRS_FILE}


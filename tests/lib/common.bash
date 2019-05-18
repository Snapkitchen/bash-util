
# # enable alias expansion for mocks
# shopt -s expand_aliases
# 
# # clear any existing aliases
# unalias -a

# check if attribute is set e.g. 'e'
__test__shell_attribute_is_set() {
  case "$-" in
    *"$1"*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# check if option is set e.g. 'pipefail'
__test__shell_option_is_set() {
  case "$(set -o | grep "$1")" in
    *on)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

__test__load_bash_util() {
  # if e is set, disable and set
  # restore flag
  local restore_e='false'
  if __test__shell_attribute_is_set 'e'; then
    restore_e='true'
    set +e
  fi
  
  # check for required vars
  : ${__TEST__BASH_UTIL__LOADER_FILE:?}
  : ${__TEST__BASH_UTIL__LIB_FILE:?}
  
  # run the loader
  local source_exit_code=
  source "${__TEST__BASH_UTIL__LOADER_FILE}" -l "${__TEST__BASH_UTIL__LIB_FILE}"
  source_exit_code=$?
  
  # restore state of e, if needed
  if [[ "${restore_e}" = 'true' ]]; then
    set -e
  fi
  
  return $source_exit_code
}

return 0

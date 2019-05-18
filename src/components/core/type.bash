# ==============================================================================
# type - types
# ==============================================================================

readonly BASH_UTIL__TYPE__STRING='STRING'
readonly BASH_UTIL__TYPE__BOOL='BOOL'
readonly BASH_UTIL__TYPE__INT='INT'
readonly BASH_UTIL__TYPE__LIST='LIST'
readonly BASH_UTIL__TYPE__DICT='DICT'

# ==============================================================================
# type - clone_value
# ==============================================================================

bash_util__type__clone_value() {
  # 1) source var name
  # 2) source var type
  # 3) dest var name

  bash_util__type__is_valid "${2:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  {
    case "${2}" in
      "${BASH_UTIL__TYPE__BOOL}")
        bash_util__bool__clone_value "${1:-}" "${3:-}"
        ;;
      "${BASH_UTIL__TYPE__DICT}")
        bash_util__dict__clone "${1:-}" "${3:-}"
        ;;
      "${BASH_UTIL__TYPE__INT}")
        bash_util__int__clone_value "${1:-}" "${3:-}"
        ;;
      "${BASH_UTIL__TYPE__LIST}")
        bash_util__list__clone "${1:-}" "${3:-}"
        ;;
      "${BASH_UTIL__TYPE__STRING}")
        bash_util__string__clone_value "${1:-}" "${3:-}"
        ;;
      *)
        echo "type '${2}' not yet implemented" | bash_util__log__error
        return "${BASH_UTIL__CODE__NOT_IMPLEMENTED}"
        ;;
    esac
  } || {
    echo "failed to clone '${2}' var '${1:-}' to var: '${3:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# type - destroy_type
# ==============================================================================

bash_util__type__destroy_type() {
  if bash_util__string__destroy "${1:-}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed to destroy type: ${1:-}" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

# ==============================================================================
# type - destroy_value
# ==============================================================================

bash_util__type__destroy_value() {
  # 1) dynamic var name
  # 2) type

  bash_util__type__is_valid "${2:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  {
    case "${2}" in
      "${BASH_UTIL__TYPE__BOOL}")
        bash_util__bool__destroy "${1:-}"
        ;;
      "${BASH_UTIL__TYPE__DICT}")
        bash_util__dict__destroy "${1:-}"
        ;;
      "${BASH_UTIL__TYPE__INT}")
        bash_util__int__destroy "${1:-}"
        ;;
      "${BASH_UTIL__TYPE__LIST}")
        bash_util__list__destroy "${1:-}"
        ;;
      "${BASH_UTIL__TYPE__STRING}")
        bash_util__string__destroy "${1:-}"
        ;;
      *)
        echo "type '${2}' not yet implemented" | bash_util__log__error
        return "${BASH_UTIL__CODE__NOT_IMPLEMENTED}"
        ;;
    esac
  } || {
    echo "failed to destroy '${2}' var: '${1:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# type - is_valid
# ==============================================================================

bash_util__type__is_valid() {
  # 1) type
  # 2) description
  
  case "${1:-}" in
    'STRING'|'BOOL'|'INT'|'LIST'|'DICT')
      return "${BASH_UTIL__CODE__TRUE}"
      ;;
    *)
      echo "invalid ${2:-"type"}: '${1:-}'" | bash_util__log__error 1
      return "${BASH_UTIL__CODE__FALSE}"
      ;;
  esac
}

# ==============================================================================
# type - get_type
# ==============================================================================

bash_util__type__get_type() {
  # 1) dynamic var name

  # valid check
  bash_util__var__is_valid "${1:-}" 'var name' ||
    return "${BASH_UTIL__CODE__INVALID}"

  # set check
  bash_util__var__is_set "${1:-}" 'var' ||
    return "${BASH_UTIL__CODE__UNSET}"
  
  if eval "printf '%s\n' \"\${$1}\""
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo 'failed printing type' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

# ==============================================================================
# type - set_type
# ==============================================================================

# sets a variable to a specified type
#   and does type validation
bash_util__type__set_type() {
  # 1) dynamic var name
  # 2) type
  
  bash_util__type__is_valid "${2:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  if bash_util__string__assign "${1:-}" "${2:-}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed assigning string" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

# ==============================================================================
# type - get_value
# ==============================================================================

# returns a variable value based on
#   specified type
bash_util__type__get_value() {
  # 1) dynamic var name
  # 2) var type

  # type check
  bash_util__type__is_valid "${2:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  {
    case "${2}" in
        "${BASH_UTIL__TYPE__BOOL}")
          bash_util__bool__print_value "${1}"
          ;;
        "${BASH_UTIL__TYPE__DICT}")
          bash_util__var__print_name "${1}" 'dict name'
          ;;
        "${BASH_UTIL__TYPE__INT}")
          bash_util__int__print_value "${1}"
          ;;
        "${BASH_UTIL__TYPE__LIST}")
          bash_util__var__print_name "${1}" 'list name'
          ;;
        "${BASH_UTIL__TYPE__STRING}")
          bash_util__string__print_value "${1}"
          ;;
        *)
          echo "type '${2}' not yet implemented" | bash_util__log__error
          return "${BASH_UTIL__CODE__NOT_IMPLEMENTED}"
          ;;
    esac
  } || {
    return $?
  }
  
  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# type - set_value
# ==============================================================================

# sets a variable to a specified value
#   and does type validation
bash_util__type__set_value() {
  # 1) dynamic var name
  # 2) var type
  # 3-N) value(s)

  # type check
  bash_util__type__is_valid "${2:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  {
    case "${2}" in
        "${BASH_UTIL__TYPE__BOOL}")
          bash_util__bool__assign "${1:-}" ${3+"${3}"}
          ;;
        "${BASH_UTIL__TYPE__DICT}")
          bash_util__dict__clone "${3:-}" "${1:-}"
          ;;
        "${BASH_UTIL__TYPE__INT}")
          bash_util__int__assign "${1:-}" ${3+"${3}"}
          ;;
        "${BASH_UTIL__TYPE__LIST}")
          bash_util__list__clone "${3:-}" "${1:-}"
          ;;
        "${BASH_UTIL__TYPE__STRING}")
          bash_util__string__assign "${1:-}" ${3+"${3}"}
          ;;
        *)
          echo "type '${2}' not yet implemented" | bash_util__log__error
          return "${BASH_UTIL__CODE__NOT_IMPLEMENTED}"
          ;;
    esac
  } || {
    echo "failed assigning values to '${2}' var: '${1}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# type - value_is_set
# ==============================================================================

# checks if a value is
# set based on specified type
bash_util__type__value_is_set() {
  # 1) dynamic var name
  # 2) var type

  # type check
  bash_util__type__is_valid "${2:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  {
    case "${2}" in
        "${BASH_UTIL__TYPE__BOOL}")
          bash_util__bool__exists "${1:-}"
          ;;
        "${BASH_UTIL__TYPE__DICT}")
          bash_util__dict__exists "${1:-}"
          ;;
        "${BASH_UTIL__TYPE__INT}")
          bash_util__int__exists "${1:-}"
          ;;
        "${BASH_UTIL__TYPE__LIST}")
          bash_util__list__exists "${1:-}"
          ;;
        "${BASH_UTIL__TYPE__STRING}")
          bash_util__string__exists "${1:-}"
          ;;
        *)
          echo "type '${2}' not yet implemented" | bash_util__log__error
          return "${BASH_UTIL__CODE__NOT_IMPLEMENTED}"
          ;;
    esac
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        return "${BASH_UTIL__CODE__FALSE}"
        ;;
      *)
        echo "failed checking if '${2}' value is set for var: '${1}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    esac
  }

  return "${BASH_UTIL__CODE__TRUE}"
}

# ==============================================================================
# type - value_is_valid
# ==============================================================================

# checks if a value is valid
# based on specified type
bash_util__type__value_is_valid() {
  # 1) dynamic var name
  # 2) var type

  # type check
  bash_util__type__is_valid "${2:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  {
    case "${2}" in
        "${BASH_UTIL__TYPE__BOOL}")
          bash_util__bool__is_valid "${1:-}"
          ;;
        "${BASH_UTIL__TYPE__DICT}")
          bash_util__dict__is_valid "${1:-}"
          ;;
        "${BASH_UTIL__TYPE__INT}")
          bash_util__int__is_valid "${1:-}"
          ;;
        "${BASH_UTIL__TYPE__LIST}")
          bash_util__list__is_valid "${1:-}"
          ;;
        "${BASH_UTIL__TYPE__STRING}")
          bash_util__string__is_valid "${1:-}"
          ;;
        *)
          echo "type '${2}' not yet implemented" | bash_util__log__error
          return "${BASH_UTIL__CODE__NOT_IMPLEMENTED}"
          ;;
    esac
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        return "${BASH_UTIL__CODE__FALSE}"
        ;;
      *)
        echo "failed checking if '${2}' value is valid" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    esac
  }

  return "${BASH_UTIL__CODE__TRUE}"
}

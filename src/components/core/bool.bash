# ==============================================================================
# bool - constants
# ==============================================================================

# bools
readonly BASH_UTIL__BOOL__TRUE="true"
readonly BASH_UTIL__BOOL__FALSE="false"

# ==============================================================================
# bool - assign
# ==============================================================================

# assigns a valid bool value to a string var
bash_util__bool__assign() {
  # 1) dynamic var name
  # 2) bool value

  # check value
  bash_util__bool__value_is_valid "${2:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  # assign value
  if bash_util__string__assign "${1:-}" "${2}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo 'failed to assign bool value' | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# bool - clone_value
# ==============================================================================

# clones the value of a bool var to another bool var
bash_util__bool__clone_value() {
  # 1) source bool name
  # 2) destination bool name

  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1:-}" '____bash_util__bool__clone_value__source_value' &&
    bash_util__var__names_do_not_conflict "${2:-}" '____bash_util__bool__clone_value__source_value'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  local ____bash_util__bool__clone_value__source_value=
  {
    ____bash_util__bool__clone_value__source_value="$(bash_util__bool__print_value "${1:-}")" &&
    bash_util__bool__assign "${2:-}" "${____bash_util__bool__clone_value__source_value}" &&
    return "${BASH_UTIL__CODE__OK}"
  } || {
    echo "failed to clone bool '${1:-}' to bool: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# bool - convert_from_exit_code
# ==============================================================================

#
# evaluates a numeric
#   exit code and returns
#   a bool string
#   where 0 == 'true'
#   and anything else == 'false'
#
# inputs:
#   1) exit code
#
# outputs:
#   stdout) 'true' or 'false'
#
bash_util__bool__convert_from_exit_code() {
  local exit_code="${1:-}"

  bash_util__int__value_is_valid "${exit_code}" 'exit code' ||
    return "${BASH_UTIL__CODE__INVALID}"

  if [[ "${exit_code}" -eq "${BASH_UTIL__CODE__TRUE}" ]]
  then
    bash_util__bool__print_true
  else
    bash_util__bool__print_false
  fi
}

# ==============================================================================
# bool - convert_to_exit_code
# ==============================================================================

#
# evaluates a bool
#   string and returns a
#   a numeric value
#   where 'true' == TRUE
#   and 'false' == FALSE
#
# inputs:
#   1) bool string
#
# outputs:
#   INVALID) invalid bool
#   TRUE) 'true'
#   FALSE) 'false'
#
bash_util__bool__convert_to_exit_code() {
  local bool_value="${1:-}"

  bash_util__bool__value_is_valid "${bool_value}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  if bash_util__bool__value_is_true "${bool_value}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# bool - destroy
# ==============================================================================

bash_util__bool__destroy() {
  if bash_util__var__destroy "${1:-}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed to destroy bool: ${1:-}" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

# ==============================================================================
# bool - equals
# ==============================================================================

# returns status code indicating if valid bools are equal
bash_util__bool__equals() {
  local bool_a="${1:-}"
  local bool_b="${2:-}"
  
  {
    bash_util__bool__value_is_valid "${bool_a}" 'first bool value' &&
    bash_util__bool__value_is_valid "${bool_b}" 'second bool value'
  } || {
    return "${BASH_UTIL__CODE__INVALID}"
  }
  
  if bash_util__string__equals "${bool_a}" "${bool_b}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# bool - exists
# ==============================================================================

# status code indicating if var exists
bash_util__bool__exists() {
  # 1) dynamic var name

  bash_util__var__is_valid "${1:-}" 'bool name' ||
    return "${BASH_UTIL__CODE__INVALID}"

  if _bash_util__var__is_set "${1}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# bool - is_false
# ==============================================================================

#
# evaluates a bool var
#   and checks it for a false value
#
# inputs:
#   1) bool var
# outputs:
#   TRUE) bool is 'false'
#   FALSE) bool is not 'false'
#
bash_util__bool__is_false() {
  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1:-}" '____bash_util__bool__is_false__value'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  local ____bash_util__bool__is_false__value=
  ____bash_util__bool__is_false__value="$(bash_util__bool__print_value "${1:-}")" || {
    echo 'failed getting bool value' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  bash_util__bool__value_is_false "${____bash_util__bool__is_false__value}"
}

# ==============================================================================
# bool - is_true
# ==============================================================================

#
# evaluates a bool var
#   and checks it for a true value
#
# inputs:
#   1) bool var
# outputs:
#   TRUE) bool is 'true'
#   FALSE) bool is not 'true'
#
bash_util__bool__is_true() {
  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1:-}" '____bash_util__bool__is_true__value'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  local ____bash_util__bool__is_true__value=
  ____bash_util__bool__is_true__value="$(bash_util__bool__print_value "${1:-}")" || {
    echo 'failed getting bool value' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  bash_util__bool__value_is_true "${____bash_util__bool__is_true__value}"
}

# ==============================================================================
# bool - is_valid
# ==============================================================================

#
# evaluates a bool string
#   and compares it to valid
#   bool values
#
# inputs:
#   1) bool string
# outputs:
#   TRUE) bool is valid
#   FALSE) bool is invalid
#
bash_util__bool__is_valid() {
  # 1) dynamic var name
  # 2) bool description

  {
    bash_util__bool__exists "${1:-}" &&
    {
      bash_util__bool__is_true "${1}" ||
      bash_util__bool__is_false "${1}"
    }
  } || {
    echo "invalid ${2:-"bool"}: '${1:-}'" | bash_util__log__error 1
    return "${BASH_UTIL__CODE__FALSE}"
  }
}

# ==============================================================================
# bool - false
# ==============================================================================

#
# prints a string representation
#   of a 'false' value
#
# outputs:
#   stdout) 'false'
#
bash_util__bool__print_false() {
  if printf "%s\n" "${BASH_UTIL__BOOL__FALSE}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo 'failed to print bool' | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# bool - true
# ==============================================================================

#
# prints a string representation
#   of a 'true' value
#
# outputs:
#   stdout) 'true'
#
bash_util__bool__print_true() {
  if printf "%s\n" "${BASH_UTIL__BOOL__TRUE}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo 'failed to print bool' | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# bool - print_value
# ==============================================================================

bash_util__bool__print_value() {
  if bash_util__string__print_value "${1:-}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo 'failed to print bool value' | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# bool - value_is_false
# ==============================================================================

bash_util__bool__value_is_false() {
  if bash_util__string__equals "${1:-}" "${BASH_UTIL__BOOL__FALSE}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# bool - value_is_true
# ==============================================================================

bash_util__bool__value_is_true() {
  if bash_util__string__equals "${1:-}" "${BASH_UTIL__BOOL__TRUE}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# bool - value_is_valid
# ==============================================================================

bash_util__bool__value_is_valid() {
  # 1) bool value
  # 2) bool description

  {
    bash_util__bool__value_is_true "${1:-}" ||
    bash_util__bool__value_is_false "${1:-}"
  } || {
    echo "invalid ${2:-"bool value"}: '${1:-}'" | bash_util__log__error 1
    return "${BASH_UTIL__CODE__FALSE}"
  }
}

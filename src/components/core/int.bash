# ==============================================================================
# int - assign
# ==============================================================================

# assigns a valid int value to a variable
bash_util__int__assign() {
  # check value
  bash_util__int__value_is_valid "${2:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  # assign value
  if bash_util__string__assign "${1:-}" "${2}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo 'failed to assign int value' | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# int - clone_value
# ==============================================================================

# clones the value of an int var to another int var
bash_util__int__clone_value() {
  # 1) source int name
  # 2) destination int name

  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1:-}" '____bash_util__int__clone_value__source_value' &&
    bash_util__var__names_do_not_conflict "${2:-}" '____bash_util__int__clone_value__source_value'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  local ____bash_util__int__clone_value__source_value=
  {
    ____bash_util__int__clone_value__source_value="$(bash_util__int__print_value "${1:-}")" &&
    bash_util__int__assign "${2:-}" "${____bash_util__int__clone_value__source_value}" &&
    return "${BASH_UTIL__CODE__OK}"
  } || {
    echo "failed to clone int '${1:-}' to int: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# int - destroy
# ==============================================================================

bash_util__int__destroy() {
  if bash_util__var__destroy "${1:-}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed to destroy int: ${1:-}" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

# ==============================================================================
# int - equals
# ==============================================================================

# returns status code indicating if valid ints are equal
bash_util__int__equals() {
  local int_a="${1:-}"
  local int_b="${2:-}"
  
  {
    bash_util__int__value_is_valid "${int_a}" 'first int value' &&
    bash_util__int__value_is_valid "${int_b}" 'second int value'
  } || {
    return "${BASH_UTIL__CODE__INVALID}"
  }
  
  if [[ "${int_a}" -eq "${int_b}" ]]
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# int - exists
# ==============================================================================

# status code indicating if var exists
bash_util__int__exists() {
  # 1) dynamic var name

  bash_util__var__is_valid "${1:-}" 'int name' ||
    return "${BASH_UTIL__CODE__INVALID}"

  if _bash_util__var__is_set "${1}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# int - is_valid
# ==============================================================================

# validates if int is valid
bash_util__int__is_valid() {
  # 1) dynamic var name
  # 2) int description

  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1:-}" '____bash_util__bool__is_valid__value'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  local ____bash_util__bool__is_valid__value=
  ____bash_util__bool__is_valid__value="$(bash_util__bool__print_value "${1:-}")" || {
    echo 'failed getting bool value' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  bash_util__int__value_is_valid "${____bash_util__bool__is_valid__value}" || {
    echo "invalid ${2:-"int"}: '${1}'" | bash_util__log__error 1
    return "${BASH_UTIL__CODE__FALSE}"
  }
}

# ==============================================================================
# int - max_value
# ==============================================================================

bash_util__int__max_value() {
  # 1n) int values

  local ____bash_util__int__max_value__value=
  for ____bash_util__int__max_value__value in ${@+"${@}"}
  do
    bash_util__int__value_is_valid "${____bash_util__int__max_value__value}" ||
      return "${BASH_UTIL__CODE__INVALID}"
  done

  _bash_util__int__max_value ${@+"${@}"}
}

# ==============================================================================

_bash_util__int__max_value() {
  if [[ "${#@}" -eq 0 ]]
  then
    echo 'requires at least 1 argument, received 0' | bash_util__log__error
    return "${BASH_UTIL__CODE__INVALID}"
  fi

  local ____bash_util__int__max_value__value=
  local ____bash_util__int__max_value__max_value="${1}"
  for ____bash_util__int__max_value__value in ${@+"${@}"}
  do
    if [[ "${____bash_util__int__max_value__value}" -gt "${____bash_util__int__max_value__max_value}" ]]
    then
      ____bash_util__int__max_value__max_value="${____bash_util__int__max_value__value}"
    fi
  done

  {
    bash_util__int__print_value '____bash_util__int__max_value__max_value' &&
    return "${BASH_UTIL__CODE__OK}"
  } || {
    echo 'failed to print max int value' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# int - min_value
# ==============================================================================

bash_util__int__min_value() {
  # 1n) int values

  local ____bash_util__int__min_value__value=
  for ____bash_util__int__min_value__value in ${@+"${@}"}
  do
    bash_util__int__value_is_valid "${____bash_util__int__min_value__value}" ||
      return "${BASH_UTIL__CODE__INVALID}"
  done

  _bash_util__int__min_value ${@+"${@}"}
}

# ==============================================================================

_bash_util__int__min_value() {
  if [[ "${#@}" -eq 0 ]]
  then
    echo 'requires at least 1 argument, received 0' | bash_util__log__error
    return "${BASH_UTIL__CODE__INVALID}"
  fi

  local ____bash_util__int__min_value__value=
  local ____bash_util__int__min_value__min_value="${1}"
  for ____bash_util__int__min_value__value in ${@+"${@}"}
  do
    if [[ "${____bash_util__int__min_value__value}" -lt "${____bash_util__int__min_value__min_value}" ]]
    then
      ____bash_util__int__min_value__min_value="${____bash_util__int__min_value__value}"
    fi
  done

  {
    bash_util__int__print_value '____bash_util__int__min_value__min_value' &&
    return "${BASH_UTIL__CODE__OK}"
  } || {
    echo 'failed to print max int value' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# int - print_value
# ==============================================================================

bash_util__int__print_value() {
  # 1) dynamic var name

  bash_util__int__exists "${1:-}" 'int name' ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  if eval "printf '%d' \"\${${1}}\""
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed executing eval string" | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# int - value_is_valid
# ==============================================================================

# validates if int value is valid
bash_util__int__value_is_valid() {
  local int_value="${1:-}"
  local int_description="${2:-"int value"}"

  {
    bash_util__string__is_not_null "${1:-}" 2>/dev/null &&
    printf '%d' "${1:-}" 1>/dev/null 2>/dev/null &&
    return "${BASH_UTIL__CODE__TRUE}"
  } || {
    echo "invalid ${int_description}: '${int_value}'" | bash_util__log__error 1
    return "${BASH_UTIL__CODE__FALSE}"
  }
}

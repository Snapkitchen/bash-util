# ==============================================================================
# string - append
# ==============================================================================

bash_util__string__append() {
  # 1) dynamic var name
  # 2) value to append

  bash_util__string__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  if eval "${1}+=\"\${2}\""
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed executing eval string" | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# string - assign
# ==============================================================================

# assigns a string value to a dynamic var name
bash_util__string__assign() {
  # 1) dynamic var name
  # 2) string value

  bash_util__var__is_valid "${1:-}" 'string name' ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  # execute eval string
  if eval "${1}=\"\${2:-}\""
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed executing eval string" | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# string - clone_value
# ==============================================================================

# clones the value of a string var to another string var
bash_util__string__clone_value() {
  # 1) source string name
  # 2) destination string name

  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1:-}" '____bash_util__string__clone_value__source_value' &&
    bash_util__var__names_do_not_conflict "${2:-}" '____bash_util__string__clone_value__source_value'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  local ____bash_util__string__clone_value__source_value=
  {
    ____bash_util__string__clone_value__source_value="$(bash_util__string__print_value "${1:-}")" &&
    bash_util__string__assign "${2:-}" "${____bash_util__string__clone_value__source_value}" &&
    return "${BASH_UTIL__CODE__OK}"
  } || {
    echo "failed to clone string '${1:-}' to string: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# string - destroy
# ==============================================================================

bash_util__string__destroy() {
  if bash_util__var__destroy "${1:-}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed to destroy string: ${1:-}" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

# ==============================================================================
# string - equals
# ==============================================================================

# returns status code indicating if strings are equal
bash_util__string__equals() {
  if [[ "${1:-}" = "${2:-}" ]]
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# string - exists
# ==============================================================================

# status code indicating if var exists
bash_util__string__exists() {
  # 1) dynamic var name

  bash_util__var__is_valid "${1:-}" 'string name' ||
    return "${BASH_UTIL__CODE__INVALID}"

  if ! _bash_util__var__is_set "${1}"
  then
    return "${BASH_UTIL__CODE__FALSE}"
  fi

  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__string__exists__regex_string' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__string__exists__declare_output'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  local ____bash_util__string__exists__regex_string=
  ____bash_util__string__exists__regex_string="^declare -[-|r] ${1}="

  local ____bash_util__string__exists__declare_output=
  ____bash_util__string__exists__declare_output="$(declare -p "${1}")" || {
    echo 'failed to get string var info' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  if [[ "${____bash_util__string__exists__declare_output}" =~ ${____bash_util__string__exists__regex_string} ]]
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# string - is_not_null
# ==============================================================================

bash_util__string__is_not_null() {
  local string_value="${1:-}"
  local string_description="${2:-"string value"}"

  if [[ -n "${string_value}" ]]
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    echo "${string_description} is null" | bash_util__log__error 1
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# string - is_null
# ==============================================================================

bash_util__string__is_null() {
  local string_value="${1:-}"
  local string_description="${2:-"string value"}"

  if [[ -z "${string_value}" ]]
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    echo "${string_description} is not null" | bash_util__log__error 1
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# string - is_valid
# ==============================================================================

bash_util__string__is_valid() {
  # 1) dynamic var name
  # 2) string description

  {
    bash_util__string__exists "${1:-}" &&
    return "${BASH_UTIL__CODE__TRUE}"
  } || {
    echo "invalid ${2:-"string"}: '${1:-}'" | bash_util__log__error 1
    return "${BASH_UTIL__CODE__FALSE}"
  }
}

# ==============================================================================
# string - not_equals
# ==============================================================================

# returns status code indicating if strings are equal
bash_util__string__not_equals() {
  if [[ "${1:-}" != "${2:-}" ]]
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# string - print_value
# ==============================================================================

bash_util__string__print_value() {
  # 1) dynamic var name

  bash_util__string__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  if eval "printf '%s\n' \"\${${1}}\""
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed executing eval string" | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# string - sanitize
# ==============================================================================

# sanitizes a string (escapes special characters and spaces)
bash_util__string__sanitize() {
  if printf '%q\n' "${1:-}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    return $?
  fi
}

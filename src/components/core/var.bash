# ==============================================================================
# var - destroy
# ==============================================================================

bash_util__var__destroy() {
  # null check
  bash_util__string__is_not_null "${1:-}" 'var name' ||
    return "${BASH_UTIL__CODE__NULL}"
    
  if _bash_util__var__is_unset "${1}"
  then
    # return immediately if already unset
    return "${BASH_UTIL__CODE__OK}"
  elif ! unset "${1}"
  then
    # failed to unset
    echo "failed to unset var: '${1}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  elif _bash_util__var__is_set "${1}"
  then
    # still set for some reason
    echo "var is still set: '${1}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  else
    # success
    return "${BASH_UTIL__CODE__OK}"
  fi
}

# ==============================================================================
# var - is_set
# ==============================================================================

bash_util__var__is_set() {
  # 1) var name
  # 2) var description
  if _bash_util__var__is_set ${@+"${@}"}
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    echo "${2:-"var"} is unset: '${1:-}'" | bash_util__log__error 1
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================

_bash_util__var__is_set() {
  declare -p "${1:-}" 1>/dev/null 2>/dev/null
}

# ==============================================================================
# var - is_unset
# ==============================================================================

bash_util__var__is_unset() {
  # 1) var name
  # 2) var description
  if _bash_util__var__is_unset ${@+"${@}"}
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    echo "${2:-"var"} is set: '${1:-}'" | bash_util__log__error 1
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================

_bash_util__var__is_unset() {
  ! declare -p "${1:-}" 1>/dev/null 2>/dev/null
}

# ==============================================================================
# var - is_valid
# ==============================================================================

bash_util__var__is_valid() {
  # 1) dynamic var name
  # 2) var description

  {
    bash_util__string__is_not_null "${1:-}" &&
    bash_util__var__name_is_valid "${1}" &&
    return "${BASH_UTIL__CODE__OK}"
  } || {
    echo "invalid ${2:-"var"}: '${1:-}'" | bash_util__log__error 1
    return "${BASH_UTIL__CODE__FALSE}"
  }
}

# ==============================================================================
# var - name_is_valid
# ==============================================================================

bash_util__var__name_is_valid() {
  local var_description="${2:-"var name"}"

  if _bash_util__var__name_is_valid "${1:-}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    echo "invalid ${var_description}: '${1:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================

_bash_util__var__name_is_valid() {
  [[ "${1:-}" =~ ^[a-zA-Z_]+[a-zA-Z0-9_]*$ ]]
}

# ==============================================================================
# var - names_do_not_conflict
# ==============================================================================

bash_util__var__names_do_not_conflict() {
  # 1) global var name
  # 2) local var name
  if _bash_util__var__names_do_not_conflict ${@+"${@}"}
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    echo "var name conflict: '${2:-}'" | bash_util__log__error 1
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================

_bash_util__var__names_do_not_conflict() {
  bash_util__string__not_equals "${1:-}" "${2:-}"
}

# ==============================================================================
# var - print_name
# ==============================================================================

bash_util__var__print_name() {
  # 1) dynamic var name
  # 2) var description

  bash_util__var__is_valid "${1}" "${2:-'var name'}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  if printf '%s\n' "${1}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed printing ${2:-'var name'}" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

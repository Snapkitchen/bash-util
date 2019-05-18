# ==============================================================================
# list - append
# ==============================================================================

# append items to end of list
bash_util__list__append() {
  # 1) dynamic var name
  # 2-N) var values

  bash_util__list__is_valid "${1:-}" || return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__append ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__append() {
  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__append__list_value' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__append__available_index'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }
  
  # get next available index for each value
  # and set the value at that index
  local ____bash_util__list__append__list_value=
  local ____bash_util__list__append__available_index=
  for ____bash_util__list__append__list_value in "${@:2}"; do
    ____bash_util__list__append__available_index="$(_bash_util__list__next_available_index "${1}")" || {
      echo "failed getting available index for list" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    _bash_util__list__set_element_value "${1}" "${____bash_util__list__append__available_index}" "${____bash_util__list__append__list_value}" || {
      echo "failed setting list value" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
  done

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# list - assign
# ==============================================================================

# assigns items to list
bash_util__list__assign() {
  bash_util__list__create "${1:-}" || {
    echo "failed creating list: '${1:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
  
  # use private function since create will create a valid list
  _bash_util__list__append "${1}" "${@:2}" || {
    echo "failed appending items to list: '${1}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# list - clone_all_elements
# ==============================================================================

bash_util__list__clone_all_elements() {
  # 1) src list name
  # 2) dst list name
  
  {
    bash_util__list__is_valid "${1:-}" 'source list' &&
    bash_util__list__is_valid "${2:-}" 'dest list'
  } || {
    return "${BASH_UTIL__CODE__INVALID}"
  }

  _bash_util__list__clone_all_elements ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__clone_all_elements() {
  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__clone_all_elements__list_indices' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__clone_all_elements__iter' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__clone_all_elements__list_value' &&

    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__clone_all_elements__list_indices' &&
    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__clone_all_elements__iter' &&
    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__clone_all_elements__list_value'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  # get list indices
  local ____bash_util__list__clone_all_elements__list_indices=
  ____bash_util__list__clone_all_elements__list_indices=( $(_bash_util__list__indices "${1}") ) || {
    echo "failed getting indices for source list: '${1}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
  
  # for each value
  local ____bash_util__list__clone_all_elements__iter=
  local ____bash_util__list__clone_all_elements__list_value=
  for (( ____bash_util__list__clone_all_elements__iter=0; ____bash_util__list__clone_all_elements__iter<"${#____bash_util__list__clone_all_elements__list_indices[@]}"; ____bash_util__list__clone_all_elements__iter++ )); do
    ____bash_util__list__clone_all_elements__list_value="$(_bash_util__list__get_element_value "${1}" "${____bash_util__list__clone_all_elements__list_indices[$____bash_util__list__clone_all_elements__iter]}")" || {
      echo "failed getting list '${1}' item at index '${____bash_util__list__clone_all_elements__list_indices[$____bash_util__list__clone_all_elements__iter]}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
    
    # set same index in new list to same value
    _bash_util__list__set_element_value "${2}" "${____bash_util__list__clone_all_elements__list_indices[$____bash_util__list__clone_all_elements__iter]}" "${____bash_util__list__clone_all_elements__list_value}" || {
      echo "failed setting list '${2}' element '${____bash_util__list__clone_all_elements__list_indices[$____bash_util__list__clone_all_elements__iter]}' to value: '${____bash_util__list__clone_all_elements__list_value}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
  done

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# list - clone
# ==============================================================================

bash_util__list__clone() {
  # 1) src list name
  # 2) dst list name

  bash_util__list__is_valid "${1:-}" 'source list' ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__clone ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__clone() {
  bash_util__list__create "${2:-}" || {
    echo "failed creating list: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  _bash_util__list__clone_all_elements "${1}" "${2}" || {
    echo "failed cloning elements to list: '${2}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# list - contains
# ==============================================================================

# check if list contains specified value
bash_util__list__contains() {
  # 1) dynamic var name
  # 2) value expected

  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__contains ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__contains() {
  # ensure a second arg was passed
  if [[ "$#" -lt  2 ]]
  then
    echo 'no value provided' | bash_util__log__error
    return "${BASH_UTIL__CODE__INVALID}"
  fi

  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__contains__list_indices' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__contains__iter' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__contains__list_value'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  # get list indices
  local ____bash_util__list__contains__list_indices=
  ____bash_util__list__contains__list_indices=( $(_bash_util__list__indices "${1}") ) || {
    echo 'failed getting indices for list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
  
  # iterate through each index
  # and get value for each
  local ____bash_util__list__contains__iter=
  local ____bash_util__list__contains__list_value=
  for (( ____bash_util__list__contains__iter=0; ____bash_util__list__contains__iter<"${#____bash_util__list__contains__list_indices[@]}"; ____bash_util__list__contains__iter++ ))
  do
    ____bash_util__list__contains__list_value="$(_bash_util__list__get_element_value "${1}" "${____bash_util__list__contains__list_indices[$____bash_util__list__contains__iter]}")" || {
      echo "failed getting value from list '${1}' at index '${____bash_util__list__contains__list_indices[$____bash_util__list__contains__iter]}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
    
    # if found
    if [[ "${____bash_util__list__contains__list_value}" = "${2:-}" ]]
    then
      return "${BASH_UTIL__CODE__TRUE}"
    fi
  done
  
  # match not found
  return "${BASH_UTIL__CODE__FALSE}"
}

# ==============================================================================
# list - copy
# ==============================================================================

bash_util__list__copy() {
  # 1) src list name
  # 2) dst list name

  bash_util__list__is_valid "${1:-}" 'source list' ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__copy ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__copy() {
  bash_util__list__create "${2:-}" || {
    echo "failed creating list: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
  
  # use private function since create will create a valid list
  _bash_util__list__extend "${1}" "${2}" || {
    echo "failed copying list '${1}' to list: '${2}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# list - create
# ==============================================================================

# initialize empty list
bash_util__list__create() {
  # 1) dynamic var name

  bash_util__var__is_valid "${1}" 'list name' ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  # execute eval string
  if eval "${1}=()"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed executing eval string" | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# list - destroy
# ==============================================================================

bash_util__list__destroy() {
  if bash_util__var__destroy "${1:-}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed to destroy list: ${1:-}" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

# ==============================================================================
# list - equals
# ==============================================================================

# check if lists contain the same items
bash_util__list__equals() {
  # 1) dynamic var name
  # 2) dynamic var name
  {
    bash_util__list__is_valid "${1:-}" 'left list' &&
    bash_util__list__is_valid "${2:-}" 'right list'
  } ||
  {
    return "${BASH_UTIL__CODE__INVALID}"
  }

  _bash_util__list__equals ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__equals() {
  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__equals__list_indices_a' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__equals__list_indices_b' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__equals__iter' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__equals__match_list' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__equals__list_value' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__equals__value_count_a' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__equals__value_count_b' &&

    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__equals__list_indices_a' &&
    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__equals__list_indices_b' &&
    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__equals__iter' &&
    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__equals__match_list' &&
    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__equals__list_value' &&
    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__equals__value_count_a' &&
    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__equals__value_count_b'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  # get list indices
  local ____bash_util__list__equals__list_indices_a=
  ____bash_util__list__equals__list_indices_a=( $(_bash_util__list__indices "${1}") ) || {
    echo 'failed getting indices for first list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  local ____bash_util__list__equals__list_indices_b=
  ____bash_util__list__equals__list_indices_b=( $(_bash_util__list__indices "${2}") ) || {
    echo 'failed getting indices for second list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  if [[ "${#____bash_util__list__equals__list_indices_a[@]}" -ne "${#____bash_util__list__equals__list_indices_b[@]}" ]]
  then
    # different lengths, cannot be equal
    return "${BASH_UTIL__CODE__FALSE}"
  elif [[ "${#____bash_util__list__equals__list_indices_a[@]}" -eq 0 ]]
  then
    # both lengths are zero, must be equal
    return "${BASH_UTIL__CODE__TRUE}"
  fi
  
  local ____bash_util__list__equals__iter=
  local ____bash_util__list__equals__match_list=()
  local ____bash_util__list__equals__list_value=
  local ____bash_util__list__equals__value_count_a=
  local ____bash_util__list__equals__value_count_b=
  for (( ____bash_util__list__equals__iter=0; ____bash_util__list__equals__iter<"${#____bash_util__list__equals__list_indices_a[@]}"; ____bash_util__list__equals__iter++ ))
  do
    # get first value
    ____bash_util__list__equals__list_value=$(_bash_util__list__get_element_value "${1}" "${____bash_util__list__equals__list_indices_a[$____bash_util__list__equals__iter]}") || {
      echo "failed getting first list '${1}' value at index '${____bash_util__list__equals__list_indices_a[$____bash_util__list__equals__iter]}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # check if we've already compared this value
    {
      # skip this comparison
      _bash_util__list__contains '____bash_util__list__equals__match_list' "${____bash_util__list__equals__list_value}" &&
      continue
    } || {
      case $? in
        "${BASH_UTIL__CODE__FALSE}")
          # proceed
          ;;
        *)
          # error
          echo 'failed checking match list for value' | bash_util__log__error
          return "${BASH_UTIL__CODE__GENERAL_ERROR}"
          ;;
      esac
    }

    # get count of value in list a
    ____bash_util__list__equals__value_count_a="$(_bash_util__list__get_value_count "${1}" "${____bash_util__list__equals__list_value}")" || {
      echo "failed getting count of value in first list: '${1}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # get count of value in list b
    ____bash_util__list__equals__value_count_b="$(_bash_util__list__get_value_count "${2}" "${____bash_util__list__equals__list_value}")" || {
      echo "failed getting count of value in second list: '${2}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    if [[ "${____bash_util__list__equals__value_count_a}" -ne "${____bash_util__list__equals__value_count_b}" ]]
    then
      # different counts of same value, cannot be equal
      return "${BASH_UTIL__CODE__FALSE}"
    elif [[ "${____bash_util__list__equals__list_length_a}" -eq "${____bash_util__list__equals__value_count_a}" ]]
    then
      # list consists entirely of value, with same count, so must be equal
      return "${BASH_UTIL__CODE__TRUE}"
    else
      # lists both contain same quantity of value
      # add to match list
      ____bash_util__list__equals__match_list+=("${____bash_util__list__equals__list_value}")
    fi
  done

  # lists are equal
  return "${BASH_UTIL__CODE__TRUE}"
}

# ==============================================================================
# list - exists
# ==============================================================================

# status code indicating if list exists
bash_util__list__exists() {
  # 1) dynamic var name

  bash_util__var__is_valid "${1:-}" 'list name' ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__exists ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__exists() {
  {
    _bash_util__var__is_set "${1}" &&
    _bash_util__list__is_valid "${1}" &&
    return "${BASH_UTIL__CODE__TRUE}"
  } || {
    return "${BASH_UTIL__CODE__FALSE}"
  }
}

# ==============================================================================
# list - extend
# ==============================================================================

# extends a list with items from another list
bash_util__list__extend() {
  # 1) dynamic var name - source list
  # 2) dynamic var name - destination list

  {
    bash_util__list__is_valid "${1:-}" 'source list' &&
    bash_util__list__is_valid "${2:-}" 'dest list'
  } ||
  {
    return "${BASH_UTIL__CODE__INVALID}"
  }

  _bash_util__list__extend ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__extend() {
  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__extend__list_indices' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__extend__iter' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__extend__list_value' &&

    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__extend__list_indices' &&
    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__extend__iter' &&
    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__extend__list_value'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  # get list indices
  local ____bash_util__list__extend__list_indices=
  ____bash_util__list__extend__list_indices=( $(_bash_util__list__indices "${1}") ) || {
    echo 'failed getting indices for list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
  
  local ____bash_util__list__extend__iter=
  local ____bash_util__list__extend__list_value=
  for (( ____bash_util__list__extend__iter=0; ____bash_util__list__extend__iter<"${#____bash_util__list__extend__list_indices[@]}"; ____bash_util__list__extend__iter++ )); do
    ____bash_util__list__extend__list_value="$(_bash_util__list__get_element_value "${1}" "${____bash_util__list__extend__list_indices[$____bash_util__list__extend__iter]}")" || {
      echo "failed getting list '${1}' item at index '${____bash_util__list__extend__list_indices[$____bash_util__list__extend__iter]}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
    
    _bash_util__list__append "${2}" "${____bash_util__list__extend__list_value}" || {
      echo "failed appending list item '${____bash_util__list__extend__list_value}' to list '${2}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
  done

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# list - get_element_value
# ==============================================================================

# returns item at specified index
bash_util__list__get_element_value() {
  # 1) dynamic var name
  # 2) index
  
  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__get_element_value ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__get_element_value() {
  # 1) dynamic var name
  # 2) index

  bash_util__int__value_is_valid "${2:-}" 'index' ||
    return "${BASH_UTIL__CODE__INVALID}"

  # execute eval string
  if eval "printf '%s' \"\${$1[$2]}\""
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed executing eval string" | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# list - get_max_index
# ==============================================================================

# returns highest index
bash_util__list__get_max_index() {
  # 1) dynamic var name
  
  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__get_max_index ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__get_max_index() {
  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__get_max_index__indices' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__get_max_index__indices_length'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  # get list of indices in array
  local ____bash_util__list__get_max_index__indices=
  ____bash_util__list__get_max_index__indices=( $(_bash_util__list__indices "${1}") ) || {
    echo 'failed getting indices for list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # store length of index array
  local ____bash_util__list__get_max_index__indices_length=
  ____bash_util__list__get_max_index__indices_length="${#____bash_util__list__get_max_index__indices[@]}"

  # if we have any indices
  if [[ "${____bash_util__list__get_max_index__indices_length}" -gt 0 ]]
  then
    # then print last index in the index array (length - 1)
    # which will have a value of the max index of the input array
    if ! printf '%d\n' "${____bash_util__list__get_max_index__indices[____bash_util__list__get_max_index__indices_length - 1]}"
    then
      echo "failed printing max index for list: '${1}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    fi
  fi

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# list - get_min_index
# ==============================================================================

bash_util__list__get_min_index() {
  # 1) dynamic var name
  # 2) index floor (optional)
  
  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__get_min_index ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__get_min_index() {
  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__get_min_index__indices' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__get_min_index__floor' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__get_min_index__index' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__get_min_index__min_index'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  local ____bash_util__list__get_min_index__floor=
  local ____bash_util__list__get_min_index__index=
  local ____bash_util__list__get_min_index__min_index=

  # if floor was specified
  if [[ -n "${2:-}" ]]
  then
    # validate the number
    bash_util__int__value_is_valid "${2:-}" ||
      return "${BASH_UTIL__CODE__INVALID}"
    
    # store it
    ____bash_util__list__get_min_index__floor="${2}"
  fi

  # get list of indices in array
  local ____bash_util__list__get_min_index__indices=
  ____bash_util__list__get_min_index__indices=( $(_bash_util__list__indices "${1}") ) || {
    echo 'failed getting indices for list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # if we have any indices
  if [[ "${#____bash_util__list__get_min_index__indices[@]}" -gt 0 ]]
  then
    # if we don't have a floor
    if [[ -z "${____bash_util__list__get_min_index__floor}" ]]
    then
      # then use first index in the index array
      # which will have a value of the min index of the input array
      ____bash_util__list__get_min_index__min_index="${____bash_util__list__get_min_index__indices[0]}"
    else
      # otherwise, iterate through indices
      for ____bash_util__list__get_min_index__index in "${____bash_util__list__get_min_index__indices[@]}"
      do
        # find a value that is greater than or equal to the floor
        if [[ "${____bash_util__list__get_min_index__index}" -ge "${____bash_util__list__get_min_index__floor}" ]]
        then
          ____bash_util__list__get_min_index__min_index="${____bash_util__list__get_min_index__index}"
          break
        fi
      done
    fi

    # if we found a min index
    if [[ -n "${____bash_util__list__get_min_index__min_index}" ]]
    then
      # print it
      if ! printf '%d\n' "${____bash_util__list__get_min_index__min_index}"
      then
        echo "failed printing min index for list: '${1}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      fi
    fi
  fi

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# list - get_value_count
# ==============================================================================

# returns count of value
bash_util__list__get_value_count() {
  # 1) dynamic var name
  # 2) value to count

  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__get_value_count ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__get_value_count() {
  # ensure a second arg was passed
  if [[ "$#" -lt  2 ]]
  then
    echo 'no value provided' | bash_util__log__error
    return "${BASH_UTIL__CODE__INVALID}"
  fi

  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__get_value_count__list_indices' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__get_value_count__iter' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__get_value_count__list_value' && 
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__get_value_count__list_count'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  # get list indices
  local ____bash_util__list__get_value_count__list_indices=
  ____bash_util__list__get_value_count__list_indices=( $(_bash_util__list__indices "${1}") ) || {
    echo 'failed getting indices for list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
  
  # iterate through each value
  local ____bash_util__list__get_value_count__iter=
  local ____bash_util__list__get_value_count__list_value=
  local ____bash_util__list__get_value_count__list_count=0
  for (( ____bash_util__list__get_value_count__iter=0; ____bash_util__list__get_value_count__iter<"${#____bash_util__list__get_value_count__list_indices[@]}"; ____bash_util__list__get_value_count__iter++ ))
  do
    # get a list item
    ____bash_util__list__get_value_count__list_value="$(_bash_util__list__get_element_value "${1}" "${____bash_util__list__get_value_count__list_indices[$____bash_util__list__get_value_count__iter]}")" || {
      echo "failed getting value from list '${1}' at index '${____bash_util__list__get_value_count__list_indices[$____bash_util__list__get_value_count__iter]}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
    
    # if value matches
    if [[ "${____bash_util__list__get_value_count__list_value}" = "${2}" ]]
    then
      # increment count
      ____bash_util__list__get_value_count__list_count=$((____bash_util__list__get_value_count__list_count + 1))
    fi
  done

  # print count
  if printf '%d\n' "${____bash_util__list__get_value_count__list_count}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo 'failed printing list count' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

# ==============================================================================
# list - get_value_index
# ==============================================================================

# returns index where value is first found
bash_util__list__get_value_index() {
  # 1) dynamic var name
  # 2) value to find

  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__get_value_index ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__get_value_index() {
  # ensure a second arg was passed
  if [[ "$#" -lt  2 ]]
  then
    echo 'no value provided' | bash_util__log__error
    return "${BASH_UTIL__CODE__INVALID}"
  fi

  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1:-}" '____bash_util__list__get_value_index__list_indices' &&
    bash_util__var__names_do_not_conflict "${1:-}" '____bash_util__list__get_value_index__iter' &&
    bash_util__var__names_do_not_conflict "${1:-}" '____bash_util__list__get_value_index__list_value'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  # get list indices
  local ____bash_util__list__get_value_index__list_indices=
  ____bash_util__list__get_value_index__list_indices=( $(_bash_util__list__indices "${1}") ) || {
    echo 'failed getting indices for list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
  
  # iterate through each value
  local ____bash_util__list__get_value_index__iter=
  local ____bash_util__list__get_value_index__list_value=
  for (( ____bash_util__list__get_value_index__iter=0; ____bash_util__list__get_value_index__iter<"${#____bash_util__list__get_value_index__list_indices[@]}"; ____bash_util__list__get_value_index__iter++ ))
  do
    ____bash_util__list__get_value_index__list_value="$(_bash_util__list__get_element_value "${1}" "${____bash_util__list__get_value_index__list_indices[$____bash_util__list__get_value_index__iter]}")" || {
      echo "failed getting value from list '${1}' at index '${____bash_util__list__get_value_index__list_indices[$____bash_util__list__get_value_index__iter]}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
    
    # if found
    if [[ "${____bash_util__list__get_value_index__list_value}" = "${2:-}" ]]
    then
      printf '%d\n' "${____bash_util__list__get_value_index__list_indices[$____bash_util__list__get_value_index__iter]}" || {
        echo 'failed printing list index' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
      return "${BASH_UTIL__CODE__OK}"
    fi
  done
  
  # match not found
  return "${BASH_UTIL__CODE__NOT_FOUND}"
}

# ==============================================================================
# list - get_value_indices
# ==============================================================================

# returns indices where value is found
bash_util__list__get_value_indices() {
  # 1) dynamic var name
  # 2) value to find

  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__get_value_indices ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__get_value_indices() {
  # ensure a second arg was passed
  if [[ "$#" -lt  2 ]]
  then
    echo 'no value provided' | bash_util__log__error
    return "${BASH_UTIL__CODE__INVALID}"
  fi

  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__get_value_indices__list_indices' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__get_value_indices__iter' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__get_value_indices__list_value' && 
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__get_value_indices__list_value_indices'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  # get list indices
  local ____bash_util__list__get_value_indices__list_indices=
  ____bash_util__list__get_value_indices__list_indices=( $(_bash_util__list__indices "${1}") ) || {
    echo 'failed getting indices for list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
  
  # iterate through each value
  local ____bash_util__list__get_value_indices__iter=
  local ____bash_util__list__get_value_indices__list_value=
  local ____bash_util__list__get_value_indices__list_value_indices=()
  for (( ____bash_util__list__get_value_indices__iter=0; ____bash_util__list__get_value_indices__iter<"${#____bash_util__list__get_value_indices__list_indices[@]}"; ____bash_util__list__get_value_indices__iter++ ))
  do
    ____bash_util__list__get_value_indices__list_value="$(_bash_util__list__get_element_value "${1}" "${____bash_util__list__get_value_indices__list_indices[$____bash_util__list__get_value_indices__iter]}")" || {
      echo "failed getting value from list '${1}' at index '${____bash_util__list__get_value_indices__list_indices[$____bash_util__list__get_value_indices__iter]}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
    
    # if found
    if [[ "${____bash_util__list__get_value_indices__list_value}" = "${2:-}" ]]
    then
      # add to list of indices
      ____bash_util__list__get_value_indices__list_value_indices+=("${____bash_util__list__get_value_indices__list_indices[$____bash_util__list__get_value_indices__iter]}")
    fi
  done

  # if index list has values
  if [[ "${#____bash_util__list__get_value_indices__list_value_indices[@]}" -gt 0 ]]
  then
    # print the values
    echo "${____bash_util__list__get_value_indices__list_value_indices[@]}" || {
      echo 'failed printing list indices' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
    return "${BASH_UTIL__CODE__OK}"
  else
    # match not found
    return "${BASH_UTIL__CODE__NOT_FOUND}"
  fi
}

# ==============================================================================
# list - indices
# ==============================================================================

bash_util__list__indices() {
  # 1) dynamic var name
  
  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__indices ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__indices() {
  # 1) dynamic var name
  
  # execute eval string
  if eval "echo \${!${1}[@]}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed executing eval string" | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# list - is_valid
# ==============================================================================

bash_util__list__is_valid() {
  # 1) dynamic var name
  # 2) var description

  {
    bash_util__var__is_valid "${1:-}" 'list name' &&
    bash_util__var__is_set "${1}" &&
    _bash_util__list__is_valid "${1}" &&
    return "${BASH_UTIL__CODE__TRUE}"
  } || {
    echo "invalid ${2:-"list"}: '${1}'" | bash_util__log__error 1
    return "${BASH_UTIL__CODE__FALSE}"
  }
}

# ==============================================================================

_bash_util__list__is_valid() {
  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__is_valid__regex_string' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__is_valid__declare_output'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  local ____bash_util__list__is_valid__regex_string=
  ____bash_util__list__is_valid__regex_string="^declare -ar* ${1}='?\((\[[0-9]+\]=\".*\" ?)*\)'?\$"

  local ____bash_util__list__is_valid__declare_output=
  ____bash_util__list__is_valid__declare_output="$(declare -p "${1}")" || {
    echo 'failed to get list var info' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  if [[ "${____bash_util__list__is_valid__declare_output}" =~ ${____bash_util__list__is_valid__regex_string} ]]
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# list - length
# ==============================================================================

# get length of list
bash_util__list__length() {
  # 1) dynamic var name

  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__length ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__length() {  
  # execute eval string
  if eval "printf '%d\n' \"\${#${1}[@]}\""
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed executing eval string" | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# list - next_available_index
# ==============================================================================

# returns next available index
bash_util__list__next_available_index() {
  # 1) dynamic var name
  
  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__next_available_index ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__next_available_index() {
  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__next_available_index__indices' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__next_available_index__next_index' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__next_available_index__iter'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  # get list indices
  local ____bash_util__list__next_available_index__indices=
  ____bash_util__list__next_available_index__indices=( $(_bash_util__list__indices "${1}") ) || {
    echo 'failed getting indices for list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  local ____bash_util__list__next_available_index__next_index=
  local ____bash_util__list__next_available_index__iter=

  # if there are any indices
  if [[ "${#____bash_util__list__next_available_index__indices[@]}" -gt 0 ]]
  then
    # for each index
    for ((____bash_util__list__next_available_index__iter=0; ____bash_util__list__next_available_index__iter<"${#____bash_util__list__next_available_index__indices[@]}"; ____bash_util__list__next_available_index__iter++))
    do
      # if current index is zero
      # and its value is greater than zero
      if [[ "${____bash_util__list__next_available_index__iter}" -eq 0 &&
            "${____bash_util__list__next_available_index__indices[0]}" -gt 0 ]]
      then
        # next value = zero
        ____bash_util__list__next_available_index__next_index=0
        break
      fi

      # if no next value
      # or next value is less than current value + 1
      if [[ -z "${____bash_util__list__next_available_index__indices[$____bash_util__list__next_available_index__iter + 1]:-}" ||
            "$((____bash_util__list__next_available_index__indices[$____bash_util__list__next_available_index__iter] + 1))" -lt "${____bash_util__list__next_available_index__indices[$____bash_util__list__next_available_index__iter + 1]}" ]]
      then
        # next value = current value + 1
        ____bash_util__list__next_available_index__next_index="$((____bash_util__list__next_available_index__indices[$____bash_util__list__next_available_index__iter] + 1))"
        break
      fi
    done
  else
    # no indices so use index zero
    ____bash_util__list__next_available_index__next_index=0
  fi

  # if we didn't find an array index
  if [[ -z "${____bash_util__list__next_available_index__next_index}" ]]
  then
    # fatal error
    echo 'failed to find next available index in list' | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi

  # print the index
  if printf '%d\n' "${____bash_util__list__next_available_index__next_index}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo 'failed printing next available index in list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

# ==============================================================================
# list - remove_all_value
# ==============================================================================

bash_util__list__remove_all_value() {
  # 1) dynamic var name
  # 2) value

  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__remove_all_value ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__remove_all_value() {
  # ensure a second arg was passed
  if [[ "$#" -lt  2 ]]
  then
    echo 'no value provided' | bash_util__log__error
    return "${BASH_UTIL__CODE__INVALID}"
  fi

  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__remove_all_value__list_value_indices' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__remove_all_value__iter'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  # get value indices
  local ____bash_util__list__remove_all_value__list_value_indices=
  ____bash_util__list__remove_all_value__list_value_indices=( $(_bash_util__list__get_value_indices "${1}" "${2}") ) || {
    case $? in
      "${BASH_UTIL__CODE__NOT_FOUND}")
        echo "list value not found: '${2}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__NOT_FOUND}"
        ;;
      *)
        echo 'failed getting indices for list value' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }

  # for each value index
  local ____bash_util__list__remove_all_value__iter=
  for ((____bash_util__list__remove_all_value__iter=0; ____bash_util__list__remove_all_value__iter<"${#____bash_util__list__remove_all_value__list_value_indices[@]}"; ____bash_util__list__remove_all_value__iter++))
  do
    # remove element at that index
    _bash_util__list__remove_element "${1}" "${____bash_util__list__remove_all_value__list_value_indices[$____bash_util__list__remove_all_value__iter]}" || {
      echo "failed removing value from list '${1}' at index '${____bash_util__list__remove_all_value__list_value_indices[$____bash_util__list__remove_all_value__iter]}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
  done

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# list - remove_element
# ==============================================================================

bash_util__list__remove_element() {
  # 1) dynamic var name
  # 2) index

  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  _bash_util__list__remove_element ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__remove_element() {
  bash_util__int__value_is_valid "${2:-}" 'index' ||
    return "${BASH_UTIL__CODE__INVALID}"

  if unset "${1}[${2}]"
  then
    # success
    return "${BASH_UTIL__CODE__OK}"
  else
    # failed to unset
    echo "failed to remove list '${1}' element: '${2}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# list - remove_value
# ==============================================================================

bash_util__list__remove_value() {
  # 1) dynamic var name
  # 2) value

  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__remove_value ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__remove_value() {
  # ensure a second arg was passed
  if [[ "$#" -lt  2 ]]
  then
    echo 'no value provided' | bash_util__log__error
    return "${BASH_UTIL__CODE__INVALID}"
  fi

  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__remove_value__list_value_index'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  # get value index
  local ____bash_util__list__remove_value__list_value_index=
  ____bash_util__list__remove_value__list_value_index=( $(_bash_util__list__get_value_indices "${1}" "${2}") ) || {
    case $? in
      "${BASH_UTIL__CODE__NOT_FOUND}")
        echo "list value not found: '${2}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__NOT_FOUND}"
        ;;
      *)
        echo 'failed getting index for list value' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }

  # remove element at that index
  _bash_util__list__remove_element "${1}" "${____bash_util__list__remove_value__list_value_index}" || {
    echo "failed removing value from list '${1}' at index '${____bash_util__list__remove_value__list_value_index}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# list - set_element_value
# ==============================================================================

bash_util__list__set_element_value() {
  # 1) dynamic var name
  # 2) index
  # 3) value

  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__set_element_value ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__set_element_value() {
  # 1) dynamic var name
  # 2) index
  # 3) value

  bash_util__int__value_is_valid "${2:-}" 'index' ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  # execute eval string
  eval "${1}[$2]=\"\${3:-}\"" || {
    echo "failed executing eval string" | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }
}

# ==============================================================================
# list - to_string
# ==============================================================================

bash_util__list__to_string() {
  # 1) list name
  # 2) string name
  # 3) start prefix (default: )
  # 4) end suffix (default: )
  # 5) item prefix (default: )
  # 6) item suffix (default: )
  # 7) separator (default: ' ')

  bash_util__list__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__list__to_string ${@+"${@}"}
}

# ==============================================================================

_bash_util__list__to_string() {
  # initialize output string with start prefix
  bash_util__string__assign "${2:-}" "${3:-}" || {
    echo 'failed initializing string with prefix' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # local var guards
  {
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__to_string__indices' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__to_string__iter' &&
    bash_util__var__names_do_not_conflict "${1}" '____bash_util__list__to_string__list_value' &&

    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__to_string__indices' &&
    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__to_string__iter' &&
    bash_util__var__names_do_not_conflict "${2}" '____bash_util__list__to_string__list_value'
  } || {
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  }

  # get list indices
  local ____bash_util__list__to_string__indices=
  ____bash_util__list__to_string__indices=( $(_bash_util__list__indices "${1}") ) || {
    echo "failed getting indices for list: '${1}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # for each value
  local ____bash_util__list__to_string__iter=
  local ____bash_util__list__to_string__list_value=
  for (( ____bash_util__list__to_string__iter=0; ____bash_util__list__to_string__iter<"${#____bash_util__list__to_string__indices[@]}"; ____bash_util__list__to_string__iter++ )); do
    # append the item prefix
    bash_util__string__append "${2}" "${5:-}" || {
      echo 'failed appending string item prefix' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # get the current item value
    ____bash_util__list__to_string__list_value="$(_bash_util__list__get_element_value "${1}" "${____bash_util__list__to_string__indices[$____bash_util__list__to_string__iter]}")" || {
      echo "failed getting list '${1}' item at index '${____bash_util__list__to_string__indices[$____bash_util__list__to_string__iter]}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # append the item value
    bash_util__string__append "${2}" "${____bash_util__list__to_string__list_value}" || {
      echo 'failed appending string item value' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # append the item suffix
    bash_util__string__append "${2}" "${6:-}" || {
      echo 'failed appending string item suffix' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # append separator if this isn't the final item
    if (( ____bash_util__list__to_string__iter+1 < ${#____bash_util__list__to_string__indices[@]} ))
    then
      bash_util__string__append "${2}" "${7:-" "}" || {
        echo 'failed appending string separator' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    fi
  done

  # append output string with end suffix
  bash_util__string__append "${2}" "${4:-}" || {
    echo 'failed appending string end suffix' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# dict - add_key
# ==============================================================================

bash_util__dict__add_key() {
  # 1) dynamic var name
  # 2) key name
  # 3) key type

  bash_util__dict__key_does_not_exist "${1:-}" "${2:-}" || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        return "${BASH_UTIL__CODE__RESOURCE_EXISTS}"
        ;;
      *)
        return $?
        ;;
    esac
  }

  _bash_util__dict__add_key ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__add_key() {
  # key doesn't exist, set type, add key
  {
    _bash_util__dict__set_key_type "${1}" "${2}" "${3}" &&
    _bash_util__list__append "${1}__KEYS" "${2}" &&
    return "${BASH_UTIL__CODE__OK}"
  } || {
    echo "failed adding key '${2}' to dict: '${1}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# dict - clone_all_keys
# ==============================================================================

bash_util__dict__clone_all_keys() {
  # 1) src dict name
  # 2) dest dict name
  
  {
    bash_util__dict__is_valid "${1:-}" &&
    bash_util__dict__is_valid "${2:-}"
  } || {
    return "${BASH_UTIL__CODE__INVALID}"
  }

  _bash_util__dict__clone_all_keys ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__clone_all_keys() {
  # get list indices
  local ____bash_util__dict__clone_all_keys__indices=
  ____bash_util__dict__clone_all_keys__indices=( $(_bash_util__list__indices "${1}__KEYS") ) || {
    echo 'failed getting indices for list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # iterate through each key
  local ____bash_util__dict__clone_all_keys__iter=
  local ____bash_util__dict__clone_all_keys__value=
  for (( ____bash_util__dict__clone_all_keys__iter=0; ____bash_util__dict__clone_all_keys__iter<"${#____bash_util__dict__clone_all_keys__indices[@]}"; ____bash_util__dict__clone_all_keys__iter++ ))
  do
    ____bash_util__dict__clone_all_keys__value="$(_bash_util__list__get_element_value "${1}__KEYS" "${____bash_util__dict__clone_all_keys__indices[$____bash_util__dict__clone_all_keys__iter]}")" || {
      echo "failed getting value from list '${1}__KEYS' at index '${____bash_util__dict__clone_all_keys__indices[$____bash_util__dict__clone_all_keys__iter]}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # clone the key
    _bash_util__dict__clone_key "${1}" "${____bash_util__dict__clone_all_keys__value}" "${2}" || {
      echo "failed to clone key '${____bash_util__dict__clone_all_keys__value}' from dict '${1}' to dict '${2}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
  done

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# dict - clone_key
# ==============================================================================

bash_util__dict__clone_key() {
  # 1) src dict name
  # 2) src dict key
  # 3) dest dict name
  # 4) dest dict key (optional)

  # ensure source key exists
  bash_util__dict__key_exists "${1:-}" "${2:-}" || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        return "${BASH_UTIL__CODE__NOT_FOUND}"
        ;;
      *)
        return $?
        ;;
    esac
  }

  _bash_util__dict__clone_key ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__clone_key() {
  # use same key name as source key if not specified
  local ____bash_util__dict__clone_key__dest_key="${4:-"${2}"}"

  local ____bash_util__dict__clone_key__type=
  ____bash_util__dict__clone_key__type="$(_bash_util__dict__get_key_type "${1}" "${2}")" || {
    echo 'failed getting key type' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # add key to dest dict
  bash_util__dict__add_key "${3}" "${____bash_util__dict__clone_key__dest_key}" "${____bash_util__dict__clone_key__type}" || {
    echo "failed adding dict '${3}' key '${____bash_util__dict__clone_key__dest_key}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  {
    # check if value is set
    bash_util__type__value_is_set "${1}__KEY__${2}__VALUE" "${____bash_util__dict__clone_key__type}"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        # value unset, no need to clone
        return "${BASH_UTIL__CODE__OK}"
        ;;
      *)
        echo "failed checking if value was set for dict '${1}' key '${2}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }

  # value is set, clone value
  bash_util__type__clone_value "${1}__KEY__${2}__VALUE" "${____bash_util__dict__clone_key__type}" "${3}__KEY__${____bash_util__dict__clone_key__dest_key}__VALUE" || {
    echo "failed cloning dict '${1}' key '${2}' to dict '${3}' key '${____bash_util__dict__clone_key__dest_key}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# dict - count
# ==============================================================================

bash_util__dict__count() {
  # 1) dynamic var name

  bash_util__dict__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  _bash_util__dict__count ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__count() {
  _bash_util__list__length "${1}__KEYS"
}

# ==============================================================================
# dict - clone
# ==============================================================================

bash_util__dict__clone() {
  # 1) src dict name
  # 2) dest dict name

  bash_util__dict__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  _bash_util__dict__clone ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__clone() {
  {
    # create destination dict
    bash_util__dict__create "${2:-}" &&
    # clone all keys
    _bash_util__dict__clone_all_keys "${1}" "${2}"
  } || {
    echo "failed cloning dict '${1}' to dict '${2}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# dict - create
# ==============================================================================

bash_util__dict__create() {
  bash_util__string__is_not_null "${1:-}" 'dict name' ||
    return "${BASH_UTIL__CODE__NULL}"
  
  bash_util__list__create "${1}__KEYS" &&
    return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# dict - destroy
# ==============================================================================

bash_util__dict__destroy() {
  # 1) dynamic var name

  bash_util__dict__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  _bash_util__dict__destroy ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__destroy() {
  {
    _bash_util__dict__remove_all_keys "${1}" &&
    bash_util__list__destroy "${1}__KEYS" &&
    return "${BASH_UTIL__CODE__OK}"
  } || {
    echo "failed to destroy dict: '${1}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# dict - exists
# ==============================================================================

# status code indicating if var exists
bash_util__dict__exists() {
  # 1) dynamic var name

  bash_util__var__is_valid "${1:-}" 'dict name' ||
    return "${BASH_UTIL__CODE__INVALID}"

  if _bash_util__list__exists "${1}__KEYS"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# dict - get_key_type
# ==============================================================================

bash_util__dict__get_key_type() {
  # 1) dynamic var name
  # 2) key name

  bash_util__dict__key_exists "${1:-}" "${2:-}" || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        return "${BASH_UTIL__CODE__NOT_FOUND}"
        ;;
      *)
        return $?
        ;;
    esac
  }

  _bash_util__dict__get_key_type ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__get_key_type() {
  if bash_util__type__get_type "${1}__KEY__${2}__TYPE"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo 'failed to get key type' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

# ==============================================================================
# dict - get_key_value
# ==============================================================================

bash_util__dict__get_key_value() {
  # 1) dynamic var name
  # 2) key name

  bash_util__dict__key_exists "${1:-}" "${2:-}" || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        return "${BASH_UTIL__CODE__NOT_FOUND}"
        ;;
      *)
        return $?
        ;;
    esac
  }

  _bash_util__dict__get_key_value ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__get_key_value() {
  local ____bash_util__dict__get_key_value__type=
  ____bash_util__dict__get_key_value__type="$(_bash_util__dict__get_key_type "${1}" "${2}")" || {
    echo 'failed getting key type' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  if bash_util__type__get_value "${1}__KEY__${2}__VALUE" "${____bash_util__dict__get_key_value__type}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo 'failed to get key value' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

# ==============================================================================
# dict - get_keys_indices
# ==============================================================================

bash_util__dict__get_keys_indices() {
  bash_util__dict__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  _bash_util__dict__get_keys_indices ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__get_keys_indices() {
  _bash_util__list__indices "${1}__KEYS"
}

# ==============================================================================
# dict - get_keys_list
# ==============================================================================

bash_util__dict__get_keys_list() {
  bash_util__dict__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  _bash_util__dict__get_keys_list ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__get_keys_list() {
  bash_util__var__print_name "${1}__KEYS"
}

# ==============================================================================
# dict - has_key
# ==============================================================================

bash_util__dict__has_key() {
  # 1) dynamic var name
  # 2) key name

  {
    bash_util__dict__is_valid "${1:-}" &&
    bash_util__var__is_valid "${2:-}" 'key name'
  } || {
    return "${BASH_UTIL__CODE__INVALID}"
  }

  _bash_util__dict__has_key ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__has_key() {
  {
    _bash_util__list__contains "${1}__KEYS" "${2}" &&
    return "${BASH_UTIL__CODE__TRUE}"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        return "${BASH_UTIL__CODE__FALSE}"
        ;;
      *)
        echo 'failed checking for key' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }
}

# ==============================================================================
# dict - is_valid
# ==============================================================================

bash_util__dict__is_valid() {
  # 1) dynamic var name

  {
    bash_util__var__is_valid "${1:-}" 'dict name' &&
    bash_util__list__is_valid "${1}__KEYS" 'dict keys list' &&
    return "${BASH_UTIL__CODE__TRUE}"
  } || {
    echo "invalid ${2:-"dict"}: '${1:-}'" | bash_util__log__error 1
    return "${BASH_UTIL__CODE__FALSE}"
  }
}

# ==============================================================================
# dict - key_does_not_exist
# ==============================================================================

bash_util__dict__key_does_not_exist() {
  # 1) dynamic var name
  # 2) key name
  
  {
    bash_util__dict__is_valid "${1:-}" &&
    bash_util__var__is_valid "${2:-}" 'key name'
  } || {
    return "${BASH_UTIL__CODE__INVALID}"
  }

  {
    _bash_util__list__contains "${1}__KEYS" "${2}" &&
    echo "key exists: '${2}'" | bash_util__log__error 1 &&
    return "${BASH_UTIL__CODE__FALSE}"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        return "${BASH_UTIL__CODE__TRUE}"
        ;;
      *)
        echo 'failed checking for key' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }
}

# ==============================================================================
# dict - key_exists
# ==============================================================================

bash_util__dict__key_exists() {
  # 1) dynamic var name
  # 2) key name

  {
    bash_util__dict__is_valid "${1:-}" &&
    bash_util__var__is_valid "${2:-}" 'key name'
  } || {
    return "${BASH_UTIL__CODE__INVALID}"
  }

  {
    _bash_util__list__contains "${1}__KEYS" "${2}" &&
    return "${BASH_UTIL__CODE__TRUE}"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        echo "key not found: '${2}'" | bash_util__log__error 1
        return "${BASH_UTIL__CODE__FALSE}"
        ;;
      *)
        echo 'failed checking for key' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }
}

# ==============================================================================
# dict - key_is_type
# ==============================================================================

bash_util__dict__key_is_type() {
  # 1) dict name
  # 2) key name
  # 3) key type

  {
    # check input key
    bash_util__dict__key_exists "${1:-}" "${2:-}" &&
    # check input type
    bash_util__type__is_valid "${3:-}" 'key type'
  } || {
    return "${BASH_UTIL__CODE__INVALID}"
  }

  _bash_util__dict__key_is_type ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__key_is_type() {
  # get type for key
  local ____bash_util__dict__key_is_type__key_type=
  ____bash_util__dict__key_is_type__key_type="$(_bash_util__dict__get_key_type "${1}" "${2}")" || {
    echo 'failed getting key type' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # compare types
  if bash_util__string__equals "${____bash_util__dict__key_is_type__key_type}" "${3}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    echo "key '${2}' type '${____bash_util__dict__key_is_type__key_type}' does not match key type: '${3}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# dict - key_value_is_set
# ==============================================================================

bash_util__dict__key_value_is_set() {
  # 1) dict name
  # 2) key name

  # check input key
  bash_util__dict__key_exists "${1:-}" "${2:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  _bash_util__dict__key_value_is_set ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__key_value_is_set() {
  # get type for key
  local ____bash_util__dict__key_is_type__key_type=
  ____bash_util__dict__key_is_type__key_type="$(_bash_util__dict__get_key_type "${1}" "${2}")" || {
    echo 'failed getting key type' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  {
    bash_util__type__value_is_set "${1}__KEY__${2}__VALUE" "${____bash_util__dict__key_is_type__key_type}" &&
    return "${BASH_UTIL__CODE__TRUE}"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        return "${BASH_UTIL__CODE__FALSE}"
        ;;
      *)
        echo "failed checking key value for key: '${2}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }
}

# ==============================================================================
# dict - keys
# ==============================================================================

bash_util__dict__keys() {
  bash_util__dict__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  _bash_util__dict__keys ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__keys() {
  # 1) dynamic var name
  
  # execute eval string
  if eval "echo \${${1}__KEYS[*]}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo "failed executing eval string" | bash_util__log__error
    return "${BASH_UTIL__CODE__FATAL_ERROR}"
  fi
}

# ==============================================================================
# dict - remove_all_keys
# ==============================================================================

bash_util__dict__remove_all_keys() {
  # 1) dynamic var name

  bash_util__dict__is_valid "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"
  
  _bash_util__dict__remove_all_keys ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__remove_all_keys() {
  # get list indices
  local ____bash_util__dict__remove_all_keys__indices=
  ____bash_util__dict__remove_all_keys__indices=( $(_bash_util__list__indices "${1}__KEYS") ) || {
    echo 'failed getting indices for list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # iterate through each value
  local ____bash_util__dict__remove_all_keys__iter=
  local ____bash_util__dict__remove_all_keys__list_value=
  for (( ____bash_util__dict__remove_all_keys__iter=0; ____bash_util__dict__remove_all_keys__iter<"${#____bash_util__dict__remove_all_keys__indices[@]}"; ____bash_util__dict__remove_all_keys__iter++ ))
  do
    ____bash_util__dict__remove_all_keys__list_value="$(_bash_util__list__get_element_value "${1}__KEYS" "${____bash_util__dict__remove_all_keys__indices[$____bash_util__dict__remove_all_keys__iter]}")" || {
      echo "failed getting value from list '${1}__KEYS' at index '${____bash_util__dict__remove_all_keys__indices[$____bash_util__dict__remove_all_keys__iter]}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # remove the key
    _bash_util__dict__remove_key "${1}" "${____bash_util__dict__remove_all_keys__list_value}" || {
      echo "failed to remove key '${____bash_util__dict__remove_all_keys__list_value}' from dict '${1}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
  done

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# dict - remove_key
# ==============================================================================

bash_util__dict__remove_key() {
  # 1) dynamic var name
  # 2) key name

  bash_util__dict__key_exists "${1:-}" "${2:-}" || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        return "${BASH_UTIL__CODE__NOT_FOUND}"
        ;;
      *)
        return $?
        ;;
    esac
  }

  _bash_util__dict__remove_key ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__remove_key() {
  # check if key has type
  # remove value based on type
  # remove type
  # remove key from keys list

  # get key value type
  local ____bash_util__dict__remove_key__value_type=
  ____bash_util__dict__remove_key__value_type="$(_bash_util__dict__get_key_type "${1}" "${2}")" || {
    echo 'failed to get key type' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # destroy key value
  bash_util__type__destroy_value "${1}__KEY__${2}__VALUE" "${____bash_util__dict__remove_key__value_type}" || {
    echo 'failed to destroy key value' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # destroy key type
  bash_util__type__destroy_type "${1}__KEY__${2}__TYPE" || {
    echo 'failed to destroy key type' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # remove key from list
  bash_util__list__remove_value "${1}__KEYS" "${2}" || {
    echo 'failed to remove key' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================
# dict - set_key_type
# ==============================================================================

bash_util__dict__set_key_type() {
  # 1) dynamic var name
  # 2) key name
  # 3) key type

  bash_util__dict__key_exists "${1:-}" "${2:-}" || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        return "${BASH_UTIL__CODE__NOT_FOUND}"
        ;;
      *)
        return $?
        ;;
    esac
  }

  _bash_util__dict__set_key_type ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__set_key_type() {
  if bash_util__type__set_type "${1}__KEY__${2}__TYPE" "${3}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo 'failed to set key type' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

# ==============================================================================
# dict - set_key_value
# ==============================================================================

bash_util__dict__set_key_value() {
  # 1) dynamic var name
  # 2) key name
  # 3-N) value(s)

  bash_util__dict__key_exists "${1:-}" "${2:-}" || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        return "${BASH_UTIL__CODE__NOT_FOUND}"
        ;;
      *)
        return $?
        ;;
    esac
  }

  _bash_util__dict__set_key_value ${@+"${@}"}
}

# ==============================================================================

_bash_util__dict__set_key_value() {
  local ____bash_util__dict__set_key_value__type=
  ____bash_util__dict__set_key_value__type="$(_bash_util__dict__get_key_type "${1}" "${2}")" || {
    echo 'failed getting key type' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  if bash_util__type__set_value "${1}__KEY__${2}__VALUE" "${____bash_util__dict__set_key_value__type}" "${@:3}"
  then
    return "${BASH_UTIL__CODE__OK}"
  else
    echo 'failed to set key value' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

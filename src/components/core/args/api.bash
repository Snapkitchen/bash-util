#
# option api
#

# ==============================================================================
# args - add_option
# ==============================================================================

bash_util__args__add_option() {
  # 1) parser namespace
  # 2) option name

  {
    # ensure parser exists
    bash_util__args__parser_exists "${1:-}" &&

    # get options dict
    local options_dict= &&
    options_dict="$(_bash_util__args__get_options_dict "${1}")" &&

    # add new option key to options dict
    bash_util__dict__add_key "${options_dict}" "${2:-}" "${BASH_UTIL__TYPE__DICT}" &&

    # get new option dict
    local option_dict= &&
    option_dict="$(_bash_util__args__get_option_dict "${1}" "${2}")" &&

    # initialize the new key value
    bash_util__dict__create "${option_dict}" &&

    # add action key
    _bash_util__dict__add_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__ACTION}" "${BASH_UTIL__TYPE__STRING}" &&

    # add choices key
    _bash_util__dict__add_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__CHOICES}" "${BASH_UTIL__TYPE__LIST}" &&

    # add long name key
    _bash_util__dict__add_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__LONG_NAME}" "${BASH_UTIL__TYPE__STRING}" &&

    # add nargs key
    _bash_util__dict__add_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__NARGS}" "${BASH_UTIL__TYPE__STRING}" &&

    # add required key
    _bash_util__dict__add_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__REQUIRED}" "${BASH_UTIL__TYPE__BOOL}" &&

    # default required to false
    _bash_util__dict__set_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__REQUIRED}" "${BASH_UTIL__BOOL__FALSE}" &&

    # add short name key
    _bash_util__dict__add_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__SHORT_NAME}" "${BASH_UTIL__TYPE__STRING}" &&

    # add type key
    _bash_util__dict__add_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__TYPE}" "${BASH_UTIL__TYPE__STRING}" &&

    # success
    return "${BASH_UTIL__CODE__OK}"
  } || {
    echo "failed adding option: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - get_option_value_type
# ==============================================================================

bash_util__args__get_option_value_type() {
  # 1) parser namespace
  # 2) option name

  {
    # ensure option exists
    bash_util__args__option_exists "${1:-}" "${2:-}" &&

    # get option dict
    local option_dict= &&
    option_dict="$(_bash_util__args__get_option_dict "${1}" "${2}")"
  } || {
    echo "failed getting value type for option: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # check for value key
  _bash_util__dict__has_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__VALUE}" ||
    return "${BASH_UTIL__CODE__NOT_FOUND}"

  # get key type
  _bash_util__dict__get_key_type "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__VALUE}" ||
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
}

# ==============================================================================
# args - get_option_value
# ==============================================================================

bash_util__args__get_option_value() {
  # 1) parser namespace
  # 2) option name

  {
    # ensure option exists
    bash_util__args__option_exists "${1:-}" "${2:-}" &&

    # get option dict
    local option_dict= &&
    option_dict="$(_bash_util__args__get_option_dict "${1}" "${2}")"
  } || {
    echo "failed getting value for option: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # check for value key
  _bash_util__dict__has_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__VALUE}" ||
    return "${BASH_UTIL__CODE__NOT_FOUND}"

  # check if value key is set
  _bash_util__dict__key_value_is_set "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__VALUE}" ||
    return "${BASH_UTIL__CODE__UNSET}"

  # get positional value key value
  _bash_util__dict__get_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__VALUE}"
}

# ==============================================================================
# args - option_exists
# ==============================================================================

bash_util__args__option_exists() {
  # 1) parser namespace
  # 2) option name

  {
    # ensure parser exists
    bash_util__args__parser_exists "${1:-}" &&

    # get options dict
    local options_dict= &&
    options_dict="$(_bash_util__args__get_options_dict "${1}")" &&

    # check if key exists
    bash_util__dict__key_exists "${options_dict}" "${2:-}"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        echo "option does not exist: '${2:-}'" | bash_util__log__error 1
        return "${BASH_UTIL__CODE__FALSE}"
        ;;
      *)
        echo "failed checking for option: '${2:-}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    esac
  }
}

# ==============================================================================
# args - set_option_action
# ==============================================================================

bash_util__args__set_option_action() {
  # 1) parser namespace
  # 2) option name
  # 3) action

  {
    # ensure option exists
    bash_util__args__option_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__option_action_is_unset "${1}" "${2}" &&

    # ensure action is valid
    _bash_util__args__action_is_valid "${3:-}" &&

    # get option dict
    local option_dict= &&
    option_dict="$(_bash_util__args__get_option_dict "${1}" "${2}")" &&

    # set option action to value
    _bash_util__dict__set_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__ACTION}" "${3}"
  } || {
    echo "failed setting action for option: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # set nargs to 0 for store_const, append_const, count, store_false, or store_true
  case "${3}" in
    "${BASH_UTIL__ARGS__ACTION__STORE_CONST}"|"${BASH_UTIL__ARGS__ACTION__APPEND_CONST}"|"${BASH_UTIL__ARGS__ACTION__COUNT}"|"${BASH_UTIL__ARGS__ACTION__STORE_FALSE}"|"${BASH_UTIL__ARGS__ACTION__STORE_TRUE}")
      {
        _bash_util__dict__set_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__NARGS}" 0
      } || {
        echo "failed setting nargs to 0 for option: '${2:-}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
      ;;
  esac

  # set default to appropriate bool value for store_true or store_false
  case "${3}" in
    "${BASH_UTIL__ARGS__ACTION__STORE_FALSE}")
      {
        # add default key as bool
        _bash_util__dict__add_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__DEFAULT}" "${BASH_UTIL__TYPE__BOOL}" &&

        # set default key value
        _bash_util__dict__set_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__DEFAULT}" "${BASH_UTIL__BOOL__TRUE}"
      } || {
        echo "failed setting default to 'true' for option: '${2:-}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
      ;;
    "${BASH_UTIL__ARGS__ACTION__STORE_TRUE}")
      {
        # add default key as bool
        _bash_util__dict__add_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__DEFAULT}" "${BASH_UTIL__TYPE__BOOL}" &&

        # set default key value
        _bash_util__dict__set_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__DEFAULT}" "${BASH_UTIL__BOOL__FALSE}"
      } || {
        echo "failed setting default to 'false' for option: '${2:-}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
      ;;
  esac
}

# ==============================================================================
# args - set_option_choices
# ==============================================================================

bash_util__args__set_option_choices() {
  # 1) parser namespace
  # 2) option name
  # 3) choices value

  {
    # ensure option exists
    bash_util__args__option_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__option_action_is_unset "${1}" "${2}" &&

    # get option dict
    local option_dict= &&
    option_dict="$(_bash_util__args__get_option_dict "${1}" "${2}")" &&

    # set option choices to value
    _bash_util__dict__set_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__CHOICES}" "${3:-}"
  } || {
    echo "failed setting choices for option: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - set_option_const
# ==============================================================================

bash_util__args__set_option_const() {
  # 1) parser namespace
  # 2) option name
  # 3) const type
  # 4n) const value

  {
    # ensure option exists
    bash_util__args__option_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__option_action_is_unset "${1}" "${2}" &&

    # ensure type is supported
    _bash_util__args__type_is_supported "${3:-}" &&

    # get option dict
    local option_dict= &&
    option_dict="$(_bash_util__args__get_option_dict "${1}" "${2}")" &&

    # add const key
    bash_util__dict__add_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__CONST}" "${3}" &&

    # set option const to value
    _bash_util__dict__set_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__CONST}" "${@:4}"
  } || {
    echo "failed setting const for option: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - set_option_default
# ==============================================================================

bash_util__args__set_option_default() {
  # 1) parser namespace
  # 2) option name
  # 3) default type
  # 4n) default value

  {
    # ensure option exists
    bash_util__args__option_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__option_action_is_unset "${1}" "${2}" &&

    # ensure type is supported
    _bash_util__args__type_is_supported "${3:-}" &&

    # get option dict
    local option_dict= &&
    option_dict="$(_bash_util__args__get_option_dict "${1}" "${2}")" &&

    # add const key
    bash_util__dict__add_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__DEFAULT}" "${3}" &&

    # set option default to value
    _bash_util__dict__set_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__DEFAULT}" "${@:4}"
  } || {
    echo "failed setting default for option: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - set_option_long_name
# ==============================================================================

bash_util__args__set_option_long_name() {
  # 1) parser namespace
  # 2) option name
  # 3) option long name

  {
    # ensure option exists
    bash_util__args__option_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__option_action_is_unset "${1}" "${2}" &&

    # validate long name
    _bash_util__args__option_long_name_is_valid "${3:-}" &&

    # ensure long name is unique
    _bash_util__args__option_name_is_unique "${_BASH_UTIL__ARGS__OPTION__LONG_NAME}" "${1}" "${3}" &&

    # get option dict
    local option_dict= &&
    option_dict="$(_bash_util__args__get_option_dict "${1}" "${2}")" &&

    # set option long name to value
    _bash_util__dict__set_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__LONG_NAME}" "${3}"
  } || {
    echo "failed setting long name for option: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - set_option_nargs
# ==============================================================================

bash_util__args__set_option_nargs() {
  # 1) parser namespace
  # 2) option name
  # 3) nargs value

  {
    # ensure option exists
    bash_util__args__option_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__option_action_is_unset "${1}" "${2}" &&

    # validate nargs
    _bash_util__args__nargs_is_valid "${3:-}" &&

    # get option dict
    local option_dict= &&
    option_dict="$(_bash_util__args__get_option_dict "${1}" "${2}")" &&

    # set option nargs to value
    _bash_util__dict__set_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__NARGS}" "${3}"
  } || {
    echo "failed setting nargs for option: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - set_option_required
# ==============================================================================

bash_util__args__set_option_required() {
  # 1) parser namespace
  # 2) option name

  {
    # ensure option exists
    bash_util__args__option_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__option_action_is_unset "${1}" "${2}" &&

    # get option dict
    local option_dict= &&
    option_dict="$(_bash_util__args__get_option_dict "${1}" "${2}")" &&

    # set option required to true
    _bash_util__dict__set_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__REQUIRED}" "${BASH_UTIL__BOOL__TRUE}"
  } || {
    echo "failed setting required for option: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - set_option_short_name
# ==============================================================================

bash_util__args__set_option_short_name() {
  # 1) parser namespace
  # 2) option name
  # 3) option short name

  {
    # ensure option exists
    bash_util__args__option_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__option_action_is_unset "${1}" "${2}" &&

    # validate short name
    _bash_util__args__option_short_name_is_valid "${3:-}" &&

    # ensure short name is unique
    _bash_util__args__option_name_is_unique "${_BASH_UTIL__ARGS__OPTION__SHORT_NAME}" "${1}" "${3}" &&

    # get option dict
    local option_dict= &&
    option_dict="$(_bash_util__args__get_option_dict "${1}" "${2}")" &&

    # set option short name to value
    _bash_util__dict__set_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__SHORT_NAME}" "${3}"
  } || {
    echo "failed setting short name for option: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - set_option_type
# ==============================================================================

bash_util__args__set_option_type() {
  # 1) parser namespace
  # 2) option name
  # 3) type

  {
    # ensure option exists
    bash_util__args__option_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__option_action_is_unset "${1}" "${2}" &&

    # ensure type is supported
    _bash_util__args__type_is_supported "${3:-}" &&

    # get option dict
    local option_dict= &&
    option_dict="$(_bash_util__args__get_option_dict "${1}" "${2}")" &&

    # set option type to value
    _bash_util__dict__set_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__TYPE}" "${3}"
  } || {
    echo "failed setting type for option: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

#
# parser api
#

# ==============================================================================
# args - create_parser
# ==============================================================================

bash_util__args__create_parser() {
  # 1) parser namespace

  {
    # ensure parser doesn't already exist
    bash_util__args__parser_does_not_exist "${1:-}" &&

    # create parent dict
    bash_util__dict__create "${1}__ARGS__PARSER" &&
    
    # add positional key
    _bash_util__dict__add_key "${1}__ARGS__PARSER" 'POSITIONAL' "${BASH_UTIL__TYPE__DICT}" &&
    
    # get positional key dict
    local positional_dict= &&
    positional_dict="$(_bash_util__args__get_positional_dict "${1}")" &&
    
    # create positional key dict
    bash_util__dict__create "${positional_dict}" &&
    
    # add options key
    _bash_util__dict__add_key "${1}__ARGS__PARSER" 'OPTIONS' "${BASH_UTIL__TYPE__DICT}" &&
    
    # get options key dict
    local options_dict= &&
    options_dict="$(_bash_util__args__get_options_dict "${1}")" &&
    
    # create options key dict
    bash_util__dict__create "${options_dict}" &&

    # add extras key
    _bash_util__dict__add_key "${1}__ARGS__PARSER" 'EXTRAS' "${BASH_UTIL__TYPE__LIST}" &&
    
    # get extras key list
    local extras_list= &&
    extras_list="$(_bash_util__args__get_extras_list "${1}")" &&
    
    # create extras key list
    bash_util__list__create "${extras_list}" &&

    # success
    return "${BASH_UTIL__CODE__OK}"
  } || {
    # failed a step
    echo "failed creating parser: '${1:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - get_extras_value
# ==============================================================================

bash_util__args__get_extras_value() {
  # 1) parser namespace

  {
    # ensure parser exists
    bash_util__args__parser_exists "${1:-}" &&

    # get extras list
    _bash_util__args__get_extras_list "${1}"
  } || {
    echo "failed getting extras value for parser: '${1:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - parse_args
# ==============================================================================

bash_util__args__parse_args() {
  # check if parser exists
  bash_util__args__parser_exists "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  # parse the args
  _bash_util__args__parse_known_args ${@+"${@}"} ||
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"

  # get extras list
  local extras_list_name=
  extras_list_name="$(_bash_util__args__get_extras_list "${1}")" || {
    echo 'failed getting extras list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # get extras list length
  local extras_list_length=
  extras_list_length="$(_bash_util__list__length "${extras_list_name}")" || {
    echo 'failed getting extras list length' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  if [[ "${extras_list_length}" -gt 0 ]]
  then
    local extras_list_items=
    # 1) list name
    # 2) string name
    # 3) start prefix (default: )
    # 4) end suffix (default: )
    # 5) item prefix (default: )
    # 6) item suffix (default: )
    # 7) separator (default: ' ')
    _bash_util__list__to_string \
      "${extras_list_name}" 'extras_list_items' \
      '' '' \
      "'" "'" \
      ' ' || {
        echo 'failed converting extras list to string' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    echo "unrecognized arguments: ${extras_list_items}" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

# ==============================================================================
# args - parse_known_args
# ==============================================================================

bash_util__args__parse_known_args() {
  # check if parser exists
  bash_util__args__parser_exists "${1:-}" ||
    return "${BASH_UTIL__CODE__INVALID}"

  # parse the args
  _bash_util__args__parse_known_args ${@+"${@}"}
}

#
# positional api
#

# ==============================================================================
# args - add_positional
# ==============================================================================

bash_util__args__add_positional() {
  # 1) parser namespace
  # 2) positional name

  {
    # ensure parser exists
    bash_util__args__parser_exists "${1:-}" &&

    # get positional dict
    local positional_dict= &&
    positional_dict="$(_bash_util__args__get_positional_dict "${1}")" &&

    # add new positional key to positional dict
    bash_util__dict__add_key "${positional_dict}" "${2:-}" "${BASH_UTIL__TYPE__DICT}" &&

    # get new positional dict
    local positional_arg_dict= &&
    positional_arg_dict="$(_bash_util__args__get_positional_arg_dict "${1}" "${2}")" &&

    # initialize the new key value
    bash_util__dict__create "${positional_arg_dict}" &&

    # add action key
    _bash_util__dict__add_key "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__ACTION}" "${BASH_UTIL__TYPE__STRING}" &&

    # add choices key
    _bash_util__dict__add_key "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__CHOICES}" "${BASH_UTIL__TYPE__LIST}" &&

    # add nargs key
    _bash_util__dict__add_key "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__NARGS}" "${BASH_UTIL__TYPE__STRING}" &&

    # add type key
    _bash_util__dict__add_key "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__TYPE}" "${BASH_UTIL__TYPE__STRING}" &&

    # success
    return "${BASH_UTIL__CODE__OK}"
  } || {
    echo "failed adding positional: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - get_positional_value_type
# ==============================================================================

bash_util__args__get_positional_value_type() {
  # 1) parser namespace
  # 2) positional name

  {
    # ensure positional exists
    bash_util__args__positional_exists "${1:-}" "${2:-}" &&

    # get positional arg dict
    local positional_arg_dict= &&
    positional_arg_dict="$(_bash_util__args__get_positional_arg_dict "${1}" "${2}")"
  } || {
    echo "failed getting value type for positional: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # check for value key
  _bash_util__dict__has_key "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__VALUE}" ||
    return "${BASH_UTIL__CODE__NOT_FOUND}"

  # get positional value key type
  _bash_util__dict__get_key_type "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__VALUE}"
}

# ==============================================================================
# args - get_positional_value
# ==============================================================================

bash_util__args__get_positional_value() {
  # 1) parser namespace
  # 2) positional name

  {
    # ensure positional exists
    bash_util__args__positional_exists "${1:-}" "${2:-}" &&

    # get positional arg dict
    local positional_arg_dict= &&
    positional_arg_dict="$(_bash_util__args__get_positional_arg_dict "${1}" "${2}")"
  } || {
    echo "failed getting value for positional: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # check for value key
  _bash_util__dict__has_key "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__VALUE}" ||
    return "${BASH_UTIL__CODE__NOT_FOUND}"

  # check if value key is set
  _bash_util__dict__key_value_is_set "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__VALUE}" ||
    return "${BASH_UTIL__CODE__UNSET}"

  # get positional value key value
  _bash_util__dict__get_key_value "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__VALUE}"
}

# ==============================================================================
# args - positional_exists
# ==============================================================================

bash_util__args__positional_exists() {
  # 1) parser namespace
  # 2) positional name

  {
    # ensure parser exists
    bash_util__args__parser_exists "${1:-}" &&

    # get positional dict
    local positional_dict= &&
    positional_dict="$(_bash_util__args__get_positional_dict "${1}")" &&

    # check if key exists
    bash_util__dict__key_exists "${positional_dict}" "${2:-}"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        echo "positional does not exist: '${2:-}'" | bash_util__log__error 1
        return "${BASH_UTIL__CODE__FALSE}"
        ;;
      *)
        echo "failed checking for positional: '${2:-}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    esac
  }
}

# ==============================================================================
# args - set_positional_action
# ==============================================================================

bash_util__args__set_positional_action() {
  # 1) parser namespace
  # 2) positional name
  # 3) action

  {
    # ensure positional exists
    bash_util__args__positional_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__positional_action_is_unset "${1}" "${2}" &&

    # ensure action is valid
    _bash_util__args__action_is_valid "${3:-}" &&

    # get positional arg dict
    local positional_arg_dict= &&
    positional_arg_dict="$(_bash_util__args__get_positional_arg_dict "${1}" "${2}")" &&

    # set positional action to value
    _bash_util__dict__set_key_value "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__ACTION}" "${3}"
  } || {
    echo "failed setting action for positional: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # set nargs to 0 for store_const, append_const, count, store_false, or store_true
  case "${3}" in
    "${BASH_UTIL__ARGS__ACTION__STORE_CONST}"|"${BASH_UTIL__ARGS__ACTION__APPEND_CONST}"|"${BASH_UTIL__ARGS__ACTION__COUNT}"|"${BASH_UTIL__ARGS__ACTION__STORE_FALSE}"|"${BASH_UTIL__ARGS__ACTION__STORE_TRUE}")
      {
        _bash_util__dict__set_key_value "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__NARGS}" 0
      } || {
        echo "failed setting nargs to 0 for positional: '${2:-}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
      ;;
  esac

  # set default to appropriate bool value for store_true or store_false
  case "${3}" in
    "${BASH_UTIL__ARGS__ACTION__STORE_FALSE}")
      {
        # add default key as bool
        _bash_util__dict__add_key "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" "${BASH_UTIL__TYPE__BOOL}" &&

        # set default key value
        _bash_util__dict__set_key_value "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" "${BASH_UTIL__BOOL__TRUE}"
      } || {
        echo "failed setting default to 'true' for positional: '${2:-}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
      ;;
    "${BASH_UTIL__ARGS__ACTION__STORE_TRUE}")
      {
        # add default key as bool
        _bash_util__dict__add_key "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" "${BASH_UTIL__TYPE__BOOL}" &&

        # set default key value
        _bash_util__dict__set_key_value "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" "${BASH_UTIL__BOOL__FALSE}"
      } || {
        echo "failed setting default to 'false' for positional: '${2:-}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
      ;;
  esac
}

# ==============================================================================
# args - set_positional_choices
# ==============================================================================

bash_util__args__set_positional_choices() {
  # 1) parser namespace
  # 2) positional name
  # 3) choices value

  {
    # ensure positional exists
    bash_util__args__positional_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__positional_action_is_unset "${1}" "${2}" &&

    # get positional arg dict
    local positional_arg_dict= &&
    positional_arg_dict="$(_bash_util__args__get_positional_arg_dict "${1}" "${2}")" &&

    # set positional choices to value
    _bash_util__dict__set_key_value "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__CHOICES}" "${3:-}"
  } || {
    echo "failed setting choices for positional: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - set_positional_const
# ==============================================================================

bash_util__args__set_positional_const() {
  # 1) parser namespace
  # 2) positional name
  # 3) const type
  # 4n) const value

  {
    # ensure positional exists
    bash_util__args__positional_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__positional_action_is_unset "${1}" "${2}" &&

    # ensure type is supported
    _bash_util__args__type_is_supported "${3:-}" &&

    # get positional arg dict
    local positional_arg_dict= &&
    positional_arg_dict="$(_bash_util__args__get_positional_arg_dict "${1}" "${2}")" &&

    # add const key
    bash_util__dict__add_key "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__CONST}" "${3}" &&

    # set positional const to value
    _bash_util__dict__set_key_value "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__CONST}" "${@:4}"
  } || {
    echo "failed setting const for positional: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - set_positional_default
# ==============================================================================

bash_util__args__set_positional_default() {
  # 1) parser namespace
  # 2) positional name
  # 3) default type
  # 4n) default value

  {
    # ensure positional exists
    bash_util__args__positional_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__positional_action_is_unset "${1}" "${2}" &&

    # ensure type is supported
    _bash_util__args__type_is_supported "${3:-}" &&

    # get positional arg dict
    local positional_arg_dict= &&
    positional_arg_dict="$(_bash_util__args__get_positional_arg_dict "${1}" "${2}")" &&

    # add const key
    bash_util__dict__add_key "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" "${3}" &&

    # set positional default to value
    _bash_util__dict__set_key_value "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" "${@:4}"
  } || {
    echo "failed setting default for positional: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - set_positional_nargs
# ==============================================================================

bash_util__args__set_positional_nargs() {
  # 1) parser namespace
  # 2) positional name
  # 3) nargs value

  {
    # ensure positional exists
    bash_util__args__positional_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__positional_action_is_unset "${1}" "${2}" &&

    # validate nargs
    _bash_util__args__nargs_is_valid "${3:-}" &&

    # get positional arg dict
    local positional_arg_dict= &&
    positional_arg_dict="$(_bash_util__args__get_positional_arg_dict "${1}" "${2}")" &&

    # set positional nargs to value
    _bash_util__dict__set_key_value "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__NARGS}" "${3}"
  } || {
    echo "failed setting nargs for positional: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - set_positional_type
# ==============================================================================

bash_util__args__set_positional_type() {
  # 1) parser namespace
  # 2) positional name
  # 3) type

  {
    # ensure positional exists
    bash_util__args__positional_exists "${1:-}" "${2:-}" &&

    # ensure action is unset
    _bash_util__args__positional_action_is_unset "${1}" "${2}" &&

    # ensure type is supported
    _bash_util__args__type_is_supported "${3:-}" &&

    # get positional arg dict
    local positional_arg_dict= &&
    positional_arg_dict="$(_bash_util__args__get_positional_arg_dict "${1}" "${2}")" &&

    # set positional type to value
    _bash_util__dict__set_key_value "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__TYPE}" "${3}"
  } || {
    echo "failed setting type for positional: '${2:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

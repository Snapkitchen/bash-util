#
# get extras list
#

# ==============================================================================
# args - _get_extras_list
# ==============================================================================

_bash_util__args__get_extras_list() {
  # 1) parser namespace
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER" 'EXTRAS'
}

#
# get option dict
#

# ==============================================================================
# args - _get_option_dict
# ==============================================================================

_bash_util__args__get_option_dict() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__OPTIONS__VALUE" "${2}"
}

#
# get option keys
#

# ==============================================================================
# args - _get_option_action
# ==============================================================================

_bash_util__args__get_option_action() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__OPTIONS__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__OPTION__ACTION}"
}

# ==============================================================================
# args - _get_option_choices
# ==============================================================================

_bash_util__args__get_option_choices() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__OPTIONS__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__OPTION__CHOICES}"
}

# ==============================================================================
# args - _get_option_const
# ==============================================================================

_bash_util__args__get_option_const() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__OPTIONS__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__OPTION__CONST}"
}

# ==============================================================================
# args - _get_option_default
# ==============================================================================

_bash_util__args__get_option_default() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__OPTIONS__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__OPTION__DEFAULT}"
}

# ==============================================================================
# args - _get_option_long_name
# ==============================================================================

_bash_util__args__get_option_long_name() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__OPTIONS__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__OPTION__LONG_NAME}"
}

# ==============================================================================
# args - _get_option_nargs
# ==============================================================================

_bash_util__args__get_option_nargs() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__OPTIONS__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__OPTION__NARGS}"
}

# ==============================================================================
# args - _get_option_required
# ==============================================================================

_bash_util__args__get_option_required() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__OPTIONS__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__OPTION__REQUIRED}"
}

# ==============================================================================
# args - _get_option_short_name
# ==============================================================================

_bash_util__args__get_option_short_name() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__OPTIONS__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__OPTION__SHORT_NAME}"
}

# ==============================================================================
# args - _get_option_type
# ==============================================================================

_bash_util__args__get_option_type() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__OPTIONS__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__OPTION__TYPE}"
}

# ==============================================================================
# args - _get_option_value
# ==============================================================================

_bash_util__args__get_option_value() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__OPTIONS__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__OPTION__VALUE}"
}

#
# get options dict
#

# ==============================================================================
# args - _get_options_dict
# ==============================================================================

_bash_util__args__get_options_dict() {
  # 1) parser namespace
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER" 'OPTIONS'
}

#
# get positional dict
#

# ==============================================================================
# args - _get_positional_dict
# ==============================================================================

_bash_util__args__get_positional_dict() {
  # 1) parser namespace
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER" 'POSITIONAL'
}

#
# get positional arg keys
#

# ==============================================================================
# args - _get_positional_arg_action
# ==============================================================================

_bash_util__args__get_positional_arg_action() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__POSITIONAL__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__POSITIONAL__ACTION}"
}

# ==============================================================================
# args - _get_positional_arg_choices
# ==============================================================================

_bash_util__args__get_positional_arg_choices() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__POSITIONAL__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__POSITIONAL__CHOICES}"
}

# ==============================================================================
# args - _get_positional_arg_const
# ==============================================================================

_bash_util__args__get_positional_arg_const() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__POSITIONAL__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__POSITIONAL__CONST}"
}

# ==============================================================================
# args - _get_positional_arg_default
# ==============================================================================

_bash_util__args__get_positional_arg_default() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__POSITIONAL__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}"
}

# ==============================================================================
# args - _get_positional_arg_nargs
# ==============================================================================

_bash_util__args__get_positional_arg_nargs() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__POSITIONAL__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__POSITIONAL__NARGS}"
}

# ==============================================================================
# args - _get_positional_arg_type
# ==============================================================================

_bash_util__args__get_positional_arg_type() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__POSITIONAL__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__POSITIONAL__TYPE}"
}

# ==============================================================================
# args - _get_positional_arg_value
# ==============================================================================

_bash_util__args__get_positional_arg_value() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__POSITIONAL__VALUE__KEY__${2}__VALUE" "${_BASH_UTIL__ARGS__POSITIONAL__VALUE}"
}

#
# get positional arg dict
#

# ==============================================================================
# args - _get_positional_arg_dict
# ==============================================================================

_bash_util__args__get_positional_arg_dict() {
  # 1) parser namespace
  # 2) option name
  _bash_util__dict__get_key_value "${1}__ARGS__PARSER__KEY__POSITIONAL__VALUE" "${2}"
}

#
# get option values
#

# ==============================================================================
# args - _get_option_values
# ==============================================================================

_bash_util__args__get_option_values() {
  # 1) parser namespace
  # 2) arg name
  # 3) args

  _bash_util__args__get_values 'OPTION' "${@}"
}

#
# get positional values
#

# ==============================================================================
# args - _get_positional_values
# ==============================================================================

_bash_util__args__get_positional_values() {
  # 1) parser namespace
  # 2) arg name
  # 3) args

  _bash_util__args__get_values 'POSITIONAL' "${@}"
}

#
# option helpers
#

# ==============================================================================
# args - _bash_util__args__option_action_is_unset
# ==============================================================================

_bash_util__args__option_action_is_unset() {
  # 1) parser namespace
  # 2) arg name

  local option_dict=
  option_dict="$(_bash_util__args__get_option_dict "${1}" "${2}")" || {
    echo 'failed getting option dict' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  {
    _bash_util__dict__has_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__ACTION}" &&

    _bash_util__dict__key_value_is_set "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__ACTION}"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        # ok
        return "${BASH_UTIL__CODE__OK}"
        ;;
      *)
        echo 'failed checking if option action key is set' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }

  echo "option action is already set" | bash_util__log__error
  return "${BASH_UTIL__CODE__GENERAL_ERROR}"
}

# ==============================================================================
# args - _option_long_name_is_valid
# ==============================================================================

_bash_util__args__option_long_name_is_valid() {
  {
    bash_util__string__is_not_null "${1:-}" &&

    # does not contain spaces
    ! [[ "${1}" =~ ' ' ]] &&

    # does not start with three dash characters
    ! [[ "${1}" =~ ^---.+$ ]] &&

    # starts with two dash characters
    [[ "${1}" =~ ^--.+$ ]] &&

    return "${BASH_UTIL__CODE__TRUE}"
  } || {
    echo "invalid option long name: '${1:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__FALSE}"
  }
}

# ==============================================================================
# args - _option_short_name_is_valid
# ==============================================================================

_bash_util__args__option_short_name_is_valid() {
  {
    bash_util__string__is_not_null "${1:-}" &&

    # does not contain spaces
    ! [[ "${1}" =~ ' ' ]] &&

    # does not start with two dash characters
    ! [[ "${1}" =~ ^--.+$ ]] &&

    # starts with one dash character
    [[ "${1}" =~ ^-.+$ ]] &&

    return "${BASH_UTIL__CODE__TRUE}"
  } || {
    echo "invalid option short name: '${1:-}'" | bash_util__log__error
    return "${BASH_UTIL__CODE__FALSE}"
  }
}

# ==============================================================================
# args - _option_name_is_unique
# ==============================================================================

_bash_util__args__option_name_is_unique() {
  # 1) _BASH_UTIL__ARGS__OPTION__LONG_NAME / _BASH_UTIL__ARGS__OPTION__SHORT_NAME
  # 2) parser namespace
  # 3) option long / short name

  local get_function=
  case "${1}" in
    "${_BASH_UTIL__ARGS__OPTION__SHORT_NAME}")
      get_function='_bash_util__args__get_option_short_name'
      ;;
    "${_BASH_UTIL__ARGS__OPTION__LONG_NAME}")
      get_function='_bash_util__args__get_option_long_name'
      ;;
  esac

  # get options dict
  local options_dict=
  options_dict="$(_bash_util__args__get_options_dict "${2}")"

  # get options
  local options=( $(_bash_util__dict__keys "${options_dict}") ) || {
    echo 'failed getting options dict keys' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # iterate through options
  local option=
  for option in "${options[@]}"
  do
    # get option dict
    local option_dict=
    option_dict="$(_bash_util__args__get_option_dict "${2}" "${option}")" || {
      echo 'failed getting option dict' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # check if short / long name is set
    {
      _bash_util__dict__key_value_is_set "${option_dict}" "${1}"
    } || {
      case $? in
        "${BASH_UTIL__CODE__FALSE}")
          # short / long name not set, skip
          continue
          ;;
        *)
          # failed
          echo 'failed checking if short / long name was set' | bash_util__log__error
          return "${BASH_UTIL__CODE__GENERAL_ERROR}"
          ;;
      esac
    }
    
    # get option long name
    local option_name=
    option_name="$("${get_function}" "${2}" "${option}")" || {
      echo 'failed getting option short / long name' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # if option arg string matches input arg string
    if bash_util__string__equals "${3}" "${option_name}"
    then
      echo "option name '${3}' already in use by option: '${option}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__FALSE}"
    fi
  done

  return "${BASH_UTIL__CODE__TRUE}"
}

#
# parser helpers
#

# ==============================================================================
# args - parser_does_not_exist
# ==============================================================================

bash_util__args__parser_does_not_exist() {
  bash_util__string__is_not_null "${1:-}" 'parser namespace' ||
    return "${BASH_UTIL__CODE__NULL}"

  {
    bash_util__dict__exists "${1}__ARGS__PARSER" &&
    echo "parser exists: '${1}'" | bash_util__log__error 1 &&
    return "${BASH_UTIL__CODE__FALSE}"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        return "${BASH_UTIL__CODE__TRUE}"
        ;;
      *)
        echo 'failed checking for parser' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }
}

# ==============================================================================
# args - parser_exists
# ==============================================================================

bash_util__args__parser_exists() {
  bash_util__string__is_not_null "${1:-}" 'parser namespace' ||
    return "${BASH_UTIL__CODE__NULL}"

  {
    bash_util__dict__exists "${1}__ARGS__PARSER" &&
    return "${BASH_UTIL__CODE__TRUE}"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        echo "parser does not exist: '${1}'" | bash_util__log__error 1 &&
        return "${BASH_UTIL__CODE__FALSE}"
        ;;
      *)
        echo 'failed checking for parser' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }
}

#
# positional helpers
#

# ==============================================================================
# args - _bash_util__args__positional_action_is_unset
# ==============================================================================

_bash_util__args__positional_action_is_unset() {
  # 1) parser namespace
  # 2) arg name

  local positional_arg_dict=
  positional_arg_dict="$(_bash_util__args__get_positional_arg_dict "${1}" "${2}")" || {
    echo 'failed getting positional arg dict' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  {
    _bash_util__dict__has_key "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__ACTION}" &&

    _bash_util__dict__key_value_is_set "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__ACTION}"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        # ok
        return "${BASH_UTIL__CODE__OK}"
        ;;
      *)
        echo 'failed checking if positional action key is set' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }

  echo "positional action is already set" | bash_util__log__error
  return "${BASH_UTIL__CODE__GENERAL_ERROR}"
}

#
# nargs helpers
#

# ==============================================================================
# args - _get_nargs_pattern
# ==============================================================================

_bash_util__args__get_nargs_pattern() {
  # 1) nargs pattern
  # 2) is option (default: false)

  local nargs=
  nargs="${1}"

  local pattern=

  # null defaults to single argument
  if [[ -z "${nargs}" ]]
  then
    pattern='(-*A-*)'
  
  # zero or one arguments
  elif [[ "${nargs}" = "${BASH_UTIL__ARGS__NARGS__OPTIONAL}" ]]
  then
    pattern='(-*A?-*)'

  # zero or more arguments
  elif [[ "${nargs}" = "${BASH_UTIL__ARGS__NARGS__ZERO_OR_MORE}" ]]
  then
    pattern='(-*[A-]*)'

  # one or more arguments
  elif [[ "${nargs}" = "${BASH_UTIL__ARGS__NARGS__ONE_OR_MORE}" ]]
  then
    pattern='(-*A[A-]*)'

  # any number of arguments
  elif [[ "${nargs}" = "${BASH_UTIL__ARGS__NARGS__REMAINDER}" ]]
  then
    pattern='([-AO]*)'

  # one and more arguments
  elif [[ "${nargs}" = "${BASH_UTIL__ARGS__NARGS__PARSER}" ]]
  then
    pattern='(-*A[-AO]*)'

  # integers
  else
    local iter=
    pattern='(-*'
    for (( iter=0; iter<nargs; iter++ ))
    do
      pattern+='A-*'
    done
    pattern+=')'
  fi

  # if option then remove '--' indicator (which is '-')
  if bash_util__bool__value_is_true "${2:-}"
  then
    pattern="${pattern//-\*}"
    pattern="${pattern//-}"
  fi

  # print the pattern
  {
    bash_util__string__print_value 'pattern' &&
    return "${BASH_UTIL__CODE__OK}"
  } || {
    echo 'failed to print nargs pattern' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# args - _nargs_is_valid
# ==============================================================================

_bash_util__args__nargs_is_valid() {
  local nargs_value="${1:-}"

  case "${nargs_value}" in
    "${BASH_UTIL__ARGS__NARGS__ONE_OR_MORE}")
      ;;
    "${BASH_UTIL__ARGS__NARGS__OPTIONAL}")
      ;;
    "${BASH_UTIL__ARGS__NARGS__PARSER}")
      ;;
    "${BASH_UTIL__ARGS__NARGS__REMAINDER}")
      ;;
    "${BASH_UTIL__ARGS__NARGS__ZERO_OR_MORE}")
      ;;
    *)
      if bash_util__int__value_is_valid "${nargs_value}"
      then
        if ! [[ "${nargs_value}" -gt 0 ]]
        then
          echo 'nargs value must be greater than 0' | bash_util__log__error
          return "${BASH_UTIL__CODE__FALSE}"
        fi
      else
        echo 'nargs value must be an int or known type' | bash_util__log__error
        return "${BASH_UTIL__CODE__FALSE}"
      fi
      ;;
  esac

  return "${BASH_UTIL__CODE__TRUE}"
}

#
# type helpers
#

# ==============================================================================
# args - _type_is_supported
# ==============================================================================

_bash_util__args__type_is_supported() {
  # 1) type

  local type="${1:-}"

  case "${type}" in
    "${BASH_UTIL__TYPE__STRING}")
      ;;
    "${BASH_UTIL__TYPE__BOOL}")
      ;;
    "${BASH_UTIL__TYPE__INT}")
      ;;
    "${BASH_UTIL__TYPE__LIST}")
      ;;
    *)
      echo "unsupported type: '${type}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__FALSE}"
      ;;
  esac

  return "${BASH_UTIL__CODE__TRUE}"
}

#
# action helpers
#

# ==============================================================================
# args - _action_is_valid
# ==============================================================================

_bash_util__args__action_is_valid() {
  # 1) action

  local action="${1:-}"

  case "${action}" in
    "${BASH_UTIL__ARGS__ACTION__APPEND}")
      ;;
    "${BASH_UTIL__ARGS__ACTION__APPEND_CONST}")
      ;;
    "${BASH_UTIL__ARGS__ACTION__COUNT}")
      ;;
    "${BASH_UTIL__ARGS__ACTION__STORE}")
      ;;
    "${BASH_UTIL__ARGS__ACTION__STORE_CONST}")
      ;;
    "${BASH_UTIL__ARGS__ACTION__STORE_FALSE}")
      ;;
    "${BASH_UTIL__ARGS__ACTION__STORE_TRUE}")
      ;;
    *)
      echo "invalid action: '${action}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__FALSE}"
      ;;
  esac

  return "${BASH_UTIL__CODE__TRUE}"
}

# ==============================================================================
# args - _parse_option
# ==============================================================================

_bash_util__args__parse_option() {
  # 1) parser namespace
  # 2) arg string

  # parser assumed to be valid
  
  local arg_string=
  arg_string="${2:-}"

  local arg_string_type=
  
  if [[ -z "${arg_string}" ]]
  then
    # if the string is empty it is a positional
    return "${BASH_UTIL__CODE__NOT_FOUND}"
  elif [[ "${arg_string}" =~ ' ' ]]
  then
    # if it contains a space it is a positional
    return "${BASH_UTIL__CODE__NOT_FOUND}"
  elif [[ "${arg_string}" =~ ^--.+$ ]]
  then
    # if it starts with two dashes it is a long option
    arg_string_type="${_BASH_UTIL__ARGS__OPTION__LONG_NAME}"
  elif [[ "${arg_string}" =~ ^-.+$ ]]
  then
    # if it starts with one dash it is a short option
    arg_string_type="${_BASH_UTIL__ARGS__OPTION__SHORT_NAME}"
  else
    # not an option
    return "${BASH_UTIL__CODE__NOT_FOUND}"
  fi

  {
    # get options dict
    local options_dict= &&
    options_dict="$(_bash_util__args__get_options_dict "${1}")" &&

    # get options dict keys
    local options_keys= &&
    options_keys=( $(_bash_util__dict__keys "${options_dict}") )
  } || {
    echo 'failed getting option dict keys' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # iterate through each option key
  local option=
  for option in "${options_keys[@]}"
  do
    # get option dict
    local option_dict=
    option_dict="$(_bash_util__args__get_option_dict "${1}" "${option}")" || {
      echo 'failed getting option dict' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # check if value is set
    {
      _bash_util__dict__key_value_is_set "${option_dict}" "${arg_string_type}"
    } || {
      case $? in
        "${BASH_UTIL__CODE__FALSE}")
          # value not set, skip
          continue
          ;;
        *)
          # failed
          echo 'failed checking if key value was set' | bash_util__log__error
          return "${BASH_UTIL__CODE__GENERAL_ERROR}"
          ;;
      esac
    }

    # get arg string for option
    local option_arg_string=
    option_arg_string="$(_bash_util__dict__get_key_value "${option_dict}" "${arg_string_type}")" || {
      echo 'failed getting option arg string' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # if option arg string matches input arg string
    if bash_util__string__equals "${option_arg_string}" "${arg_string}"
    then
      {
        # print the name of the option that matched
        bash_util__string__print_value 'option' &&
        return "${BASH_UTIL__CODE__OK}"
      } || {
        echo 'failed printing option name' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    fi
  done

  # no matches found
  return "${BASH_UTIL__CODE__NOT_FOUND}"
}

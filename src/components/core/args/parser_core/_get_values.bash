# ==============================================================================
# args - _get_values
# ==============================================================================

_bash_util__args__get_values() {
  # 1) arg category (POSITIONAL / OPTION)
  # 2) parser namespace
  # 3) arg name
  # 4) args

  # ============================================================================
  # args - _get_values__check_from_key
  # ============================================================================
  _bash_util__args__get_values__check_from_key() {
    # unpacks values from an arg key
    # and passes them to check function

    local target_key="${1}"

    # get key type
    local key_type=
    key_type="$(_bash_util__dict__get_key_type "${arg_dict}" "${target_key}")" || {
      echo "failed getting key type for target key: '${target_key}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # get value based on type
    local key_value=
    case "${key_type}" in
      "${BASH_UTIL__TYPE__STRING}"|"${BASH_UTIL__TYPE__INT}"|"${BASH_UTIL__TYPE__LIST}")
        key_value="$(_bash_util__dict__get_key_value "${arg_dict}" "${target_key}")" || {
          echo "failed getting key value for target key: '${target_key}'" | bash_util__log__error
          return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        }
        ;;
      *)
        # other key types don't do validation
        return "${BASH_UTIL__CODE__OK}"
        ;;
    esac

    # check value(s)
    case "${key_type}" in
      "${BASH_UTIL__TYPE__STRING}"|"${BASH_UTIL__TYPE__INT}")
        # check single string or int value
        _bash_util__args__get_values__check "${key_value}"
        ;;
      "${BASH_UTIL__TYPE__LIST}")
        # clone list values to local var
        local key_values=
        _bash_util__list__clone "${key_value}" 'key_values' || {
          echo "failed cloning value for key '${target_key}' to local list" | bash_util__log__error
        }

        # check list of values
        _bash_util__args__get_values__check "${key_values[@]}"
        ;;
    esac
  }

  # ============================================================================
  # args - _get_values__check
  # ============================================================================
  _bash_util__args__get_values__check() {
    # 1n) check args
    # input> arg_name
    # input> arg_dict
    # input> choices_key
    # input> choices_get_function
    # input> type
    # input> parser_namespace

    local check_args=("${@}")

    # check if type is supported
    _bash_util__args__type_is_supported "${type}" ||
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"

    # get choices list name
    local choices_list_name=
    {
      # if choices is set
      _bash_util__dict__key_value_is_set "${arg_dict}" "${choices_key}" &&
      # then get choices list name
      choices_list_name="$("${choices_get_function}" "${parser_namespace}" "${arg_name}")"
    } || {
      case $? in
        "${BASH_UTIL__CODE__FALSE}")
          # choices is unset, skip
          return "${BASH_UTIL__CODE__OK}"
          ;;
        *)
          # failed
          echo 'failed checking if choices was set' | bash_util__log__error
          return "${BASH_UTIL__CODE__GENERAL_ERROR}"
          ;;
      esac
    }

    # check if each arg
    # is in the choices list
    local arg=
    for arg in "${check_args[@]}"
    do
      _bash_util__list__contains "${choices_list_name}" "${arg}" || {
        case $? in
          "${BASH_UTIL__CODE__FALSE}")
            # arg value not found
            # decorate choices with 'quotes'
            local decorated_choices=
            _bash_util__list__to_string "${choices_list_name}" 'decorated_choices' '' '' "'" "'" ', ' || {
              echo 'failed to convert choices list to string' | bash_util__log__error
              return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            }

            # print error message
            echo "invalid choice '${arg}' for arg '${arg_name}' (choose from: ${decorated_choices})" | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
          *)
            # failed
            echo 'failed checking if value is valid choice' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
        esac
      }
    done

    return "${BASH_UTIL__CODE__OK}"
  }

  # ============================================================================
  # args - _get_values__take_action
  # ============================================================================
  _bash_util__args__get_values__take_action() {

    # ==========================================================================
    # args - _get_values__take_action__clear_value
    # ==========================================================================
    # clears existing value, if present
    _bash_util__args__get_values__take_action__clear_value() {
      {
        _bash_util__dict__has_key "${arg_dict}" "${value_key}" &&
        _bash_util__dict__remove_key "${arg_dict}" "${value_key}"
      } || {
        case $? in
          "${BASH_UTIL__CODE__FALSE}")
            # continue
            ;;
          *)
            echo 'failed attempting to destroy value key' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
        esac
      }
    }

    # ==========================================================================
    # args - _get_values__take_action__store
    # ==========================================================================
    # store value as-is
    _bash_util__args__get_values__take_action__store() {
      # clear any previous value
      _bash_util__args__get_values__take_action__clear_value || {
        echo 'failed clearing value' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      # skip if temp key does not exist
      _bash_util__dict__has_key "${arg_dict}" "${temp_key}" ||
        return "${BASH_UTIL__CODE__OK}"

      # clone the temp key
      _bash_util__dict__clone_key "${arg_dict}" "${temp_key}" "${arg_dict}" "${value_key}" || {
        echo 'failed cloning temp key to value key' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    }

    # ==========================================================================
    # args - _get_values__take_action__store_const
    # ==========================================================================
    # store const as-is
    _bash_util__args__get_values__take_action__store_const() {
      # clear any previous value
      _bash_util__args__get_values__take_action__clear_value || {
        echo 'failed clearing value' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      {
        # check for const key
        _bash_util__dict__has_key "${arg_dict}" "${const_key}" &&

        # check value is set
        _bash_util__dict__key_value_is_set "${arg_dict}" "${const_key}"
      } || {
        case $? in
          "${BASH_UTIL__CODE__FALSE}")
            echo 'const value is unset, cannot store const' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
          *)
            echo 'failed checking const key' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
        esac
      }

      # clone the const key
      _bash_util__dict__clone_key "${arg_dict}" "${const_key}" "${arg_dict}" "${value_key}" || {
        echo 'failed cloning const key to value key' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    }

    # ==========================================================================
    # args - _get_values__take_action__store_true
    # ==========================================================================
    # store true
    _bash_util__args__get_values__take_action__store_true() {
      # clear any previous value
      _bash_util__args__get_values__take_action__clear_value || {
        echo 'failed clearing value' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      {
        # create value key
        _bash_util__dict__add_key "${arg_dict}" "${value_key}" "${BASH_UTIL__TYPE__BOOL}" &&

        # store the value
        _bash_util__dict__set_key_value "${arg_dict}" "${value_key}" "${BASH_UTIL__BOOL__TRUE}"
      } || {
        echo 'failed storing true value' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    }

    # ==========================================================================
    # args - _get_values__take_action__store_false
    # ==========================================================================
    # store false
    _bash_util__args__get_values__take_action__store_false() {
      # clear any previous value
      _bash_util__args__get_values__take_action__clear_value || {
        echo 'failed clearing value' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      {
        # create value key
        _bash_util__dict__add_key "${arg_dict}" "${value_key}" "${BASH_UTIL__TYPE__BOOL}" &&

        # store the value
        _bash_util__dict__set_key_value "${arg_dict}" "${value_key}" "${BASH_UTIL__BOOL__FALSE}"
      } || {
        echo 'failed storing false value' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    }

    # ==========================================================================
    # args - _get_values__take_action__init_value_dict
    # ==========================================================================
    local value_key_dict=
    local value_key_dict_keys=
    _bash_util__args__get_values__take_action__init_value_dict() {
      # output> value_key_dict
      # output> value_key_dict_keys

      ## echo "(debug) arg_dict: ${arg_dict}" | bash_util__log__error
      ## echo "(debug) value_key: ${value_key}" | bash_util__log__error
      # check for existing value key
      _bash_util__dict__has_key "${arg_dict}" "${value_key}" || {
        case $? in
          "${BASH_UTIL__CODE__FALSE}")
            ## echo "(debug) creating value key" | bash_util__log__error
            # create value key
            _bash_util__dict__add_key "${arg_dict}" "${value_key}" "${BASH_UTIL__TYPE__DICT}" || {
              echo 'failed creating value key' | bash_util__log__error
              return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            }
            ;;
          *)
            echo 'failed checking for existing value key' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
        esac
      }

      # get reference to value key dict
      value_key_dict="$("${value_get_function}" "${parser_namespace}" "${arg_name}")" || {
        echo 'failed getting reference to value key dict' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      # check if value was set
      _bash_util__dict__key_value_is_set "${arg_dict}" "${value_key}" || {
        case $? in
          "${BASH_UTIL__CODE__FALSE}")
            # init value key dict value
            bash_util__dict__create "${value_key_dict}" || {
              echo 'failed creating value key dict value' | bash_util__log__error
              return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            }
            ;;
          *)
            echo 'failed checking for existing value key dict value' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
        esac
      }

      # confirm type of value
      _bash_util__dict__key_is_type "${arg_dict}" "${value_key}" "${BASH_UTIL__TYPE__DICT}" || {
        echo 'type mismatch between existing value and value to append' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      # get reference to value key dict keys
      value_key_dict_keys="$(_bash_util__dict__get_keys_list "${value_key_dict}")" || {
        echo 'failed getting reference to value key dict keys' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    }

    # ==========================================================================
    # args - _get_values__take_action__get_next_value_index
    # ==========================================================================
    local next_value_index=
    _bash_util__args__get_values__take_action__get_next_value_index() {
      # input> value_key_dict_keys
      # output> next_value_index

      next_value_index="$(_bash_util__list__next_available_index "${value_key_dict_keys}")" || {
        echo 'failed getting next available index for value key dict keys' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    }

    # ==========================================================================
    # args - _get_values__take_action__append
    # ==========================================================================
    # append
    _bash_util__args__get_values__take_action__append() {
      # input> value_key_dict
      # input> next_value_index
      
      {
        # init value dict
        _bash_util__args__get_values__take_action__init_value_dict &&

        # skip if temp key does not exist
        {
          _bash_util__dict__has_key "${arg_dict}" "${temp_key}" ||
            return "${BASH_UTIL__CODE__OK}"
        } &&

        _bash_util__args__get_values__take_action__get_next_value_index &&

        local value_key_dict_value_key="${_BASH_UTIL__ARGS__VALUE_PREFIX}${next_value_index}"
      } || {
        echo "failed preparing to clone temp key value" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      # clone the temp key
      _bash_util__dict__clone_key "${arg_dict}" "${temp_key}" "${value_key_dict}" "${value_key_dict_value_key}" || {
        echo "failed cloning temp key to value key dict value key: '${value_key_dict_value_key}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    }

    # ==========================================================================
    # args - _get_values__take_action__append_const
    # ==========================================================================
    # append const
    _bash_util__args__get_values__take_action__append_const() {
      # input> value_key_dict
      # input> next_value_index
      # input> const_key

      {
        # check for const key
        _bash_util__dict__has_key "${arg_dict}" "${const_key}" &&

        # check value is set
        _bash_util__dict__key_value_is_set "${arg_dict}" "${const_key}"
      } || {
        case $? in
          "${BASH_UTIL__CODE__FALSE}")
            echo 'const value is unset, cannot append const' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
          *)
            echo 'failed checking const key' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
        esac
      }

      {
        _bash_util__args__get_values__take_action__init_value_dict &&

        _bash_util__args__get_values__take_action__get_next_value_index &&

        local value_key_dict_value_key="${_BASH_UTIL__ARGS__VALUE_PREFIX}${next_value_index}" &&

        # clone the const key
        _bash_util__dict__clone_key "${arg_dict}" "${const_key}" "${value_key_dict}" "${value_key_dict_value_key}"
      } || {
        echo "failed cloning const key to value key dict value key: '${value_key_dict_value_key}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    }

    # ==========================================================================
    # args - _get_values__take_action__count
    # ==========================================================================
    # count
    _bash_util__args__get_values__take_action__count() {
      # check for existing value key
      _bash_util__dict__has_key "${arg_dict}" "${value_key}" || {
        case $? in
          "${BASH_UTIL__CODE__FALSE}")
            # create value key
            _bash_util__dict__add_key "${arg_dict}" "${value_key}" "${BASH_UTIL__TYPE__INT}" || {
              echo 'failed creating value key' | bash_util__log__error
              return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            }
            ;;
          *)
            echo 'failed checking for existing value key' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
        esac
      }

      # check if value is set
      _bash_util__dict__key_value_is_set "${arg_dict}" "${value_key}" || {
        case $? in
          "${BASH_UTIL__CODE__FALSE}")
            # init value to 0
            _bash_util__dict__set_key_value "${arg_dict}" "${value_key}" 0 || {
              echo 'failed setting initial value key count value' | bash_util__log__error
              return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            }
            ;;
          *)
            echo 'failed checking for existing value key count value' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
        esac
      }

      # get current value
      local current_count=
      current_count="$(_bash_util__dict__get_key_value "${arg_dict}" "${value_key}")" || {
        echo 'failed getting current value key count value' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      # increment value
      current_count=$((current_count+1))

      # set updated value
      _bash_util__dict__set_key_value "${arg_dict}" "${value_key}" "${current_count}" || {
        echo 'failed setting updated value key count value' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    }

    # ==========================================================================
    # args - _get_values__main
    # ==========================================================================

    # input> action
    # input> arg_dict
    # input> value_key
    # input> temp_key
    # input> arg_name
    # input> const_key

    case "${action}" in
      "${BASH_UTIL__ARGS__ACTION__STORE}")
        _bash_util__args__get_values__take_action__store
        ;;
      "${BASH_UTIL__ARGS__ACTION__STORE_CONST}")
        _bash_util__args__get_values__take_action__store_const
        ;;
      "${BASH_UTIL__ARGS__ACTION__STORE_TRUE}")
        _bash_util__args__get_values__take_action__store_true
        ;;
      "${BASH_UTIL__ARGS__ACTION__STORE_FALSE}")
        _bash_util__args__get_values__take_action__store_false
        ;;
      "${BASH_UTIL__ARGS__ACTION__APPEND}")
        _bash_util__args__get_values__take_action__append
        ;;
      "${BASH_UTIL__ARGS__ACTION__APPEND_CONST}")
        _bash_util__args__get_values__take_action__append_const
        ;;
      "${BASH_UTIL__ARGS__ACTION__COUNT}")
        _bash_util__args__get_values__take_action__count
        ;;
    esac
  }

  local arg_category="${1}"
  local parser_namespace="${2}"
  local arg_name="${3}"
  local args=("${@:4}")

  # get arg dict
  # and set helper variables
  local arg_dict=
  local action_key=
  local action_get_function=
  local choices_key=
  local choices_get_function=
  local const_key=
  local type_key=
  local type_get_function=
  local nargs_key=
  local nargs_get_function=
  local value_key=
  local value_get_function=
  case "${arg_category}" in
    'POSITIONAL')
      arg_dict="$(_bash_util__args__get_positional_arg_dict "${parser_namespace}" "${arg_name}")" || {
        echo 'failed getting positional arg dict' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
      value_key="${_BASH_UTIL__ARGS__POSITIONAL__VALUE}"
      value_get_function='_bash_util__args__get_positional_arg_value'
      action_key="${_BASH_UTIL__ARGS__POSITIONAL__ACTION}"
      action_get_function='_bash_util__args__get_positional_arg_action'
      choices_key="${_BASH_UTIL__ARGS__POSITIONAL__CHOICES}"
      choices_get_function='_bash_util__args__get_positional_arg_choices'
      const_key="${_BASH_UTIL__ARGS__POSITIONAL__CONST}"
      type_key="${_BASH_UTIL__ARGS__POSITIONAL__TYPE}"
      type_get_function='_bash_util__args__get_positional_arg_type'
      nargs_key="${_BASH_UTIL__ARGS__POSITIONAL__NARGS}"
      nargs_get_function='_bash_util__args__get_positional_arg_nargs'
      ;;
    'OPTION')
      arg_dict="$(_bash_util__args__get_option_dict "${parser_namespace}" "${arg_name}")" || {
        echo 'failed getting option dict' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
      value_key="${_BASH_UTIL__ARGS__OPTION__VALUE}"
      value_get_function='_bash_util__args__get_option_value'
      action_key="${_BASH_UTIL__ARGS__OPTION__ACTION}"
      action_get_function='_bash_util__args__get_option_action'
      choices_key="${_BASH_UTIL__ARGS__OPTION__CHOICES}"
      choices_get_function='_bash_util__args__get_option_choices'
      const_key="${_BASH_UTIL__ARGS__OPTION__CONST}"
      type_key="${_BASH_UTIL__ARGS__OPTION__TYPE}"
      type_get_function='_bash_util__args__get_option_type'
      nargs_key="${_BASH_UTIL__ARGS__OPTION__NARGS}"
      nargs_get_function='_bash_util__args__get_option_nargs'
      ;;
    *)
      echo "invalid arg category: '${arg_category}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__INVALID}"
      ;;
  esac

  # remove existing temporary value, if present
  local temp_key='temp'
  {
    _bash_util__dict__has_key "${arg_dict}" "${temp_key}" &&
    _bash_util__dict__remove_key "${arg_dict}" "${temp_key}"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        # continue
        ;;
      *)
        echo 'failed attempting to destroy temporary value' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }

  # check if action is set
  local action=
  {
    # if action is set
    _bash_util__dict__key_value_is_set "${arg_dict}" "${action_key}" &&
    # then get action value
    action="$("${action_get_function}" "${parser_namespace}" "${arg_name}")"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        # action is unset, default to STORE
        action="${BASH_UTIL__ARGS__ACTION__STORE}"
        ;;
      *)
        # failed
        echo 'failed checking if action was set' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }

  # check if nargs is set
  local nargs=
  {
    # if nargs is set
    _bash_util__dict__key_value_is_set "${arg_dict}" "${nargs_key}" &&
    # then get nargs value
    nargs="$("${nargs_get_function}" "${parser_namespace}" "${arg_name}")"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        # nargs is unset, default to null string
        nargs=''
        ;;
      *)
        # failed
        echo 'failed checking if nargs was set' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }

  # check if type is set
  local type=
  {
    # if type is set
    _bash_util__dict__key_value_is_set "${arg_dict}" "${type_key}" &&
    # then get type value
    type="$("${type_get_function}" "${parser_namespace}" "${arg_name}")"
  } || {
    case $? in
      "${BASH_UTIL__CODE__FALSE}")
        # type is unset, default to STRING
        type="${BASH_UTIL__TYPE__STRING}"
        ;;
      *)
        # failed
        echo 'failed checking if type was set' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        ;;
    esac
  }

  # try to remove first '--' from non-parser/remainder args
  if [[ "${nargs}" != "${BASH_UTIL__ARGS__NARGS__PARSER}" && \
        "${nargs}" != "${BASH_UTIL__ARGS__NARGS__REMAINDER}" ]]
  then
    {
      _bash_util__list__remove_value 'args' '--' 2>/dev/null
    } || {
      case $? in
        "${BASH_UTIL__CODE__NOT_FOUND}")
          # ok
          ;;
        *)
          echo "failed removing '--' from args list" | bash_util__log__error
          return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      esac
    }
  fi

  # optional arguments use default or const values when unset
  if [[ "${#args[@]}" -eq 0 ]] \
  && [[ "${nargs}" = "${BASH_UTIL__ARGS__NARGS__OPTIONAL}" ]]
  then
    ## echo "(debug) first case" | bash_util__log__error
    case "${arg_category}" in
      'POSITIONAL')
        # check if positional has a default value
        {
          # check for default key
          _bash_util__dict__has_key "${arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" &&

          # check value is set
          _bash_util__dict__key_value_is_set "${arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" &&

          # check default key value
          _bash_util__args__get_values__check_from_key "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" &&

          # clone the default key value
          _bash_util__dict__clone_key "${arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" "${arg_dict}" "${temp_key}"
        } || {
          case $? in
            "${BASH_UTIL__CODE__FALSE}")
              ;;
            *)
              echo 'failed using default value' | bash_util__log__error
              return "${BASH_UTIL__CODE__GENERAL_ERROR}"
              ;;
          esac
        }
        ;;
      'OPTION')
        # check if option has a const value
        {
          # check for const key
          _bash_util__dict__has_key "${arg_dict}" "${_BASH_UTIL__ARGS__OPTION__CONST}" &&

          # check value is set
          _bash_util__dict__key_value_is_set "${arg_dict}" "${_BASH_UTIL__ARGS__OPTION__CONST}" &&

          # check const key value
          _bash_util__args__get_values__check_from_key "${_BASH_UTIL__ARGS__OPTION__CONST}" &&

          # clone the const key value
          _bash_util__dict__clone_key "${arg_dict}" "${_BASH_UTIL__ARGS__OPTION__CONST}" "${arg_dict}" "${temp_key}"
        } || {
          case $? in
            "${BASH_UTIL__CODE__FALSE}")
              ;;
            *)
              echo 'failed using const value' | bash_util__log__error
              return "${BASH_UTIL__CODE__GENERAL_ERROR}"
              ;;
          esac
        }
        ;;
    esac
  
  # for positional with nargs='*'
  # if no args, use the default, if present
  elif [[ "${arg_category}" = 'POSITIONAL' ]] \
    && [[ "${nargs}" = "${BASH_UTIL__ARGS__NARGS__ZERO_OR_MORE}" ]] \
    && [[ "${#args[@]}" -eq 0 ]]
  then
    ## echo "(debug) second case" | bash_util__log__error
    {
      # check if positional has a default key
      _bash_util__dict__has_key "${arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" &&

      # check if value is set
      _bash_util__dict__key_value_is_set "${arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" &&

      # check default key value
      _bash_util__args__get_values__check_from_key "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" &&

      # clone the default value
      _bash_util__dict__clone_key "${arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" "${arg_dict}" "${temp_key}"
    } || {
      case $? in
        "${BASH_UTIL__CODE__FALSE}")
          # set value to empty list
          
          # create value key
          _bash_util__dict__add_key "${arg_dict}" "${temp_key}" "${BASH_UTIL__TYPE__LIST}" &&

          # store the value
          _bash_util__dict__set_key_value "${arg_dict}" "${temp_key}" 'args'
          ;;
        *)
          echo 'failed using default value' | bash_util__log__error
          return "${BASH_UTIL__CODE__GENERAL_ERROR}"
          ;;
      esac
    }
  
  # single or optional argument produces a single value
  elif [[ "${#args[@]}" -eq 1 ]] \
    && [[ -z "${nargs}" || "${nargs}" = "${BASH_UTIL__ARGS__NARGS__OPTIONAL}" ]]
  then
    ## echo "(debug) third case" | bash_util__log__error
    {
      # check the value
      _bash_util__args__get_values__check "${args}" &&

      # create value key of specified type
      _bash_util__dict__add_key "${arg_dict}" "${temp_key}" "${type}" &&

      # store the value
      _bash_util__dict__set_key_value "${arg_dict}" "${temp_key}" "${args}"
    } || {
      echo 'failed to store value' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
  
  # remainder arguments store all values with no validation
  elif [[ "${nargs}" = "${BASH_UTIL__ARGS__NARGS__REMAINDER}" ]]
  then
    ## echo "(debug) fourth case" | bash_util__log__error
    {
      # create value key
      _bash_util__dict__add_key "${arg_dict}" "${temp_key}" "${BASH_UTIL__TYPE__LIST}" &&

      # store the value
      _bash_util__dict__set_key_value "${arg_dict}" "${temp_key}" 'args'
    } || {
      echo 'failed to store remainder' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

  # parser arguments store all values and check the first
  elif [[ "${nargs}" = "${BASH_UTIL__ARGS__NARGS__PARSER}" ]]
  then
    ## echo "(debug) fifth case" | bash_util__log__error
    # store the args
    {
      # check the first value
      _bash_util__args__get_values__check "${args[0]}" &&

      # create value key
      _bash_util__dict__add_key "${arg_dict}" "${temp_key}" "${BASH_UTIL__TYPE__LIST}" &&

      # store the value
      _bash_util__dict__set_key_value "${arg_dict}" "${temp_key}" 'args'
    } || {
      echo 'failed to store remainder' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
  
  # all other nargs produce a list with valid values
  else
    ## echo "(debug) sixth case" | bash_util__log__error
    # validate the value types
    local arg=
    for arg in "${args[@]}"
    do
      bash_util__type__value_is_valid 'arg' "${type}" || {
        echo "invalid value: '${arg}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    done

    {
      # check all values
      _bash_util__args__get_values__check "${args[@]}" &&

      # create value key
      _bash_util__dict__add_key "${arg_dict}" "${temp_key}" "${BASH_UTIL__TYPE__LIST}" &&

      # store the value
      _bash_util__dict__set_key_value "${arg_dict}" "${temp_key}" 'args'
    } || {
      echo 'failed to store values' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
  fi

  # take action
  _bash_util__args__get_values__take_action
}

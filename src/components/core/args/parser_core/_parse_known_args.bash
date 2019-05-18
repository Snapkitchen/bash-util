# ==============================================================================
# args - _parse_known_args
# ==============================================================================

_bash_util__args__parse_known_args() {
  # 1) parser namespace
  # 2n) args

  # ============================================================================
  # args - _parse_known_args__set_default_values
  # ============================================================================
  # iterate through positional args and options
  # and set the destination value to default, if present
  _bash_util__args__parse_known_args__set_default_values() {
    # input> parser_namespace

    #
    # positional
    #
    {
      # get positional dict
      local positional_dict= &&
      positional_dict="$(_bash_util__args__get_positional_dict "${parser_namespace}")" &&

      # get positional dict keys
      local positional_dict_keys= &&
      positional_dict_keys=( $(_bash_util__dict__keys "${positional_dict}") )
    } || {
      echo 'failed getting positional dict keys' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # iterate through each positional key
    # and determine if positionals have default keys
    local positional=
    for positional in "${positional_dict_keys[@]}"
    do
      # get positional arg dict
      local positional_arg_dict=
      positional_arg_dict="$(_bash_util__args__get_positional_arg_dict "${parser_namespace}" "${positional}")" || {
        echo 'failed getting positional arg dict' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      # check if default key exists and is set
      {
        _bash_util__dict__has_key "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" &&

        _bash_util__dict__key_value_is_set "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}"
      } || {
        case $? in
          "${BASH_UTIL__CODE__FALSE}")
            # default is not set, ignore
            continue
            ;;
          *)
            # failed
            echo 'failed checking if positional default key value was set' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
        esac
      }

      # clone default key to value key
      _bash_util__dict__clone_key "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__VALUE}" || {
        echo 'failed cloning positional default key to value key' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    done

    #
    # options
    #
    {
      # get options dict
      local options_dict= &&
      options_dict="$(_bash_util__args__get_options_dict "${parser_namespace}")" &&

      # get options dict keys
      local options_dict_keys= &&
      options_dict_keys=( $(_bash_util__dict__keys "${options_dict}") )
    } || {
      echo 'failed getting options dict keys' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # iterate through each option key
    # and determine if options have default keys
    local option=
    for option in "${options_dict_keys[@]}"
    do
      # get option dict
      local option_dict=
      option_dict="$(_bash_util__args__get_option_dict "${parser_namespace}" "${option}")" || {
        echo 'failed getting option dict' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      # check if default key exists and is set
      {
        _bash_util__dict__has_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__DEFAULT}" &&

        _bash_util__dict__key_value_is_set "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__DEFAULT}"
      } || {
        case $? in
          "${BASH_UTIL__CODE__FALSE}")
            # default is not set, ignore
            continue
            ;;
          *)
            # failed
            echo 'failed checking if option default key value was set' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
        esac
      }

      # clone default key to value key
      _bash_util__dict__clone_key "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__DEFAULT}" "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__VALUE}" || {
        echo 'failed cloning option default key to value key' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    done
  }

  # ============================================================================
  # args - _parse_known_args__consume_positional
  # ============================================================================
  _bash_util__args__parse_known_args__consume_positional() {
    # 1) starting index
    # 2) output var name
    # input> parser_namespace
    # input> args
    # input> args_pattern
    # input> positional_keys
    # input> processed_positionals
    # output> positional_keys
    # output> processed_positionals

    local start_index=
    start_index="${1}"

    local output_var_name=
    output_var_name="${2}"
    
    # get pattern slice
    local pattern=
    pattern="${args_pattern:start_index}"

    ## echo "(debug) pattern slice: ${pattern}" | bash_util__log__error

    # get number of positional keys
    local positional_keys_count=
    positional_keys_count="$(_bash_util__list__length 'positional_keys')" || {
      echo 'failed getting number of positional keys' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    ## echo "(debug) positional keys length: ${positional_keys_count}" | bash_util__log__error

    # aggregate the list of positionals' nargs patterns
    # then shorten the aggregation list until a match is found
    # and store list of match lengths
    local arg_counts=()
    local outer_iter=
    for (( outer_iter=positional_keys_count; outer_iter>0; outer_iter-- ))
    do
      # start nargs pattern with ^
      # to ensure string is matched from the start
      local nargs_pattern=
      nargs_pattern='^'
      
      local inner_iter=
      for (( inner_iter=0; inner_iter<outer_iter; inner_iter++ ))
      do
        # get positional arg dict
        local positional_arg_dict=
        positional_arg_dict="$(_bash_util__args__get_positional_arg_dict "${parser_namespace}" "${positional_keys[$inner_iter]}")" || {
          echo 'failed getting positional arg dict' | bash_util__log__error
          return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        }

        local nargs=
        {
          # if nargs is set
          _bash_util__dict__key_value_is_set "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__NARGS}" &&
          # then get nargs value
          nargs="$(_bash_util__args__get_positional_arg_nargs "${parser_namespace}" "${positional_keys[$inner_iter]}")"
        } || {
          case $? in
            "${BASH_UTIL__CODE__FALSE}")
              # nargs is unset, default to null string
              nargs=''
              ;;
            *)
              # failed
              echo 'failed checking if positional nargs was set' | bash_util__log__error
              return "${BASH_UTIL__CODE__GENERAL_ERROR}"
              ;;
          esac
        }
        
        # get and append nargs pattern segment to total pattern
        nargs_pattern+="$(_bash_util__args__get_nargs_pattern "${nargs}")" || {
          echo 'failed getting positional nargs pattern' | bash_util__log__error
          return "${BASH_UTIL__CODE__GENERAL_ERROR}"
        }
      done

      ## echo "(debug) checking if ${pattern} =~ ${nargs_pattern}" | bash_util__log__error

      # if we found a match
      if [[ "${pattern}" =~ ${nargs_pattern} ]]
      then
        ## echo "(debug) match found" | bash_util__log__error
        # add the length of each match group value to the arg counts list
        local match=
        for match in "${BASH_REMATCH[@]:1}"
        do
          arg_counts+=( "${#match}" )
        done

        # exit the outer loop
        break
      fi
    done

    # get length of arg counts list
    local arg_count_length=
    arg_count_length="${#arg_counts[@]}"
    
    # determine which list (arg counts or positionals) is shorter
    # and use that as the index ceiling
    local iter_max=
    iter_max="$(_bash_util__int__min_value "${positional_keys_count}" "${arg_count_length}")" || {
      echo 'failed getting min int value' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # up to the max positional or arg count, process each arg
    local process_iter=
    for (( process_iter=0; process_iter<iter_max; process_iter++ ))
    do
      local arg_count=
      arg_count="${arg_counts[$process_iter]}"

      local args_slice=
      args_slice=( "${args[@]:start_index:arg_count}" )

      start_index=$(( start_index + arg_count ))

      # process positional with args
      # _bash_util__args__process_positional "${positional_keys[$process_iter]}" "${args_slice[@]}"
      ## echo "(debug) processing positional arg: ${positional_keys[$process_iter]}" | bash_util__log__error
      ## echo "(debug) with args: ${args_slice[*]}" | bash_util__log__error

      processed_positionals+=("${positional_keys[$process_iter]}")

      _bash_util__args__get_positional_values "${parser_namespace}" "${positional_keys[$process_iter]}" ${args_slice+"${args_slice[@]}"} || {
        echo "failed processing values for positional arg: '${positional_keys[$process_iter]}'" | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }
    done

    ## echo "(debug) pre-slice positional keys: ${positional_keys[*]}" | bash_util__log__error

    ## echo "(debug) pre-slice arg count length: ${arg_count_length}" | bash_util__log__error

    # slice positionals keys list
    # removing the positionals we've parsed
    local positional_keys_slice=
    positional_keys_slice=( "${positional_keys[@]:$arg_count_length}" )

    # replace current keys list with sliced value
    positional_keys=( "${positional_keys_slice[@]}" )

    ## echo "(debug) post-slice positional keys: ${positional_keys[*]}" | bash_util__log__error

    # set the output value
    bash_util__int__assign "${output_var_name}" "${start_index}" || {
      echo 'failed to set output value' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
  }

  # ============================================================================
  # args - _parse_known_args__consume_option
  # ============================================================================
  _bash_util__args__parse_known_args__consume_option() {
    # 1) starting index
    # 2) output var name
    # input> args
    # input> parser_namespace
    # input> option_string_indices
    # input> args_pattern
    # output> processed_options

    local start_index=
    start_index="${1}"

    local output_var_name=
    output_var_name="${2}"

    # get current option
    local current_option=
    current_option="${option_string_indices[$start_index]}"

    # move index to following argument
    start_index="$((start_index+1))"

    # get pattern slice
    local pattern=
    pattern="${args_pattern:start_index}"

    ## echo "(debug) pattern slice: ${pattern}" | bash_util__log__error

    # get current option dict
    local current_option_dict=
    current_option_dict="$(_bash_util__args__get_option_dict "${parser_namespace}" "${current_option}")" || {
      echo 'failed getting current option dict' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    local nargs=
    {
      # if nargs is set
      _bash_util__dict__key_value_is_set "${current_option_dict}" "${_BASH_UTIL__ARGS__OPTION__NARGS}" &&
      # then get nargs value
      nargs="$(_bash_util__args__get_option_nargs "${parser_namespace}" "${current_option}")"
    } || {
      case $? in
        "${BASH_UTIL__CODE__FALSE}")
          # nargs is unset, default to null string
          nargs=''
          ;;
        *)
          # failed
          echo 'failed checking if option nargs was set' | bash_util__log__error
          return "${BASH_UTIL__CODE__GENERAL_ERROR}"
          ;;
      esac
    }

    local nargs_pattern=
    nargs_pattern="$(_bash_util__args__get_nargs_pattern "${nargs}" "${BASH_UTIL__BOOL__TRUE}")" || {
      echo 'failed getting option nargs pattern' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # if we don't find a match
    [[ "${pattern}" =~ ${nargs_pattern} ]] || {
      case "${nargs}" in
        '')
          echo "expected one argument for option: '${current_option}'" | bash_util__log__error
          ;;
        "${BASH_UTIL__ARGS__NARGS__OPTIONAL}")
          echo "expected at most one argument for option: '${current_option}'" | bash_util__log__error
          ;;
        "${BASH_UTIL__ARGS__NARGS__ONE_OR_MORE}")
          echo "expected at least one argument for option: '${current_option}'" | bash_util__log__error
          ;;
        *)
          echo "expected ${nargs} argument(s) for option: '${current_option}'" | bash_util__log__error
          ;;
      esac

      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # get count of arguments matched
    local arg_count=
    arg_count="${#BASH_REMATCH[1]}"

    # get args slice for option
    local option_args=
    option_args=( "${args[@]:start_index:arg_count}" )

    # process option with args
    ## echo "(debug) processing option arg: ${current_option}" | bash_util__log__error
    ## echo "(debug) with args: ${option_args[*]}" | bash_util__log__error

    processed_options+=("${current_option}")

    _bash_util__args__get_option_values "${parser_namespace}" "${current_option}" ${option_args+"${option_args[@]}"} || {
      echo "failed processing values for option: '${current_option}'" | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # calculate the stop index
    local stop_index=
    stop_index="$((start_index + arg_count))"

    # set the output value
    bash_util__int__assign "${output_var_name}" "${stop_index}" || {
      echo 'failed to set output value' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }
  }

  # ============================================================================
  # args - _parse_known_args__check_required_args
  # ============================================================================
  _bash_util__args__parse_known_args__check_required_args() {
    # input> parser_namespace
    # input> processed_positionals
    # input> processed_options
    # output> required_positionals
    # output> required_options

    {
      # get positional dict
      local positional_dict= &&
      positional_dict="$(_bash_util__args__get_positional_dict "${parser_namespace}")" &&

      # get positional dict keys
      local positional_dict_keys= &&
      positional_dict_keys=( $(_bash_util__dict__keys "${positional_dict}") )
    } || {
      echo 'failed getting positional dict keys' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # iterate through each positional key
    # and determine if positionals are required
    # if positionals can be defaulted when unspecified
    # then they aren't required
    local positional=
    for positional in "${positional_dict_keys[@]}"
    do
      # check if positional was already processed
      {
        _bash_util__list__contains 'processed_positionals' "${positional}" &&
        continue
      } || {
        case $? in
          "${BASH_UTIL__CODE__FALSE}")
            # not processed, proceed
            ;;
          *)
            # failed
            echo 'failed checking if positional was already processed' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
        esac
      }

      # get positional arg dict
      local positional_arg_dict=
      positional_arg_dict="$(_bash_util__args__get_positional_arg_dict "${parser_namespace}" "${positional}")" || {
        echo 'failed getting positional arg dict' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      # check if nargs is set
      {
        _bash_util__dict__key_value_is_set "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__NARGS}"
      } || {
        case $? in
          "${BASH_UTIL__CODE__FALSE}")
            # nargs is not set, mark as required
            required_positionals+=("${positional}")
            continue
            ;;
          *)
            # failed
            echo 'failed checking if positional nargs key value was set' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
        esac
      }

      # get nargs value
      local nargs=
      nargs="$(_bash_util__dict__get_key_value "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__NARGS}")" || {
        echo 'failed getting positional nargs value' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      # if nargs is not OPTIONAL or ZERO_OR_MORE or PARSER
      if [[ "${nargs}" != "${BASH_UTIL__ARGS__NARGS__OPTIONAL}" && \
           "${nargs}" != "${BASH_UTIL__ARGS__NARGS__ZERO_OR_MORE}" && \
           "${nargs}" != "${BASH_UTIL__ARGS__NARGS__PARSER}" ]]
      then
        # then it's required
        required_positionals+=("${positional}")
        continue
      fi

      # check if nargs is ZERO_OR_MORE or PARSER and missing a default
      if [[ "${nargs}" = "${BASH_UTIL__ARGS__NARGS__ZERO_OR_MORE}" || \
            "${nargs}" = "${BASH_UTIL__ARGS__NARGS__PARSER}" ]]
      then
        # check if default key exists and is set
        {
          _bash_util__dict__has_key "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}" &&

          _bash_util__dict__key_value_is_set "${positional_arg_dict}" "${_BASH_UTIL__ARGS__POSITIONAL__DEFAULT}"
        } || {
          case $? in
            "${BASH_UTIL__CODE__FALSE}")
              # default is not set, mark as required
              required_positionals+=("${positional}")
              continue
              ;;
            *)
              # failed
              echo 'failed checking if positional default key value was set' | bash_util__log__error
              return "${BASH_UTIL__CODE__GENERAL_ERROR}"
              ;;
          esac
        }
      fi

      # if nargs is PARSER and it is not the only positional argument
      if [[ "${nargs}" = "${BASH_UTIL__ARGS__NARGS__PARSER}" && "${#positional_dict_keys[@]}" -ne 1 ]]
      then
        required_positionals+=("${positional}")
        continue
      fi
    done

    {
      # get options dict
      local options_dict= &&
      options_dict="$(_bash_util__args__get_options_dict "${parser_namespace}")" &&

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
      # check if option was already processed
      {
        _bash_util__list__contains 'processed_options' "${option}" &&
        continue
      } || {
        case $? in
          "${BASH_UTIL__CODE__FALSE}")
            # not processed, proceed
            ;;
          *)
            # failed
            echo 'failed checking if option was already processed' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
        esac
      }

      # get option dict
      local option_dict=
      option_dict="$(_bash_util__args__get_option_dict "${parser_namespace}" "${option}")" || {
        echo 'failed getting option dict' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      # get required flag value for option
      local option_required=
      option_required="$(_bash_util__dict__get_key_value "${option_dict}" "${_BASH_UTIL__ARGS__OPTION__REQUIRED}")" || {
        echo 'failed getting option required flag value' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      # if option required flag is true
      if bash_util__bool__value_is_true "${option_required}"
      then
        # add to list of required options
        required_options+=("${option}")
      fi
    done

    return "${BASH_UTIL__CODE__OK}"
  }

  # ============================================================================
  # args - _parse_known_args__main
  # ============================================================================

  local parser_namespace=
  parser_namespace="${1}"

  local args=
  args=("${@:2}")

  local args_pattern=

  #
  # set default values
  #

  _bash_util__args__parse_known_args__set_default_values ||
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"

  #
  # build the arg pattern
  #

  local option_string_indices=
  option_string_indices=()

  # for each arg passed in
  local iter=
  for (( iter=0; iter<"${#args[@]}"; iter++ ))
  do
    # if the arg is '--'
    if bash_util__string__equals "${args[$iter]}" '--'
    then
      # mark remaining args as positional
      bash_util__string__append 'args_pattern' '-'
      
      # increment iterator
      iter=$((iter+1))
      
      local arg_string=
      for arg_string in "${args[@]:$iter}"
      do
        # add each remaining arg as an 'A'
        ## echo "(debug) adding remaining args as A: ${arg_string}" | bash_util__log__info
        bash_util__string__append 'args_pattern' 'A'
      done

      # exit the loop
      break
    else
      {
        # look for matching option
        local found_option=
        found_option="$(_bash_util__args__parse_option "${parser_namespace}" "${args[$iter]}")" &&

        ## echo "(debug) option arg found: '${args[$iter]}'" | bash_util__log__info &&

        # set option index at current iter to found option
        option_string_indices[$iter]="${found_option}" &&

        # add as option
        bash_util__string__append 'args_pattern' 'O'
      } || {
        case $? in
          "${BASH_UTIL__CODE__NOT_FOUND}")
            # option not found, must be a positional
            ## echo "(debug) positional arg found: '${args[$iter]}'" | bash_util__log__info
            bash_util__string__append 'args_pattern' 'A'
            ;;
          *)
            echo 'failed searching for matching option' | bash_util__log__error
            return "${BASH_UTIL__CODE__GENERAL_ERROR}"
            ;;
        esac
      }
    fi
  done

  ## echo "(debug) arg pattern: ${args_pattern}" | bash_util__log__info
  ## echo "(debug) option indices: ${!option_string_indices[*]}" | bash_util__log__info

  #
  # consume options and positional
  #

  local processed_positionals=()
  local processed_options=()

  # get positional dict
  local positional_dict=
  positional_dict="$(_bash_util__args__get_positional_dict "${parser_namespace}")" || {
    echo 'failed getting positional dict' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # get the list of positional keys
  # which will be mutated when we consume positionals
  local positional_keys=
  positional_keys=( $(_bash_util__dict__keys "${positional_dict}") ) || {
    echo 'failed getting positional dict keys' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  ## echo "(debug) positional dict keys: ${positional_keys[*]}" | bash_util__log__info

  local extras=
  extras=()

  local current_index=
  current_index=0

  # get max index for option string list
  local max_option_string_index=
  max_option_string_index="$(_bash_util__list__get_max_index 'option_string_indices')" || {
    echo 'failed getting max index for option string list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # if we got no value, default to -1
  if [[ -z "${max_option_string_index}" ]]
  then
    max_option_string_index=-1
  fi

  ## echo "(debug) max option string index: ${max_option_string_index}" | bash_util__log__info

  # consume positional and options
  while [[ "${current_index}" -le "${max_option_string_index}" ]]
  do
    # get next option string index
    local next_option_string_index=
    next_option_string_index="$(_bash_util__list__get_min_index 'option_string_indices' "${current_index}")" || {
      echo 'failed getting next option string index' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # consume positional preceeding the next option string
    if [[ "${current_index}" != "${next_option_string_index}" ]]
    then
      local positional_end_index=
      _bash_util__args__parse_known_args__consume_positional "${current_index}" 'positional_end_index' || {
        echo 'failed to consume positional args preceeding next option string' | bash_util__log__error
        return "${BASH_UTIL__CODE__GENERAL_ERROR}"
      }

      ## echo "(debug) positional end index: ${positional_end_index}" | bash_util__log__error

      # if the next option was already consumed during positional processing
      # then skip that option
      if [[ "${positional_end_index}" -gt "${current_index}" ]]
      then
        current_index="${positional_end_index}"
        continue
      else
        current_index="${positional_end_index}"
      fi
    fi

    # get option string indices... indices
    local option_string_indices__indices=
    option_string_indices__indices=( $(_bash_util__list__indices 'option_string_indices') ) || {
      echo 'failed getting indices from option indices list' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    # check if the current index is an option string index
    {
      _bash_util__list__contains 'option_string_indices__indices' "${current_index}"
    } || {
      case $? in
        "${BASH_UTIL__CODE__FALSE}")
          # if not, then there were extra positional arguments
          # slice and store in extras
          extras+=( "${args[@]:current_index:next_option_string_index - current_index}" )
          # move current index to next option string index
          current_index="${next_option_string_index}"
          ;;
        *)
          echo 'failed checking option string indices list for current index' | bash_util__log__error
          return "${BASH_UTIL__CODE__GENERAL_ERROR}"
          ;;
      esac
    }

    # consume option
    _bash_util__args__parse_known_args__consume_option "${current_index}" 'current_index' || {
      echo 'failed to consume option' | bash_util__log__error
      return "${BASH_UTIL__CODE__GENERAL_ERROR}"
    }

    ## echo "(debug) current index after option consumption: ${current_index}" | bash_util__log__info
  done

  ## echo "(debug) positional dict keys post options: ${positional_keys[*]}" | bash_util__log__info

  # consume positionals following the last option
  local final_index=
  _bash_util__args__parse_known_args__consume_positional "${current_index}" 'final_index' || {
    echo 'failed to consume positional args following last option' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  ## echo "(debug) positional dict keys post final: ${positional_keys[*]}" | bash_util__log__info

  ## echo "(debug) final index: ${final_index}" | bash_util__log__info

  # add any remaining args to the extras list
  extras+=( "${args[@]:final_index}" )

  ## echo "(debug) extras: ${extras[*]}" | bash_util__log__info

  # get extras key list
  local extras_key_list=
  extras_key_list="$(_bash_util__args__get_extras_list "${parser_namespace}")" || {
    echo 'failed getting extras key list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  # clone extras to extras key list
  _bash_util__list__clone 'extras' "${extras_key_list}" || {
    echo 'failed cloning extras to extras key list' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  local required_positionals=()
  local required_options=()

  # check if any required args were not provided
  _bash_util__args__parse_known_args__check_required_args ||
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"

  # if we have any required arguments
  if [[ "${#required_positionals[@]}" -gt 0 ]] || [[ "${#required_options[@]}" -gt 0 ]]
  then
    # if positionals are required
    if [[ "${#required_positionals[@]}" -gt 0 ]]
    then
      # print required positionals
      echo "the following positional args are required: ${required_positionals[*]}" | bash_util__log__error
    fi

    # if options are required
    if [[ "${#required_options[@]}" -gt 0 ]]
    then
      # print required options
      echo "the following options are required: ${required_options[*]}" | bash_util__log__error
    fi

    # return error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi
}

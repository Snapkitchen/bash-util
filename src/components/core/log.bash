# ==============================================================================
# log - private constants
# ==============================================================================

# colors
readonly _BASH_UTIL__LOG__COLOR__ERROR="\e[91m"
readonly _BASH_UTIL__LOG__COLOR__DEBUG="\e[92m"
readonly _BASH_UTIL__LOG__COLOR__WARNING="\e[93m"
readonly _BASH_UTIL__LOG__COLOR__VERBOSE="\e[37m"
readonly _BASH_UTIL__LOG__COLOR__INFO="\e[39m"
readonly _BASH_UTIL__LOG__COLOR__TRACE="\e[35m"
readonly _BASH_UTIL__LOG__COLOR__RESET="\e[0m"

# types
readonly _BASH_UTIL__LOG__TYPE__ERROR="ERROR"
readonly _BASH_UTIL__LOG__TYPE__INFO="INFO"
readonly _BASH_UTIL__LOG__TYPE__WARNING="WARNING"
readonly _BASH_UTIL__LOG__TYPE__VERBOSE="VERBOSE"
readonly _BASH_UTIL__LOG__TYPE__DEBUG="DEBUG"
readonly _BASH_UTIL__LOG__TYPE__TRACE="TRACE"

# switches
readonly _BASH_UTIL__LOG__SWITCH__OFF=0
readonly _BASH_UTIL__LOG__SWITCH__ON=1

# ==============================================================================
# log - private variables
# ==============================================================================

# switches
: "${_BASH_UTIL__LOG__VERBOSE_ENABLED:=0}"
: "${_BASH_UTIL__LOG__DEBUG_ENABLED:=0}"
: "${_BASH_UTIL__LOG__TRACE_ENABLED:=0}"
: "${_BASH_UTIL__LOG__SLIM_ENABLED:=0}"
: "${_BASH_UTIL__LOG__COLOR_ENABLED:=1}"

# default type
: "${_BASH_UTIL__LOG__DEFAULT_TYPE:="${_BASH_UTIL__LOG__TYPE__INFO}"}"

# ==============================================================================
# log - functional core
# ==============================================================================

# prints a log message to stderr
_bash_util__log__print_stderr() {
  printf >&2 "%s\n" "${1}"
}

# ==============================================================================

# prints a log message to stdout
_bash_util__log__print_stdout() {
  printf "%s\n" "${1}"
}

# ==============================================================================

# returns exit code indicating if switch is on
_bash_util__log__switch_is_on() {
  [[ "${1}" = "${_BASH_UTIL__LOG__SWITCH__ON}" ]]
}

# ==============================================================================

# returns exit code indicating if switch is off
_bash_util__log__switch_is_off() {
  [[ "${1}" = "${_BASH_UTIL__LOG__SWITCH__OFF}" ]]
}

# ==============================================================================

# returns exit code indicating if message type is valid
_bash_util__log__message_type_valid() {
  local message_type="${1}"

  case "$message_type" in
    "${_BASH_UTIL__LOG__TYPE__ERROR}"|\
    "${_BASH_UTIL__LOG__TYPE__DEBUG}"|\
    "${_BASH_UTIL__LOG__TYPE__WARNING}"|\
    "${_BASH_UTIL__LOG__TYPE__VERBOSE}"|\
    "${_BASH_UTIL__LOG__TYPE__INFO}"|\
    "${_BASH_UTIL__LOG__TYPE__TRACE}")
      return "${BASH_UTIL__CODE__TRUE}"
      ;;
    *)
      return "${BASH_UTIL__CODE__FALSE}"
  esac
}

# ==============================================================================

# colorizes message
_bash_util__log__colorize_message() {
  local message_type="${1}"
  local message="${2}"
  local color_suffix="${_BASH_UTIL__LOG__COLOR__RESET}"
  local color_prefix=

  case "$message_type" in
    "${_BASH_UTIL__LOG__TYPE__ERROR}")
      color_prefix="${_BASH_UTIL__LOG__COLOR__ERROR}"
      ;;
    "${_BASH_UTIL__LOG__TYPE__DEBUG}")
      color_prefix="${_BASH_UTIL__LOG__COLOR__DEBUG}"
      ;;
    "${_BASH_UTIL__LOG__TYPE__WARNING}")
      color_prefix="${_BASH_UTIL__LOG__COLOR__WARNING}"
      ;;
    "${_BASH_UTIL__LOG__TYPE__VERBOSE}")
      color_prefix="${_BASH_UTIL__LOG__COLOR__VERBOSE}"
      ;;
    "${_BASH_UTIL__LOG__TYPE__INFO}")
      color_prefix="${_BASH_UTIL__LOG__COLOR__INFO}"
      ;;
    "${_BASH_UTIL__LOG__TYPE__TRACE}")
      color_prefix="${_BASH_UTIL__LOG__COLOR__TRACE}"
      ;;
  esac

  printf "%b%s%b\n" "${color_prefix}" "${message}" "${color_suffix}"
}

# ==============================================================================

# decorates a message
_bash_util__log__decorate_message() {
  local message_type="${1}"
  local timestamp="${2}"
  local file_name="${3}"
  local function_name="${4}"
  local message="${5}"
  
  printf "%s | %-7s | %s | %s | %s\n" "${timestamp}" "${message_type}" "${file_name}" "${function_name}" "${message}"
}

# ==============================================================================

# prints a message
_bash_util__log__print_message() {
  # flags
  local sw_slim="${1}"
  local sw_color="${2}"
  local sw_stderr="${3}"
  # variables
  local message_type="${4}"
  local timestamp="${5}"
  local file_name="${6}"
  local function_name="${7}"
  local message="${8}"
  
  # decorate if slim is disabled
  if _bash_util__log__switch_is_off "${sw_slim}"
  then
    message="$(\
      _bash_util__log__decorate_message \
        "${message_type}" \
        "${timestamp}" \
        "${file_name}" \
        "${function_name}" \
        "${message}")"
  fi
  
  # colorize if color is enabled
  if _bash_util__log__switch_is_on "${sw_color}"
  then
    message="$(\
      _bash_util__log__colorize_message \
        "${message_type}" \
        "${message}")"
  fi
  
  # print the message to stderr or stdout
  if _bash_util__log__switch_is_on "${sw_stderr}"
  then
    _bash_util__log__print_stderr "${message}"
  else
    _bash_util__log__print_stdout "${message}"
  fi
}

# ==============================================================================

# reads input and prints messages for each line
_bash_util__log__read_message_lines() {  
  while IFS= read -r stdin_message || [[ -n "$stdin_message" ]]; do
    _bash_util__log__print_message "${@}" "${stdin_message}"
  done || :
}

# ==============================================================================
# log - private message helpers
# ==============================================================================

# gets a timestamp for the decorator
_bash_util__log__decorate__timestamp() {
  local timestamp=
  timestamp=$(bash_util__datetime__utc 2>/dev/null)
  
  if [[ $? -ne 0 || -z "${timestamp}" ]]; then
    timestamp="0000-00-00T00:00:00Z"
  fi
  
  printf '%s\n' "${timestamp}"
}

# ==============================================================================

# gets a file name for the decorator
_bash_util__log__decorate__file_name() {
  local file_name=
  file_name=$(bash_util__common__file_name 2>/dev/null)
  
  if [[ $? -ne 0 || -z "${file_name}" ]]; then
    file_name="UNKNOWN"
  fi
  
  printf '%s\n' "${file_name}"
}

# ==============================================================================

# gets a function name for the decorator
_bash_util__log__decorate__function_name() {
  local function_depth=${1}
  local function_name=
  function_name="$(bash_util__common__function_name "${function_depth}" 2>/dev/null)"
  
  if [[ $? -ne 0 || -z "${function_name}" ]]; then
    function_name="UNKNOWN"
  fi
  
  printf '%s\n' "${function_name}"
}

# ==============================================================================

_bash_util__log__message_type() {
  # if message type is disabled
  # read the incoming pipe and return immediately
  bash_util__log__message_type_enabled "${1:-}" || {
    while IFS= read -r stdin_message || [[ -n "$stdin_message" ]]; do
      true
    done || return "${BASH_UTIL__CODE__OK}"
  }

  local message_type="${1}"
  local function_depth_offset="${2:-0}"
  local function_depth=4

  # allow modifying function depth by an offset
  function_depth=$((function_depth + function_depth_offset))
  
  local message_args=()

  if bash_util__log__slim_enabled
  then
    message_args[0]="${_BASH_UTIL__LOG__SWITCH__ON}" # sw_slim
    message_args[5]='' # timestamp
    message_args[6]='' # file_name
    message_args[7]='' # function_name
  else
    message_args[0]="${_BASH_UTIL__LOG__SWITCH__OFF}" # sw_slim
    message_args[5]="$(_bash_util__log__decorate__timestamp)" # timestamp
    message_args[6]="$(_bash_util__log__decorate__file_name)" # file_name
    message_args[7]="$(_bash_util__log__decorate__function_name "${function_depth}")" # function_name
  fi

  # sw_color
  if bash_util__log__color_enabled
  then
    message_args[1]="${_BASH_UTIL__LOG__SWITCH__ON}"
  else
    message_args[1]="${_BASH_UTIL__LOG__SWITCH__OFF}"
  fi

  # sw_stderr
  if bash_util__log__message_type_stderr "${message_type}"
  then
    message_args[2]="${_BASH_UTIL__LOG__SWITCH__ON}"
  else
    message_args[2]="${_BASH_UTIL__LOG__SWITCH__OFF}"
  fi

  # message_type
  message_args[3]="${message_type}"

  # pass args to read_message_lines
  _bash_util__log__read_message_lines "${message_args[@]}"
}

# ==============================================================================
# log - private execution helpers
# ==============================================================================

# executes a command with args
#   and automatically logs stdout to the
#   specified type
#   as well as stderr to error
#   and returns the exit code
_bash_util__log__execute() {
  local message_type="${1}"
  shift
  local exit_code=
  exec 3>&1 4>&2 # set up extra file descriptors
  {
    # execute it
    "${@}" | _bash_util__log__message_type "${message_type}" 1 2>&4 1>&3 &&
    return "${PIPESTATUS[0]}"
  } 2>&1 | _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__ERROR}" 1
  exit_code="${PIPESTATUS[0]}"
  exec 3>&- 4>&- # release the extra file descriptors
  return "${exit_code}"
}

# ==============================================================================

# executes a command with args
#   and automatically logs stdout + stderr to the
#   specified type
#   and returns the exit code
_bash_util__log__execute_force_stdout() {
  local message_type="${1}"
  shift

  "${@}" 2>&1 | _bash_util__log__message_type "${message_type}" 1

  return "${PIPESTATUS[0]}"
}

# ==============================================================================

# executes a command with args
#   and automatically logs stdout + stderr to the
#   specified type
#   and dumps to stderr
#   if a nonzero exit code is returned
#   and returns the exit code
_bash_util__log__execute_force_stdout_with_error_dump() {
  local message_type="${1}"
  shift
  local exit_code=
  local output=
  exec 3>&1 4>&2 # set up extra file descriptors
  output="$(
  {
    # execute it
    "${@}" 2>&1 | tee /dev/stderr | _bash_util__log__message_type "${message_type}" 1 2>&4 1>&3 &&
    return "${PIPESTATUS[0]}"
  } 2>&1
  )"
  exit_code="${PIPESTATUS[0]}"
  exec 3>&- 4>&- # release the extra file descriptors

  # dump error output on non-zero exit code
  if [[ "${exit_code}" -ne 0 ]]
  then
    echo "--- begin: ${1+"${1} "}output ---" | _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__ERROR}" 1
    echo "${output}" | _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__ERROR}" 1
    echo "--- end: ${1+"${1} "}output ---" | _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__ERROR}" 1
  fi

  return "${exit_code}"
}

# ==============================================================================

# executes a command with args
#   combining stdout and stderr
#   and dumps output to error
#   if a nonzero exit code is returned
#   and returns the exit code
_bash_util__log__execute_raw_force_stdout_with_error_dump() {
  local exit_code=
  local output=
  exec 3>&1 # set up extra file descriptors
  output="$(
  {
    # execute it
    "${@}" 2>&1 | tee /dev/stderr 1>&3 &&
    return "${PIPESTATUS[0]}"
  } 2>&1
  )"
  exit_code="${PIPESTATUS[0]}"
  exec 3>&- # release the extra file descriptors

  # dump error output on non-zero exit code
  if [[ "${exit_code}" -ne 0 ]]
  then
    echo "--- begin: ${1+"${1} "}output ---" | _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__ERROR}" 1
    echo "${output}" | _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__ERROR}" 1
    echo "--- end: ${1+"${1} "}output ---" | _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__ERROR}" 1
  fi

  return "${exit_code}"
}

# ==============================================================================

# executes a command with args
#   and logs stderr to error
#   and returns the exit code
_bash_util__log__execute_raw() {
  local exit_code=
  exec 3>&1 # set up extra file descriptors
  {
    # execute it
    "${@}" 1>&3
  } 2>&1 | _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__ERROR}" 1
  exit_code="${PIPESTATUS[0]}"
  exec 3>&- # release the extra file descriptors
  return "${exit_code}"
}

# ==============================================================================
# log - public api - log message types
# ==============================================================================

#
# logs a message using the default type
#
# inputs:
#   stdin) message
# outputs:
#   stdout) message
#   0) success
#
bash_util__log__default() {
  _bash_util__log__message_type "$(bash_util__log__get_default_message_type)" ${1+"${1}"}
}

# ==============================================================================

#
# logs an error message
#
# inputs:
#   stdin) message
# outputs:
#   stderr) message
#   0) success
#
bash_util__log__error() {
  _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__ERROR}" ${1+"${1}"}
}

# ==============================================================================

#
# logs an info message
#
# inputs:
#   stdin) message
#   1) function offset (optional)
# outputs:
#   stdout) message
#   0) success
#
bash_util__log__info() {
  _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__INFO}" ${1+"${1}"}
}

# ==============================================================================

#
# logs a warning message
#
# inputs:
#   stdin) message
# outputs:
#   stdout) message
#   0) success
#
bash_util__log__warning() {
  _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__WARNING}" ${1+"${1}"}
}

# ==============================================================================

#
# logs a debug message
#
# inputs:
#   stdin) message
# outputs:
#   stdout) message
#   0) success
#
bash_util__log__debug() {
  _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__DEBUG}" ${1+"${1}"}
}

# ==============================================================================

#
# logs a verbose message
#
# inputs:
#   stdin) message
# outputs:
#   stdout) message
#   0) success
#
bash_util__log__verbose() {
  _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__VERBOSE}" ${1+"${1}"}
}

# ==============================================================================

#
# logs a trace message
#
# inputs:
#   stdin) message
# outputs:
#   stdout) message
#   0) success
#
bash_util__log__trace() {
  _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__TRACE}" ${1+"${1}"}
}

# ==============================================================================

#
# logs a trace 'begin'
#   message with an
#   optional description
#
# inputs:
#   1) description
# outputs:
#   stdout) message
#   0) success
#
bash_util__log__trace__begin() {
  echo "begin${1+": ${1}"}" | _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__TRACE}"
}

# ==============================================================================

#
# logs a trace 'end'
#   message with an
#   optional description
#
# inputs:
#   1) description
# outputs:
#   stdout) message
#   0) success
#
bash_util__log__trace__end() {
  echo "end${1+": ${1}"}" | _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__TRACE}"
}

# ==============================================================================

#
# logs a trace 'error'
#   message with an
#   optional description
#
# inputs:
#   1) description
# outputs:
#   stdout) message
#   0) success
#
bash_util__log__trace__error() {
  echo "error${1+": ${1}"}" | _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__TRACE}"
}

# ==============================================================================

#
# logs a trace 'end'
#   message which calculates
#   total duration
#   using the starting timestamp
#   and optional description
#
# inputs:
#   1) starting timestamp
#   2) description
# outputs:
#   stdout) message
#   0) success
#
bash_util__log__trace__end_timer() {
  local time_start="${1}"
  local time_stop="$(date +%s)" || {
      time_stop="${time_start}"
  }
  echo "end${2+": ${2}"} [$((time_stop - time_start))s]" | _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__TRACE}"
}

# ==============================================================================

#
# logs a trace 'error'
#   message which calculates
#   total duration
#   using the starting timestamp
#   and optional description
#
# inputs:
#   1) starting timestamp
#   2) description
# outputs:
#   stdout) message
#   0) success
#
bash_util__log__trace__error_timer() {
  local time_start="${1}"
  local time_stop="$(date +%s)" || {
      time_stop="${time_start}"
  }
  echo "error${2+": ${2}"} [$((time_stop - time_start))s]" | _bash_util__log__message_type "${_BASH_UTIL__LOG__TYPE__TRACE}"
}

# ==============================================================================
# log - public api - execution helpers
# ==============================================================================

#
# executes a command with args
#   and automatically logs stdout
#   as default
#   as well as stderr to error
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout from command
#   stderr) logged stderr from command
#   X) exit code from command
#
bash_util__log__execute_default() {
  _bash_util__log__execute "$(bash_util__log__get_default_message_type)" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   forcing stderr to stdout
#   and automatically logs stdout
#   as default
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout + stderr from command
#   X) exit code from command
#
bash_util__log__execute_force_default() {
  _bash_util__log__execute_force_stdout "$(bash_util__log__get_default_message_type)" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   forcing stderr to stdout
#   and automatically logs stdout
#   as default
#   and dumps stderr to error
#   on non-zero exit code
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout + stderr from command
#   stderr) dumped stdout + stderr from command on non-zero exit code
#   X) exit code from command
#
bash_util__log__execute_force_default_with_error_dump() {
  _bash_util__log__execute_force_stdout_with_error_dump "$(bash_util__log__get_default_message_type)" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   and automatically logs stdout
#   as info
#   as well as stderr to error
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout from command
#   stderr) logged stderr from command
#   X) exit code from command
#
bash_util__log__execute_info() {
  _bash_util__log__execute "${_BASH_UTIL__LOG__TYPE__INFO}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   forcing stderr to stdout
#   and automatically logs stdout
#   as info
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout + stderr from command
#   X) exit code from command
#
bash_util__log__execute_force_info() {
  _bash_util__log__execute_force_stdout "${_BASH_UTIL__LOG__TYPE__INFO}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   forcing stderr to stdout
#   and automatically logs stdout
#   as info
#   and dumps stderr to error
#   on non-zero exit code
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout + stderr from command
#   stderr) dumped stdout + stderr from command on non-zero exit code
#   X) exit code from command
#
bash_util__log__execute_force_info_with_error_dump() {
  _bash_util__log__execute_force_stdout_with_error_dump "${_BASH_UTIL__LOG__TYPE__INFO}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   and automatically logs stdout
#   as warning
#   as well as stderr to error
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout from command
#   stderr) logged stderr from command
#   X) exit code from command
#
bash_util__log__execute_warning() {
  _bash_util__log__execute "${_BASH_UTIL__LOG__TYPE__WARNING}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   forcing stderr to stdout
#   and automatically logs stdout
#   as warning
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout + stderr from command
#   X) exit code from command
#
bash_util__log__execute_force_warning() {
  _bash_util__log__execute_force_stdout "${_BASH_UTIL__LOG__TYPE__WARNING}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   forcing stderr to stdout
#   and automatically logs stdout
#   as warning
#   and dumps stderr to error
#   on non-zero exit code
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout + stderr from command
#   stderr) dumped stdout + stderr from command on non-zero exit code
#   X) exit code from command
#
bash_util__log__execute_force_warning_with_error_dump() {
  _bash_util__log__execute_force_stdout_with_error_dump "${_BASH_UTIL__LOG__TYPE__WARNING}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   and automatically logs stdout
#   as debug
#   as well as stderr to error
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout from command
#   stderr) logged stderr from command
#   X) exit code from command
#
bash_util__log__execute_debug() {
  _bash_util__log__execute "${_BASH_UTIL__LOG__TYPE__DEBUG}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   forcing stderr to stdout
#   and automatically logs stdout
#   as debug
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout + stderr from command
#   X) exit code from command
#
bash_util__log__execute_force_debug() {
  _bash_util__log__execute_force_stdout "${_BASH_UTIL__LOG__TYPE__DEBUG}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   forcing stderr to stdout
#   and automatically logs stdout
#   as debug
#   and dumps stderr to error
#   on non-zero exit code
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout + stderr from command
#   stderr) dumped stdout + stderr from command on non-zero exit code
#   X) exit code from command
#
bash_util__log__execute_force_debug_with_error_dump() {
  _bash_util__log__execute_force_stdout_with_error_dump "${_BASH_UTIL__LOG__TYPE__DEBUG}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   and automatically logs stdout
#   as verbose
#   as well as stderr to error
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout from command
#   stderr) logged stderr from command
#   X) exit code from command
#
bash_util__log__execute_verbose() {
  _bash_util__log__execute "${_BASH_UTIL__LOG__TYPE__VERBOSE}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   forcing stderr to stdout
#   and automatically logs stdout
#   as verbose
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout + stderr from command
#   X) exit code from command
#
bash_util__log__execute_force_verbose() {
  _bash_util__log__execute_force_stdout "${_BASH_UTIL__LOG__TYPE__VERBOSE}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   forcing stderr to stdout
#   and automatically logs stdout
#   as verbose
#   and dumps stderr to error
#   on non-zero exit code
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout + stderr from command
#   stderr) dumped stdout + stderr from command on non-zero exit code
#   X) exit code from command
#
bash_util__log__execute_force_verbose_with_error_dump() {
  _bash_util__log__execute_force_stdout_with_error_dump "${_BASH_UTIL__LOG__TYPE__VERBOSE}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   and automatically logs stdout
#   as trace
#   as well as stderr to error
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout from command
#   stderr) logged stderr from command
#   X) exit code from command
#
bash_util__log__execute_trace() {
  _bash_util__log__execute "${_BASH_UTIL__LOG__TYPE__TRACE}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   forcing stderr to stdout
#   and automatically logs stdout
#   as trace
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout + stderr from command
#   X) exit code from command
#
bash_util__log__execute_force_trace() {
  _bash_util__log__execute_force_stdout "${_BASH_UTIL__LOG__TYPE__TRACE}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   forcing stderr to stdout
#   and automatically logs stdout
#   as trace
#   and dumps stderr to error
#   on non-zero exit code
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) logged stdout + stderr from command
#   stderr) dumped stdout + stderr from command on non-zero exit code
#   X) exit code from command
#
bash_util__log__execute_force_trace_with_error_dump() {
  _bash_util__log__execute_force_stdout_with_error_dump "${_BASH_UTIL__LOG__TYPE__TRACE}" "${@}"
}

# ==============================================================================

#
# executes a command with args
#   outputting stdout as is
#   and automatically logs 
#   stderr to error
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) stdout from command
#   stderr) logged stderr from command
#   X) exit code from command
#
bash_util__log__execute_raw() {
  _bash_util__log__execute_raw "${@}"
}

# ==============================================================================

#
# executes a command with args
#   outputting stdout+stderr to stdout
#   and dumps stderr to error
#   on non-zero exit code
#   and returns the exit code
#
# inputs:
#   @) command and args
# outputs:
#   stdout) stdout from command
#   stderr) logged stderr from command
#   X) exit code from command
#
bash_util__log__execute_raw_force_stdout_with_error_dump() {
  _bash_util__log__execute_raw_force_stdout_with_error_dump "${@}"
}

# ==============================================================================
# log - public api - log settings
# ==============================================================================

#
# sets the default message type
#
# inputs:
#   1) message type
# outputs:
#   0) success
#
bash_util__log__set_default_message_type() {
  local message_type="${1}"
  
  if ! _bash_util__log__message_type_valid "${message_type}"; then
    printf "invalid message type '%s'\n" "${message_type}" | bash_util__log__error
    return "${BASH_UTIL__CODE__INVALID}"
  fi
  
  _BASH_UTIL__LOG__DEFAULT_TYPE="${message_type}"
  
  return "${BASH_UTIL__CODE__OK}"
}

# ==============================================================================

#
# gets the default message type
#
# outputs:
#   stdout) default message type
#
bash_util__log__get_default_message_type() {
  printf "%s\n" "${_BASH_UTIL__LOG__DEFAULT_TYPE}"
}

# ==============================================================================

#
# returns exit code
#   indicating whether or not
#   the input message type
#   is enabled
#
# inputs:
#   1) message type
# outputs:
#   TRUE) enabled
#   FALSE) disabled
#
bash_util__log__message_type_enabled() {
  local message_type="${1}"
  
  case "$message_type" in
    "${_BASH_UTIL__LOG__TYPE__DEBUG}")
      bash_util__log__debug_enabled
      return $?
      ;;
    "${_BASH_UTIL__LOG__TYPE__VERBOSE}")
      bash_util__log__verbose_enabled
      return $?
      ;;
    "${_BASH_UTIL__LOG__TYPE__TRACE}")
      bash_util__log__trace_enabled
      return $?
      ;;
    *)
      return "${BASH_UTIL__CODE__TRUE}"
      ;;
  esac
}

# ==============================================================================

#
# returns exit code
#   indicating whether or not
#   the input message type
#   prints to stderr
#
# inputs:
#   1) message type
# outputs:
#   TRUE) prints to stderr
#   FALSE) prints to stdout
#
bash_util__log__message_type_stderr() {
  local message_type="${1}"
  
  # check if this is an error message
  if [[ "${message_type}" = "${_BASH_UTIL__LOG__TYPE__ERROR}" ]]; then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# log - public api - switch helpers
# ==============================================================================

#
# returns exit status of debug switch or override
#
# outputs:
#   TRUE) debug enabled
#   FALSE) debug disabled
#
bash_util__log__debug_enabled() {
  if _bash_util__log__switch_is_on "${BASH_UTIL__LOG__DEBUG:-}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  elif _bash_util__log__switch_is_off "${BASH_UTIL__LOG__DEBUG:-}"
  then
    return "${BASH_UTIL__CODE__FALSE}"
  elif _bash_util__log__switch_is_on "${_BASH_UTIL__LOG__DEBUG_ENABLED}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================

#
# returns exit status of verbose switch or override
#
# outputs:
#   TRUE) verbose enabled
#   FALSE) verbose disabled
#
bash_util__log__verbose_enabled() {
  if _bash_util__log__switch_is_on "${BASH_UTIL__LOG__VERBOSE:-}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  elif _bash_util__log__switch_is_off "${BASH_UTIL__LOG__VERBOSE:-}"
  then
    return "${BASH_UTIL__CODE__FALSE}"
  elif _bash_util__log__switch_is_on "${_BASH_UTIL__LOG__VERBOSE_ENABLED}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================

#
# returns exit status of trace switch or override
#
# outputs:
#   TRUE) trace enabled
#   FALSE) trace disabled
#
bash_util__log__trace_enabled() {
  if _bash_util__log__switch_is_on "${BASH_UTIL__LOG__TRACE:-}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  elif _bash_util__log__switch_is_off "${BASH_UTIL__LOG__TRACE:-}"
  then
    return "${BASH_UTIL__CODE__FALSE}"
  elif _bash_util__log__switch_is_on "${_BASH_UTIL__LOG__TRACE_ENABLED}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================

#
# returns exit status of color switch or override
#
# outputs:
#   TRUE) color enabled
#   FALSE) color disabled
#
bash_util__log__color_enabled() {
  if _bash_util__log__switch_is_on "${BASH_UTIL__LOG__COLOR:-}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  elif _bash_util__log__switch_is_off "${BASH_UTIL__LOG__COLOR:-}"
  then
    return "${BASH_UTIL__CODE__FALSE}"
  elif _bash_util__log__switch_is_on "${_BASH_UTIL__LOG__COLOR_ENABLED}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================

#
# returns exit status of slim switch or override
#
# outputs:
#   TRUE) slim enabled
#   FALSE) slim disabled
#
bash_util__log__slim_enabled() {
  if _bash_util__log__switch_is_on "${BASH_UTIL__LOG__SLIM:-}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  elif _bash_util__log__switch_is_off "${BASH_UTIL__LOG__SLIM:-}"
  then
    return "${BASH_UTIL__CODE__FALSE}"
  elif _bash_util__log__switch_is_on "${_BASH_UTIL__LOG__SLIM_ENABLED}"
  then
    return "${BASH_UTIL__CODE__TRUE}"
  else
    return "${BASH_UTIL__CODE__FALSE}"
  fi
}

# ==============================================================================
# log - public api - switches
# ==============================================================================

# enables slim switch
bash_util__log__enable_slim() {
  _BASH_UTIL__LOG__SLIM_ENABLED="${_BASH_UTIL__LOG__SWITCH__ON}"
}

# ==============================================================================

# disables slim switch
bash_util__log__disable_slim() {
  _BASH_UTIL__LOG__SLIM_ENABLED="${_BASH_UTIL__LOG__SWITCH__OFF}"
}

# ==============================================================================

# enables color switch
bash_util__log__enable_color() {
  _BASH_UTIL__LOG__COLOR_ENABLED="${_BASH_UTIL__LOG__SWITCH__ON}"
}

# ==============================================================================

# disables color switch
bash_util__log__disable_color() {
  _BASH_UTIL__LOG__COLOR_ENABLED="${_BASH_UTIL__LOG__SWITCH__OFF}"
}

# ==============================================================================

# enables verbose switch
bash_util__log__enable_verbose() {
  _BASH_UTIL__LOG__VERBOSE_ENABLED="${_BASH_UTIL__LOG__SWITCH__ON}"
}

# ==============================================================================

# disables verbose switch
bash_util__log__disable_verbose() {
  _BASH_UTIL__LOG__VERBOSE_ENABLED="${_BASH_UTIL__LOG__SWITCH__OFF}"
}

# ==============================================================================

# enables debug switch
bash_util__log__enable_debug() {
  _BASH_UTIL__LOG__DEBUG_ENABLED="${_BASH_UTIL__LOG__SWITCH__ON}"
}

# ==============================================================================

# disables debug switch
bash_util__log__disable_debug() {
  _BASH_UTIL__LOG__DEBUG_ENABLED="${_BASH_UTIL__LOG__SWITCH__OFF}"
}

# ==============================================================================

# enables debug switch
bash_util__log__enable_trace() {
  _BASH_UTIL__LOG__TRACE_ENABLED="${_BASH_UTIL__LOG__SWITCH__ON}"
}

# ==============================================================================

# disables debug switch
bash_util__log__disable_trace() {
  _BASH_UTIL__LOG__TRACE_ENABLED="${_BASH_UTIL__LOG__SWITCH__OFF}"
}

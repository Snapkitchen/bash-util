# ==============================================================================
# common functions - environment
# ==============================================================================

#
# crawls the function stack list
#   starting from N until it finds a function name
#
# defaults to '1' so you can call this from a function
#   and get the name of that calling function
#
# returns 'unknown' if unable to determine
#
# inputs:
#   1) (optional) starting function depth (default: 1)
# outputs:
#   stdout) function name or 'unknown'
#
bash_util__common__function_name() {
  # default to 1 if unspecified
  local starting_function_depth=${1:-1}
  local function_name="unknown"
  
  # uses seq to count from N down to 0
  for function_depth in $(seq $starting_function_depth 0); do
    # if function depth exists
    if [[ -n "${FUNCNAME[function_depth]:-}" ]]; then
      # use function depth and break from the loop
      function_name="${FUNCNAME[function_depth]:-}"
      break
    fi
  done

  printf "%s\n" "$function_name"
}

# ==============================================================================
# common functions - i/o
# ==============================================================================

#
# attempts to use basename
#   to return the file name
#
# if basename fails
#   returns the full current
#   value of the first argument
#
# outputs:
#   stdout) file name
#
bash_util__common__file_name() {
  local file_name=
  
  # basename will error if called from e.g. '-bash'
  #   check if basename will succeed before using its output
  if basename "$0" 2>/dev/null 1>&2; then
    file_name="$(basename $0)"
  else
    file_name="$0"
  fi
  
  printf "%s\n" "$file_name"
}

#
# sources a script file
#
# inputs:
#   1) script file path
# outputs:
#   0) success
#   1+) error
#
bash_util__common__source_script_file() {
  source "$1"
}

#
# checks if file exists
#
# inputs:
#   1) file path
# outputs:
#   0) file exists
#   1) file does not exist
#
bash_util__common__file_exists() {
  [[ -e "${1}" ]]
}

#
# checks if file is readable
#   by current user
#
# inputs:
#   1) file path
# outputs:
#   0) file readable
#   1) file not readable
#
bash_util__common__file_readable() {
  [[ -r "${1}" ]]
}

# ==============================================================================
# common functions - text
# ==============================================================================

#
# checks if string is null or empty
#
# inputs:
#   1) string
# outputs:
#   0) null or empty
#   1) not null or empty
#
bash_util__common__string_null_or_empty() {
  [[ -z "${1}" ]]
}

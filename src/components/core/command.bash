# ==============================================================================
# command - private constants
# ==============================================================================

# var names
# BASH_UTIL__COMMAND__STATUS
# BASH_UTIL__COMMAND__STDOUT__TYPE
# BASH_UTIL__COMMAND__STDOUT__VALUE
# BASH_UTIL__COMMAND__STDERR__TYPE
# BASH_UTIL__COMMAND__STDERR__VALUE

# ==============================================================================
# command - stderr helpers
# ==============================================================================

# get stderr type
bash_util__command__get_stderr_type() {
  bash_util__type__get_type 'BASH_UTIL__COMMAND__STDERR__TYPE' || {
    echo 'failed to get stderr type' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# get stderr value
bash_util__command__get_stderr_value() {
  bash_util__var__is_set 'BASH_UTIL__COMMAND__STDERR__TYPE' || {
    echo 'stderr value type is unset' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  bash_util__type__get_value 'BASH_UTIL__COMMAND__STDERR__VALUE' "${BASH_UTIL__COMMAND__STDERR__TYPE}" || {
    echo 'failed to get stderr value' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# set stderr type
bash_util__command__set_stderr_type() {
  bash_util__type__set_type 'BASH_UTIL__COMMAND__STDERR__TYPE' ${1+"${1}"} || {
    echo 'failed to set stderr type' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# set stderr value
bash_util__command__set_stderr_value() {
  bash_util__var__is_set 'BASH_UTIL__COMMAND__STDERR__TYPE' || {
    echo 'stderr value type is unset' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  bash_util__type__set_value 'BASH_UTIL__COMMAND__STDERR__VALUE' "${BASH_UTIL__COMMAND__STDERR__TYPE}" ${@+"${@}"} || {
    echo 'failed to set stderr value' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# command - stdout helpers
# ==============================================================================

# get stdout type
bash_util__command__get_stdout_type() {
  bash_util__type__get_type 'BASH_UTIL__COMMAND__STDOUT__TYPE' || {
    echo 'failed to get stdout type' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# get stdout value
bash_util__command__get_stdout_value() {
  bash_util__var__is_set 'BASH_UTIL__COMMAND__STDOUT__TYPE' || {
    echo 'stdout value type is unset' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  bash_util__type__get_value 'BASH_UTIL__COMMAND__STDOUT__VALUE' "${BASH_UTIL__COMMAND__STDOUT__TYPE}" || {
    echo 'failed to get stdout value' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# set stdout type
bash_util__command__set_stdout_type() {
  bash_util__type__set_type 'BASH_UTIL__COMMAND__STDOUT__TYPE' ${1+"${1}"} || {
    echo 'failed to set stdout type' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# set stdout value
bash_util__command__set_stdout_value() {
  bash_util__var__is_set 'BASH_UTIL__COMMAND__STDOUT__TYPE' || {
    echo 'stdout value type is unset' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }

  bash_util__type__set_value 'BASH_UTIL__COMMAND__STDOUT__VALUE' "${BASH_UTIL__COMMAND__STDOUT__TYPE}" ${@+"${@}"} || {
    echo 'failed to set stdout value' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# command - status helpers
# ==============================================================================

# set status code
bash_util__command__set_status() {
  bash_util__type__set_value 'BASH_UTIL__COMMAND__STATUS' "${BASH_UTIL__TYPE__INT}" ${1+"${1}"} || {
    echo 'failed to set status' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# get status code
bash_util__command__get_status() {
  bash_util__type__get_value 'BASH_UTIL__COMMAND__STATUS' "${BASH_UTIL__TYPE__INT}" || {
    echo 'failed to get status' | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  }
}

# ==============================================================================
# command - reset
# ==============================================================================

# clear all output values
bash_util__command__reset() {
  # clear status code
  bash_util__type__destroy_value 'BASH_UTIL__COMMAND__STATUS' "${BASH_UTIL__TYPE__INT}"

  # clear stdout value if present
  if _bash_util__var__is_set 'BASH_UTIL__COMMAND__STDOUT__TYPE'
  then
    bash_util__type__destroy_value 'BASH_UTIL__COMMAND__STDOUT__VALUE' "${BASH_UTIL__COMMAND__STDOUT__TYPE}"
  fi
  
  # clear stdout type
  bash_util__type__destroy_type 'BASH_UTIL__COMMAND__STDOUT__TYPE'

  # clear stderr value if present
  if _bash_util__var__is_set 'BASH_UTIL__COMMAND__STDERR__TYPE'
  then
    bash_util__type__destroy_value 'BASH_UTIL__COMMAND__STDERR__VALUE' "${BASH_UTIL__COMMAND__STDERR__TYPE}"
  fi

  # clear stderr type
  bash_util__type__destroy_type 'BASH_UTIL__COMMAND__STDERR__TYPE'

  return "${BASH_UTIL__CODE__OK}"
}

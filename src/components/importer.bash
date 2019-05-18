# ==============================================================================
# script importer - public api
# ==============================================================================

#
# import script file
#
# inputs:
#   1) script to import
# outputs:
#   0) success
#
bash_util__importer__import_script_file() {
  local script_file="${1:-}"

  if bash_util__common__string_null_or_empty "$script_file"; then
    echo "script_file is unset or empty" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi

  if ! bash_util__common__file_exists "$script_file"; then
    echo "script_file not found at $script_file" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi

  if ! bash_util__common__file_readable "$script_file"; then
    echo "script_file at $script_file must be readable by current user" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi

  if ! bash_util__common__source_script_file "$script_file"; then
    echo "failed importing script file $script_file" | bash_util__log__error
    return "${BASH_UTIL__CODE__GENERAL_ERROR}"
  fi

  echo "imported script file $script_file" | bash_util__log__debug

  return "${BASH_UTIL__CODE__OK}"
}

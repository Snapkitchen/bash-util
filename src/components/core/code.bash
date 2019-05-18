# ==============================================================================
# code - constants
# ==============================================================================

readonly BASH_UTIL__CODE__OK=0
readonly BASH_UTIL__CODE__TRUE=0

readonly BASH_UTIL__CODE__GENERAL_ERROR=64
readonly BASH_UTIL__CODE__FATAL_ERROR=65
readonly BASH_UTIL__CODE__NULL=66
readonly BASH_UTIL__CODE__INVALID=67
readonly BASH_UTIL__CODE__UNSET=68
readonly BASH_UTIL__CODE__FALSE=69
readonly BASH_UTIL__CODE__NOT_FOUND=70
readonly BASH_UTIL__CODE__NOT_IMPLEMENTED=71
readonly BASH_UTIL__CODE__RESOURCE_EXISTS=72

bash_util__code__print() {
  # 1) code
  
  case "${1:-}" in
    "${BASH_UTIL__CODE__OK}")
      echo 'OK'
      ;;
    "${BASH_UTIL__CODE__TRUE}")
      echo 'TRUE'
      ;;
    "${BASH_UTIL__CODE__GENERAL_ERROR}")
      echo 'GENERAL_ERROR'
      ;;
    "${BASH_UTIL__CODE__FATAL_ERROR}")
      echo 'FATAL_ERROR'
      ;;
    "${BASH_UTIL__CODE__NULL}")
      echo 'NULL'
      ;;
    "${BASH_UTIL__CODE__INVALID}")
      echo 'INVALID'
      ;;
    "${BASH_UTIL__CODE__UNSET}")
      echo 'UNSET'
      ;;
    "${BASH_UTIL__CODE__FALSE}")
      echo 'FALSE'
      ;;
    "${BASH_UTIL__CODE__NOT_FOUND}")
      echo 'NOT_FOUND'
      ;;
    "${BASH_UTIL__CODE__NOT_IMPLEMENTED}")
      echo 'NOT_IMPLEMENTED'
      ;;
    "${BASH_UTIL__CODE__RESOURCE_EXISTS}")
      echo 'RESOURCE_EXISTS'
      ;;
    *)
      echo "unrecognized code: '${1:-}'" | bash_util__log__error
      ;;
 esac
}

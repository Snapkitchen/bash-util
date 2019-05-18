# ==============================================================================
# datetime - helpers
# ==============================================================================

#
# returns utc datetime in ISO 8601 format
#
# outputs:
#   stdout) utc datetime as a string
#
bash_util__datetime__utc() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

#
# returns unix timestamp
#
# outputs:
#   stdout) unix timestamp as a string
#
bash_util__datetime__unix() {
  date +%s || echo 0000000000
}

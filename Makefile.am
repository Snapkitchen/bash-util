## Process this file with automake to produce Makefile.in

################################################################################
# options
################################################################################

AUTOMAKE_OPTIONS = subdir-objects foreign

################################################################################
# user variables
################################################################################

LIB_SRC_DIR = $(top_srcdir)/src

LIB_SRC_FILE = $(LIB_SRC_DIR)/bash-util.bash.in

LIB_DIR = $(top_builddir)/lib

LIB_PACKAGE_DIR = $(LIB_DIR)/$(PACKAGE)

LIB_FILE_NAME = bash-util.bash

LIB_FILE = $(LIB_PACKAGE_DIR)/$(LIB_FILE_NAME)

LIB_LOADER_FILE_NAME = bash-util-loader.bash

LIB_LOADER_SOURCE_FILE = $(LIB_SRC_DIR)/bash-util-loader.bash.in

LIB_LOADER_FILE = $(LIB_PACKAGE_DIR)/$(LIB_LOADER_FILE_NAME)

LIB_PACKAGE_CONFIG_SRC_FILE = $(LIB_SRC_DIR)/bash-util.pc.in

LIB_PACKAGE_CONFIG_FILE = $(top_builddir)/$(PACKAGE).pc

LIB_COMPONENTS_DIR = $(LIB_SRC_DIR)/components

LIB_COMPONENTS = \
	core/args/parser_core/_get_values.bash \
	core/args/parser_core/_parse_known_args.bash \
	core/args/parser_core/_parse_option.bash \
	core/args/api.bash \
	core/args/constants.bash \
	core/args/helpers.bash \
	core/bool.bash \
	core/code.bash \
	core/command.bash \
	core/datetime.bash \
	core/dict.bash \
	core/int.bash \
	core/list.bash \
	core/log.bash \
	core/string.bash \
	core/type.bash \
	core/var.bash \
	common.bash \
	importer.bash

LIB_COMPONENT_FILES = $(addprefix $(LIB_COMPONENTS_DIR)/,$(LIB_COMPONENTS))

TEST_DIR = $(top_srcdir)/tests

TEST_LIB_DIR = $(TEST_DIR)/lib

TEST_LIBS = \
	$(TEST_LIB_DIR)/common.bash

INSTALL_TEST = $(TEST_DIR)/install/test

# unit tests
# ==============================================================================

COMPONENT_ARGS_UNIT_TESTS = \
	tests/ut/core/args/option/_option_long_name_is_valid.test \
	tests/ut/core/args/option/_option_short_name_is_valid.test \
	tests/ut/core/args/option/add_option.test \
	tests/ut/core/args/option/get_option_value_type.test \
	tests/ut/core/args/option/get_option_value.test \
	tests/ut/core/args/option/option_exists.test \
	tests/ut/core/args/option/set_option_action.test \
	tests/ut/core/args/option/set_option_choices.test \
	tests/ut/core/args/option/set_option_const.test \
	tests/ut/core/args/option/set_option_default.test \
	tests/ut/core/args/option/set_option_long_name.test \
	tests/ut/core/args/option/set_option_nargs.test \
	tests/ut/core/args/option/set_option_required.test \
	tests/ut/core/args/option/set_option_short_name.test \
	tests/ut/core/args/option/set_option_type.test \
	tests/ut/core/args/parser/_parse_option.test \
	tests/ut/core/args/parser/create_parser.test \
	tests/ut/core/args/parser/get_extras_value.test \
	tests/ut/core/args/parser/parser_does_not_exist.test \
	tests/ut/core/args/parser/parser_exists.test \
	tests/ut/core/args/positional/add_positional.test \
	tests/ut/core/args/positional/get_positional_value_type.test \
	tests/ut/core/args/positional/get_positional_value.test \
	tests/ut/core/args/positional/positional_exists.test \
	tests/ut/core/args/positional/set_positional_action.test \
	tests/ut/core/args/positional/set_positional_choices.test \
	tests/ut/core/args/positional/set_positional_const.test \
	tests/ut/core/args/positional/set_positional_default.test \
	tests/ut/core/args/positional/set_positional_nargs.test \
	tests/ut/core/args/positional/set_positional_type.test \
	tests/ut/core/args/_action_is_valid.test \
	tests/ut/core/args/_nargs_is_valid.test \
	tests/ut/core/args/_type_is_supported.test

COMPONENT_BOOL_UNIT_TESTS = \
	tests/ut/core/bool/assign.test \
	tests/ut/core/bool/clone_value.test \
	tests/ut/core/bool/convert_from_exit_code.test \
	tests/ut/core/bool/convert_to_exit_code.test \
	tests/ut/core/bool/destroy.test \
	tests/ut/core/bool/equals.test \
	tests/ut/core/bool/exists.test \
	tests/ut/core/bool/is_false.test \
	tests/ut/core/bool/is_true.test \
	tests/ut/core/bool/is_valid.test \
	tests/ut/core/bool/print_false.test \
	tests/ut/core/bool/print_true.test \
	tests/ut/core/bool/print_value.test \
	tests/ut/core/bool/value_is_false.test \
	tests/ut/core/bool/value_is_true.test \
	tests/ut/core/bool/value_is_valid.test

COMPONENT_COMMAND_UNIT_TESTS = \
	tests/ut/core/command/status/get_status.test \
	tests/ut/core/command/status/set_status.test \
	tests/ut/core/command/stderr/get_stderr_type.test \
	tests/ut/core/command/stderr/get_stderr_value.test \
	tests/ut/core/command/stderr/set_stderr_type.test \
	tests/ut/core/command/stderr/set_stderr_value.test \
	tests/ut/core/command/stdout/get_stdout_type.test \
	tests/ut/core/command/stdout/get_stdout_value.test \
	tests/ut/core/command/stdout/set_stdout_type.test \
	tests/ut/core/command/stdout/set_stdout_value.test \
	tests/ut/core/command/reset.test

COMPONENT_DICT_UNIT_TESTS = \
	tests/ut/core/dict/add_key.test \
	tests/ut/core/dict/clone_all_keys.test \
	tests/ut/core/dict/clone_key.test \
	tests/ut/core/dict/clone.test \
	tests/ut/core/dict/count.test \
	tests/ut/core/dict/create.test \
	tests/ut/core/dict/destroy.test \
	tests/ut/core/dict/exists.test \
	tests/ut/core/dict/get_key_type.test \
	tests/ut/core/dict/get_key_value.test \
	tests/ut/core/dict/get_keys_indices.test \
	tests/ut/core/dict/get_keys_list.test \
	tests/ut/core/dict/has_key.test \
	tests/ut/core/dict/is_valid.test \
	tests/ut/core/dict/key_does_not_exist.test \
	tests/ut/core/dict/key_exists.test \
	tests/ut/core/dict/key_is_type.test \
	tests/ut/core/dict/key_value_is_set.test \
	tests/ut/core/dict/keys.test \
	tests/ut/core/dict/remove_all_keys.test \
	tests/ut/core/dict/remove_key.test \
	tests/ut/core/dict/set_key_type.test \
	tests/ut/core/dict/set_key_value.test

COMPONENT_INT_UNIT_TESTS = \
	tests/ut/core/int/assign.test \
	tests/ut/core/int/clone_value.test \
	tests/ut/core/int/destroy.test \
	tests/ut/core/int/equals.test \
	tests/ut/core/int/exists.test \
	tests/ut/core/int/is_valid.test \
	tests/ut/core/int/max_value.test \
	tests/ut/core/int/min_value.test \
	tests/ut/core/int/print_value.test \
	tests/ut/core/int/value_is_valid.test

COMPONENT_LIST_UNIT_TESTS = \
	tests/ut/core/list/append.test \
	tests/ut/core/list/assign.test \
	tests/ut/core/list/clone_all_elements.test \
	tests/ut/core/list/clone.test \
	tests/ut/core/list/contains.test \
	tests/ut/core/list/copy.test \
	tests/ut/core/list/create.test \
	tests/ut/core/list/destroy.test \
	tests/ut/core/list/equals.test \
	tests/ut/core/list/exists.test \
	tests/ut/core/list/extend.test \
	tests/ut/core/list/get_element_value.test \
	tests/ut/core/list/get_max_index.test \
	tests/ut/core/list/get_min_index.test \
	tests/ut/core/list/get_value_count.test \
	tests/ut/core/list/get_value_index.test \
	tests/ut/core/list/get_value_indices.test \
	tests/ut/core/list/indices.test \
	tests/ut/core/list/is_valid.test \
	tests/ut/core/list/length.test \
	tests/ut/core/list/next_available_index.test \
	tests/ut/core/list/remove_all_value.test \
	tests/ut/core/list/remove_element.test \
	tests/ut/core/list/remove_value.test \
	tests/ut/core/list/set_element_value.test \
	tests/ut/core/list/to_string.test

COMPONENT_LOG_UNIT_TESTS = \
	tests/ut/core/log/colorize_message.test \
	tests/ut/core/log/decorate_message.test \
	tests/ut/core/log/message_type_valid.test \
	tests/ut/core/log/print_message.test \
	tests/ut/core/log/read_message_lines.test

COMPONENT_STRING_UNIT_TESTS = \
	tests/ut/core/string/append.test \
	tests/ut/core/string/assign.test \
	tests/ut/core/string/clone_value.test \
	tests/ut/core/string/destroy.test \
	tests/ut/core/string/equals.test \
	tests/ut/core/string/exists.test \
	tests/ut/core/string/is_not_null.test \
	tests/ut/core/string/is_null.test \
	tests/ut/core/string/is_valid.test \
	tests/ut/core/string/not_equals.test \
	tests/ut/core/string/print_value.test \
	tests/ut/core/string/sanitize.test

COMPONENT_TYPE_UNIT_TESTS = \
	tests/ut/core/type/clone_value.test \
	tests/ut/core/type/destroy_type.test \
	tests/ut/core/type/destroy_value.test \
	tests/ut/core/type/get_type.test \
	tests/ut/core/type/get_value.test \
	tests/ut/core/type/is_valid.test \
	tests/ut/core/type/set_type.test \
	tests/ut/core/type/set_value.test \
	tests/ut/core/type/value_is_set.test \
	tests/ut/core/type/value_is_valid.test

COMPONENT_VAR_UNIT_TESTS = \
	tests/ut/core/var/destroy.test \
	tests/ut/core/var/is_set.test \
	tests/ut/core/var/is_unset.test \
	tests/ut/core/var/is_valid.test \
	tests/ut/core/var/name_is_valid.test \
	tests/ut/core/var/names_do_not_conflict.test \
	tests/ut/core/var/print_name.test

UNIT_TESTS = \
	$(COMPONENT_ARGS_UNIT_TESTS) \
	$(COMPONENT_BOOL_UNIT_TESTS) \
	$(COMPONENT_COMMAND_UNIT_TESTS) \
	$(COMPONENT_DICT_UNIT_TESTS) \
	$(COMPONENT_INT_UNIT_TESTS) \
	$(COMPONENT_LIST_UNIT_TESTS) \
	$(COMPONENT_LOG_UNIT_TESTS) \
	$(COMPONENT_STRING_UNIT_TESTS) \
	$(COMPONENT_TYPE_UNIT_TESTS) \
	$(COMPONENT_VAR_UNIT_TESTS)

# integration tests
# ==============================================================================

COMPONENT_ARGS_INTEGRATION_TESTS = \
	tests/it/core/args/extra_unrecognized_arguments.test \
	tests/it/core/args/multiple_mixed_arguments.test \
	tests/it/core/args/multiple_option_arguments.test \
	tests/it/core/args/multiple_positional_arguments.test \
	tests/it/core/args/option_argument_actions.test \
	tests/it/core/args/option_argument_choices.test \
	tests/it/core/args/option_argument_const.test \
	tests/it/core/args/option_argument_default.test \
	tests/it/core/args/option_argument_nargs.test \
	tests/it/core/args/option_argument_required.test \
	tests/it/core/args/option_argument_types.test \
	tests/it/core/args/positional_argument_actions.test \
	tests/it/core/args/positional_argument_choices.test \
	tests/it/core/args/positional_argument_default.test \
	tests/it/core/args/positional_argument_nargs.test \
	tests/it/core/args/positional_argument_required.test \
	tests/it/core/args/positional_argument_types.test

INTEGRATION_TESTS = \
	$(COMPONENT_ARGS_INTEGRATION_TESTS)

# test environment
# ==============================================================================

PREINSTALL_TESTS_ENVIRONMENT = \
	export __TEST__BASH_UTIL__LOADER_FILE='$(LIB_LOADER_FILE)'; \
	export __TEST__BASH_UTIL__LIB_FILE='$(LIB_FILE)';

POSTINSTALL_TESTS_ENVIRONMENT = \
	export __TEST__BASH_UTIL__LOADER_FILE='$(libscriptsdir)/$(LIB_LOADER_FILE_NAME)'; \
	export __TEST__BASH_UTIL__LIB_FILE='$(libscriptsdir)/$(LIB_FILE_NAME)';

################################################################################
# install locations
################################################################################

libscriptsdir = $(pkglibdir)
pkgconfigdir = $(libdir)/pkgconfig

################################################################################
# files to install
################################################################################

nodist_libscripts_DATA = \
	$(LIB_FILE) \
	$(LIB_LOADER_FILE)

nodist_pkgconfig_DATA = \
	$(LIB_PACKAGE_CONFIG_FILE)

dist_doc_DATA = \
	docs/README.md \
	CHANGELOG

################################################################################
# make variables
################################################################################

EXTRA_DIST = \
	$(LIB_PACKAGE_CONFIG_SRC_FILE) \
	$(LIB_SRC_FILE) \
	$(LIB_LOADER_SOURCE_FILE) \
	$(LIB_COMPONENT_FILES) \
	$(TESTS) \
	$(TEST_LIBS) \
	$(INSTALL_TEST) \
	.PACKAGE_NAME \
	.PACKAGE_VERSION \
	.PACKAGE_REVISION \
	build-aux/tap-driver.sh \
	dev/

CLEANFILES = \
	$(nodist_libscripts_DATA) \
	$(nodist_pkgconfig_DATA)

TESTS = \
	$(UNIT_TESTS) \
	$(INTEGRATION_TESTS)

TEST_EXTENSIONS = .test

# tap driver for .test files (for using bats)
TEST_LOG_DRIVER = \
	env AM_TAP_AWK='$(AWK)' $(SHELL) \
  	$(top_srcdir)/build-aux/tap-driver.sh

AM_TESTS_ENVIRONMENT = \
	$(PREINSTALL_TESTS_ENVIRONMENT)

################################################################################
# canned recipes
################################################################################

define insert_components
	components_array=($(LIB_COMPONENTS)); \
	sed_args=(); \
	for component_name in "$${components_array[@]}"; do \
		component_file="$(LIB_COMPONENTS_DIR)/$$component_name"; \
		if [ ! -e "$$component_file" ]; then \
			echo >&2 "fatal: failed to read component file $$component_file"; exit 2; \
		fi; \
		sed_args+=('-e' "\|%%$$component_name%%|r $$component_file"); \
		sed_args+=('-e' "\|%%$$component_name%%|d"); \
	done; \
	sed "$${sed_args[@]}"
endef

define replace_build_variables
	sed_args=(); \
	sed_args+=('-e' 's|[@][@]package_name[@][@]|$(PACKAGE_NAME)|g'); \
	sed_args+=('-e' 's|[@][@]version[@][@]|$(PACKAGE_VERSION)|g'); \
	sed_args+=('-e' 's|[@][@]revision[@][@]|$(PACKAGE_REVISION)|g'); \
	sed_args+=('-e' 's|[@][@]build_id[@][@]|$(BUILD_ID)|g'); \
	sed "$${sed_args[@]}"
endef

################################################################################
# targets - generation
################################################################################

# copy and then chmod since it will be read-only during a distcheck
$(LIB_LOADER_FILE): $(LIB_LOADER_SOURCE_FILE) $(LIB_FILE) $(top_builddir)/Makefile | $(LIB_DIR) $(LIB_PACKAGE_DIR)
	$(AM_V_GEN)cp "$<" "$@"; \
	chmod +w "$@"; \
	$(replace_build_variables) -i.bak "$@"; \
	rm "$@".bak

$(LIB_PACKAGE_CONFIG_FILE): $(LIB_PACKAGE_CONFIG_SRC_FILE) $(LIB_FILE) $(top_builddir)/Makefile
	$(AM_V_GEN)sed \
		-e 's|[@]prefix[@]|$(prefix)|g' \
		-e 's|[@]exec_prefix[@]|$(exec_prefix)|g' \
		-e 's|[@]libdir[@]|$(pkglibdir)|g' \
		-e 's|[@]includedir[@]|$(includedir)|g' \
		-e 's|[@]package_name[@]|$(PACKAGE_NAME)|g' \
		-e 's|[@]version[@]|$(PACKAGE_VERSION)|g' \
		"$<" > "$@"

$(LIB_PACKAGE_DIR): | $(LIB_DIR)
	mkdir $@

$(LIB_DIR):
	mkdir $@

# copy and then chmod since it will be read-only during a distcheck
$(LIB_FILE): $(LIB_SRC_FILE) $(LIB_COMPONENT_FILES) $(top_builddir)/Makefile | $(LIB_DIR) $(LIB_PACKAGE_DIR)
	$(AM_V_GEN)cp "$<" "$@"; \
	chmod +w "$@"; \
	$(insert_components) -i.bak "$@"; \
	$(replace_build_variables) -i.bak "$@"; \
	rm "$@".bak

################################################################################
# targets - testing
################################################################################

# unit test target
# 	first export the list of tests
# 	then set -e for AM_MAKEFLAGS so it uses the value from env
# 	when it executes a sub-make
ut: export TESTS := $(UNIT_TESTS)
ut: AM_MAKEFLAGS += -e
ut: check

# integration test target
# 	first export the list of tests
# 	then set -e for AM_MAKEFLAGS so it uses the value from env
# 	when it executes a sub-make
it: export TESTS := $(INTEGRATION_TESTS)
it: AM_MAKEFLAGS += -e
it: check

test: check

# integration tests
# =================

# args component test target
it-args: export TESTS := $(COMPONENT_ARGS_INTEGRATION_TESTS)
it-args: AM_MAKEFLAGS += -e
it-args: check

# unit tests
# ==========

# args component test target
ut-args: export TESTS := $(COMPONENT_ARGS_UNIT_TESTS)
ut-args: AM_MAKEFLAGS += -e
ut-args: check

# bool component test target
ut-bool: export TESTS := $(COMPONENT_BOOL_UNIT_TESTS)
ut-bool: AM_MAKEFLAGS += -e
ut-bool: check

# command component test target
ut-command: export TESTS := $(COMPONENT_COMMAND_UNIT_TESTS)
ut-command: AM_MAKEFLAGS += -e
ut-command: check

# dict component test target
ut-dict: export TESTS := $(COMPONENT_DICT_UNIT_TESTS)
ut-dict: AM_MAKEFLAGS += -e
ut-dict: check

# int component test target
ut-int: export TESTS := $(COMPONENT_INT_UNIT_TESTS)
ut-int: AM_MAKEFLAGS += -e
ut-int: check

# list component test target
ut-list: export TESTS := $(COMPONENT_LIST_UNIT_TESTS)
ut-list: AM_MAKEFLAGS += -e
ut-list: check

# log component test target
ut-log: export TESTS := $(COMPONENT_LOG_UNIT_TESTS)
ut-log: AM_MAKEFLAGS += -e
ut-log: check

# string component test target
ut-string: export TESTS := $(COMPONENT_STRING_UNIT_TESTS)
ut-string: AM_MAKEFLAGS += -e
ut-string: check

# type component test target
ut-type: export TESTS := $(COMPONENT_TYPE_UNIT_TESTS)
ut-type: AM_MAKEFLAGS += -e
ut-type: check

# var component test target
ut-var: export TESTS := $(COMPONENT_VAR_UNIT_TESTS)
ut-var: AM_MAKEFLAGS += -e
ut-var: check

################################################################################
# targets - clean
################################################################################

# add clean hooks
clean-local: clean-local-directory-hook

# clean any leftover directories 
clean-local-directory-hook:
	-rmdir $(LIB_PACKAGE_DIR)
	-rmdir $(LIB_DIR)

################################################################################
# targets - install / uninstall
################################################################################

# add installcheck hooks
installcheck-local:
	$(POSTINSTALL_TESTS_ENVIRONMENT) $(INSTALL_TEST)

# add uninstall hooks
uninstall-hook: uninstall-directory-hook

# clean up any leftover directories
uninstall-directory-hook:
	-rmdir $(DESTDIR)$(libscriptsdir)
	-rmdir $(DESTDIR)$(pkgconfigdir)
	-rmdir $(DESTDIR)$(libdir)
	-rmdir $(DESTDIR)$(docdir)
	-rmdir $(DESTDIR)$(datadir)/doc
	-rmdir $(DESTDIR)$(datarootdir)

################################################################################
# targets - phony
################################################################################

# phony targets
.PHONY: \
	clean-local-directory-hook \
	it \
	it-args \
	test \
	uninstall-directory-hook \
	ut \
	ut-args \
	ut-bool \
	ut-command \
	ut-dict \
	ut-int \
	ut-list \
	ut-log \
	ut-string \
	ut-type \
	ut-var

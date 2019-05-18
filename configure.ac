m4_define([package_name_from_file],	m4_esyscmd_s(cat [.PACKAGE_NAME]))
m4_if(m4_sysval, 0,,[m4_fatal(failed to read package name from file)])

m4_define([package_version_from_file], m4_esyscmd_s(cat [.PACKAGE_VERSION]))
m4_if(m4_sysval, 0,,[m4_fatal(failed to read package version from file)])

m4_define([package_revision_from_file], m4_esyscmd_s(cat [.PACKAGE_REVISION]))
m4_if(m4_sysval, 0,,[m4_fatal(failed to read package revision from file)])

AC_PREREQ([2.69])
AC_INIT([package_name_from_file],
				[package_version_from_file],
				[devops@snapkitchen.com],
				[package_name_from_file],
				[https://github.com/snapkitchen/bash-util])

AC_SUBST([PACKAGE_REVISION], [package_revision_from_file])

# check for BUILD_ID
AS_IF([test -z "$BUILD_ID"], [
	# if unspecified, check for 'uuidgen'
	AC_CHECK_PROG(HAVE_UUIDGEN, [uuidgen], [yes])
	# if uuidgen is missing, error
	AS_IF([test "x$HAVE_UUIDGEN" != "xyes"], [
		AC_MSG_ERROR([
*** unable to generate BUILD_ID: uuidgen was not found in path
*** make sure uuidgen is in your path or specify the value for BUILD_ID
		])
	])
	# if uuidgen is not missing, attempt to generate uuid
	BUILD_ID="$(uuidgen)"
	# if uuidgen failed, error
	AS_IF([test $? != 0], [
		AC_MSG_ERROR([
*** unable to generate BUILD_ID: uuidgen command failed
*** check error message or specify the value for BUILD_ID
		])
	])
])

AC_SUBST([BUILD_ID])

AC_COPYRIGHT([Copyright (C) 2018-2019 Snap Kitchen, LLC.
All Rights Reserved.])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_AUX_DIR([build-aux])
AM_SILENT_RULES([yes])
AM_INIT_AUTOMAKE([-Wall])
AC_CONFIG_FILES([Makefile])
AC_OUTPUT

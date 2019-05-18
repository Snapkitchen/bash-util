# bash-util

common utility scripts for bash

## development

### table of contents

- [requirements](#requirements)
- [building](#building)
	- [1. create package files](#1-create-package-files)
	- [2. bootstrap](#2-bootstrap)
	- [3. compile](#3-compile)
	- [4. test](#4-test)
- [installing](#installing)
- [distributing](#distributing)
	- [packaging sources](#packaging-sources)

### requirements

- GNU Autotools
	- autoconf 2.69
	- automake 1.15.1
- make
- bash automated testing system
	- [bats](https://github.com/bats-core/bats-core) 1.x

### building

#### 1. create package files

##### create `.PACKAGE_REVISION` file

from the base directory:

```sh
$ echo 'MY_LOCAL_REVISION' > '.PACKAGE_REVISION'
```

to use the git commit sha:

```sh
$ git rev-parse --verify HEAD > '.PACKAGE_REVISION'
```

#### 2. bootstrap

from the base directory:

```sh
$ eval $(./bootstrap)
```

this script will:

- run autoconf -i
- create the `build` directory
- cd into it
- run `../configure`

#### 3. compile

from your build directory created in bootstrap:

`$ make`

#### 4. test

##### all tests

```sh
$ make check
```

or

```sh
$ make test
```

##### unit tests

```sh
$ make ut
```

##### integration tests

```sh
$ make it
```

### installing

install

```sh
$ sudo make install
```

test install

```sh
$ make installcheck
```

### distributing

#### packaging sources

to create a source distribution:

```
$ make dist
```

testing the distribution

```
$ make distcheck
```

## license

© 2018-2019 Snap Kitchen, LLC. All Rights Reserved.

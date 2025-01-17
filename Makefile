 # Copyright (C) 2000, 2001, 2013 Gregory Trubetskoy
 # Copyright (C) 2002, 2003, 2004, 2005, 2006, 2007 Apache Software Foundation
 #
 #  Licensed under the Apache License, Version 2.0 (the "License");
 #  you may not use this file except in compliance with the License.
 #  You may obtain a copy of the License at
 #
 #      http://www.apache.org/licenses/LICENSE-2.0
 #
 #  Unless required by applicable law or agreed to in writing, software
 #  distributed under the License is distributed on an "AS IS" BASIS,
 #  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 #  See the License for the specific language governing permissions and
 #  limitations under the License.
 #
 # Originally developed by Gregory Trubetskoy.
 #


LIBEXECDIR=/usr/lib/apache2/modules
AP_SRC=
AP_SRC_OWN=
AP_SRC_GRP=
INSTALL=/usr/bin/install -c
PYTHON_BIN=/usr/bin/python

.PHONY: all test clean

all: dso

dso: do_dso

do_dso:
	@cd src && $(MAKE)
	@cd dist && $(MAKE) build
	@echo
	@echo 'Now run sudo make install'
	@echo '  (or, if you only want to perform a partial install,'
	@echo '   you can use make install_dso and make install_py_lib)'
	@echo

no_dso:
	@echo
	@echo "DSO compilation not available. (Probably because apxs could not be found)."
	@echo

static: no_static

no_static:
	@echo
	@echo "Static compilation not available. (Probably because --with-apache was not specified)."
	@echo

install:
	$(MAKE) install_dso
	$(MAKE) install_py_lib
	cd scripts && $(MAKE) install

install_dso:	dso
	@echo
	@echo "Performing DSO installation."
	@echo
	$(INSTALL) -d $(DESTDIR)$(LIBEXECDIR)
	$(INSTALL) src/mod_python.so $(DESTDIR)$(LIBEXECDIR)

install_py_lib:
	cd dist && $(MAKE) install_py_lib

clean:
	cd src && $(MAKE) clean
	cd dist && $(MAKE) clean
	cd scripts && $(MAKE) clean
	cd test && $(MAKE) clean
	rm -f core

distclean: clean
	cd src && $(MAKE) distclean
	cd Doc && $(MAKE) distclean
	cd dist && $(MAKE) distclean
	cd scripts && $(MAKE) distclean
	cd test && $(MAKE) distclean
	rm -rf Makefile config.h config.status config.cache config.log \
		test/testconf.py 

test:	dso
	cd test && $(MAKE) test

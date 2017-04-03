# This file contains common MOOSE application settings
# Note: MOOSE applications are assumed to reside in peer directories relative to MOOSE.
#       This can be overridden by using environment variables (MOOSE_DIR and/or FRAMEWORK_DIR)

# Set LIBMESH_DIR if it is not already set in the environment (try our best to guess!)
LIBMESH_DIR       ?= $(MOOSE_DIR)/libmesh/installed

# Default number of parallel jobs to use for run_tests
MOOSE_JOBS        ?= 8

# If the user has no environment variable
# called METHOD, he gets optimized mode.
ifeq (x$(METHOD),x)
  METHOD := opt
endif

# libmesh-config is in different places depending on whether you are using
# "installed" or "uninstalled" libmesh.
libmesh_config := $(LIBMESH_DIR)/bin/libmesh-config           # installed version
ifeq ($(wildcard $(libmesh_config)),)
  libmesh_config := $(LIBMESH_DIR)/contrib/bin/libmesh-config # uninstalled version
endif

# Instead of using Make.common, use libmesh-config to get any libmesh
# make variables we might need.  Be sure to pass METHOD along to libmesh-config
# so that it can use the right one!
libmesh_CXX      ?= $(shell METHOD=$(METHOD) $(libmesh_config) --cxx)
libmesh_CC       ?= $(shell METHOD=$(METHOD) $(libmesh_config) --cc)
libmesh_F77      ?= $(shell METHOD=$(METHOD) $(libmesh_config) --fc)
libmesh_F90      ?= $(shell METHOD=$(METHOD) $(libmesh_config) --fc)
libmesh_INCLUDE  := $(shell METHOD=$(METHOD) $(libmesh_config) --include)
libmesh_CPPFLAGS := $(shell METHOD=$(METHOD) $(libmesh_config) --cppflags)
libmesh_CXXFLAGS := $(shell METHOD=$(METHOD) $(libmesh_config) --cxxflags)
libmesh_CFLAGS   := $(shell METHOD=$(METHOD) $(libmesh_config) --cflags)
libmesh_FFLAGS   := $(shell METHOD=$(METHOD) $(libmesh_config) --fflags)
libmesh_LIBS     := $(shell METHOD=$(METHOD) $(libmesh_config) --libs)
libmesh_HOST     := $(shell METHOD=$(METHOD) $(libmesh_config) --host)
libmesh_LDFLAGS  := $(shell METHOD=$(METHOD) $(libmesh_config) --ldflags)

# Make.common used to provide an obj-suffix which was related to the
# machine in question (from config.guess, i.e. @host@ in
# contrib/utils/Make.common.in) and the $(METHOD).
obj-suffix := $(libmesh_HOST).$(METHOD).lo

# The libtool script used by libmesh is in different places depending on
# whether you are using "installed" or "uninstalled" libmesh.
libmesh_LIBTOOL := $(LIBMESH_DIR)/contrib/bin/libtool # installed version
ifeq ($(wildcard $(libmesh_LIBTOOL)),)
  libmesh_LIBTOOL := $(LIBMESH_DIR)/libtool           # uninstalled version
endif
libmesh_shared  := $(shell $(libmesh_LIBTOOL) --config | grep build_libtool_libs | cut -d'=' -f2)

# If $(libmesh_CXX) is an mpiXXX compiler script, use -show
# to determine the base compiler
cxx_compiler := $(libmesh_CXX)
ifneq (,$(findstring mpi,$(cxx_compiler)))
	cxx_compiler = $(shell $(libmesh_CXX) -show)
endif

# Check that we have Asio installed.
ASIO_FILE := $(MOOSE_DIR)/framework/contrib/asio/include/asio.hpp
ifneq ("$(wildcard $(ASIO_FILE))","")
libmeshConfigHeader := $(LIBMESH_DIR)/include/libmesh/libmesh_config.h
cxx11Enabled := $(shell grep 'define LIBMESH_HAVE_CXX11 ' $(libmeshConfigHeader) | tail -c 2)
# If it is installed, make sure this is a
# build using C++11, if so, then turn on Asio Networking
ifeq (1,$(strip $(cxx11Enabled)))
	ADDITIONAL_CPPFLAGS += "-DASIO_STANDALONE"
endif
endif

MOOSE_PRECOMPILED ?= false
PCH_FLAGS=
PCH_MODE=
PCH_DEP=

# Check if using precompiled headers is possible
# cxx compiler could be used to define which compiler is being used
# so that different compiler options are usable. Libmesh only
# appears to check if GCC is used
ifeq ($(MOOSE_PRECOMPILED), true)
  ifneq (,$(filter $(cxx_compiler), g++))
	  PRECOMPILED = true
  endif
endif

all::
ifdef PRECOMPILED
#
# Precompiled Header Rules
#

# [JWP] - Libtool does not seem to have support for PCH yet, so for
# now just use the compiler directly, and depend on the user to
# disable precompiled header support if it is not available on his
# system.
%.h.gch/$(METHOD).h.gch : %.h
	@echo "MOOSE Pre-Compiling Header (in "$(METHOD)" mode) "$<"..."
	@mkdir -p $(FRAMEWORK_DIR)/include/base/Precompiled.h.gch
	@$(libmesh_CXX) $(libmesh_CPPFLAGS) $(ADDITIONAL_CPPFLAGS) $(libmesh_CXXFLAGS) -DPRECOMPILED $(libmesh_INCLUDE) -MMD -MF $@.d -c $< -o $@

#
# add dependency - all object files depend on the precompiled header file.
#
PCH_DEP=$(FRAMEWORK_DIR)/include/base/Precompiled.h.gch/$(METHOD).h.gch

PCH_FLAGS=-DPRECOMPILED -include Precompiled.h
PCH_MODE="with PCH "
endif

#
# C++ rules
#
pcre%.$(obj-suffix) : pcre%.cc $(PCH_DEP)
	@echo "MOOSE Compiling C++ $(PCH_MODE)(in "$(METHOD)" mode) "$<"..."
	@$(libmesh_LIBTOOL) --tag=CXX $(LIBTOOLFLAGS) --mode=compile --quiet \
          $(libmesh_CXX) $(libmesh_CPPFLAGS) $(ADDITIONAL_CPPFLAGS) $(libmesh_CXXFLAGS) $(PCH_FLAGS) $(app_INCLUDES) $(libmesh_INCLUDE) -DHAVE_CONFIG_H -MMD -MP -MF $@.d -MT $@ -c $< -o $@

define CXX_RULE_TEMPLATE
%$(1).$(obj-suffix) : %.C $(PCH_DEP)
ifeq ($(1),)
	@echo "MOOSE Compiling C++ $$(PCH_MODE)(in "$$(METHOD)" mode) "$$<"..."
else
	@echo "MOOSE Compiling C++ with suffix $$(PCH_MODE)(in "$$(METHOD)" mode) "$$<"..."
endif
	@$$(libmesh_LIBTOOL) --tag=CXX $$(LIBTOOLFLAGS) --mode=compile --quiet \
	  $$(libmesh_CXX) $$(libmesh_CPPFLAGS) $$(ADDITIONAL_CPPFLAGS) $$(libmesh_CXXFLAGS) $$(PCH_FLAGS) $$(app_INCLUDES) $$(libmesh_INCLUDE) -MMD -MP -MF $$@.d -MT $$@ -c $$< -o $$@
endef
# Instantiate Rules
$(eval $(call CXX_RULE_TEMPLATE,))

%.$(obj-suffix) : %.cpp $(PCH_DEP)
	@echo "MOOSE Compiling C++ $(PCH_MODE)(in "$(METHOD)" mode) "$<"..."
	@$(libmesh_LIBTOOL) --tag=CXX $(LIBTOOLFLAGS) --mode=compile --quiet \
	  $(libmesh_CXX) $(libmesh_CPPFLAGS) $(ADDITIONAL_CPPFLAGS) $(libmesh_CXXFLAGS) $(PCH_FLAGS) $(app_INCLUDES) $(libmesh_INCLUDE) -MMD -MP -MF $@.d -MT $@ -c $< -o $@

#
# Static Analysis
#

%.plist.$(obj-suffix) : %.C
	@echo "Clang Static Analysis (in "$(METHOD)" mode) "$<"..."
	@$(libmesh_CXX) $(libmesh_CXXFLAGS) $(app_INCLUDES) $(libmesh_INCLUDE) --analyze $< -o $@

#
# C rules
#

pcre%.$(obj-suffix) : pcre%.c
	@echo "MOOSE Compiling C (in "$(METHOD)" mode) "$<"..."
	@$(libmesh_LIBTOOL) --tag=CC $(LIBTOOLFLAGS) --mode=compile --quiet \
          $(libmesh_CC) $(libmesh_CPPFLAGS) $(ADDITIONAL_CPPFLAGS) $(libmesh_CFLAGS) $(app_INCLUDES) $(libmesh_INCLUDE) -DHAVE_CONFIG_H -MMD -MP -MF $@.d -MT $@ -c $< -o $@

%.$(obj-suffix) : %.c
	@echo "MOOSE Compiling C (in "$(METHOD)" mode) "$<"..."
	@$(libmesh_LIBTOOL) --tag=CC $(LIBTOOLFLAGS) --mode=compile --quiet \
	  $(libmesh_CC) $(libmesh_CPPFLAGS) $(ADDITIONAL_CPPFLAGS) $(libmesh_CFLAGS) $(app_INCLUDES) $(libmesh_INCLUDE) -MMD -MP -MF $@.d -MT $@ -c $< -o $@



#
# Fortran77 rules
#

%.$(obj-suffix) : %.f
	@echo "MOOSE Compiling Fortan (in "$(METHOD)" mode) "$<"..."
	@$(libmesh_LIBTOOL) --tag=F77 $(LIBTOOLFLAGS) --mode=compile --quiet \
	  $(libmesh_F77) $(libmesh_FFLAGS) $(app_INCLUDES) $(libmesh_INCLUDE) -c $< -o $@


#
# Fortran77 (with C preprocessor) rules
#

PreProcessed_FFLAGS := $(libmesh_FFLAGS)
%.$(obj-suffix) : %.F
	@echo "MOOSE Compiling Fortran (in "$(METHOD)" mode) "$<"..."
	@$(libmesh_LIBTOOL) --tag=F77 $(LIBTOOLFLAGS) --mode=compile --quiet \
	  $(libmesh_F90) $(PreProcessed_FFLAGS) $(app_INCLUDES) $(libmesh_INCLUDE) -c $< $(module_dir_flag) -o $@

#
# Fortran90 rules
#

mpif90_command := $(libmesh_F90)

# If $(libmesh_f90) is an mpiXXX compiler script, use -show
# to determine the base compiler
ifneq (,$(findstring mpi,$(mpif90_command)))
	mpif90_command = $(shell $(libmesh_F90) -show)
endif

# module_dir_flag is a flag that, if defined, instructs the compiler
# to put any .mod files in the directory where the obect files are put.

#ifort
ifneq (,$(findstring ifort,$(mpif90_command)))
	module_dir_flag = -module ${@D}
endif

#gfortran
ifneq (,$(findstring gfortran,$(mpif90_command)))
	module_dir_flag = -J${@D}
endif

%.$(obj-suffix) : %.f90
	@echo "MOOSE Compiling Fortran90 (in "$(METHOD)" mode) "$<"..."
	@$(libmesh_LIBTOOL) --tag=FC $(LIBTOOLFLAGS) --mode=compile --quiet \
	  $(libmesh_F90) $(libmesh_FFLAGS) $(libmesh_INCLUDE) -c $< $(module_dir_flag) -o $@

# Add method to list of defines passed to the compiler
libmesh_CXXFLAGS += -DMETHOD=$(METHOD)

# treat these warnings as errors (This doesn't seem to be necessary for Intel)
ifneq (,$(findstring g++,$(cxx_compiler)))
  libmesh_CXXFLAGS += -Werror=return-type -Werror=reorder

	# Disable the long string warning from GCC
	# warning: string length ‘524’ is greater than the length ‘509’ ISO C90 compilers are required to support [-Woverlength-strings]
	libmesh_CXXFLAGS += -Woverlength-strings
endif

#
# Fortran baggage
#
mpif77_command := $(libmesh_F77)

# If $(libmesh_f77) is an mpiXXX compiler script, use -show
# to determine the base compiler
ifneq (,$(findstring mpi,$(mpif77_command)))
	mpif77_command := $(shell $(libmesh_F77) -show | cut -f1 -d' ')
endif

# Set certain flags based on compiler

# ifort
ifneq (,$(findstring ifort,$(mpif77_command)))
	libmesh_FFLAGS += -r8
endif

# gfortran
ifneq (,$(findstring gfortran,$(mpif77_command)))
	libmesh_FFLAGS += -fdefault-real-8 -fdefault-double-8
endif

# g95
ifneq (,$(findstring g95,$(mpif77_command)))
	libmesh_FFLAGS += -r8
endif

# compile with gcov support if using the gcc compiler suite
ifeq ($(coverage),true)
	libmesh_CXXFLAGS += -fprofile-arcs -ftest-coverage
	ifeq (,$(findstring clang++,$(cxx_compiler)))
		libmesh_LDFLAGS += -lgcov
	endif
endif

# link with gcov support, but do now generate data for this build
# if you wanted code coverage data for moose, but you wanted to run
# the tests in moose_test you would make moose with coverage=true
# and moose_test with just linkcoverage=true
ifeq ($(linkcoverage),true)
	libmesh_LDFLAGS += -lgcov
endif

# graceful error exiting
ifeq ($(graceful),true)
	libmesh_CXXFLAGS += -DGRACEFUL_ERROR
endif

#
# Variables
#

CURRENT_APP ?= $(shell basename `pwd`)

ifeq ($(CURRENT_APP),moose)
  CONTAINING_DIR_FULLPATH = $(shell dirname `pwd`)
  CONTAINING_DIR = $(shell basename $(CONTAINING_DIR_FULLPATH))
  ifeq ($(CONTAINING_DIR), devel)
    CURRENT_APP = "devel/moose"
  endif
endif

#
# Plugins
# TODO[JWP]: These plugins might also be able to use libtool...but it turned
# out to be more trouble than it was worth to get working.
#
%-$(METHOD).plugin : %.C
	@echo "MOOSE Compiling C++ Plugin (in "$(METHOD)" mode) "$<"..."
	@$(libmesh_CXX) $(libmesh_CPPFLAGS) $(ADDITIONAL_CPPFLAGS) $(libmesh_CXXFLAGS) -shared -fPIC $(app_INCLUDES) $(libmesh_INCLUDE) $< -o $@
%-$(METHOD).plugin : %.c
	@echo "MOOSE Compiling C Plugin (in "$(METHOD)" mode) "$<"..."
	@$(libmesh_CC) $(libmesh_CPPFLAGS) $(ADDITIONAL_CPPFLAGS) $(libmesh_CFLAGS) -shared -fPIC $(app_INCLUDES) $(libmesh_INCLUDE) $< -o $@
%-$(METHOD).plugin : %.f
	@echo "MOOSE Compiling Fortan Plugin (in "$(METHOD)" mode) "$<"..."
	@$(libmesh_F77) $(libmesh_FFLAGS) -shared -fPIC $(app_INCLUDES) $(libmesh_INCLUDE) $< -o $@
%-$(METHOD).plugin : %.f90
	@echo "MOOSE Compiling Fortan Plugin (in "$(METHOD)" mode) "$<"..."
	@$(libmesh_F90) $(libmesh_FFLAGS) -shared -fPIC $(app_INCLUDES) $(libmesh_INCLUDE) $< -o $@

# Define the "test" target, we'll use a variable name so that we can override it without warnings if needed
TEST ?= test
$(TEST): all
	@echo ======================================================
	@echo Testing $(CURRENT_APP)
	@echo ======================================================
	@(./run_tests -j $(MOOSE_JOBS))

# Build appliations up the tree
up:
	@echo ======================================================
	@echo Building the following applications:
	@for app in $(DEP_APPS); do echo \ $$app; done
	@echo ======================================================
	@echo
	@for app in $(DEP_APPS); \
	do \
		echo ====== Making in $${app} ====== ; \
		$(MAKE) -C $${app} || exit; \
	done


test_up: up
	@echo ======================================================
	@echo Testing the following applications:
	@for app in $(DEP_APPS); do echo \ $$app; done
	@echo ======================================================
	@echo
	@for app in $(DEP_APPS); \
	do \
		echo ====== Testing in $${app} ====== ; \
		(cd $${app} && ./run_tests -q -j $(MOOSE_JOBS)) ; \
	done

test_only_up:
	@echo ======================================================
	@echo Testing the following applications:
	@for app in $(DEP_APPS); do echo \ $$app; done
	@echo ======================================================
	@echo
	@for app in $(DEP_APPS); \
	do \
		echo ====== Testing in $${app} ====== ; \
		(cd $${app} && ./run_tests -q -j $(MOOSE_JOBS)) ; \
	done

clean_up:
	@echo ======================================================
	@echo Cleaning the following applications:
	@for app in $(DEP_APPS); do echo \ $$app; done
	@echo ======================================================
	@echo
	@for app in $(DEP_APPS); \
	do \
		echo ====== Cleaning $${app} ====== ; \
		$(MAKE) -C $${app} clean; \
	done

libmesh_update:
	@echo ======================================================
	@echo Downloading and updating libMesh
	@echo ======================================================
	$(MOOSE_DIR)/scripts/update_and_rebuild_libmesh.sh

#
# Maintenance
#
.PHONY: cleanall clean doc sa test up test_up test_only_up clean_up

#
# Misc
#
syntax:
	$(shell python scripts/generate_input_syntax.py)

doc:
	$(shell doxygen doc/doxygen/Doxyfile)

depclean: cleandep
cleandep: cleandep
cleandeps: cleandep

cleandep:
	@for app in $(DEP_APPS); \
	do \
		@echo @python $(FRAMEWORK_DIR)/scripts/rm_outdated_deps.py $$app; \
	done

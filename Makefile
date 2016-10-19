# Copyright (C) 2016 Embecosm Limited.
#
# Contributor Andrew Burgess <andrew.burgess@embecosm.com>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.  */
#
##########################################################################
# Validate SRC_DIR and BUILD_DIR command line parameters
##########################################################################

SRC_DIR =
BUILD_DIR =

# Check that the source directory exists
ifeq ("","$(SRC_DIR)")
$(error "Missing source directory")
else
ifeq ("","$(shell ls -d $(SRC_DIR) 2>/dev/null)")
$(error "Souce directory `$(SRC_DIR)' does not exist")
endif
endif

# Check that the build directory exists
ifeq ("","$(BUILD_DIR)")
$(error "Missing build directory")
else
ifeq ("","$(shell ls -d $(BUILD_DIR) 2>/dev/null)")
$(error "Build directory `$(BUILD_DIR)' does not exist")
endif
endif

ABS_SRC_DIR = $(abspath $(SRC_DIR))
ABS_BUILD_DIR = $(abspath $(BUILD_DIR))

##########################################################################
# Some colors, use NC=1 (No Colours) to turn colours off
##########################################################################

COLOUR_RED=$(if $(NC),,\033[1;31m)
COLOUR_GREEN=$(if $(NC),,\033[1;32m)
COLOUR_YELLOW=$(if $(NC),,\033[1;33m)
COLOUR_BLUE=$(if $(NC),,\033[1;34m)
COLOUR_PURPLE=$(if $(NC),,\033[1;35m)
COLOUR_LIGHT_CYAN=$(if $(NC),,\033[1;36m)
COLOUR_LIGHT_GREY=$(if $(NC),,\033[1;37m)
COLOUR_NONE=$(if $(NC),,\033[0m)

##########################################################################
# Which targets to build, and special flags required
##########################################################################

TARGETS = \
	aarch64-elf \
	aarch64-linux-gnu \
	aarch64_be-elf \
	all-64 \
	all-64,32 \
	alpha-dec-vms \
	alpha-linux-gnu \
	alpha-linuxecoff \
	alpha-unknown-freebsd4.7 \
	alpha-unknown-osf4.0 \
	am33_2.0-linux \
	arc-elf \
	arc-linux-uclibc \
	arceb-elf \
	arceb-elf,m32 \
	arm-aout \
	arm-coff \
	arm-epoc-pe \
	arm-linuxeabi \
	arm-nacl \
	arm-netbsdelf \
	arm-none-eabi \
	arm-nto \
	arm-pe \
	arm-symbianelf \
	arm-vxworks \
	arm-wince-pe \
	armeb-eabi \
	avr-elf \
	bfin-elf \
	cr16-elf \
	cris-axis-linux-gnu \
	cris-elf \
	crisv32-elf \
	crisv32-linux \
	crx-elf \
	d10v-elf \
	d30v-elf \
	dlx-elf \
	epiphany-elf \
	fr30-elf \
	frv-elf \
	frv-linux \
	ft32-elf \
	h8300-elf \
	h8300-rtems \
	hppa-linux-gnu \
	hppa64-linux \
	i386-coff \
	i386-darwin \
	i386-linux \
	i386-lynxos \
	i386-netware \
	i386-pc-go32 \
	i386-rdos \
	i586-aout \
	i586-coff \
	i686-dragonfly \
	i686-nacl \
	i686-pc-beos \
	i686-pc-cygwin \
	i686-pc-elf \
	i686-pc-linux-gnu \
	i686-pc-linux-gnu,gold \
	i686-pc-mingw32 \
	i686-pe \
	i860-stardent-elf \
	i960-elf \
	ia64-elf \
	ia64-freebsd5 \
	ia64-linux \
	ia64-netbsd \
	ia64-vms \
	ia64-x-freebsd5 \
	ip2k-elf \
	iq2000-elf \
	lm32-elf \
	lm32-rtems4.10 \
	m32c-elf \
	m32r-elf \
	m68hc11-elf \
	m68k-elf \
	m68k-rtems \
	m68k-uclinux \
	mcore-elf \
	mcore-pe \
	mep-elf \
	metag-elf \
	microblaze-elf \
	mingw32-pe \
	mips-elf \
	mips-linux \
	mips-sgi-irix6 \
	mips64-linux \
	mips64vrel-elf \
	mipsel-linux-gnu \
	mipsisa32el-linux \
	mmix-mmixware \
	mmix \
	mn10200-elf \
	mn10300-elf \
	moxie-elf \
	ms1-elf \
	msp430-elf \
	mt-elf \
	nds32le-elf \
	nios2-elf \
	nios2-linux \
	ns32k-netbsd \
	or1k-elf \
	pdp11-dec-aout \
	pj-elf \
	powerpc-eabisim \
	powerpc-ibm-aix5.2.0 \
	powerpc-linux \
	powerpc-nto \
	powerpc-wrs-vxworks \
	powerpc64-linux \
	powerpc64le-elf \
	powerpcle-elf \
	ppc-lynxos \
	rl78-elf \
	rs6000-aix4.3.3 \
	rx-elf \
	s390-linux \
	s390x-ibm-tpf \
	score-elf \
	sh-elf \
	sh-linux \
	sh-nto \
	sh-pe \
	sh-rtems \
	sh-symbianelf \
	shl-unknown-netbsdelf1.6T \
	sparc-aout \
	sparc-coff \
	sparc-linux-gnu \
	sparc64-linux-gnu \
	sparc64-netbsd \
	spu-elf \
	tic30-unknown-aout \
	tic30-unknown-coff \
	tic4x-coff \
	tic54x-coff \
	tic6x-elf \
	tilepro-elf \
	tilepro-linux \
	tx39-elf \
	v850-elf \
	vax-netbsdelf \
	visium-elf \
	x86_64-darwin \
	x86_64-linux \
	x86_64-pc-cygwin \
	x86_64-pc-linux-gnu \
	x86_64-pc-linux-gnu,gold \
	x86_64-solaris2 \
	xc16x-elf \
	xgate-elf \
	xstormy16-elf \
	xtensa-elf \
	z80-coff \
	z8k-coff

BROKEN_TARGETS = \
	alpha-netbsd \
	hppa-linux \
	hppa64-hp-hpux11.23 \
	i586-linux \
	m68k-linux \
	powerpcle-cygwin \
	tilegx-linux \
	x86_64-mingw32

##########################################################################
# Customisations for different targets.
##########################################################################

CONFIGURE_aarch64-elf=--target=aarch64-elf --disable-gdb
CONFIGURE_aarch64-linux-gnu=--target=aarch64-linux-gnu --disable-gdb
CONFIGURE_aarch64_be-elf=--target=aarch64_be-elf --disable-gdb
CONFIGURE_all-64,32=--enable-targets=all --enable-64-bit-bfd --disable-gdb
CONFIGURE_all-64=--enable-targets=all --enable-64-bit-bfd
CONFIGURE_alpha-linux-gnu=--target=alpha-linux-gnu --disable-gdb
CONFIGURE_alpha-linuxecoff=--target=alpha-linuxecoff --disable-gdb
CONFIGURE_alpha-unknown-freebsd4.7=--target=alpha-unknown-freebsd4.7 --disable-gdb
CONFIGURE_alpha-unknown-osf4.0=--target=alpha-unknown-osf4.0 --disable-gdb
CONFIGURE_am33_2.0-linux=--target=am33_2.0-linux --disable-gdb
CONFIGURE_arc-elf=--target=arc-elf --disable-gdb
CONFIGURE_arc-linux-uclibc=--target=arc-linux-uclibc --disable-gdb
CONFIGURE_arceb-elf,m32=--target=arceb-elf --disable-gdb
CONFIGURE_arceb-elf=--target=arceb-elf --disable-gdb
CONFIGURE_arm-aout=--target=arm-aout --disable-gdb
CONFIGURE_arm-coff=--target=arm-coff --disable-gdb
CONFIGURE_arm-epoc-pe=--target=arm-epoc-pe --disable-gdb
CONFIGURE_arm-nacl=--target=arm-nacl --disable-gdb
CONFIGURE_arm-netbsdelf=--target=arm-netbsdelf --disable-gdb
CONFIGURE_arm-none-eabi=--target=arm-none-eabi --disable-gdb
CONFIGURE_arm-nto=--target=arm-nto --disable-gdb
CONFIGURE_arm-pe=--target=arm-pe --disable-gdb
CONFIGURE_arm-symbianelf=--target=arm-symbianelf --disable-gdb
CONFIGURE_arm-vxworks=--target=arm-vxworks --disable-gdb
CONFIGURE_arm-wince-pe=--target=arm-wince-pe --disable-gdb
CONFIGURE_armeb-eabi=--target=armeb-eabi --disable-gdb
CONFIGURE_avr-elf=--target=avr-elf --disable-gdb
CONFIGURE_bfin-elf=--target=bfin-elf --disable-gdb
CONFIGURE_cr16-elf=--target=cr16-elf --disable-gdb
CONFIGURE_cris-axis-linux-gnu=--target=cris-axis-linux-gnu --disable-gdb
CONFIGURE_cris-elf=--target=cris-elf --disable-gdb
CONFIGURE_crisv32-elf=--target=crisv32-elf --disable-gdb
CONFIGURE_crisv32-linux=--target=crisv32-*-linux
CONFIGURE_crx-elf=--target=crx-elf --disable-gdb
CONFIGURE_d10v-elf=--target=d10v-elf --disable-gdb
CONFIGURE_dlx-elf=--target=dlx-elf --disable-gdb
CONFIGURE_epiphany-elf=--target=epiphany-elf --disable-gdb
CONFIGURE_frv-elf=--target=frv-elf --disable-gdb
CONFIGURE_ft32-elf=--target=ft32-elf --disable-gdb
CONFIGURE_h8300-elf=--target=h8300-elf --disable-gdb
CONFIGURE_h8300-rtems=--target=h8300-rtems --disable-gdb
CONFIGURE_hppa-linux-gnu=--target=hppa-linux-gnu --disable-gdb
CONFIGURE_hppa64-linux=--target=hppa64-linux --disable-gdb
CONFIGURE_i386-coff=--target=i386-coff --disable-gdb
CONFIGURE_i386-darwin=--target=i386-darwin --disable-gdb
CONFIGURE_i386-lynxos=--target=i386-lynxos --disable-gdb
CONFIGURE_i386-netware=--target=i386-netware --disable-gdb
CONFIGURE_i386-pc-go32=--target=i386-pc-go32 --disable-gdb
CONFIGURE_i586-aout=--target=i586-aout --disable-gdb
CONFIGURE_i586-coff=--target=i586-coff --disable-gdb
CONFIGURE_i686-dragonfly=--target=i686-dragonfly --disable-gdb
CONFIGURE_i686-nacl=--target=i686-nacl --disable-gdb
CONFIGURE_i686-pc-beos=--target=i686-pc-beos --disable-gdb
CONFIGURE_i686-pc-cygwin=--target=i686-pc-cygwin --disable-gdb
CONFIGURE_i686-pc-elf=--target=i686-pc-elf --disable-gdb
CONFIGURE_i686-pc-linux-gnu,gold=--target=i686-pc-linux-gnu --disable-gdb
CONFIGURE_i686-pc-linux-gnu=--target=i686-pc-linux-gnu --disable-gdb
CONFIGURE_i686-pc-mingw32=--target=i686-pc-mingw32 --disable-gdb
CONFIGURE_i686-pe=--target=i686-pe --disable-gdb
CONFIGURE_i860-stardent-elf=--target=i860-stardent-elf --disable-gdb
CONFIGURE_ia64-freebsd5=--target=ia64-freebsd5 --disable-gdb
CONFIGURE_ia64-linux=--target=ia64-linux --disable-gdb
CONFIGURE_ia64-netbsd=--target=ia64-netbsd --disable-gdb
CONFIGURE_ia64-vms=--target=ia64-vms --disable-gdb
CONFIGURE_ia64-x-freebsd5=--target=ia64-x-freebsd5 --disable-gdb
CONFIGURE_ip2k-elf=--target=ip2k-elf --disable-gdb
CONFIGURE_iq2000-elf=--target=iq2000-elf --disable-gdb
CONFIGURE_lm32-elf=--target=lm32-elf --disable-gdb
CONFIGURE_lm32-rtems4.10=--target=lm32-rtems4.10 --disable-gdb
CONFIGURE_m32c-elf=--target=m32c-elf --disable-gdb
CONFIGURE_m32r-elf=--target=m32r-elf --disable-gdb
CONFIGURE_m68hc11-elf=--target=m68hc11-elf --disable-gdb
CONFIGURE_m68k-elf=--target=m68k-elf --disable-gdb
CONFIGURE_m68k-rtems=--target=m68k-rtems --disable-gdb
CONFIGURE_m68k-uclinux=--target=m68k-uclinux --disable-gdb
CONFIGURE_mcore-elf=--target=mcore-elf --disable-gdb
CONFIGURE_mcore-pe=--target=mcore-pe --disable-gdb
CONFIGURE_mep-elf=--target=mep-elf --disable-gdb
CONFIGURE_metag-elf=--target=metag-elf --disable-gdb
CONFIGURE_microblaze-elf=--target=microblaze-elf --disable-gdb
CONFIGURE_mingw32-pe=--target=mingw32-pe --disable-gdb
CONFIGURE_mips-elf=--target=mips-elf --disable-gdb
CONFIGURE_mips-sgi-irix6=--target=mips-sgi-irix6 --disable-gdb
CONFIGURE_mips64-linux=--target=mips64-linux --disable-gdb
CONFIGURE_mips64vrel-elf=--target=mips64vrel-elf --disable-gdb
CONFIGURE_mipsel-linux-gnu=--target=mipsel-linux-gnu --disable-gdb
CONFIGURE_mipsisa32el-linux=--target=mipsisa32el-linux --disable-gdb
CONFIGURE_mn10200-elf=--target=mn10200-elf --disable-gdb
CONFIGURE_mn10300-elf=--target=mn10300-elf --disable-gdb
CONFIGURE_moxie-elf=--target=moxie-elf --disable-gdb
CONFIGURE_ms1-elf=--target=ms1-elf --disable-gdb
CONFIGURE_msp430-elf=--target=msp430-elf --disable-gdb
CONFIGURE_mt-elf=--target=mt-elf --disable-gdb
CONFIGURE_nds32le-elf=--target=nds32le-elf --disable-gdb
CONFIGURE_nios2-elf=--target=nios2-elf --disable-gdb
CONFIGURE_nios2-linux=--target=nios2-linux --disable-gdb
CONFIGURE_ns32k-netbsd=--target=ns32k-netbsd --disable-gdb
CONFIGURE_pdp11-dec-aout=--target=pdp11-dec-aout --disable-gdb
CONFIGURE_pj-elf=--target=pj-elf --disable-gdb
CONFIGURE_powerpc-eabisim=--target=powerpc-eabisim --disable-gdb
CONFIGURE_powerpc-ibm-aix5.2.0=--target=powerpc-ibm-aix5.2.0 --disable-gdb
CONFIGURE_powerpc-nto=--target=powerpc-nto --disable-gdb
CONFIGURE_powerpc-wrs-vxworks=--target=powerpc-wrs-vxworks --disable-gdb
CONFIGURE_powerpc64-linux=--target=powerpc64-linux --disable-gdb
CONFIGURE_powerpc64le-elf=--target=powerpc64le-elf --disable-gdb
CONFIGURE_powerpcle-elf=--target=powerpcle-elf --disable-gdb
CONFIGURE_ppc-lynxos=--target=ppc-lynxos --disable-gdb
CONFIGURE_rl78-elf=--target=rl78-elf --disable-gdb
CONFIGURE_rs6000-aix4.3.3=--target=rs6000-aix4.3.3 --disable-gdb
CONFIGURE_rx-elf=--target=rx-elf --disable-gdb
CONFIGURE_s390-linux=--target=s390-linux --disable-gdb
CONFIGURE_score-elf=--target=score-elf --disable-gdb
CONFIGURE_sh-elf=--target=sh-elf --disable-gdb
CONFIGURE_sh-linux=--target=sh-linux --disable-gdb
CONFIGURE_sh-nto=--target=sh-nto --disable-gdb
CONFIGURE_sh-pe=--target=sh-pe --disable-gdb
CONFIGURE_sh-rtems=--target=sh-rtems --disable-gdb
CONFIGURE_sh-symbianelf=--target=sh-symbianelf --disable-gdb --disable-sim
CONFIGURE_shl-unknown-netbsdelf1.6T=--target=shl-unknown-netbsdelf1.6T --disable-gdb
CONFIGURE_sparc-aout=--target=sparc-aout --disable-gdb
CONFIGURE_sparc-coff=--target=sparc-coff --disable-gdb
CONFIGURE_sparc64-netbsd=--target=sparc64-netbsd --disable-gdb
CONFIGURE_spu-elf=--target=spu-elf --disable-gdb
CONFIGURE_tic30-unknown-aout=--target=tic30-unknown-aout --disable-gdb
CONFIGURE_tic30-unknown-coff=--target=tic30-unknown-coff --disable-gdb
CONFIGURE_tic4x-coff=--target=tic4x-coff --disable-gdb
CONFIGURE_tic6x-elf=--target=tic6x-elf --disable-gdb
CONFIGURE_tilepro-linux=--target=tilepro-linux --disable-gdb
CONFIGURE_tx39-elf=--target=tx39-elf --disable-gdb --disable-sim
CONFIGURE_v850-elf=--target=v850-elf --disable-gdb
CONFIGURE_vax-netbsdelf=--target=vax-netbsdelf --disable-gdb
CONFIGURE_visium-elf=--target=visium-elf --disable-gdb
CONFIGURE_x86_64-linux=--target=x86_64-*-linux
CONFIGURE_x86_64-pc-cygwin=--target=x86_64-pc-cygwin --disable-gdb
CONFIGURE_x86_64-pc-linux-gnu,gold=--enable-gold
CONFIGURE_x86_64-solaris2=--target=x86_64-solaris2 --disable-gdb
CONFIGURE_xc16x-elf=--target=xc16x-elf --disable-gdb
CONFIGURE_xgate-elf=--target=xgate-elf --disable-gdb
CONFIGURE_xstormy16-elf=--target=xstormy16-elf --disable-gdb
CONFIGURE_xtensa-elf=--target=xtensa-elf --disable-gdb
CONFIGURE_z80-coff=--target=z80-coff --disable-gdb
CONFIGURE_z8k-coff=--target=z8k-coff --disable-gdb

CFLAGS_arc-elf,m32 = -m32
CFLAGS_all-64,32 = -m32

define CONFIGURE_CORE_i686-pc-linux-gnu,gold =
	CC="gcc -m32" CXX="g++ -m32" ABI="32" setarch i686 \
	    $(ABS_SRC_DIR)/configure \
	        --enable-gold \
	        --target=i686-pc-linux-gnu
endef

##########################################################################
# Variables created for use within this makefile
##########################################################################

BUILD_DIR_TARGETS = $(addprefix TARGET_BUILD_DIR_,$(TARGETS))
CONFIGURE_TARGETS = $(addprefix TARGET_CONFIGURE_,$(TARGETS))
BUILD_TARGETS = $(addprefix TARGET_BUILD_,$(TARGETS))
CHECK_GAS_TARGETS = $(addprefix TARGET_CHECK_GAS_,$(TARGETS))
CHECK_LD_TARGETS = $(addprefix TARGET_CHECK_LD_,$(TARGETS))
CHECK_BINUTILS_TARGETS = $(addprefix TARGET_CHECK_BINUTILS_,$(TARGETS))

##########################################################################
# The top-level build targets within this makefile
##########################################################################

define gather_summary_files =
	cd $(BUILD_DIR) && \
	    find . -mindepth 2 -name $(1) | xargs cat | sort \
	    > $(BUILD_DIR)/$(1)
endef


all :
	@echo "Try targets:"
	@echo "  dirs           - Create per target build directory"
	@echo "  configure      - Configure all targets"
	@echo "  build          - Build all targets"
	@echo "  check-gas      - Test the assembler"
	@echo "  check-ld       - Test the linker"
	@echo "  check-binutils - Test binutils"

# Create all of the build directories
.PHONY: dirs
dirs : $(BUILD_DIR_TARGETS)

# Configure all of the targets
.PHONY: configure
configure: $(CONFIGURE_TARGETS)
	@$(call gather_summary_files,configure.sum)

# Build all of the targets
.PHONY: build
build: $(BUILD_TARGETS)
	@$(call gather_summary_files,build.sum)

# Run various tests on the targets
.PHONY: check-all check-gas check-ld check-binutils
check-all: check-gas check-ld check-binutils
check-gas check-ld check-binutils: dirs configure build
check-gas: $(CHECK_GAS_TARGETS)
	@$(call gather_summary_files,check-gas.sum)
check-ld: $(CHECK_LD_TARGETS)
	@$(call gather_summary_files,check-ld.sum)
check-binutils: $(CHECK_BINUTILS_TARGETS)
	@$(call gather_summary_files,check-binutils.sum)

##########################################################################
# Support for configuring the builds
##########################################################################

define get_target_name =
  $(shell echo $(1) | sed 's/,.*//' | sed 's/ //g')
endef

define format_cflags =
  $(if $(1),"CFLAGS=$(1)","")
endef

define get_cflags =
  $(call format_cflags,$(if $(CFLAGS_$(1)),$(CFLAGS_$(1)),$(CFLAGS)))
endef

define get_configure_flags =
  $(if $(CONFIGURE_$(1)),$(CONFIGURE_$(1)),--target=$(call get_target_name,$(1)))
endef

define CONFIGURE_CORE =
	$(ABS_SRC_DIR)/configure \
	  $(call get_configure_flags,$*) \
	  $(call get_cflags,$*)
endef

.PHONY: $(CONFIGURE_TARGETS)
$(CONFIGURE_TARGETS) : TARGET_CONFIGURE_% : $(BUILD_DIR)/%/configure.ok

$(BUILD_DIR)/%/configure.ok : | $(BUILD_DIR)/%
	@echo -e "Starting configure of $*"
	@cd $(BUILD_DIR)/$* && \
	    $(if $(CONFIGURE_CORE_$*),\
                       $(CONFIGURE_CORE_$*),\
                       $(CONFIGURE_CORE)) &>$(BUILD_DIR)/$*/configure.log && \
	  (echo -e "Finished configure of $*: $(COLOUR_GREEN)Success$(COLOUR_NONE)" && \
	      echo "$*: Success" > $(BUILD_DIR)/$*/configure.sum && \
              date > $(BUILD_DIR)/$*/configure.ok) || \
	  (echo -e "Finished configure of $*: $(COLOUR_RED)Failed$(COLOUR_NONE)" && \
	      echo "$*: Failed" > $(BUILD_DIR)/$*/configure.sum)

##########################################################################
# Support for performing the build
##########################################################################

define BUILD_CORE =
	make
endef

.PHONY: $(BUILD_TARGETS)
$(BUILD_TARGETS) : TARGET_BUILD_% : $(BUILD_DIR)/%/build.ok

$(BUILD_DIR)/%/build.ok : $(BUILD_DIR)/%/configure.ok
	@echo "Starting build of $*"
	@cd $(BUILD_DIR)/$* && \
	    $(if $(BUILD_CORE_$*),\
                       $(BUILD_CORE_$*),\
                       $(BUILD_CORE)) &>$(BUILD_DIR)/$*/build.log && \
	  (echo -e "Finished build of $*: $(COLOUR_GREEN)Success$(COLOUR_NONE)" && \
	      echo "$*: Success" > $(BUILD_DIR)/$*/build.sum && \
              date > $(BUILD_DIR)/$*/build.ok) || \
	  (echo -e "Finished build of $*: $(COLOUR_RED)Failed$(COLOUR_NONE)" && \
	      echo "$*: Failed" > $(BUILD_DIR)/$*/build.sum)

##########################################################################
# Support for creating the build directories
##########################################################################

.PHONY: $(BUILD_DIR_TARGETS)
$(BUILD_DIR_TARGETS) : TARGET_BUILD_DIR_% : | $(BUILD_DIR)/%

$(BUILD_DIR)/% :
	@echo "Creating build directory for $*"
	@mkdir $@

##########################################################################
# Support for running tests
##########################################################################

# Generates the recipe snippet to create a summary file after running the tests.
# Args: (1) Success/Failed string to write.
#       (2) The name of the tool, gas/ld/binutils.
#       (3) The path to the produced sum file within the build directory.
define write_test_sum_file =
	(echo -n "$*: $(1): " > $(BUILD_DIR)/$*/check-$(2).sum && \
	 cat $(3) | grep "^\([XK]\?PASS\|[XK]\?FAIL\|UNSUPPORTED\|UNRESOLVED\|UNTESTED\):" | \
	 cut -d: -f1 | sort | uniq -c | awk '{ print $$2 "=" $$1 }' | \
	 xargs >> $(BUILD_DIR)/$*/check-$(2).sum)
endef

# Generates a recipe gas/ld/binutils tests, print a Success/Failed
# message, and create a top level summary file including that target
# name, status, and a list of PASS/FAIL/etc counts.
# Args: (1) The name of the test set to run gas/ld/binutils.
#       (2) The path to the produced sum file within the build directory.
define run_tests =
	cd $(BUILD_DIR)/$* && \
	    $(MAKE) check-$(1) &>$(BUILD_DIR)/$*/check-$(1).log && \
	  (echo -e "Finished check-$(1) of $*: $(COLOUR_GREEN)Success$(COLOUR_NONE)" && \
	      $(call write_test_sum_file,Success,$(1),$(2))) || \
	  (echo -e "Finished check-$(1) of $*: $(COLOUR_RED)Failed$(COLOUR_NONE)" && \
	      $(call write_test_sum_file,Failed,$(1),$(2)))
endef

.PHONY : $(CHECK_GAS_TARGETS)
$(CHECK_GAS_TARGETS) : TARGET_CHECK_GAS_% : $(BUILD_DIR)/%/build.ok
	@echo "Starting check-gas of $*"
	@$(call run_tests,gas,gas/testsuite/gas.sum)

.PHONY : $(CHECK_LD_TARGETS)
$(CHECK_LD_TARGETS) : TARGET_CHECK_LD_% : $(BUILD_DIR)/%/build.ok
	@echo "Starting check-ld of $*"
	@$(call run_tests,ld,ld/ld.sum)

.PHONY : $(CHECK_BINUTILS_TARGETS)
$(CHECK_BINUTILS_TARGETS) : TARGET_CHECK_BINUTILS_% : $(BUILD_DIR)/%/build.ok
	@echo "Starting check-binutils of $*"
	@$(call run_tests,binutils,binutils/binutils.sum)

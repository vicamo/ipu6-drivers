# SPDX-License-Identifier: GPL-2.0
# Copyright (c) 2022 Intel Corporation.

export CONFIG_INTEL_VSC = m

export CONFIG_VIDEO_INTEL_IPU6 = m
export CONFIG_IPU_ISYS_BRIDGE = y
obj-y += drivers/media/pci/intel/

export CONFIG_VIDEO_HM11B1 = m
export CONFIG_VIDEO_OV01A1S = m
export CONFIG_VIDEO_OV01A10 = m
export CONFIG_VIDEO_OV02C10 = m
export CONFIG_VIDEO_OV2740 = m
export CONFIG_VIDEO_HM2170 = m
export CONFIG_VIDEO_HI556 = m
# export CONFIG_POWER_CTRL_LOGIC = m
obj-y += drivers/media/i2c/

KERNELRELEASE ?= $(shell uname -r)
KERNEL_SRC ?= /lib/modules/$(KERNELRELEASE)/build
MODSRC := $(shell pwd)

subdir-ccflags-y += \
	-I$(src)/backport-include/ \
	-I$(src)/include/ \
	-DBUILD_DKMS

define set-feature-ccflags-for
subdir-ccflags-$($(cfg)) += $(if $(filter y m,$($(1))),-D$(1)$(if $(filter m,$($(1))),_MODULE)=1)
endef

$(eval $(call set-feature-ccflags-for,CONFIG_INTEL_VSC))
$(eval $(call set-feature-ccflags-for,CONFIG_IPU_ISYS_BRIDGE))
$(eval $(call set-feature-ccflags-for,CONFIG_POWER_CTRL_LOGIC))
subdir-ccflags-y += $(subdir-ccflags-m)

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(MODSRC) modules
modules_install:
	$(MAKE) INSTALL_MOD_DIR=updates -C $(KERNEL_SRC) M=$(MODSRC) modules_install
clean:
	$(MAKE) -C $(KERNEL_SRC) M=$(MODSRC) clean

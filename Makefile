
GITHUB           = https://github.com/

BOOTSTRAP        = at91bootstrap.bin
LOADER           = u-boot.bin
KERNEL           = zImage
DTB              = sama5d31ek.dtb
ROOTFS           = rootfs.ubi

ROOTFS_DIR       = buildroot
IMAGES_DIR       = $(ROOTFS_DIR)/output/images

CP = cp -p

full: clone rfscfg rootfs sam-ba

clone:
	git clone -b 2021.08.x $(GITHUB)/buildroot/buildroot.git buildroot

rfscfg:
	BR2_EXTERNAL=$(CURDIR)/buildroot-external $(MAKE) -C $(ROOTFS_DIR) mini_sama5d31ek_defconfig

rootfs:
	$(MAKE) -C $(ROOTFS_DIR)

sam-ba:
	mkdir -p sam-ba
	$(CP) $(IMAGES_DIR)/$(BOOTSTRAP) sam-ba
	$(CP) $(IMAGES_DIR)/$(LOADER)    sam-ba
	$(CP) $(IMAGES_DIR)/$(DTB)       sam-ba
	$(CP) $(IMAGES_DIR)/$(KERNEL)    sam-ba
	$(CP) $(IMAGES_DIR)/$(ROOTFS)    sam-ba
	$(CP) prog-sama5d31ek.qml        sam-ba


.PHONY: full clone rfscfg rootfs sam-ba

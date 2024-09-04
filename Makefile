IMAGE_NAME := mintyro

.PHONY: all
all: $(IMAGE_NAME).iso

$(IMAGE_NAME).iso: kernel
	@rm -rf iso_root
	@mkdir -p iso_root/boot
	@cp kernel/zig-out/bin/kernel iso_root/boot/
	@mkdir -p iso_root/boot/limine
	@cp -v limine.conf iso_root/boot/limine/
	@cp -v font.psf iso_root/
	@cp limine/limine-bios.sys limine/limine-bios-cd.bin limine/limine-uefi-cd.bin iso_root/boot/limine/
	@mkdir -p iso_root/EFI/BOOT
	@cp limine/BOOTX64.EFI iso_root/EFI/BOOT/
	@xorriso -as mkisofs -b boot/limine/limine-bios-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot boot/limine/limine-uefi-cd.bin \
		-efi-boot-part --efi-boot-image --protective-msdos-label \
		iso_root -o $(IMAGE_NAME).iso
	@./limine/limine bios-install $(IMAGE_NAME).iso
	@rm -rf iso_root

.PHONY: kernel
kernel:
	@cd kernel && zig build

.PHONY: run
run: $(IMAGE_NAME).iso
	@qemu-system-x86_64 -m 512M -cdrom $(IMAGE_NAME).iso -boot d -debugcon stdio

.PHONY: clean
clean:
	@rm -rf iso_root $(IMAGE_NAME).iso
	@rm -rf kernel/.zig-cache kernel/zig-out
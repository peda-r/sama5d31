import SAMBA 3.2
import SAMBA.Connection.Serial 3.2
import SAMBA.Device.SAMA5D3 3.2

SerialConnection {
	port: Script.arguments[0]

        device: SAMA5D3 {
			name: "sama5d31ek"

			aliases: []

			description: "SAMA5D31EK"

			config {
				nandflash {
					ioset: 1
					busWidth: 16
					header: 0xc0902405
				}
			}
		}
        onConnectionOpened: {
		// Set returnCode to error if execution is aborted
		Script.returnCode = 1

		print("=== Initialize low-level ===")
		initializeApplet("lowlevel")

		print("=== Initialize the NAND access ===")
		initializeApplet("nandflash")

		print("=== Erase all the NAND flash blocks and verify ===")
		applet.erase()

		print("=== Load loader ===")
		applet.write(0x00040000, "u-boot.bin", false)
		// applet.write(0x00100000, "u-boot.env.bin", false)
		// applet.write(0x00140000, "u-boot.env.bin", false)

		print("=== Load the Kernel image and device tree database ===")
		applet.write(0x00180000, "sama5d31ek.dtb", false)
		applet.write(0x00200000, "zImage", false)

		print("=== Load the linux file system ===")
		applet.write(0x00800000, "rootfs.ubi", false)

		print("=== Load bootstrap in the first sector ===")
		applet.write(0x00000000, "at91bootstrap.bin", true)

		print("=== DONE. ===")

		// Return OK
		Script.returnCode = 0
        }
}

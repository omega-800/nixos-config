# https://github.com/Kicksecure/security-misc/blob/master/etc/modprobe.d/30_security-misc_disable.conf
{ config, lib, sys, ... }: {
  environment = lib.mkIf sys.paranoid {
    persistence = lib.mkIf config.m.fs.disko.root.impermanence.enable {
      "/nix/persist".files =
        [ "/etc/modprobe.d/nm-module-blacklist.conf" ];
    };
    etc."modprobe.d/nm-module-blacklist.conf".text = ''
      ## Copyright (C) 2012 - 2024 ENCRYPTED SUPPORT LP <adrelanos@whonix.org>
      ## See the file COPYING for copying conditions.

      ## See the following links for a community discussion and overview regarding the selections.
      ## https://forums.whonix.org/t/blacklist-more-kernel-modules-to-reduce-attack-surface/7989
      ## https://madaidans-insecurities.github.io/guides/linux-hardening.html#kasr-kernel-modules

      ## Blacklisting prevents kernel modules from automatically starting.
      ## Disabling prohibits kernel modules from starting.

      ## This configuration file is split into 4 sections:
      ## 1. Hardware
      ## 2. File Systems
      ## 3. Networking
      ## 4. Miscellaneous

      ## 1. Hardware:

      ## Bluetooth:
      ## Disable Bluetooth to reduce attack surface due to extended history of security vulnerabilities.
      ##
      ## https://en.wikipedia.org/wiki/Bluetooth#History_of_security_concerns
      ##
      ## Now replaced by a privacy and security preserving default Bluetooth configuration for better usability.
      ## https://github.com/Kicksecure/security-misc/pull/145
      ##
      #install bluetooth /usr/bin/disabled-bluetooth-by-security-misc
      #install bluetooth_6lowpan  /usr/bin/disabled-bluetooth-by-security-misc
      #install bt3c_cs /usr/bin/disabled-bluetooth-by-security-misc
      #install btbcm /usr/bin/disabled-bluetooth-by-security-misc
      #install btintel /usr/bin/disabled-bluetooth-by-security-misc
      #install btmrvl /usr/bin/disabled-bluetooth-by-security-misc
      #install btmrvl_sdio /usr/bin/disabled-bluetooth-by-security-misc
      #install btmtk /usr/bin/disabled-bluetooth-by-security-misc
      #install btmtksdio /usr/bin/disabled-bluetooth-by-security-misc
      #install btmtkuart /usr/bin/disabled-bluetooth-by-security-misc
      #install btnxpuart /usr/bin/disabled-bluetooth-by-security-misc
      #install btqca /usr/bin/disabled-bluetooth-by-security-misc
      #install btrsi /usr/bin/disabled-bluetooth-by-security-misc
      #install btrtl /usr/bin/disabled-bluetooth-by-security-misc
      #install btsdio /usr/bin/disabled-bluetooth-by-security-misc
      #install btusb /usr/bin/disabled-bluetooth-by-security-misc
      #install virtio_bt /usr/bin/disabled-bluetooth-by-security-misc

      ## FireWire (IEEE 1394):
      ## Disable IEEE 1394 (FireWire/i.LINK/Lynx) modules to prevent some DMA attacks.
      ##
      ## https://en.wikipedia.org/wiki/IEEE_1394#Security_issues
      ##
      install dv1394 /usr/bin/disabled-firewire-by-security-misc
      install firewire-core /usr/bin/disabled-firewire-by-security-misc
      install firewire-ohci /usr/bin/disabled-firewire-by-security-misc
      install firewire-net /usr/bin/disabled-firewire-by-security-misc
      install firewire-sbp2 /usr/bin/disabled-firewire-by-security-misc
      install ohci1394 /usr/bin/disabled-firewire-by-security-misc
      install raw1394 /usr/bin/disabled-firewire-by-security-misc
      install sbp2 /usr/bin/disabled-firewire-by-security-misc
      install video1394 /usr/bin/disabled-firewire-by-security-misc

      ## Global Positioning Systems (GPS):
      ## Disable GPS-related modules like GNSS (Global Navigation Satellite System).
      ##
      install garmin_gps /usr/bin/disabled-gps-by-security-misc
      install gnss /usr/bin/disabled-gps-by-security-misc
      install gnss-mtk /usr/bin/disabled-gps-by-security-misc
      install gnss-serial /usr/bin/disabled-gps-by-security-misc
      install gnss-sirf /usr/bin/disabled-gps-by-security-misc
      install gnss-ubx /usr/bin/disabled-gps-by-security-misc
      install gnss-usb /usr/bin/disabled-gps-by-security-misc

      ## Intel Management Engine (ME):
      ## Partially disable the Intel ME interface with the OS.
      ## ME functionality has increasing become more intertwined with basic Intel system operation.
      ## Disabling may lead to breakages in numerous places without clear debugging/error messages.
      ## May cause issues with firmware updates, security, power management, display, and DRM.
      ##
      ## https://www.kernel.org/doc/html/latest/driver-api/mei/mei.html
      ## https://en.wikipedia.org/wiki/Intel_Management_Engine#Security_vulnerabilities
      ## https://www.kicksecure.com/wiki/Out-of-band_Management_Technology#Intel_ME_Disabling_Disadvantages
      ## https://github.com/Kicksecure/security-misc/pull/236#issuecomment-2229092813
      ## https://github.com/Kicksecure/security-misc/issues/239
      ##
      #install mei /usr/bin/disabled-intelme-by-security-misc
      #install mei-gsc /usr/bin/disabled-intelme-by-security-misc
      #install mei_gsc_proxy /usr/bin/disabled-intelme-by-security-misc
      #install mei_hdcp /usr/bin/disabled-intelme-by-security-misc
      #install mei-me /usr/bin/disabled-intelme-by-security-misc
      #install mei_phy /usr/bin/disabled-intelme-by-security-misc
      #install mei_pxp /usr/bin/disabled-intelme-by-security-misc
      #install mei-txe /usr/bin/disabled-intelme-by-security-misc
      #install mei-vsc /usr/bin/disabled-intelme-by-security-misc
      #install mei-vsc-hw /usr/bin/disabled-intelme-by-security-misc
      #install mei_wdt /usr/bin/disabled-intelme-by-security-misc
      #install microread_mei /usr/bin/disabled-intelme-by-security-misc

      ## Intel Platform Monitoring Technology (PMT) Telemetry:
      ## Disable some functionality of the Intel PMT components.
      ##
      ## https://github.com/intel/Intel-PMT
      ##
      install pmt_class /usr/bin/disabled-intelpmt-by-security-misc
      install pmt_crashlog /usr/bin/disabled-intelpmt-by-security-misc
      install pmt_telemetry /usr/bin/disabled-intelpmt-by-security-misc

      ## Thunderbolt:
      ## Disables Thunderbolt modules to prevent some DMA attacks.
      ##
      ## https://en.wikipedia.org/wiki/Thunderbolt_(interface)#Security_vulnerabilities
      ##
      install intel-wmi-thunderbolt /usr/bin/disabled-thunderbolt-by-security-misc
      install thunderbolt /usr/bin/disabled-thunderbolt-by-security-misc
      install thunderbolt_net /usr/bin/disabled-thunderbolt-by-security-misc

      ## 2. File Systems:

      ## File Systems:
      ## Disable uncommon file systems to reduce attack surface.
      ## HFS/HFS+ are legacy Apple file systems that may be required depending on the EFI partition format.
      ##
      install cramfs /usr/bin/disabled-filesys-by-security-misc
      install freevxfs /usr/bin/disabled-filesys-by-security-misc
      install hfs /usr/bin/disabled-filesys-by-security-misc
      install hfsplus /usr/bin/disabled-filesys-by-security-misc
      install jffs2 /usr/bin/disabled-filesys-by-security-misc
      install jfs /usr/bin/disabled-filesys-by-security-misc
      install reiserfs /usr/bin/disabled-filesys-by-security-misc
      install udf /usr/bin/disabled-filesys-by-security-misc

      ## Network File Systems:
      ## Disable uncommon network file systems to reduce attack surface.
      ##
      install gfs2 /usr/bin/disabled-netfilesys-by-security-misc
      install ksmbd /usr/bin/disabled-netfilesys-by-security-misc
      ##
      ## Common Internet File System (CIFS):
      ##
      install cifs /usr/bin/disabled-netfilesys-by-security-misc
      install cifs_arc4 /usr/bin/disabled-netfilesys-by-security-misc
      install cifs_md4 /usr/bin/disabled-netfilesys-by-security-misc
      ##
      ## Network File System (NFS):
      ##
      install nfs /usr/bin/disabled-netfilesys-by-security-misc
      install nfs_acl /usr/bin/disabled-netfilesys-by-security-misc
      install nfs_layout_nfsv41_files /usr/bin/disabled-netfilesys-by-security-misc
      install nfs_layout_flexfiles /usr/bin/disabled-netfilesys-by-security-misc
      install nfsd /usr/bin/disabled-netfilesys-by-security-misc
      install nfsv2 /usr/bin/disabled-netfilesys-by-security-misc
      install nfsv3 /usr/bin/disabled-netfilesys-by-security-misc
      install nfsv4 /usr/bin/disabled-netfilesys-by-security-misc

      ## 2. Networking:

      ## Network Protocols:
      ## Disables rare and unneeded network protocols that are a common source of unknown vulnerabilities.
      ## Previously had blacklisted eepro100 and eth1394.
      ##
      ## https://tails.boum.org/blueprint/blacklist_modules/
      ## https://fedoraproject.org/wiki/Security_Features_Matrix#Blacklist_Rare_Protocols
      ## https://git.launchpad.net/ubuntu/+source/kmod/tree/debian/modprobe.d/blacklist-rare-network.conf?h=ubuntu/disco
      ## https://github.com/Kicksecure/security-misc/pull/234#issuecomment-2230732015
      ##
      install af_802154 /usr/bin/disabled-network-by-security-misc
      install appletalk /usr/bin/disabled-network-by-security-misc
      install ax25 /usr/bin/disabled-network-by-security-misc
      #install brcm80211 /usr/bin/disabled-network-by-security-misc
      install decnet /usr/bin/disabled-network-by-security-misc
      install dccp /usr/bin/disabled-network-by-security-misc
      install econet /usr/bin/disabled-network-by-security-misc
      install eepro100 /usr/bin/disabled-network-by-security-misc
      install eth1394 /usr/bin/disabled-network-by-security-misc
      install ipx /usr/bin/disabled-network-by-security-misc
      install n-hdlc /usr/bin/disabled-network-by-security-misc
      install netrom /usr/bin/disabled-network-by-security-misc
      install p8022 /usr/bin/disabled-network-by-security-misc
      install p8023 /usr/bin/disabled-network-by-security-misc
      install psnap /usr/bin/disabled-network-by-security-misc
      install rose /usr/bin/disabled-network-by-security-misc
      install x25 /usr/bin/disabled-network-by-security-misc
      ##
      ## Asynchronous Transfer Mode (ATM):
      ##
      install atm /usr/bin/disabled-network-by-security-misc
      install ueagle-atm /usr/bin/disabled-network-by-security-misc
      install usbatm /usr/bin/disabled-network-by-security-misc
      install xusbatm /usr/bin/disabled-network-by-security-misc
      ##
      ## Controller Area Network (CAN) Protocol:
      ##
      install c_can /usr/bin/disabled-network-by-security-misc
      install c_can_pci /usr/bin/disabled-network-by-security-misc
      install c_can_platform /usr/bin/disabled-network-by-security-misc
      install can /usr/bin/disabled-network-by-security-misc
      install can-bcm /usr/bin/disabled-network-by-security-misc
      install can-dev /usr/bin/disabled-network-by-security-misc
      install can-gw /usr/bin/disabled-network-by-security-misc
      install can-isotp /usr/bin/disabled-network-by-security-misc
      install can-raw /usr/bin/disabled-network-by-security-misc
      install can-j1939 /usr/bin/disabled-network-by-security-misc
      install can327 /usr/bin/disabled-network-by-security-misc
      install ifi_canfd /usr/bin/disabled-network-by-security-misc
      install janz-ican3 /usr/bin/disabled-network-by-security-misc
      install m_can /usr/bin/disabled-network-by-security-misc
      install m_can_pci /usr/bin/disabled-network-by-security-misc
      install m_can_platform /usr/bin/disabled-network-by-security-misc
      install phy-can-transceiver /usr/bin/disabled-network-by-security-misc
      install slcan /usr/bin/disabled-network-by-security-misc
      install ucan /usr/bin/disabled-network-by-security-misc
      install vxcan /usr/bin/disabled-network-by-security-misc
      install vcan /usr/bin/disabled-network-by-security-misc
      ##
      ## Transparent Inter Process Communication (TIPC):
      ##
      install tipc /usr/bin/disabled-network-by-security-misc
      install tipc_diag /usr/bin/disabled-network-by-security-misc
      ##
      ## Reliable Datagram Sockets (RDS):
      ##
      install rds /usr/bin/disabled-network-by-security-misc
      install rds_rdma /usr/bin/disabled-network-by-security-misc
      install rds_tcp /usr/bin/disabled-network-by-security-misc
      ##
      ## Stream Control Transmission Protocol (SCTP):
      ##
      install sctp /usr/bin/disabled-network-by-security-misc
      install sctp_diag /usr/bin/disabled-network-by-security-misc

      ## 4. Miscellaneous:

      ## Amateur Radios:
      ##
      install hamradio /usr/bin/disabled-miscellaneous-by-security-misc

      ## CPU Model-Specific Registers (MSRs):
      ## Disable CPU MSRs as they can be abused to write to arbitrary memory.
      ##
      ## https://security.stackexchange.com/questions/119712/methods-root-can-use-to-elevate-itself-to-kernel-mode
      ## https://github.com/Kicksecure/security-misc/issues/215
      ##
      #install msr /usr/bin/disabled-miscellaneous-by-security-misc

      ## Floppy Disks:
      ##
      install floppy /usr/bin/disabled-miscellaneous-by-security-misc

      ## Framebuffer (fbdev):
      ## Video drivers are known to be buggy, cause kernel panics, and are generally only used by legacy devices.
      ## These were all previously blacklisted.
      ##
      ## https://docs.kernel.org/fb/index.html
      ## https://en.wikipedia.org/wiki/Linux_framebuffer
      ## https://git.launchpad.net/ubuntu/+source/kmod/tree/debian/modprobe.d/blacklist-framebuffer.conf?h=ubuntu/disco
      ##
      install aty128fb /usr/bin/disabled-framebuffer-by-security-misc
      install atyfb /usr/bin/disabled-framebuffer-by-security-misc
      install cirrusfb /usr/bin/disabled-framebuffer-by-security-misc
      install cyber2000fb /usr/bin/disabled-framebuffer-by-security-misc
      install cyblafb /usr/bin/disabled-framebuffer-by-security-misc
      install gx1fb /usr/bin/disabled-framebuffer-by-security-misc
      install hgafb /usr/bin/disabled-framebuffer-by-security-misc
      install i810fb /usr/bin/disabled-framebuffer-by-security-misc
      install intelfb /usr/bin/disabled-framebuffer-by-security-misc
      install kyrofb /usr/bin/disabled-framebuffer-by-security-misc
      install lxfb /usr/bin/disabled-framebuffer-by-security-misc
      install matroxfb_bases /usr/bin/disabled-framebuffer-by-security-misc
      install neofb /usr/bin/disabled-framebuffer-by-security-misc
      install nvidiafb /usr/bin/disabled-framebuffer-by-security-misc
      install pm2fb /usr/bin/disabled-framebuffer-by-security-misc
      install radeonfb /usr/bin/disabled-framebuffer-by-security-misc
      install rivafb /usr/bin/disabled-framebuffer-by-security-misc
      install s1d13xxxfb /usr/bin/disabled-framebuffer-by-security-misc
      install savagefb /usr/bin/disabled-framebuffer-by-security-misc
      install sisfb /usr/bin/disabled-framebuffer-by-security-misc
      install sstfb /usr/bin/disabled-framebuffer-by-security-misc
      install tdfxfb /usr/bin/disabled-framebuffer-by-security-misc
      install tridentfb /usr/bin/disabled-framebuffer-by-security-misc
      install vesafb /usr/bin/disabled-framebuffer-by-security-misc
      install vfb /usr/bin/disabled-framebuffer-by-security-misc
      install viafb /usr/bin/disabled-framebuffer-by-security-misc
      install vt8623fb /usr/bin/disabled-framebuffer-by-security-misc
      install udlfb /usr/bin/disabled-framebuffer-by-security-misc

      ## Replaced Modules:
      ## These legacy drivers have all been entirely replaced and superseded by newer drivers.
      ## These were all previously blacklisted.
      ##
      ## https://git.launchpad.net/ubuntu/+source/kmod/tree/debian/modprobe.d/blacklist.conf?h=ubuntu/disco
      ##
      install asus_acpi /usr/bin/disabled-miscellaneous-by-security-misc
      install bcm43xx /usr/bin/disabled-miscellaneous-by-security-misc
      install de4x5 /usr/bin/disabled-miscellaneous-by-security-misc
      install prism54 /usr/bin/disabled-miscellaneous-by-security-misc

      ## USB Video Device Class:
      ## Disables the USB-based video streaming driver for devices like some webcams and digital camcorders.
      ##
      #install uvcvideo /usr/bin/disabled-miscellaneous-by-security-misc

      ## Vivid:
      ## Disables the vivid kernel module since it has been the cause of multiple vulnerabilities.
      ##
      ## https://forums.whonix.org/t/kernel-recompilation-for-better-hardening/7598/233
      ## https://www.openwall.com/lists/oss-security/2019/11/02/1
      ## https://github.com/a13xp0p0v/kconfig-hardened-check/commit/981bd163fa19fccbc5ce5d4182e639d67e484475
      ##
      install vivid /usr/bin/disabled-miscellaneous-by-security-misc
    '';
  };
}

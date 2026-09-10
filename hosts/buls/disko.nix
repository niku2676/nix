{
  disko.devices.disk.nixos = {
    # Replace this safe placeholder with the dedicated NixOS SSD, for example:
    # /dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_<serial>
    # Never use the Windows disk here.
    device = "/dev/disk/by-id/REPLACE_WITH_NIXOS_SSD";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}

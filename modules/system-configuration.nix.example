# This configuration file contains user editable system configurations that
# won't be modified on nixos-generate-config.
# I.e. non ephimeral configurations that are supposed to be in hardware-configuration.nix.
# Contents should be unique to each T480.

{ ... }:
{
  time.timeZone = "Asia/Jakarta";

  environment.etc."crypttab".text = ''
    Data /dev/nvme0n1p7 none tcrypt-veracrypt,password-echo=masked
  '';
}

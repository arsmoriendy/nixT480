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

  networking.wg-quick.interfaces.wg0 = {
    autostart = false;
    address = ["10.0.0.2/24" "fc00::2/7"];
    privateKeyFile = "/media/Data/Documents/wireguard_keys/wg0_private";
    peers = [
      {
        publicKey = "yeEZCclVIn8QS8fmNt2jZ9nh76M/NNJbD4aFGjXYMQk=";
        allowedIPs = ["0.0.0.0/0" "::/0"];
        endpoint = "arsmoriendy.com:57621";
        persistentKeepalive = 25;
      }
    ];
  };

}

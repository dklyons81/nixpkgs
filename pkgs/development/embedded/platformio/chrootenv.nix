{ lib, buildFHSUserEnv, version, src }:

let
  pio-pkgs = pkgs:
    let
      python = pkgs.python3;
    in
    (with pkgs; [
      platformio-core
      zlib
      git
      xdg-user-dirs
    ]) ++ (with python.pkgs; [
      python
      setuptools
      pip
      bottle
    ]);

in
buildFHSUserEnv {
  name = "platformio";

  targetPkgs = pio-pkgs;
  # disabled temporarily because fastdiff no longer support 32bit
  # multiPkgs = pio-pkgs;

  meta = with lib; {
    description = "An open source ecosystem for IoT development";
    homepage = "https://platformio.org";
    maintainers = with maintainers; [ mog ];
    license = licenses.asl20;
    platforms = with platforms; linux;
  };

  extraInstallCommands = ''
    mkdir -p $out/lib/udev/rules.d

    ln -s $out/bin/platformio $out/bin/pio
    ln -s ${src}/platformio/assets/system/99-platformio-udev.rules $out/lib/udev/rules.d/99-platformio-udev.rules
  '';

  runScript = "platformio";
}

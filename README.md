# monitoring
Nixpkgs overlay containing modules and packages dedicated to system monitoring.

## Usage

Use the Nix modules in this repository by importing it in your `configuration.nix` as follows:

```
let

  monitoring = builtins.fetchGit {
    url = "https://github.com/senpro-it/monitoring.git";
    ref = "main";
    rev = "<commit-hash>";
  };

in {

  imports = [
    "${monitoring}/nixos"
    ./hardware-configuration.nix
  ];

  ...

}
```

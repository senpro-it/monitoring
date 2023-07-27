{ config, pkgs, lib, ... }:

with lib;

let 

  telegrafOptions = {
    agentConfig = mkOption {
      type = types.listOf types.str;
      default = [];
      example = literalExpression ''
        [ "udp://192.168.178.1:161" ]
      '';
      description = lib.mdDoc ''
        Endpoints which should be monitored. See the [documentation](https://github.com/influxdata/telegraf/blob/master/plugins/inputs/snmp/README.md) for syntax reference.
      '';
    };
    authSNMPv3 = with types; {
      context = {
        name = mkOption {
          type = types.str;
          example = "27652626525562";
          description = lib.mdDoc ''
            Context name for SNMPv3 to authenticate at the agent.
          '';
        };
      };
      authentication = {
        protocol = mkOption {
          type = types.enum [ "MD5" "SHA" "SHA224" "SHA256" "SHA384" "SHA512" ];
          default = "MD5";
          example = "SHA";
          description = lib.mdDoc ''
            Authentication protocol used by SNMPv3 to authenticate at the agent.
          '';
        };
        password = mkOption {
          type = types.str;
          default = "yzL9sHgeYf5NJzaeAB73014M7XrY6Aagj8UhrHbePfCfxBa99uLzVrGC8ywhfW97";
          example = "VJQUpLCLGniEDVGK8Q0oPS9Yf0xObE7m8aCDK4FR7Kzzh47MD2ZQy0dVtTkDeKBd";
          description = lib.mdDoc ''
            Password used by SNMPv3 to authenticate at the agent.
          '';
        };
      };
      privacy = {
        protocol = mkOption {
          type = types.enum [ "DES" "AES" "AES192" "AES192C" "AES256" "AES256C" ];
          default = "MD5";
          example = "SHA";
          description = lib.mdDoc ''
            Privacy protocol used by SNMPv3 to authenticate at the agent.
          '';
        };
        password = mkOption {
          type = types.str;
            default = "qNMR7yeaIyQ8HKfRCZU8UW5AdKM6P56UALUeYATENOn4dX3nezXELwmLgpuMWKS2";
            example = "GO61HVwspXO514vbzZiV3IwGeBnSZsjHoBaHbJU4JgEaznJ4AdVTy0wzwpzgNffz";
            description = lib.mdDoc ''
              Password used by SNMPv3 to protect to connectiont to the agent.
            '';
          };
        };
      security = {
        level = mkOption {
          type = types.enum [ "noAuthNoPriv" "authNoPriv" "authPriv" ];
          default = "authPriv";
          example = "authPriv";
          description = lib.mdDoc ''
            Security level for SNMPv3. Look at the [documentation](https://snmp.com/snmpv3/snmpv3_intro.shtml) for further information.
          '';
        };
        username = mkOption {
          type = types.str;
          default = "monitor";
          example = "monitor";
          description = lib.mdDoc ''
            Username for SNMPv3. Also known as `Security Name`.
          '';
        };
      };
    };
  };

in {
  options = {
    senpro-it = {
      telegraf = {
        enable = mkEnableOption ''
          Whether to enable the Telegraf monitoring agent.
        '';
      };
    };
  };
  config = (lib.mkIf config.senpro-it.telegraf.enable {
    services = {
      telegraf = {
        enable = true;
        extraConfig = {
          agent = {
            interval = "60s";
            snmp_translator = "gosmi";
          };
        };
      };
    };
  });
}

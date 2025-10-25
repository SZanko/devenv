{ pkgs, config, lib, ... }:

let
  cfg = config.languages.clojure;
  inherit (lib) types mkEnableOption mkOption mkDefault mkIf optional literalExpression;
in
{
  options.languages.clojure = {
    enable = lib.mkEnableOption "tools for Clojure development";
    leinigen = {
      enable = mkEnableOption "leinigen";
      package = mkOption {
        type = types.package;
        defaultText = literalExpression "pkgs.leinigen.override { jdk_headless = cfg.jdk.package; }";
        description = ''
          The leinigen package to use.
          The leinigen package by default inherits the JDK from `languages.java.jdk.package`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    packages = with pkgs; [
      (clojure.override {
        jdk = config.languages.java.jdk.package;
      })
      clojure-lsp

    ]
    ++ (optional cfg.leinigen.enable cfg.leinigen.package);
    languages.java.enable = true;
  };
}

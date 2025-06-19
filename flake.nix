{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      system = flake-utils.lib.system.x86_64-linux;
      pkgs = nixpkgs.legacyPackages.${system};
      my-packages = import ./pkgs { inherit pkgs; };
      programSrc = pkgs.fetchFromGitHub {
        owner = "IntQuant";
        repo = "noita_entangled_worlds";
        rev = "ba7a561ffd4ccf3e4dce8939de782c6fb5ebcafe";
        sha256 = "sha256-rTO0/eWTJDp1j8Non4tB1CnzzycqcLE1qBdUteJdhcA=";
      };
      program = (
        {
          lib,
          fetchFromGitHub,
          rustPlatform,
          cargo,
          rustc,
          python3,
          xorg,
        }:
        let
          cargoFile = pkgs.writeText "$out" ''
            [workspace]
            members = ["tangled"]
            resolver = "2"

            [package]
            name = "noita-proxy"
            description = "Noita Entangled Worlds companion app."
            version = "0.30.8"
            edition = "2021"

            # See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

            [dependencies]
            eframe = { version="0.29.1", features = ["glow", "default_fonts"], default-features = false }
            egui-file-dialog = "0.7.0"
            egui_extras = { version = "0.29.1", features = ["all_loaders"] }
            egui_plot = "0.29.0"
            image = { version = "0.25.1", default-features = false, features = ["png", "webp"] }

            ron = "0.8.1"
            tungstenite = "0.24.0"
            tracing-subscriber = { version = "0.3.18", features = ["env-filter"] }
            tracing = "0.1.40"
            tangled = { path = "tangled" }
            serde = { version = "1.0.207", features = ["serde_derive", "derive"] }
            bitcode = "0.6.3"
            lz4_flex = { version = "0.11.3", default-features = false, features = ["std"]}
            rand = "0.8.5"
            steamworks = { git = "https://github.com/IntQuant/steamworks-rs", branch = "avatar-fix" }
            crossbeam = { version = "0.8.4", features = ["crossbeam-channel"] }
            clipboard = "0.5.0"
            socket2 = { version = "0.5.7", features = ["all"] }
            reqwest = { version = "0.12.4", features = ["blocking", "json", "http2", "rustls-tls-native-roots", "charset"], default-features = false}
            serde_json = "1.0.117"
            thiserror = "2.0.2"
            poll-promise = "0.3.0"
            zip = "2.2.0"
            self-replace = "1.3.7"
            bytemuck = { version = "1.16.0", features = ["derive"] }
            bincode = "1.3.3"
            rustc-hash = "2.0.0"
            fluent-templates = "0.11.0"
            unic-langid = { version = "0.9.5", features = ["serde"] }
            fluent-bundle = "0.15.3"
            crc = "3.2.1"
            argh = "0.1.12"
            shlex = "1.3.0"
            quick-xml = { version = "0.37.0", features = ["serialize"] }
            dashmap = "6.0.1"
            eyre = "0.6.12"
            tokio = { version = "1.40.0", features = ["macros", "rt-multi-thread"] }
            tracing-appender = "0.2.3"
            shared = {path = "${programSrc}/shared"}

            [build-dependencies]
            winresource = "0.1.17"

            [profile.dev]
            opt-level = 1

            [profile.release]
            lto = true
            strip = true

            [profile.release-lto]
            inherits = "release"
          '';
          fixedSrcs = pkgs.stdenv.mkDerivation {
            name = "fixedSrcs";
            buildCommand = ''
              mkdir -p $out
              cp -r ${programSrc}/noita-proxy/* .
              rm Cargo.toml
              cp ${cargoFile} Cargo.toml
              cp -r * $out
            '';
          };
        in
        rustPlatform.buildRustPackage rec {
          pname = "noita";
          version = "1.0.0";

          src = fixedSrcs;

          cargoHash = "sha256-D+TTIwx0N7yx/AK19r/KFO43u2DsggJe9SJs5DMzVbg=";
          useFetchCargoVendor = true;
          nativeBuildInputs = [
            cargo
            rustPlatform.cargoSetupHook
            rustc
            python3
            xorg.libxcb
          ];
          buildInputs = [
            pkgs.xorg.libxcb
            pkgs.libxkbcommon
            pkgs.libGL

            # WINIT_UNIX_BACKEND=wayland
            pkgs.wayland

            # WINIT_UNIX_BACKEND=x11
            pkgs.xorg.libXcursor
            pkgs.xorg.libXrandr
            pkgs.xorg.libXi
            pkgs.xorg.libX11
          ];
          doCheck = false;
          # buildPhase = ''
          # cargo build -j 16 --profile=dev
          # '';
          # cargoLock.lockFile = "${programSrc}/noita-proxy/Cargo.lock";
          # cargoLock.outputHashes = {
          #   "steamworks-0.11.0" = "sha256-brAAzwJQpefWJWCveHqBLvrlAi0tUn07V/XkWXCj8PE=";
          # };
        }
      );
      # noitastuff = pkgs.writeShellScriptBin "noitastuff" ''
      #   exec ./noita_proxy.x86_64 "$@"
      # '';
      # noitaenv = pkgs.buildFHSEnv {
      #   name = "noitasrv";
      #   runScript = "noitastuff";
      #   targetPkgs = pkgs: [
      #     noitastuff
      #     pkgs.zsh
      #     pkgs.libxkbcommon
      #     pkgs.libGL

      #     # WINIT_UNIX_BACKEND=wayland
      #     pkgs.wayland

      #     pkgs.xorg.libxcb

      #     # WINIT_UNIX_BACKEND=x11
      #     pkgs.xorg.libXcursor
      #     pkgs.xorg.libXrandr
      #     pkgs.xorg.libXi
      #     pkgs.xorg.libX11
      #   ];
      # };
      rustProgram = (pkgs.callPackage program { });
      injectDeps = pkgs.stdenv.mkDerivation {
        name = "injected";
        version = "1.0.0";
        buildInputs = [
          rustProgram
          pkgs.libxkbcommon
          pkgs.libGL
          pkgs.wayland
          pkgs.xorg.libxcb
          pkgs.xorg.libXcursor
          pkgs.xorg.libXrandr
          pkgs.xorg.libXi
          pkgs.xorg.libX11
          pkgs.gcc
          pkgs.libgcc
        ];
        nativeBuildInputs = [
          pkgs.autoPatchelfHook
        ];
        src = programSrc;
        buildPhase = ''
          mkdir -p $out
          cp -r ${rustProgram}/bin/noita-proxy $out
          cp ${programSrc}/redist/* $out
        '';
      };
      launcher = pkgs.writeShellScriptBin "launch_noita_srv" ''
        ${injectDeps}/noita-proxy --launch-cmd "steam-run ~/.local/share/Steam/steamapps/common/SteamLinuxRuntime_soldier/_v2-entry-point --verb=run $1 run /home/valde/.local/share/Steam/steamapps/common/Noita/noita.exe"
      '';
    in
    {
      devShells.${system}.default = pkgs.mkShell rec {
        name = "shell";
        buildInputs = [
          pkgs.libxkbcommon
          pkgs.libGL

          # WINIT_UNIX_BACKEND=wayland
          pkgs.wayland

          pkgs.xorg.libxcb

          # WINIT_UNIX_BACKEND=x11
          pkgs.xorg.libXcursor
          pkgs.xorg.libXrandr
          pkgs.xorg.libXi
          pkgs.xorg.libX11
        ];
        nativeBuildInputs = [
          launcher
        ];
        LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath buildInputs}";
      };
      # devShells.${system}.default = (pkgs.buildFHSEnv {
      #     name = "game-env";
      #     targetPkgs = pkgs: [
      #       pkgs.zsh
      #       pkgs.libxkbcommon
      #       pkgs.libGL

      #       # WINIT_UNIX_BACKEND=wayland
      #       pkgs.wayland

      #       pkgs.xorg.libxcb

      #       # WINIT_UNIX_BACKEND=x11
      #       pkgs.xorg.libXcursor
      #       pkgs.xorg.libXrandr
      #       pkgs.xorg.libXi
      #       pkgs.xorg.libX11
      #     ];
      #     runScript = "zsh";
      # }).env;

      packages.${system} = {
        inherit (my-packages) noita-proxy-unwrapped noita-proxy;
      };
    };

}

{
  lib,
  rustPlatform,
  cargo-tauri,
  bun,
  jq,
  moreutils,
}:
let
  cargoManifest = (lib.importTOML ./src-tauri/Cargo.toml).package;
in
rustPlatform.buildRustPackage rec {
  pname = "opentinytask";

  version = cargoManifest.version;
  src = ./.;

  cargoRoot = "src-tauri";
  useFetchCargoVendor = true;

  nativeBuildInputs = [
    cargo-tauri.hook
    bun
    jq
    moreutils
  ];

  preBuild = ''
    bun install
  '';

  postPatch = ''
    tauri_conf="src-tauri/tauri.conf.json"
    jq '.bundle.createUpdaterArtifacts = false' "$tauri_conf" | sponge "$tauri_conf"
  '';
  cargoLock.lockFile = "${src}/src-tauri/Cargo.lock";

  meta = {
    description = "Open alternate version of tinytask";
    mainProgram = "opentinytask";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eveeifyeve ];
  };
}

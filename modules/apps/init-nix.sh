help() {
  cat <<EOF

#############################################################################
  Initial NixOS setup

  So that the secrets get cloned correctly, following environment variables 
  have to be set (or passed as args):
  PASS_STORE_REPO_FILE="file containing git url to your password-store repo"
  SOPS_SECRET_REPO_FILE="file containing git url to your sops secrets repo"
  
  Syntax: nix run .#init-nix -[h|t (profile)|n (hostname)|p (url)|s (url)]

  Options:
  h     print this help
  n     hostname of the new machine
  t     profile (type) of the new machine
  p     password store repo url
  s     sops repo url
#############################################################################

EOF
}

while getopts ":hs:t:p:n:" arg; do
  case $arg in
  n) hostname="$OPTARG" ;;
  t) profile="$OPTARG" ;;
  p) pass_url="$OPTARG" ;;
  s) sops_url="$OPTARG" ;;
  h | *) help && exit 0 ;;
  esac
done

[ "$pass_url" = "" ] && [ -f "$PASS_STORE_REPO_FILE" ] && pass_url="$(cat "$PASS_STORE_REPO_FILE")"
[ "$sops_url" = "" ] && [ -f "$SOPS_SECRET_REPO_FILE" ] && sops_url="$(cat "$SOPS_SECRET_REPO_FILE")"

[ "$hostname" = "" ] && echo "please provide a hostname with -n" && exit 1
[ "$pass_url" = "" ] && echo "please provide your pass-store git url with -p" && exit 1
[ "$sops_url" = "" ] && echo "please provide your sops git url with -s" && exit 1

hostcfgdir="./modules/hosts"

[ -d "$hostcfgdir/$hostname" ] && echo "configs for $hostname already exist!" && exit 1

echo "creating configurations..."
# nixos-generate-config

echo "copying configuration files..."
cp -r "$hostcfgdir"/generic-template "$hostcfgdir/$hostname"
cp -f /etc/nixos/{,hardware-}configuration.nix "$hostcfgdir/$hostname"

echo "cloning secrets..."

# envvar, defaultdir, repo
get_or_clone_secrets() {
  dir="$1"
  [ "$1" = "" ] && dir="$2"
  if [ ! -d "$dir" ]; then
    echo "cloning secret..."
    mkdir -p "$dir"
    git clone "$3" "$dir"
  fi
}

get_or_clone_secrets "$PASSWORD_STORE_DIR" "$HOME/.local/share/pass" "$pass_url"
get_or_clone_secrets "$SOPS_SECRET_DIR" "$HOME/.config/sops" "$sops_url"
get_or_clone_secrets "$PGP_KEYS_DIR" "$HOME/.tmp/pgp-keys" "$pgp_url"

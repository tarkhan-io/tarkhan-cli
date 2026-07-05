#!/usr/bin/env bash
# Tarkhan CLI installer (macOS / Linux)
#   curl -fsSL https://raw.githubusercontent.com/tarkhan-io/tarkhan-cli/main/install.sh | bash
set -euo pipefail

REPO="${TARKHAN_CLI_REPO:-tarkhan-io/tarkhan-cli}"
TARKHAN_HOME="${TARKHAN_HOME:-$HOME/.tarkhan}"

echo "> tarkhan installer - querying latest release"
meta=$(curl -fsSL "https://raw.githubusercontent.com/$REPO/main/version.json")
ver=$(echo "$meta" | grep '"version"' | sed 's/.*"version": *"\([^"]*\)".*/\1/')
asset=$(echo "$meta" | grep '"asset"' | sed 's/.*"asset": *"\([^"]*\)".*/\1/')

app_dir="$TARKHAN_HOME/app"
dest="$app_dir/$ver"
mkdir -p "$dest"

tmp=$(mktemp /tmp/tarkhan-cli-XXXXXX.tar.gz)
trap 'rm -f "$tmp"' EXIT
echo "> downloading $asset"
curl -fsSL "$asset" -o "$tmp"
echo "> extracting to $dest"
tar -xzf "$tmp" -C "$dest"

# Repoint current
echo -n "$ver" > "$app_dir/current"

# Install launcher to ~/.local/bin (XDG standard; on PATH by default on most systems)
bin_dir="$HOME/.local/bin"
mkdir -p "$bin_dir"

cat > "$bin_dir/tarkhan" <<LAUNCHER
#!/usr/bin/env bash
tkver=\$(cat "$app_dir/current")
exec node "$app_dir/\$tkver/bin/tarkhan" "\$@"
LAUNCHER
chmod +x "$bin_dir/tarkhan"

# PATH check
case ":${PATH}:" in
  *":$bin_dir:"*) ;;
  *)
    echo ""
    echo "> warning: '$bin_dir' is not on your PATH."
    echo "> Add this line to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
    echo ">   export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo "> Then restart your shell or run: export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    ;;
esac

echo "> installed tarkhan $ver - run 'tarkhan --version'"

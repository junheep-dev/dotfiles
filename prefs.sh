#!/bin/zsh

# Syncs preferences for GUI apps that have no file-based config.
# Their settings live only in a `defaults` domain, so we snapshot the domain
# into prefs/, keeping only the keys listed below.

DOTFILES_DIR="${0:A:h}"
source "$DOTFILES_DIR/scripts/utils.sh"

PREFS_DIR="$DOTFILES_DIR/prefs"
AGENT_LABEL="com.junhee.dotfiles.prefs-export"
AGENT_PLIST="$HOME/Library/LaunchAgents/$AGENT_LABEL.plist"

# <defaults domain>:<process name to quit before importing>
DOMAINS=(
  "com.knollsoft.Rectangle:Rectangle"
  "pl.maketheweb.cleanshotx:CleanShot X"
  "com.lwouis.alt-tab-macos:AltTab"
)

# Keys that must never reach a snapshot because the repo is public. The
# allowlists below already exclude them; this guards against a careless glob.
SECRETS=(
  "activationKey"
)

# The keys worth carrying to a new machine. Anything not listed - window
# positions, updater state, usage counters, license keys - stays behind and the
# app falls back to its own default.
keeps_for() {
  case "$1" in
    com.knollsoft.Rectangle)
      # cycleSizesIsChanged is the switch that makes selectedCycleSizes apply
      # at all (CycleSize.swift), so the two travel together.
      print -l \
        "gapSize" "skipGapTopEdge" \
        "selectedCycleSizes" "cycleSizesIsChanged" \
        "subsequentExecutionMode" "showAdditionalSizesInMenu" \
        "alternateDefaultShortcuts" "allowAnyShortcut" \
        "launchOnLogin" "hideMenubarIcon"
      ;;
    pl.maketheweb.cleanshotx)
      print -l \
        "LAVA*" \
        "exportPath" "afterScreenshotActions" "afterVideoActions" \
        "captureWithoutDesktopIcons" \
        "showKeystrokes" "keyboardOverlayPosition" "highlightClicks" \
        "autoClosePopup" "popupAutoCloseMode" \
        "showMenubarIcon"
      ;;
    com.lwouis.alt-tab-macos)
      # Keys carry no suffix for shortcut set 1 and a "2" for set 2
      # (Preferences.swift: baseName + (index == 0 ? "" : String(index + 1))).
      # Only set 1 is synced; the rest falls back to AltTab's defaults.
      print -l \
        "holdShortcut" "shortcutStyle" \
        "appsToShow" "spacesToShow" "screensToShow" \
        "showHiddenWindows" "showMinimizedWindows" "showWindowlessApps" \
        "windowDisplayDelay"
      ;;
  esac
}

# Keeps only the allowlisted keys and writes a sorted XML plist so diffs stay
# readable. Aborts if a secret slips through, and warns about a pattern that
# matched nothing - that means the app renamed or dropped the key.
select_keys() {
  local src="$1" dst="$2" secret_count="$3"
  shift 3
  python3 - "$src" "$dst" "$secret_count" "$@" <<'PY'
import fnmatch, os, plistlib, sys

src, dst, secret_count = sys.argv[1], sys.argv[2], int(sys.argv[3])
rest = sys.argv[4:]
secrets, patterns = rest[:secret_count], rest[secret_count:]

with open(src, "rb") as f:
    data = plistlib.load(f)

kept = {k: v for k, v in data.items()
        if any(fnmatch.fnmatch(k, p) for p in patterns)}

# A path under this machine's home is stored as "~/..." so it still resolves
# on a machine with a different user name.
home = os.path.expanduser("~")
kept = {k: f"~{v[len(home):]}" if isinstance(v, str) and (v == home or v.startswith(home + "/")) else v
        for k, v in kept.items()}

leaked = [k for k in kept if any(fnmatch.fnmatch(k, s) for s in secrets)]
if leaked:
    sys.exit(f"secret key matched the allowlist: {', '.join(leaked)}")

unmatched = [p for p in patterns if not any(fnmatch.fnmatch(k, p) for k in data)]
if unmatched:
    print(f"no key matched: {', '.join(unmatched)}", file=sys.stderr)

with open(dst, "wb") as f:
    plistlib.dump(kept, f, sort_keys=True)

print(f"{len(data)} -> {len(kept)}")
PY
}

# Undoes the export-side rewrite: "~/..." becomes this machine's home.
expand_paths() {
  python3 - "$1" "$2" <<'PY'
import os, plistlib, sys

with open(sys.argv[1], "rb") as f:
    data = plistlib.load(f)

data = {k: os.path.expanduser(v) if isinstance(v, str) and (v == "~" or v.startswith("~/")) else v
        for k, v in data.items()}

with open(sys.argv[2], "wb") as f:
    plistlib.dump(data, f, sort_keys=True)
PY
}

cmd_export() {
  print_section "Export app preferences"
  mkdir -p "$PREFS_DIR"

  local tmp
  tmp=$(mktemp -d)
  trap "rm -rf '$tmp'" EXIT

  local entry domain snapshot raw counts
  for entry in "${DOMAINS[@]}"; do
    domain="${entry%%:*}"
    snapshot="$PREFS_DIR/$domain.plist"
    raw="$tmp/$domain.plist"

    print_header "$domain"
    if ! defaults export "$domain" "$raw" 2>/dev/null; then
      print_error "Domain not found - is the app installed?"
      continue
    fi

    local -a keeps
    keeps=(${(f)"$(keeps_for "$domain")"})
    if (( ${#keeps} == 0 )); then
      print_error "No allowlist defined for $domain"
      continue
    fi

    if ! counts=$(select_keys "$raw" "$tmp/selected.plist" "${#SECRETS[@]}" "${SECRETS[@]}" "${keeps[@]}"); then
      print_error "Selection failed, snapshot left untouched"
      continue
    fi

    if [[ -f "$snapshot" ]] && cmp -s "$tmp/selected.plist" "$snapshot"; then
      print_step "unchanged ($counts keys)"
    else
      mv "$tmp/selected.plist" "$snapshot"
      print_step "updated ($counts keys)"
    fi
  done

  print_success "Export complete"
}

cmd_import() {
  print_section "Import app preferences"

  local tmp
  tmp=$(mktemp -d)
  trap "rm -rf '$tmp'" EXIT

  local entry domain app snapshot
  for entry in "${DOMAINS[@]}"; do
    domain="${entry%%:*}"
    app="${entry#*:}"
    snapshot="$PREFS_DIR/$domain.plist"

    print_header "$app"
    if [[ ! -f "$snapshot" ]]; then
      print_error "No snapshot at $snapshot"
      continue
    fi

    # A running app holds its own copy of the domain and writes it back on quit,
    # which would undo the import.
    print_step "Quitting $app"
    killall "$app" 2>/dev/null

    # Merge rather than replace: the snapshot holds only the curated keys, and
    # `defaults import` would otherwise wipe the app's own state, license included.
    if ! expand_paths "$snapshot" "$tmp/expanded.plist"; then
      print_error "Failed to read $snapshot"
      continue
    fi

    if defaults import "$domain" "$tmp/expanded.plist"; then
      print_step "Imported $domain"
      open -a "$app" 2>/dev/null
    else
      print_error "Failed to import $domain"
    fi
  done

  print_success "Import complete"
}

# Runs once a day. StartCalendarInterval (unlike StartInterval) coalesces
# missed firings and runs on the next wake, which matters on a laptop.
cmd_install_agent() {
  print_section "Install preferences export agent"

  mkdir -p "$HOME/Library/LaunchAgents"
  cat > "$AGENT_PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>$AGENT_LABEL</string>
	<key>ProgramArguments</key>
	<array>
		<string>$DOTFILES_DIR/prefs.sh</string>
		<string>export</string>
	</array>
	<key>StartCalendarInterval</key>
	<dict>
		<key>Hour</key>
		<integer>21</integer>
		<key>Minute</key>
		<integer>0</integer>
	</dict>
	<key>StandardOutPath</key>
	<string>$HOME/Library/Logs/$AGENT_LABEL.log</string>
	<key>StandardErrorPath</key>
	<string>$HOME/Library/Logs/$AGENT_LABEL.log</string>
</dict>
</plist>
PLIST

  launchctl bootout "gui/$UID/$AGENT_LABEL" 2>/dev/null
  launchctl bootstrap "gui/$UID" "$AGENT_PLIST"

  print_success "Agent installed - exports daily at 21:00"
}

case "${1:-}" in
  export)        cmd_export ;;
  import)        cmd_import ;;
  install-agent) cmd_install_agent ;;
  *)
    echo "Usage: ./prefs.sh <export|import|install-agent>"
    echo
    echo "  export         Snapshot app preferences into prefs/"
    echo "  import         Apply prefs/ snapshots to this machine"
    echo "  install-agent  Run export daily via launchd"
    exit 1
    ;;
esac

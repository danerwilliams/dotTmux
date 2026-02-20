#!/usr/bin/env bash
# Custom continuum status: shows "Last saved at HH:MM" instead of countdown
export LC_ALL=en_US.UTF-8

if [ -d "$HOME/.tmux/resurrect" ]; then
  default_resurrect_dir="$HOME/.tmux/resurrect"
else
  default_resurrect_dir="${XDG_DATA_HOME:-$HOME/.local/share}"/tmux/resurrect
fi
resurrect_dir_option="@resurrect-dir"
auto_save_interval_option="@continuum-save-interval"
auto_save_interval_default="15"

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

current_timestamp() {
  echo "$(date +%s)"
}

file_mtime() {
  if [ ! -f "$1" ]; then
    echo -1
    return
  fi
  case $(uname -s) in
    Linux|Darwin)
      date -r "$1" +%s
      ;;
    FreeBSD)
      stat -f %m "$1"
      ;;
  esac
}

resurrect_dir() {
  if [ -z "$_RESURRECT_DIR" ]; then
    local path="$(get_tmux_option "$resurrect_dir_option" "$default_resurrect_dir")"
    echo "$path" | sed "s,\$HOME,$HOME,g; s,\$HOSTNAME,$(hostname),g; s,\~,$HOME,g"
  else
    echo "$_RESURRECT_DIR"
  fi
}
_RESURRECT_DIR="$(resurrect_dir)"

last_resurrect_file() {
  echo "$(resurrect_dir)/last"
}

last_saved_timestamp() {
  # Always read the actual file mtime for an accurate timestamp
  echo "$(file_mtime "$(last_resurrect_file)")"
}

timestamp_to_time() {
  case $(uname -s) in
    Linux)
      TZ=America/New_York date -d "@$1" '+%I:%M%p'
      ;;
    Darwin|FreeBSD)
      TZ=America/New_York date -r "$1" '+%I:%M%p'
      ;;
  esac
}

save_if_needed() {
  local save_int="$(get_tmux_option "$auto_save_interval_option" "$auto_save_interval_default")"
  local interval_seconds="$((save_int * 60))"
  local last_mtime="$(file_mtime "$(last_resurrect_file)")"
  local now="$(current_timestamp)"

  if [[ "$last_mtime" == "-1" ]] || [[ $((now - last_mtime)) -ge $interval_seconds ]]; then
    local save_script="$(get_tmux_option "@resurrect-save-script-path" "")"
    if [[ -n "$save_script" ]] && [[ -x "$save_script" ]]; then
      "$save_script" "quiet" >/dev/null 2>&1
    fi
  fi
}

print_status() {
  local save_int="$(get_tmux_option "$auto_save_interval_option" "$auto_save_interval_default")"

  save_if_needed

  local last_timestamp="$(last_saved_timestamp)"

  if [[ $save_int -gt 0 ]]; then
    if [[ "$last_timestamp" == "-1" ]] || [[ -z "$last_timestamp" ]]; then
      echo "no save"
    else
      echo "Last saved at $(timestamp_to_time "$last_timestamp")"
    fi
  else
    echo "off"
  fi
}

print_status

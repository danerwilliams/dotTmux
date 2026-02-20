#!/usr/bin/env bash
# Custom continuum status: shows "Last saved at HH:MM" instead of countdown
export LC_ALL=en_US.UTF-8

if [ -d "$HOME/.tmux/resurrect" ]; then
  default_resurrect_dir="$HOME/.tmux/resurrect"
else
  default_resurrect_dir="${XDG_DATA_HOME:-$HOME/.local/share}"/tmux/resurrect
fi
resurrect_dir_option="@resurrect-dir"
last_auto_save_option="@continuum-save-last-timestamp"
auto_save_interval_option="@continuum-save-interval"
auto_save_interval_default="15"
first_save="@dracula-continuum-first-save"

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

set_tmux_option() {
  local option="$1"
  local value="$2"
  tmux set-option -gq "$option" "$value"
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
  local last_saved_timestamp="$(get_tmux_option "$last_auto_save_option" "")"
  local first_save_timestamp="$(get_tmux_option "$first_save" "")"
  if [ -z "$first_save_timestamp" ]; then
    last_saved_timestamp="$(file_mtime "$(last_resurrect_file)")" || last_saved_timestamp=-1
    set_tmux_option "$first_save" "$last_saved_timestamp"
  elif [ "$first_save_timestamp" != "done" ]; then
    last_saved_timestamp="$(file_mtime "$(last_resurrect_file)")" || last_saved_timestamp=-1
    if [ "$last_saved_timestamp" -gt "$first_save_timestamp" ]; then
      set_tmux_option "$first_save" "done"
    else
      last_saved_timestamp="$first_save_timestamp"
    fi
  fi
  echo "$last_saved_timestamp"
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

print_status() {
  local save_int="$(get_tmux_option "$auto_save_interval_option" "$auto_save_interval_default")"
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

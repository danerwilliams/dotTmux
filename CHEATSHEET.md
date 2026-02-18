# Tmux Cheat Sheet

Prefix key: `Ctrl+Space` (hold Ctrl, press Space, release both, then press the next key)

## Sessions
| Action | Keys |
|--------|------|
| New session | `tmux new -s name` |
| List sessions | `tmux ls` |
| Attach to session | `tmux attach -t name` |
| Detach from session | `prefix + d` |
| Kill session | `tmux kill-session -t name` |

## Windows (tabs)
| Action | Keys |
|--------|------|
| New window | `prefix + c` |
| Next window | `prefix + n` |
| Previous window | `prefix + p` |
| Go to window N | `prefix + N` (e.g. `prefix + 1`) |
| Rename window | `prefix + ,` |
| Close window | `prefix + &` (or just `exit` in last pane) |

## Panes (splits) — via tmux-pain-control
| Action | Keys |
|--------|------|
| Split vertically (side-by-side) | `prefix + \|` |
| Split horizontally (top/bottom) | `prefix + -` |
| Navigate left/down/up/right | `prefix + h/j/k/l` |
| Resize left/down/up/right | `prefix + H/J/K/L` |
| Close pane | `prefix + x` (or just `exit`) |
| Toggle pane zoom (fullscreen) | `prefix + z` |
| Swap pane positions | `prefix + {` or `prefix + }` |

## Copy Mode & Search (vi mode)
| Action | Keys |
|--------|------|
| Enter copy mode | `prefix + [` (or scroll up with mouse) |
| Search forward | `/pattern` then Enter |
| Search backward | `?pattern` then Enter |
| Next/prev match | `n` / `N` |
| Start selection | `v` |
| Copy selection | `y` (copies to system clipboard via tmux-yank) |
| Exit copy mode | `q` or `Enter` |
| Move around | `h/j/k/l` or arrow keys |
| Page up/down | `Ctrl+u` / `Ctrl+d` |

## Session Restore (resurrect + continuum)
| Action | Keys |
|--------|------|
| Manual save | `prefix + Ctrl+s` |
| Manual restore | `prefix + Ctrl+r` |
| Auto-save | Every 10 min (via continuum) |
| Auto-restore | On tmux start (via continuum) |

## Other
| Action | Keys |
|--------|------|
| Reload config | `prefix + r` |
| Install plugins | `prefix + I` (capital i) |
| Update plugins | `prefix + U` |
| Show time | `prefix + t` |
| List keybindings | `prefix + ?` |

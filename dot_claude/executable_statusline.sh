#!/usr/bin/env bash

# Redirect all stderr to /dev/null to prevent UI interference
exec 2>/dev/null

# Read JSON input from stdin
input=$(cat)

# Extract model display name with fallback
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name // .model.id // "Claude"')

# Extract current directory with fallback
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir // .workspace.project_dir // .cwd // empty')

# If still empty, use PWD
if [ -z "$CURRENT_DIR" ] || [ "$CURRENT_DIR" = "null" ]; then
  CURRENT_DIR="$PWD"
fi

# Truncate directory name if too long (max 20 chars)
DIR_NAME="${CURRENT_DIR##*/}"
if [ ${#DIR_NAME} -gt 20 ]; then
  DIR_NAME="${DIR_NAME:0:17}..."
fi

# Use jq for all calculations (avoids locale issues with bc/awk/printf).
# Missing values come back as "-" so the shell side can drop that section.
IFS=$'\t' read -r effort_level ctx_used ctx_size ctx_pct cost_usd h5_pct h5_left d7_pct d7_left < <(echo "$input" | jq -r '
  def fmtnum:
    if . >= 1000000 then ((. / 1000000 * 10 | round) / 10 | tostring) + "M"
    elif . >= 1000 then ((. / 1000 * 10 | round) / 10 | tostring) + "K"
    else (. | tostring) end;
  def fmtdur:
    (. | floor) as $s |
    if $s <= 0 then "0m"
    elif $s >= 86400 then "\($s / 86400 | floor)d\(($s % 86400) / 3600 | floor)h"
    else (($s / 3600) | floor) as $h | ((($s % 3600) / 60) | floor) as $m |
      (if $h > 0 then "\($h)h\($m)m" else "\($m)m" end)
    end;
  (.context_window // {}) as $ctx |
  (.rate_limits // {}) as $rl |
  [
    (.effort.level // "-"),
    (if $ctx.used_percentage == null then "-"
     else (($ctx.total_input_tokens // 0) + ($ctx.total_output_tokens // 0)) | fmtnum end),
    (if $ctx.context_window_size == null then "-" else $ctx.context_window_size | fmtnum end),
    (if $ctx.used_percentage == null then "-" else $ctx.used_percentage | round | tostring end),
    (if .cost.total_cost_usd == null then "-"
     else (.cost.total_cost_usd * 100 | round) as $c |
       "\($c / 100 | floor).\($c % 100 | tostring | if length == 1 then "0" + . else . end)" end),
    (if $rl.five_hour.used_percentage == null then "-" else $rl.five_hour.used_percentage | round | tostring end),
    (if $rl.five_hour.resets_at == null then "-" else ($rl.five_hour.resets_at - now) | fmtdur end),
    (if $rl.seven_day.used_percentage == null then "-" else $rl.seven_day.used_percentage | round | tostring end),
    (if $rl.seven_day.resets_at == null then "-" else ($rl.seven_day.resets_at - now) | fmtdur end)
  ] | @tsv
')

# ANSI color codes
RED=$'\033[31m'
YELLOW=$'\033[33m'
GREEN=$'\033[32m'
DIM=$'\033[2m'
RESET=$'\033[0m'

# Colorize a percentage: green below 70, yellow below 90, red at 90 and above
colorize_pct() {
  local pct="$1"
  if [ -z "$pct" ] || [ "$pct" = "-" ]; then
    echo "${DIM}-%${RESET}"
  elif [ "$pct" -ge 90 ]; then
    echo "${RED}${pct}%${RESET}"
  elif [ "$pct" -ge 70 ]; then
    echo "${YELLOW}${pct}%${RESET}"
  else
    echo "${GREEN}${pct}%${RESET}"
  fi
}

# Effort level shown next to the model name
if [ "$effort_level" = "-" ]; then
  EFFORT_SEGMENT=""
else
  EFFORT_SEGMENT="${DIM}(${effort_level})${RESET}"
fi

# Context window: used/limit(percentage)
if [ "$ctx_used" = "-" ]; then
  CONTEXT_SEGMENT="📊${DIM}-${RESET}"
else
  CONTEXT_SEGMENT="📊${ctx_used}/${ctx_size}($(colorize_pct "$ctx_pct"))"
fi

# Session cost so far
if [ "$cost_usd" = "-" ]; then
  COST_SEGMENT=""
else
  COST_SEGMENT=" | 💰\$${cost_usd}"
fi

# Rate limits: hourglass for the 5-hour session window, calendar for the 7-day window
LIMIT_SEGMENT=""
if [ "$h5_pct" != "-" ]; then
  LIMIT_SEGMENT=" | ⏳5h $(colorize_pct "$h5_pct")"
  if [ "$h5_left" != "-" ]; then
    LIMIT_SEGMENT="${LIMIT_SEGMENT}${DIM}(${h5_left})${RESET}"
  fi
fi
if [ "$d7_pct" != "-" ]; then
  # Both windows are the same kind of limit, so a space separates them, not a pipe
  if [ -z "$LIMIT_SEGMENT" ]; then D7_PREFIX=" | "; else D7_PREFIX=" "; fi
  LIMIT_SEGMENT="${LIMIT_SEGMENT}${D7_PREFIX}📅7d $(colorize_pct "$d7_pct")"
  if [ "$d7_left" != "-" ]; then
    LIMIT_SEGMENT="${LIMIT_SEGMENT}${DIM}(${d7_left})${RESET}"
  fi
fi

# Emoji icons are environment-dependent (font coverage and cell width).
# Replace them with ASCII labels if the status line renders misaligned.
echo "🤖${MODEL_DISPLAY}${EFFORT_SEGMENT} | 📁${DIR_NAME} | ${CONTEXT_SEGMENT}${COST_SEGMENT}${LIMIT_SEGMENT}"

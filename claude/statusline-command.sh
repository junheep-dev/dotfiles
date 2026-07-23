#!/bin/bash

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

RED='\033[31m'
GREEN='\033[32m'
RESET='\033[0m'

parts=""

# Model (bold)
if [ -n "$model" ]; then
  parts="$(printf "${GREEN}%s${RESET}" "$model")"
fi

# Context usage
if [ -n "$used_pct" ]; then
  pct_int=$(printf '%.0f' "$used_pct")
  if [ "$pct_int" -ge 80 ]; then
    parts="$parts $(printf "| ${RED}ctx %d%%${RESET}" "$pct_int")"
  else
    parts="$parts $(printf "| ctx %d%%" "$pct_int")"
  fi
fi

# 5-hour rate limit (only show when >= 80%)
if [ -n "$five_hour_pct" ]; then
  pct_int=$(printf '%.0f' "$five_hour_pct")
  if [ "$pct_int" -ge 80 ]; then
    parts="$parts $(printf "| ${RED}5h %d%%${RESET}" "$pct_int")"
  fi
fi

# 7-day rate limit (only show when >= 80%)
if [ -n "$seven_day_pct" ]; then
  pct_int=$(printf '%.0f' "$seven_day_pct")
  if [ "$pct_int" -ge 80 ]; then
    parts="$parts $(printf "| ${RED}7d %d%%${RESET}" "$pct_int")"
  fi
fi

printf '%b' "$parts"

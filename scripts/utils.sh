#!/bin/zsh

# Colors for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Print functions
print_section() {
  echo -e "\n${CYAN}${BOLD}═══════════════════════════════════════════${NC}"
  echo -e "${CYAN}${BOLD}  $1${NC}"
  echo -e "${CYAN}${BOLD}═══════════════════════════════════════════${NC}"
}

print_header() {
  echo -e "\n${YELLOW}${BOLD}[$1]${NC}"
}

print_step() {
  echo -e "\n${BLUE}$1${NC}"
}

print_success() {
  echo -e "\n${GREEN}✓ $1${NC}"
}

print_error() {
  echo -e "\n${RED}✗ $1${NC}"
}

# Wait for user confirmation with 'y'
confirm_action() {
  local prompt="$1"
  echo -n "$prompt"
  read -r response
  while [[ "$response" != "y" ]]; do
    echo -n "Please press 'y' and Enter to continue... "
    read -r response
  done
}

#!/bin/zsh

print_header "Node.js"

print_step "Install NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Load nvm to install Node.js
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

print_step "Install Node.js LTS"
nvm install --lts
print_step "Enable Corepack"
corepack enable

print_success "Node.js setup complete"

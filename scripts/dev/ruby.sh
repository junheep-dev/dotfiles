#!/bin/zsh

print_header "Ruby"

print_step "Install rbenv"
brew install rbenv
rbenv init

print_step "Install Ruby latest stable version"
latest_ruby_version=$(rbenv install -l | grep -v - | tail -1)
rbenv install "$latest_ruby_version"

print_step "Set global Ruby version"
rbenv global "$latest_ruby_version"

print_success "Ruby setup complete"

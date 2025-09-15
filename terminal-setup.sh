#!/bin/bash

# source setup_env.sh

# Set custom prompt
export PS1='\[\e[1;32m\]\u\[\e[0m\]:\[\e[1;34m\]\W\[\e[0m\]\$ '

alias ..='cd ..'
alias ...='cd ../..'

# Define alias
alias k=kubectl
alias kgp="kubectl get pods"
alias kpw="kubectl get pods -w"

alias tf="terraform"

# Add this to your ~/.bashrc or ~/.zshrc
alias kdes="sed -n '/Events:/,\$p'"


h() {
  # Extract the number from the command name, e.g. h5 -> 5
  local cmd=${FUNCNAME[0]}
  local num=${cmd#h}   # remove 'h' prefix
  head -n "$num"
}

# Make dynamic commands like h5, h10
for i in {1..100}; do
  eval "h$i() { head -n $i; }"
done

# Dynamic tail: tN -> tail -n N
for i in {1..100}; do
  eval "t$i() { tail -n $i; }"
done

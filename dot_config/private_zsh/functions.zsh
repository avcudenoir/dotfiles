# Custom ZSH Functions

# Tmux session manager - attach to existing session or create new one
,tmux() {
  local session_name="${1:-ghostty}"

  # Check if the session already exists
  tmux has-session -t "$session_name" 2>/dev/null

  if [ $? -eq 0 ]; then
    # If the session exists, reattach to it
    tmux attach-session -t "$session_name"
  else
    # If the session doesn't exist, start a new one
    tmux new-session -s "$session_name" -d
    tmux attach-session -t "$session_name"
  fi
}

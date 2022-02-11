if status is-interactive
    # Commands to run in interactive sessions can go here
end

export PATH="$HOME/.cargo/bin:$PATH"

set -x _JAVA_AWT_WM_NONREPARENTING 1

starship init fish | source

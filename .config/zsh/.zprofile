# remove completions cache on login
# helps speed the shell up over time
if [ -z "$ZDOTDIR/.zcompdump" ]; then
    rm "$ZDOTDIR/.zcompdump"
fi

export PATH="/home/fvhockney/.config/cargo/bin:$PATH"

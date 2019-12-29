# remove completions cache on login
# helps speed the shell up over time
if [ -z "$ZDOTDIR/.zcompdump" ]; then
    rm "$ZDOTDIR/.zcompdump"
fi

is_tty () {
    echo "running"
    local temp
    #temp=$(tty | sed -e 's:/dev/\(^[0-9/]*\)[0-9/]*:\1:')
    #if [ "$temp" = "tty" ]; then
    if [[ $(tty) =~ "tty" ]]; then
        IS_TTY=0
    else
        IS_TTY=1
    fi
    export IS_TTY
}

is_tty

export PATH="/home/fvhockney/.config/cargo/bin:$PATH"

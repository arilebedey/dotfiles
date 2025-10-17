if [[ $(pgrep -f "ft_lock_bot.py") == "" ]]; then
    nohup /home/alebedev/Code/bots/venv_ft_lock/bin/python3 \
        /home/alebedev/Code/bots/ft_lock_bot.py \
        > /home/alebedev/Code/bots/ft_lock_bot.log 2>&1 &
fi

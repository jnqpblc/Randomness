export PROMPT_COMMAND="history -a"
touch ~/.bash_history ~/.bash_logout ~/.bashrc ~/.login ~/.history ~/.profile
chattr +a ~/.bash_history ~/.bash_logout ~/.bashrc ~/.login ~/.history ~/.profile

#/bin/bash
if [ -z $1 ]; then printf "\nSyntax: ./gitSync.sh [pull|push]\n\n"
else

	if [ $1 == push ]; then
		rm -f automated-va/paused.conf
		git add -A
		git commit -am "Pushing changes...";
		git push origin master
	else
		git pull origin master
fi
fi

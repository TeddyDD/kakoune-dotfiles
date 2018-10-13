#!/bin/sh
# Merge all standard autoloads into one file

if [ -e "/usr/share/kak/autoload" ]; then
	auto="/usr/share/kak/autoload"
elif [ -e "/usr/local/share/kak/autoload" ]; then 
	auto="/usr/local/share/kak/autoload"
else 
	echo "No autoload directory found!"
	exit 1
fi

cat $auto/core/**.kak > autoload/0.kak
cat $auto/base/**.kak >> autoload/0.kak
cat $auto/extra/**.kak >> autoload/0.kak


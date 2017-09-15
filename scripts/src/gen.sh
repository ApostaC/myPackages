#!/bin/sh
if [ $# -lt 1 ]; then
	./generate $1
else
	./generate
fi

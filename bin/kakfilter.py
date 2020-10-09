#!/usr/bin/env python3
# https://discuss.kakoune.com/t/filter-your-selections-more-easily/1296

from sys import argv

f = 'lambda sel: ' + argv[1]
filter = eval(f)

def main(input):
    if filter(input):
        exit(0)
    else:
        exit(1)

main(input())


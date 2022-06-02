#!/bin/bash

# Converts all nitter occurrences to twitter

input=`cat`
echo "${input//nitter.net/twitter.com}"

#!/bin/bash

# Converts a Spotify podcast page to RSS

DEFAULT_IFS=$IFS
IFS=$'\n'

input=$(cat)

podcast_url=$(echo $input | grep -o 'https://open.spotify.com/show/[^"]*' | head -1)

podcast_title=$(echo $input | grep -o 'data-testid="showTitle">[^<]*' | sed -n 's/.*>//p' | head -1)

episode_titles=($(echo $input | grep -o 'data-testid="play-button" aria-label="[^"]*' | sed -n "s/.*Play //p"))

episode_links=($(echo $input | grep -o 'href="/episode/[^"]*' | sed -n 's/.*href="/https:\/\/open.spotify.com/p'))

IFS=$DEFAULT_IFS

# TODO extract description
cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>$podcast_title</title>
    <link>$podcast_url</link>
    <description>TODO sample description.</description>
EOF
{
    channels=$(( ${#episode_titles[@]}))
    for i in $(seq 0 $channels); do
        # Skip if link is empty
        if [ -z "${episode_links[i]}" ]
        then
            continue
        fi
        echo "      <item>"
        echo "          <title>$((i+1)). ${episode_titles[i]}</title>"
        echo "          <link>${episode_links[i]}</link>"
        echo "      </item>"
    done
    echo "  </channel>"
    echo "</rss>"
}

#!/bin/bash

source .env

while read -r line; do
  board=$(echo "$line" | awk -F'\t' '{print $1}')
  board_name=$(echo "$line" | awk -F'\t' '{print $2}')
  mkdir -p "boards/$board_name"
  while read -r line; do
    list=$(echo "$line" | awk -F'\t' '{print $1}')
    list_name=$(echo "$line" | awk -F'\t' '{print $2}' | sed -e 's%/%_%g')
    file="boards/$board_name/$list_name.md"
    mkdir -p "$(dirname "$file")"
    cp /dev/null "$file"
    while read -r line; do
      card="$(echo "$line" | jq -r '.id')"
      echo -n "# " >> "$file"
      echo "$line" | jq -r '.name' >> "$file"
      echo "$card" >> "$file"
      echo "$line" | jq -r '.updated' >> "$file"
      echo "$line" | jq -r '.url'  >> "$file"
      echo >> "$file"

      while read -r member; do
        echo "* $member" >> "$file"
      done < <( echo "$line" | jq -r '.members[]')
      [ x"0" = x"$(echo "$line" | jq -r '.members|length')" ] || echo >> "$file"

      echo "## Description" >> "$file"
      echo >> "$file"
      echo "$line" | jq -r '.desc' >> "$file"
      echo >> "$file"

      if [ x"0" != x"$(echo "$line" | jq -r '.attachments')" ] ; then
        echo "## Attachments" >> "$file"
        echo >> "$file"
        while read -r attachment; do
          echo "$attachment" | jq -r '.filename' >> "$file"
          echo "$attachment" | jq -r '.url' >> "$file"
          echo "$attachment" | jq -r '.date' >> "$file"
          echo "$attachment" | jq -r '.uploader' >> "$file"
          echo >> "$file"
        done < <(bundle exec trello attachment list -c "$card" -o json | jq -M -c '.[]')
      fi

      if [ x"0" != x"$(echo "$line" | jq -r '.comments')" ] ; then
        echo "## Comments" >> "$file"
        echo >> "$file"
        while read -r comment; do
          echo -n "### " >> "$file"
          echo "$comment" | jq -r '.name' >> "$file"
          echo "$comment" | jq -r '.date' >> "$file"
          echo >> "$file"
          echo "$comment" | jq -r '.text' >> "$file"
          echo >> "$file"
        done < <(bundle exec trello comment list -c "$card" -o json | jq -M -c '.[]')
      fi
    done < <(bundle exec trello card list -b "$board" -l "$list" -o json | jq -M -c '.[]')
  done < <(bundle exec trello list list -b "$board" -o tsv)
done < <(bundle exec trello board list -o tsv)

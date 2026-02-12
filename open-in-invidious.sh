#!/bin/bash

#########################################################################################
#                                                                              			#
#                         Open in Invidious                                    			#
#                                                                              			#
#  Takes a YouTube URL or video ID and opens it in an Invidious instance       			#
#  (a privacy-focused YouTube frontend).                                       			#
#                                                                              			#
#  Input formats supported:                                                    			#
#    • Full YouTube URLs (youtube.com/watch?v=...)                             			#
#    • YouTube Shorts (youtube.com/shorts/...)                                 			#
#    • Short links (youtu.be/...)                                              			#
#    • Embed URLs (youtube.com/embed/...)                                      			#
#    • Direct video IDs (11-character codes)                                   			#
#                                                                              			#
#  Features:                                                                   			#
#    • Automatically extracts video ID from URLs                               			#
#    • Caches the most popular instance, based on the number of users, for 24 hours     #
#    • Opens video in your default browser 												#
#																						#
#  Clear cache if needed: 																#
#    • rm /tmp/invidious_instances.cache                                     			#
#                                                                              			#
#########################################################################################

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open in Invidious
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🎬
# @raycast.argument1 { "type": "text", "placeholder": "YouTube URL or ID" }

# Documentation:
# @raycast.author mickaphd
# @raycast.authorURL https://github.com/mickaphd/Invidious-for-Raycast

INPUT="$1"

# Extract video ID from URL if it's a full URL
if [[ $INPUT =~ youtube.com/shorts/([a-zA-Z0-9_-]+) ]]; then
    VIDEO_ID="${BASH_REMATCH[1]}"
elif [[ $INPUT =~ youtube.com.*v=([a-zA-Z0-9_-]+) ]]; then
    VIDEO_ID="${BASH_REMATCH[1]}"
elif [[ $INPUT =~ youtu.be/([a-zA-Z0-9_-]+) ]]; then
    VIDEO_ID="${BASH_REMATCH[1]}"
elif [[ $INPUT =~ youtube.com/embed/([a-zA-Z0-9_-]+) ]]; then
    VIDEO_ID="${BASH_REMATCH[1]}"
elif [[ $INPUT =~ ^[a-zA-Z0-9_-]{11}$ ]]; then
    # Valid YouTube video ID format (11 characters)
    VIDEO_ID="$INPUT"
else
    echo "❌ Invalid YouTube URL or video ID"
    exit 1
fi

# Cache file for instances (valid for 24 hours)
CACHE_FILE="/tmp/invidious_instances.cache"
CACHE_AGE=$(($(date +%s) - $(stat -f%m "$CACHE_FILE" 2>/dev/null || echo 0)))

if [ $CACHE_AGE -lt 86400 ] && [ -f "$CACHE_FILE" ]; then
    INSTANCE=$(cat "$CACHE_FILE")
else
    # Fetch instances with timeout, sorted by most users
    INSTANCE=$(curl -s --max-time 5 https://api.invidious.io/instances.json 2>/dev/null | \
      jq -r '.[] | select(.[1].stats != null and .[1].stats.usage != null and .[1].stats.usage.users != null) | "\(.[1].stats.usage.users.total) \(.[1].uri)"' | \
      sort -rn | head -1 | awk '{print $2}')
    
    if [ -n "$INSTANCE" ]; then
        echo "$INSTANCE" > "$CACHE_FILE"
    fi
fi

# Open the video in the selected Invidious instance
if [ -z "$INSTANCE" ]; then
    echo "❌ Could not find any Invidious instances"
    exit 1
else
    echo "✅ Using: $INSTANCE"
    open "${INSTANCE}/embed/${VIDEO_ID}"
fi

# Invidious-for-Raycast
🎬 Raycast script for instant YouTube-to-Invidious conversion. Supports YouTube URLs, Shorts, youtu.be links, video IDs. 

## What is Invidious?

Invidious is a privacy-focused, open-source YouTube frontend. This script lets you seamlessly convert any YouTube link to Invidious and watch without ads or tracking.

## Features

- ✅ Automatically extracts video ID from any YouTube URL format
- ✅ Check and cache the most popular Invidious instance (based on user count) for 24 hours (https://api.invidious.io/)
- ✅ Opens video in your default browser

## Supported Input Formats

- Full YouTube URLs: `youtube.com/watch?v=...`
- YouTube Shorts: `youtube.com/shorts/...`
- Short links: `youtu.be/...`
- Embed URLs: `youtube.com/embed/...`
- Direct video IDs: `11-character codes`

## Installation

Download the `open-in-invidious.sh` script to your Raycast scripts directory

## Usage

1. Open Raycast
2. Search for "Open in Invidious"
3. Paste a YouTube URL, Short link, or video ID
4. Press Enter
5. Video opens in Invidious in your default browser

## Cache Management

The script caches the address of the best Invidious instance for 24 hours to enhance performance.
To clear the cache manually:

```bash
rm /tmp/invidious_instances.cache

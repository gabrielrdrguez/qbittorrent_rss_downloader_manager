# qBittorrent RSS Downloader Manager

This is a personal project for editing qBittorrent RSS auto downloader export files

It's not really meant to be a generic editor, at least not right now, but it could serve as a starting point for you

I might try to add a GUI in the future, right now I didn't even added a "view layer"

## How to run
- Ruby v3+ (because of syntax sugar)
- Copy config/configuration.example.yml to config/configuration.yml and edit values to your needs (or run first to autocopy from example)
- Save your export file to the root folder as `rss.json` 

`ruby main.rb`
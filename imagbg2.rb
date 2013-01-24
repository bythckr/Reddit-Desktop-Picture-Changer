require 'json'
require 'open-uri'

# setup variables
wallpaper = "";
filename = "";
body="";
curr_path ="";

# open sub reddit hot json feed and store response in body variable
open("http://www.reddit.com/r/imaginarylandscapes/hot.json") { |f| body = f.read() }
body = JSON.parse(body)

# extract the url of the first post
wallpaper = body["data"]["children"][0]["data"]["url"]

# get the file name from the url
filename = wallpaper.split("/")
filename = filename.last

# get current path
curr_path = File.expand_path(File.dirname(__FILE__))

# download file into bg-images directory
%x[wget -P #{curr_path}/bg-images/ #{wallpaper}]

# change the desktop picture on mac using osascript
%x[osascript -e 'tell application "System Events" to set picture of every desktop to "#{curr_path}/bg-images/#{filename}"']
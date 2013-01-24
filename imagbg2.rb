require 'json'
require 'open-uri'

# setup variables
body="";
wallpaper = "";
filename = "";
hotWallpaper="";
hotFilename="";
curr_path ="";

# open sub reddit hot json feed and store response in body variable
open("http://www.reddit.com/r/imaginarylandscapes/hot.json?limit=25") { |f| body = f.read() }
body = JSON.parse(body)

# setup hot posts array
body_children = body["data"]["children"]

# loop through hot posts
body_children.each { 
  |x|
  # if file extension is jpg, png or gif, store file url and filename and end loop
  filename = x["data"]["url"].split("/")
  filename = filename.last
  fileext = filename.split(".")
  fileext = fileext.last
  if fileext == 'jpg' || fileext == 'png' || fileext == 'gif'
    hotWallpaper = x["data"]["url"]
	hotFilename = filename
	puts hotWallpaper
	puts hotFilename
    break
  end
}

# get current path
curr_path = File.expand_path(File.dirname(__FILE__))

# download file into bg-images directory
%x[wget -P #{curr_path}/bg-images/ #{hotWallpaper}]

# change the desktop picture on mac using osascript
%x[osascript -e 'tell application "System Events" to set picture of every desktop to "#{curr_path}/bg-images/#{hotFilename}"']
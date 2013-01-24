require 'json'
require 'open-uri'

wallpaper = "";
filename = "";
body="";

open("http://www.reddit.com/r/imaginarylandscapes/hot.json") { |f| body = f.read() }
body = JSON.parse(body)

wallpaper = body["data"]["children"][1]["data"]["url"]

filename = wallpaper.split("/")
filename = filename.last

%x[wget -P ~/ruby/imaginarybgs/bg-images/ #{wallpaper}]

%x[osascript -e 'tell application "System Events" to set picture of every desktop to "/Users/David/ruby/imaginarybgs/bg-images/#{filename}"']

#%x[defaults write com.apple.desktop '{ Background = {default = {ImageFilePath = "~/ruby/imaginarybgs/bg-image/#{filename}"; NewChangePath = "~/ruby/imaginarybgs/bg-image"; NewImageFilePath = "~/ruby/imaginarybgs/bg-image/#{filename}"; };};}']
#%x[killall Dock]
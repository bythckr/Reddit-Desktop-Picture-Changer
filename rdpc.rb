require 'json'
require 'open-uri'

# function to set desktop picture, the feh commands are for linux, the osascript command works on a mac.
def setasbackground(filename, curr_path)
  #puts `feh --bg-center #{curr_path}/#{filename}` # centers the image in the middle
  #puts `feh --bg-scale #{curr_path}/#{filename}` # scales the image to fit the whole screen
  %x[osascript -e 'tell application "System Events" to set picture of every desktop to "#{curr_path}/#{filename}"']  # change desktop on mac using osascript
  puts "Background Changed!"
end

def start

  # set the sub reddit you want to pull the hottest image from
  reddit = "imaginarylandscapes"

  # pull in the hot feed from the sub reddit
  body = JSON.parse(open("http://www.reddit.com/r/#{reddit}/hot.json") { |f| body = f.read() })

  # loop through the hot feed and pull out the hottest image file
  i=0
  until i==25
    imgurl = body["data"]["children"][i]["data"]["url"]
    if imgurl.include? "jpg" or imgurl.include? "png" or imgurl.include? "gif"

      # get the image file name
      img = imgurl.split("/")
      img = img.last

      # add the name of the sub-reddit as a prefix to the image file name
      filename = "#{reddit}-#{img}"

      # get current path
      curr_path = File.expand_path(File.dirname(__FILE__))

      # if image already exists in the current directory, exit the script
      if File.exists? "#{curr_path}/#{filename}"
        puts "#{filename} has already been downloaded."

        # look for the next image file if hottest bg is already set?
        puts "Do you want to look for the next image? y/n"
        if gets.strip == "y"
          i+=1
        else
          exit 0
        end
      else
        break
      end

    else
      i+=1
    end

  end

  puts "Downloading image..."

  # download the image to the current directory
  open(imgurl) {|f|
    File.open("#{curr_path}/#{filename}","wb") do |file|
      file.puts f.read
    end
  }

  # call function to set background
  setasbackground(filename, curr_path)

end

start
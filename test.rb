require "uri"
require "net/http"
require "json"

def request(url)
  uri = URI(url)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  request = Net::HTTP::Get.new(uri)

  response = https.request(request)

  data = JSON.parse(response.read_body)

  data
end

def buid_web_page(data)
  photos = data["photos"]

  html_content = "<html>\n<head>\n</head>\n<body>\n<ul>\n"

  photos.each do |photo|
    img_src = photo["img_src"]
    html_content += "<li><img src='#{img_src}'></li>\n"
  end

  html_content += "</ul>\n</body>\n</html>"

  File.open("mars_photos.html", "w") do |file|
    file.write(html_content)
  end

  puts "La página web ha sido creada con éxito: mars_photos.html"
end

def photos_count(data)
  camera_count = {}

  data["photos"].each do |photo|
    camera_name = photo["camera"]["name"]

    if camera_count.key?(camera_name)
      camera_count[camera_name] += 1
    else
      camera_count[camera_name] = 1
    end
  end

  camera_count
end

url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=DEMO_KEY"

response_hash = request(url)

buid_web_page(response_hash)

camera_photo_count = photos_count(response_hash)
puts camera_photo_count

require 'sinatra'
require 'digest/md5'
require 'sdbm'

IMG_DIR = File.join(settings.root, "public/images")
DB_DIR = File.join(settings.root, "db")

get "/:hash" do
  content_type :png
  send_file File.join(IMG_DIR, params[:hash] + ".png")
end

post "/upload" do
  id = params[:id]
  img = params[:imagedata][:tempfile].read
  hash = Digest::MD5.hexdigest(img)

  is_newid = false
  if !id || id.empty?
    id = Digest::MD5.hexdigest(Time.now.to_s)
    is_newid = true
  end
  dbm = SDBM.open("#{DB_DIR}/id",0644)
  dbm[hash] = id
  dbm.close

  File.open("#{IMG_DIR}/#{hash}.png", "w").print(img)

  if is_newid
    headers = {"X-Gyazo-ID" => id}
  end
  "http://#{settings.gyazo_server}/#{hash}"
end

class StaticPagesController < ApplicationController
  require "net/http"
  require "json"

  def home
    @user_id = params[:flickr_user_id] || "199013012@N03"

    api_key = ENV["FLICKR_API_KEY"]
    url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=#{api_key}&user_id=#{@user_id}&format=json&nojsoncallback=1"

    response = Net::HTTP.get(URI.parse(url))
    data = JSON.parse(response)

    if data["photos"] && data["photos"]["total"].to_i > 0
      @photos = data["photos"]["photo"].map do |photo|
        server = photo["server"]
        id = photo["id"]
        secret = photo["secret"]
        "https://live.staticflickr.com/#{server}/#{id}_#{secret}.jpg"
      end
    else
      @no_photos_found = true
    end
  end
end

# encoding: UTF-8

class Facebook::Album < Facebook::GraphObject

  attr_accessor :photos

  def name
    data["name"] 
  end

  def description
    data["description"] 
  end
  
  def path
    "bilder/#{id}/#{name.parameterize}"
  end

  def type
    data["type"]
  end

  def cover
    "http://graph.facebook.com/#{data["cover_photo"]}/picture"
  end


  def created_date
    Time.zone.parse(data["created_time"])
  end

  def updated_date
    Time.zone.parse(data["updated_time"])
  end

  class << self

    def find(id)
      album_data, photos = cache(id) do
        graph.batch do |batch_api|
          batch_api.get_object(id)
          batch_api.get_connections(id, "photos", :limit => 200)
        end
      end

      new(album_data).tap do |album|
        album.photos = photos.collect{|photo_data| Facebook::Photo.new photo_data }
      end
    end

    def all
      albums = cache("collection") do
        graph.get_connections(Settings.facebook["page_id"], "albums")
      end.collect{ |album| new album }

      # sort out profile images
      albums.select{|album| album.type != "profile" }
    end
  end

end

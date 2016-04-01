# encoding: UTF-8

class Facebook::Photo < Facebook::GraphObject

  def thumb
    img = data["images"][2] 
    img ||= data["images"][0]
    img["source"]
  end

  def url
    data["source"]
  end

end
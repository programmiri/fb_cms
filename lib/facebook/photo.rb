class Facebook::Photo < Facebook::GraphObject

  def thumb
     data["images"][5]["source"]
  end

  def url
    data["source"]
  end

end
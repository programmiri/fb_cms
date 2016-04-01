# encoding: UTF-8

class Facebook::Post < Facebook::GraphObject

  def message
    data["message"]
  end

  def type
    data["type"]
  end

  def date
    I18n.l(upated_at, :format => :date)
  end

  def picture
    data["picture"]
  end

  def link
    data["link"]
  end

  def name
    data["name"]
  end

  class << self

    def all
      posts = cache("collection") do
        graph.get_connections(Settings.facebook["page_id"], "posts", :limit => 25)
      end.collect{|post| new post }

      # only take statuses and links
      posts.select{|post| post.message && ["status", "link"].include?(post.type) }
    end
  end

end

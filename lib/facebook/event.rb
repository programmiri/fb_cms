class Facebook::Event < Facebook::GraphObject

  attr_accessor :attending

  def description
    data["description"]
  end
  
  def summary
    description[0..200] + "..."
  end

  def address
    {}.merge({ "venue" => data["venue"]}).merge("location" => location)
  end

  def location
    data["location"]
  end
  
  def path
    "termine/#{id}/#{name.parameterize}"
  end

  def start
    Time.zone.parse(data["start_time"])
  end
  
  def end_time
    data["end_time"] && Time.zone.parse(data["end_time"])
  end

  def date(d= :start)
    I18n.l(send(d), :format => :starting)
  end
  


  class << self

    def find(id)
      event_data = cache(id) { graph.get_object(id) }
      attending = cache("#{id}:attending") { graph.get_connections(id, "attending") }

      new(event_data).tap do |event|
        event.attending = attending.collect{|attendee| Facebook::User.new(attendee) }
      end
    end

    def all
      events = cache("collection") { graph.get_connections(settings.facebook["page_id"], "events") }

      detailled_events = cache("detailled_events") do
        graph.batch do |batch_api|
          events.each {|event| batch_api.get_object(event["id"]) }
        end
      end

      detailled_events.collect{|e| new(e) }.reject{|e| e.start < 2.days.ago }.sort_by(&:start)
    end
  end

end
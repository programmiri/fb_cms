#Hilfsmethoden rund um Text
module Text

  def linkify(text)
    text = text.to_s.dup
    generic_URL = Regexp.new('(^|[\n ])([\w]+?://[\w]+[^ \"\n\r\t<]*)', Regexp::MULTILINE | Regexp::IGNORECASE)
    starts_with_www = Regexp.new('(^|[\n ])((www)\.[^ \"\t\n\r<]*)', Regexp::MULTILINE | Regexp::IGNORECASE)
    text.gsub!(generic_URL, '\1<a href="\2">\2</a>')
    text.gsub!(starts_with_www, '\1<a href="http://\2">\2</a>')
    text
  end

  def linkify_feed(text, name)
    text = text.to_s.dup
    generic_URL = Regexp.new('(^|[\n ])([\w]+?://[\w]+[^ \"\n\r\t<]*)', Regexp::MULTILINE | Regexp::IGNORECASE)
    text.gsub!(generic_URL, '\1<a href="\2">&raquo;' + name + '</a>')
    text
  end
  # brauchts nicht, weil fb nur per http übergibt, aber aufheben
  # starts_with_www = Regexp.new('(^|[\n ])((www)\.[^ \"\t\n\r<]*)', Regexp::MULTILINE | Regexp::IGNORECASE)
  # text.gsub!(starts_with_www, '\1<a href="http://\2">' + name + '</a>')

  def truncate(text, max_length = 20)
    postfix = "(...)"
    return text.dup if text.size <= max_length
    text.dup[0..(max_length-postfix.size)] + postfix
  end


  # elegant ist anders - was solls
  # entfernt Link aus String für ALT / TITLE Newsfeed 
  # verwendet in index.haml
  # momentan nur http da FB Balle Links im Newsfeed mit http übergibt
  # Besteht der Beitrag nur aus einem Link, wird der dargestellt
  def deletelink(text) 
    text.gsub /http(s)?:\/\/[^\s]+\s|\shttp(s)?:\/\/[^\s]*/,""
  end


  def headify(text)
    text.gsub( /~~\s*([^~]+)\s*~~/, '<h3>\1</h3>')
  end

  def simple_format(text, options = {})
    start_tag = "<p>"
    text = '' if text.nil?
    text = text.dup.to_str
    text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
    text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  -> paragraph
    text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
    text.insert 0, start_tag
    text << "</p>"
  end


  # ergänzt, 2 /n geben ebenfalls einen BR
  # Verwendung nur für Newsfeedausgabe index.haml
  # deshalb brauchts kein p

  def nl2br(text)
    text = '' if text.nil?
    text = text.dup.to_str
    text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
    text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
    text.gsub!(/([^\n\n]\n\n)(?=[^\n\n])/, '\1<br />') # "2 newline   -> br
    text
  end

  # Leerzeilene aus String durch whitespace ersetzen. 
  # Entfernden doofe Idee :P
  # Ausgabe Newsfeed und Ausgabe als ALT bei img
  # verwendet in album, albums, index
  #
  def nl2delete(text)
    text = '' if text.nil?
    text.gsub!(/\n\n/, ' ')
    text.gsub!(/\n/, ' ')  
    text
  end

end
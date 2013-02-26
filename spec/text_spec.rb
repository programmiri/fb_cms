require 'spec_helper'

describe Text do

  describe "linkify" do
    it "replaces an url in a string with a link" do
      linkify("hi http://google.com ho").should eql("hi <a href=\"http://google.com\">http://google.com</a> ho")
    end

    it "replaces an url without protocol in a string with a link" do
      linkify("hi www.google.com ho").should eql("hi <a href=\"http://www.google.com\">www.google.com</a> ho")
    end

    it "replaces nothing in a string without a url" do
      linkify("hi google ho").should eql("hi google ho")
    end
  end

  describe "linkify_feed" do
    it "delete url from message, set link with name" do
      linkify_feed("hi http://google.com ho", "Google Link").should eql("hi <a href=\"http://google.com\">&raquo;Google Link</a> ho")
    end
  end


  describe "deletelink" do
    it "remove an url in string" do
      deletelink("hi http://google.com ho").should eql("hi ho")
      deletelink("http://google.com ho").should eql("ho")
      deletelink("hi http://google.com").should eql("hi")
      deletelink("http://google.com").should eql("http://google.com")
    end

    it "remove nothing in a string without a url" do
      linkify("hi google ho").should eql("hi google ho")
    end
  end

  describe "headify" do
    it "replaces a  specified character string with heading tags" do
      headify("i really ~~love~~ google").should eql("i really <h3>love</h3> google")
    end
  end


  describe "simple_format" do
    it "wraps the given text in a paragrah" do
      simple_format("hi").should eql("<p>hi</p>")
    end

    it "inserts a br tag for a new line" do
      text = <<-eos
        Line 1
        Line 2
      eos
      text.gsub!(/ +/, ' ')

      simple_format(text).should eql("<p>"" Line 1\n<br /> Line 2\n</p>")
    end

    it "starts a new paragraph at 2 new lines" do
      text = <<-eos
        Paragraph 1

        Paragraph 2
      eos
      text.gsub!(/ +/, ' ')

      simple_format(text).should eql("<p> Paragraph 1</p>\n\n<p> Paragraph 2\n</p>")
    end
  end

  describe "nl2br" do
    it "adds br tags after new lines" do
      text = "This\nis a\ntest\n"
      nl2br(text).should eql("This\n<br />is a\n<br />test\n")
    end
    it "adds br tags after 2 new lines" do
      text = "This\n\nis a\n\ntest\n\n"
      nl2br(text).should eql("This\n\n<br />is a\n\n<br />test\n\n")
    end
  end

  describe "nl2delete" do
    it "delete new line in string" do
      text = "This\nis a\ntest"
      nl2delete(text).should eql("This is a test")
    end
    it "delete new lines in string" do
      text = "This\n\nis a\n\ntest"
      nl2delete(text).should eql("This is a test")
    end
  end

end
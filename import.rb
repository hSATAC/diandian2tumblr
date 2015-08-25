require 'rubygems'
require 'nokogiri'
require 'time'
require 'date'
require 'config'
require 'tumblr_client'

Config.load_and_set_settings('settings.yml')

Tumblr.configure do |config|
  config.consumer_key = Settings.tumblr.consumer_key
  config.consumer_secret = Settings.tumblr.consumer_secret
  config.oauth_token = Settings.tumblr.oauth_token
  config.oauth_token_secret = Settings.tumblr.oauth_token_secret
end

client = Tumblr::Client.new

xml = IO.read("diandian.xml")
xml = Nokogiri::XML xml
items = []

xml.xpath("//Post").each do |node|
  item = Hash.new
  item[:text] = node.xpath(".//Text").inner_text
  item[:title] = node.xpath(".//Title").inner_text
  item[:post_type] = node.xpath(".//PostType").inner_text
  item[:created_at] = Time.at(node.xpath(".//CreateTime").inner_text.gsub(/...$/,'').to_i)
  item[:desc] = node.xpath(".//Desc").inner_text
  item[:link] = node.xpath(".//Link").inner_text
  items << item
end

puts "Importing..."
items.each do |item|
  puts "[#{item[:created_at]}][#{item[:post_type]}] #{item[:title]}"

  arg = case item[:post_type]
        when "text"
          {
            :title => item[:title],
            :body => item[:text],
            :date => item[:created_at].iso8601,
            :state => "published"
          }
        when "photo"
          {
            :caption => item[:desc],
            :source => "http://lorempixel.com/400/200/", # diandian export does not contain image, fake it.
            :date => item[:created_at].iso8601,
            :state => "published"
          }
        when "link"
          {
            :title => item[:title],
            :description => item[:text],
            :url => item[:link],
            :date => item[:created_at].iso8601,
            :state => "published"
          }
        end

  client.create_post(item[:post_type].to_sym, Settings.tumblr.blog_name, arg)
end

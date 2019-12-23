require 'aws-sdk-v1'
require 'twitter'


client = Twitter::REST::Client.new do |config|
  config.consumer_key    = ENV['MY_CONSUMER_KEY']
  config.consumer_secret = ENV['MY_CONSUMER_SECRET']
  config.access_token    = ENV['MY_ACCESS_TOKEN']
  config.access_token_secret = ENV['MY_ACCESS_TOKEN_SECRET']
end

AWS.config({
         :access_key_id => ENV['AWS_ACCESS_KEY'],
         :secret_access_key => ENV['AWS_ACCESS_SECRET'],
})

s3 = AWS::S3.new
bucket = s3.buckets["neruneru"]
age = bucket.objects["age.txt"]
i = 18
reply = []
loop do
  time = Time.now.min
  client.home_timeline.each do |tweet|
    puts tweet.text
    p reply
    if tweet.text.include?("@Nerun_Eruneru") and (tweet.text.include?("誕生日") or tweet.text.include?("おたおめ") or tweet.text.include?("たんおめ")) and !reply.include?(tweet.id) then
      reply.push(tweet.id)
      age.write((age.read.to_i + 1).to_s)
      i = age.read
   
      client.update("@#{tweet.user.screen_name} ねるねるは現在#{i}歳です", options = {:in_reply_to_status_id => tweet.id})
      client.favorite(tweet.id)
    end
    elsif tweet.text.include?("いま何歳") then
      client.update("@#{tweet.user.screen_name} ねるねるは現在#{i}歳です", options = {:in_reply_to_status_id => tweet.id})
      client.favorite(tweet.id)
  end
  sleep(60)
end

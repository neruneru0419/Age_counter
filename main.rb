require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key    = ENV['MY_CONSUMER_KEY']
  config.consumer_secret = ENV['MY_CONSUMER_SECRET']
  config.access_token    = ENV['MY_ACCESS_TOKEN']
  config.access_token_secret = ENV['MY_ACCESS_TOKEN_SECRET']
end


age = File.open("age.txt", "r")
i = age.read.to_i
reply = []
loop do
  time = Time.now.min
  client.home_timeline.each do |tweet|
    puts tweet.text
    p reply
    if tweet.text.include?("@Nerun_Erueru") and (tweet.text.include?("誕生日") or tweet.text.include?("おたおめ") or tweet.text.include?("たんおめ")) and !reply.include?(tweet.id) then
      i += 1
      File.open("age.txt", "w") do |f|
        f.puts(i)
      end
      reply.push(tweet.id)
      puts age.read
      client.update("@#{tweet.user.screen_name} ねるねるは現在#{i}歳です", options = {:in_reply_to_status_id => tweet.id})
      client.favorite(tweet.id)
    end
  end
  if time % 15 == 0 then
    reply.clear
  end
  sleep(60)
end

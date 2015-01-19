require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'blNMYNa5NjQxSOY2hIInrf0Ct'
  config.consumer_secret = 'Tcza6W0CTcC0yzpDZlIoQ2Uo4fvO5mAp6uSJNwq0QywAlJQ0Ln'
  config.access_token = '284465379-iXLQQnDLmklH8ECFuibh0FdC5Bu92LlGTiUSUm8E'
  config.access_token_secret = 'TKD8H07phRDMQKb9sbuAl0EoT6AWh2zHxiora08sN78LM'
end

search_term = URI::encode('#todayilearned')

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end
require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "56dd1dd2d9372ea037e2829bd224301d"

get "/" do
    @entry = false
    view "ask"
end

get "/news" do
    results = Geocoder.search(params["q"])

    @lat_long = results.first.coordinates # => [lat, long]

    @forecast = ForecastIO.forecast(@lat_long[0],@lat_long[1]).to_hash

    url = "https://newsapi.org/v2/top-headlines?country=#{results.first.country_code}&apiKey=b96fe19a316d4179b9bb5f5a48073090"

    @news = HTTParty.get(url).parsed_response.to_hash
    
    @entry = true

    view "ask"
end

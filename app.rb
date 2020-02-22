require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "56dd1dd2d9372ea037e2829bd224301d"
#news = HTTParty.get("https://newsapi.org/v2/top-headlines?country=us&apiKey=b96fe19a316d4179b9bb5f5a48073090").parsed_response.to_hash
# news is now a Hash you can pretty print (pp) and parse for your output

get "/" do
    view "ask"
    results = Geocoder.search(params["q"])
    lat_long = results.first.coordinates # => [lat, long]
    @forecast = ForecastIO.forecast(lat_long[0],lat_long[1]).to_hash
    @current_temperature = @forecast["currently"]["temperature"]
    @current_summary = @forecast["currently"]["summary"]

    @forecast_temperature = Array.new
    @forecast_summary = Array.new

    i = 0
    for day in @forecast["daily"]["data"] do
        @forecast_temperature[i] = day["temperatureHigh"]
        @forecast_summary[i] = day["summary"]
        i = i+1
    end
    #view "ask"
  # show a view that asks for the location
end

#get "/news" do

#@source_name = Array.new
  #  @title = Array.new
  #  @description = Array.new
  #  @story_url = Array.new
  #  a = 0
  #  for story in news["articles"] do
  #      @source_name[a] = story["source"]["name"]
  #      @title[a] = story["title"]
  #      @description[a] = story["description"]
  #      @story_url[a] = story["url"]
  #      a = a+1
  #  end
    
  #  view "news"

#end
require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    # ==========================================================================
    # Your code goes below.
    #
    # The street address that the user typed is in the variable @street_address.
    # ==========================================================================

    maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + @street_address.gsub(" ", "+")
    
    maps_parsed_data = JSON.parse(open(maps_url).read)
    

    @new_lat = maps_parsed_data["results"][0]["geometry"]["location"]["lat"]

    @new_lng = maps_parsed_data["results"][0]["geometry"]["location"]["lng"]
    
    
    weather_url = "https://api.darksky.net/forecast/2fa4cec13d4ff661872f47cd208d89de/" + @new_lat.to_s + "," + @new_lng.to_s
    
    weather_parsed_data = JSON.parse(open(weather_url).read)
    

   @current_temperature = weather_parsed_data.dig("currently", "temperature")

    @current_summary = weather_parsed_data.dig("currently", "summary")

    @summary_of_next_sixty_minutes = weather_parsed_data.dig("minutely", "summary")

    @summary_of_next_several_hours = weather_parsed_data.dig("hourly", "summary")

    @summary_of_next_several_days = weather_parsed_data.dig("daily", "summary")

    render("meteorologist/street_to_weather.html.erb")
  end
end

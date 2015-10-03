require 'sinatra'
require 'open-uri'
require 'json'

get '/playtime' do
  erb :playtime
end

post '/playtime' do
  calculate_playtime(params[:playerid])
  erb :playtime
end

def calculate_playtime(playerid)
  data = JSON.load(open("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=AADA11508386B68F3D1E54F972C57845&steamid=#{playerid}&format=json"))

  total = 0
  data['response']['games'].each do |game|
    total = total + game['playtime_forever']
  end

  @minutes = total
  @hours   = (total / 60.0).round(2)
  @days    = (total / 60.0 / 24.0).round(2)
  @months  = (total / 60.0 / 24.0 / 30.0).round(2)
  @years   = (total / 60.0 / 24.0 / 30.0 / 12.0).round(2)
end

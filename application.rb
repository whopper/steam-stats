require 'sinatra'
require 'open-uri'
require 'json'

get '/' do
  erb :playerclock
end

get '/playerclock' do
  erb :playerclock
end

post '/playerclock' do
  calculate_playtime(params[:playerid])
  erb :playerclock
end

def calculate_playtime(playerid)
  begin
    data = JSON.load(open("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=AADA11508386B68F3D1E54F972C57845&steamid=#{playerid}&format=json"))
  rescue
    data = nil
  end

  total = 0
  if data
    data['response']['games'].each do |game|
      total = total + game['playtime_forever']
    end
  end

  @minutes = total
  @hours   = total / 60
  @days    = total / 60 / 24
  @months  = (total / 60.0 / 24.0 / 30.0).round(2)
  @years   = (total / 60.0 / 24.0 / 30.0 / 12.0).round(2)
  @lifespan_percent = (@years / 78.0).round(3)
end

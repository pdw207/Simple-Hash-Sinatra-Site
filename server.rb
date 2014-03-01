require 'pry'
require 'sinatra'



get '/leaderboard' do

  data = [
  {
    home_team: "Patriots",
    away_team: "Broncos",
    home_score: 7,
    away_score: 3
  },
  {
    home_team: "Broncos",
    away_team: "Colts",
    home_score: 3,
    away_score: 0
  },
  {
    home_team: "Patriots",
    away_team: "Colts",
    home_score: 11,
    away_score: 7
  },
  {
    home_team: "Steelers",
    away_team: "Patriots",
    home_score: 7,
    away_score: 21
  }
]

  # Initatilize new stats instance
  stats = {}

  def update_winner_and_loser stats, winner, loser
        stats[winner][:win] += 1
        stats[winner][:total] += 1

        stats[loser][:loss] += 1
        stats[loser][:total] += 1
  end

  def array_to_hash array
    array.inject({}) do |result, (key, value)|
      result.merge!(key => value)
    end
  end

  data.each do |game|

    # Simplify our reference to team names
    home_team = game[:home_team]
    away_team = game[:away_team]

    # Initialize team in stats hash unless already included
    stats[home_team] = {win: 0 , loss: 0, total: 0} unless stats.include?(home_team)
    stats[away_team] = {win: 0 , loss: 0, total: 0} unless stats.include?(away_team)

    # Update stats based on game
    if game[:home_score] > game[:away_score]
      update_winner_and_loser stats, home_team, away_team
    else
      update_winner_and_loser stats, away_team, home_team
    end

  end

  #sort by win status
  stats_sorted_by_win = array_to_hash stats.sort_by {|k,v| v[:win] }.reverse

  #sort by loss if win is the same
  @stats =  stats_sorted_by_win.sort_by {|k,v| v[:loss] if v[:win] == v[:win]}


  erb :index
end

get '/teams/:team' do
  games = []
  data.each do |game|
    if game[:home_team] == params[:team] || game[:away_team] == params[:team]
    @games << game
  end

 erb :team
end

set :view, File.dirname(__FILE__) + '/views'
set :public_folder, File.dirname(__FILE__) + '/public'

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end

  delete '/reviews/:id' do
    Review.find(params[:id]).destroy.to_json
  end

  post '/reviews' do
    Review.create(score: params[:score], comment: params[:comment], game_id: params[:game_id], user_id: params[:user_id]).to_json
  end

  patch '/reviews/:id' do
    upd = Review.find(params[:id])
    upd.update(score: params[:score], comment: params[:comment])
    upd.to_json
  end

end


# t.integer "score"
# t.string "comment"
# t.integer "game_id"
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.integer "user_id"
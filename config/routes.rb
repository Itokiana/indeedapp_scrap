Rails.application.routes.draw do
  root to: 'indeed#index'

  get '/download_excel/:keyword/:city', to: 'indeed#to_excel', as: 'to_excel'
  get '/game_over', to: 'indeed#game_over', as: 'end_trying'

  post 'get_data', to: 'indeed#manage'
  # get 'indeed/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

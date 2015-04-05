Rails.application.routes.draw do
  
  root 'upload#index'

  get 'analyze' => 'upload#analyze'
  post 'upload' => 'upload#create'


end

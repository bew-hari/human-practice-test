Rails.application.routes.draw do
  
  root 'upload#index'

  post 'upload' => 'upload#create'

end

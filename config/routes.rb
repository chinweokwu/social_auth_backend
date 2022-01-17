Rails.application.routes.draw do
  devise_for :users
  scope :api, defaults: { format: :json } do
    devise_scope :user do
      post "sign_up", to: "registrations#create"
      post "sign_in", to: "sessions#create"
    end
  end
end

Rails.application.routes.draw do
  scope "(:locale)", locale: /en/ do
    root "static_pages#home"
    
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
  end
end
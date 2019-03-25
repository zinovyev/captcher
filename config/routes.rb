Captcher::Engine.routes.draw do
  resource :captcha, only: [:show] do
    member do
      %i[reload refresh confirm].each do |route|
        send :post, route
        send :get, route
      end
    end
  end
end

Captcher::Engine.routes.draw do
  resource :captcha, only: %i[show create] do
    member do
      %i[post get].each do |http_method|
        send(http_method, "refresh")
        send(http_method, "validate")
      end
    end
  end
end

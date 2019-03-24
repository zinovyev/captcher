Captcher::Engine.routes.draw do
  resource :captcha, only: %i[show create] do
    member do
      post "refresh"
      post "validate"
    end
  end
end

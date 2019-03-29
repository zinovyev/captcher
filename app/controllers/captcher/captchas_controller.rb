module Captcher
  class CaptchasController < ActionController::Base
    include Captcher::CaptchaAware

    def show
      render_captcha(load_captcha)
    end

    def reload
      render_captcha(reload_captcha)
    end
    alias refresh reload

    def confirm
      if confirm_captcha?(params[:captcha])
        render json: { success: true }, status: 200
      else
        render json: { success: false }, status: 422
      end
    end
  end
end

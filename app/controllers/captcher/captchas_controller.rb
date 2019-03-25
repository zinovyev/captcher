module Captcher
  class CaptchasController < ActionController::Base
    include Captcher::CaptchaAware

    def show
      render_captcha(load_captcha(session))
    end

    def reload
      render_captcha(reload_captcha(session))
    end
    alias refresh reload

    def confirm
      if confirm_captcha?(session, params[:confirmation])
        render json: { success: true }, status: 200
      else
        render json: { success: false }, status: 422
      end
    end
  end
end

module Captcher
  class CaptchasController < ActionController::Base
    include Captcher::ApplicationHelper

    def show
      captcha = load_captcha(session)
      send_data captcha.represent, filename: "captcha.png",
                                   type: "image/png",
                                   disposition: :inline
    end

    def reload
      captcha = init_captcha(session)
      send_data captcha.represent, filename: "captcha.png",
                                   type: "image/png",
                                   disposition: :inline
    end
    alias refresh reload

    def confirm
      if validate_captcha(session, params[:confirmation])
        render json: { success: true }, status: 200
      else
        render json: { success: false }, status: 422
      end
    end
  end
end

module Captcher
  class CaptchasController < ApplicationController
    include Captcher::ApplicationHelper

    def show
      captcha = load_captcha(session)
      send_data captcha.represent, filename: "captcha.png",
                                   type: "image/png",
                                   disposition: :inline
    end

    def refresh
      captcha = init_captcha(session)
      send_data captcha.represent, filename: "captcha.png",
                                   type: "image/png",
                                   disposition: :inline
    end

    def validate
      if validate_captcha(session, params[:confirmation])
        render json: { success: true }, status: 204
      else
        render json: { success: false }, status: 422
      end
    end
  end
end

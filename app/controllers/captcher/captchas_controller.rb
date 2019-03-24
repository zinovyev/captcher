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
      init_captcha(session)
    end

    def validate
      if validate_captcha(session, params[:confirmation])
        render body: nil, status: 204
      else
        render body: nil, status: 422
      end
    end
  end
end

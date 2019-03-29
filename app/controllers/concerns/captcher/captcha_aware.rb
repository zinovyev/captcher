module Captcher
  module CaptchaAware
    extend ActiveSupport::Concern

    def load_captcha
      Captcher.captcha_class.restore_or_create(Captcher.config, session)
    end

    def reload_captcha
      captcha = Captcher.captcha_class.new(config: Captcher.config)
      captcha.store(session)
      captcha
    end

    def confirm_captcha(confirmation)
      captcha = load_captcha
      captcha.validate(confirmation)
    end
    alias confirm_captcha? confirm_captcha

    private

    def render_captcha(captcha)
      format = params[:format] || captcha.own_config[:format]
      filename = "captcha.#{format}"
      type = "image/#{format}"
      send_data captcha.represent, filename: filename, type: type, disposition: :inline
    end
  end
end

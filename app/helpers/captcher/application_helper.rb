module Captcher
  module ApplicationHelper
    def load_captcha(session)
      Captcher.captcha_class.restore_or_create(Captcher.config, session)
    end

    def init_captcha(session)
      captcha = Captcher.captcha_class.new(config: Captcher.config)
      captcha.store(session)
      captcha
    end

    def validate_captcha(session, confirmation)
      captcha = load_captcha(session)
      captcha.validate(confirmation)
    end
  end
end

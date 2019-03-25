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

    def captcha_tag(options)
      options = options.symbolize_keys

      src = options[:src] = captcha_path

      options[:alt] = options.fetch(:alt) { image_alt(src) }
      options[:width], options[:height] = extract_dimensions(options.delete(:size)) if options[:size]
      tag("img", options)
    end
  end
end

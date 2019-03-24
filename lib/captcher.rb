require "mini_magick"
require "captcher/engine"
require "captcher/config"

if Rails.env.in?(["development", "test"])
  require "pry"
end

module Captcher
  extend self

  def configure
    @config = Captcher::Config.new
    yield(@config)
    self
  end

  def config
    default_config.merge(@config)
  end

  def captcha_class
    return @captcha_class if @captcha_class

    klass = Captcher.config[:mode].to_s.camelize
    @captcha_class = "Captcher::Captchas::#{klass}".constantize
  end

  def build_captcha(session)
    if session[Captcher::BaseCaptcha::SESSION_KEY]
      captcha_class.restore(session)
    else
      captcha_class.new(config: config)
      captcha_class.store(session)
    end
  end

  # rubocop:disable Metrics/MethodLength
  def default_config
    @default_config ||= Captcher::Config.new do |c|
      c.mode = :code_captcha

      c.code_captcha do |cc|
        cc.fonts Dir[Captcher::Engine.root.join("lib/fonts/**")]
        cc.font_size 50
        cc.font_color "black"
        cc.count 5
        cc.background "#999999"
        cc.format "png"
      end

      c.math_captcha do |mc|

      end

      c.awesome_captcha do |ac|

      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end

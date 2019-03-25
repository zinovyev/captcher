module Captcher
  class TextImage
    attr_accessor :text, :config

    def initialize(text, config)
      @text = text
      @config = config
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Lint/Void
    def generate
      MiniMagick::Tool::Convert.new do |i|
        i.font      random_font
        i.size      image_size
        i.pointsize config[:font_size]
        i.fill      config[:font_color]
        i.gravity   "center"
        i.canvas    config[:background]
        i.draw      "text 0,0 '#{text}'"
        i.noise + "Gaussian"
        i << "#{config[:format]}:-"
      end
    end
    # rubocop:enable Lint/Void
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    private

    def image_size
      "#{image_width}x#{image_height}"
    end

    def image_height
      config[:font_size] + 10
    end

    def image_width
      config[:font_size] * config[:count] + 10
    end

    def random_font
      config[:fonts].sample
    end
  end
end

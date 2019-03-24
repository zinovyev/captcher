module Captcher
  module Captchas
    class CodeCaptcha < BaseCaptcha
      SPECIAL_CHAR_CODES = (91..96)
      self.name = :code_captcha

      def after_initialize
        @payload ||= random_text
      end

      # rubocop:disable Metrics/AbcSize
      def represent(format = :html, _options = {})
        MiniMagick::Tool::Convert.new do |i|
          i.font random_font
          i.size image_size
          i.pointsize own_config[:font_size]
          i.fill own_config[:font_color]
          i.gravity "center"
          i.canvas "#{own_config[:background]}"
          i.draw "text 0,0 '#{@payload}'"
          i.noise.+("Gaussian")
          i << "#{own_config[:format]}:-"
        end
      end
      # rubocop:enable Metrics/AbcSize

      def validate(confirmation)
        confirmation.strip.downcase == @payload.downcase
      end

      private

      def image_size
        "#{image_width}x#{image_height}"
      end

      def image_height
        own_config[:font_size] + 10
      end

      def image_width
        own_config[:font_size] * own_config[:count] + 10
      end

      def random_font
        own_config[:fonts].sample
      end

      def random_text
        @random_text ||= Array.new(own_config[:count]).map { random_char }.join("")
      end

      def random_char
        random_char_code.chr
      end

      def random_char_code
        char_code = ("A".ord + (rand * ("z".ord - "A".ord)).floor)
        char_code.in?(SPECIAL_CHAR_CODES) ? random_char_code : char_code
      end
    end
  end
end

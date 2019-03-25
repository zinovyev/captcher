module Captcher
  module Captchas
    class CodeCaptcha < BaseCaptcha
      SPECIAL_CHAR_CODES = (91..96).freeze

      self.name = :code_captcha

      # rubocop:disable Naming/MemoizedInstanceVariableName
      def after_initialize
        @payload ||= random_text
      end
      # rubocop:enable Naming/MemoizedInstanceVariableName

      # rubocop:disable Lint/UnusedMethodArgument
      def represent(format = :html, options = {})
        Captcher::TextImage.new(@payload, own_config).generate
      end
      # rubocop:enable Lint/UnusedMethodArgument

      def validate(confirmation)
        confirmation.to_s.strip.casecmp(@payload).zero?
      end

      private

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

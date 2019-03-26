module Captcher
  module Captchas
    class CachedCaptcha < BaseCaptcha
      KEY_PREFIX = "captcher__cached__".freeze
      CACHE_TTL = 1.hour

      self.name = :cached_captcha

      def after_initialize
        @payload ||= Rails.cache.read(payload_key)
        if @payload
          @wrapped = wrapped_class.new(config: @config, payload: @payload)
        else
          @wrapped = wrapped_class.new(config: @config)
          @payload = @wrapped.payload
          Rails.cache.write(payload_key, @payload, expires_in: CACHE_TTL)
        end
      end

      # rubocop:disable Lint/UnusedMethodArgument
      def represent(format = :html, options = {})
        Rails.cache.fetch(representation_key, expires_in: CACHE_TTL) do
          @wrapped.represent
        end
      end
      # rubocop:enable Lint/UnusedMethodArgument

      def validate(confirmation)
        @wrapped.validate(confirmation)
      end

      private

      def wrapped_class
        Captcher.captcha_class(own_config[:wrapped])
      end

      def representation_key
        payload_hash = Digest::MD5.hexdigest(@payload)
        "#{KEY_PREFIX}:#{payload_hash}"
      end

      def payload_key
        "#{KEY_PREFIX}:#{own_config[:wrapped]}:#{random_slot}"
      end

      def random_slot
        rand(own_config[:slots_count])
      end
    end
  end
end

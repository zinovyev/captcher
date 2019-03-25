module Captcher
  class BaseCaptcha
    SESSION_KEY = "captcha_state".freeze

    class << self
      attr_accessor :name

      def restore(session)
        state = session[SESSION_KEY]
        new(state) if state
      end

      def restore_or_create(config, session)
        restore(session) || new(config: config).store(session)
      end
    end

    attr_accessor :config, :payload

    def initialize(options = {})
      options = options.with_indifferent_access
      @config = options[:config] if options[:config]
      @payload = options[:payload] if options[:payload]
      after_initialize
    end

    def after_initialize; end

    def store(session)
      session[SESSION_KEY] = { payload: payload, config: config }
      self
    end

    def own_config
      @own_config ||= @config[self.class.name.to_sym]
    end

    def represent(format = :html, options = {})
      raise NotImplementedError
    end

    def validate(confirmation)
      raise NotImplementedError
    end
  end
end

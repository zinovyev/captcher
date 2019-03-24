module Captcher
  class Config < OpenStruct
    def initialize
      super
      yield(self) if block_given?
    end

    def merge(other)
      to_h.merge(other.to_h)
    end

    def respond_to_missing?
      true
    end

    def method_missing(name, *args)
      if block_given?
        branch = self.class.new
        yield(branch)
        args = [branch]
      end
      name = to_writer(name, args)
      super
    end

    def to_h
      attributes = super
      attributes.map do |key, value|
        if value.class == self.class
          [key, value.to_h]
        else
          [key, value]
        end
      end.to_h
    end

    def to_writer(name, args)
      args && (name !~ /=$/) ? "#{name}=" : name
    end
  end
end

module Captcher
  module ApplicationHelper
    def captcha_tag(options)
      options = options.symbolize_keys

      src = options[:src] = captcha_path

      options[:alt] = options.fetch(:alt) { image_alt(src) }
      options[:width], options[:height] = extract_dimensions(options.delete(:size)) if options[:size]
      tag("img", options)
    end
  end
end

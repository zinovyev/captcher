module Captcher
  class CaptchasController < ApplicationController
    def show
      image = MiniMagick::Tool::Convert.new do |i|
        i.size "100x50"
        i.xc "black"
        i << "png:-"
      end
      send_data image, filename: "captcha.png",
                       type: "image/png",
                       disposition: :inline
    end
  end
end

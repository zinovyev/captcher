module Captcher
  class CaptchasController < ApplicationController
    def show
      content = MiniMagick::Tool::Convert.new do |convert|
        convert.resize "100x50"
        convert.stdout # alias for "-"
      end
    end
  end
end

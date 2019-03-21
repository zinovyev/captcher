require "captcher/engine"
require "mini_magick"

if Rails.env.in?(["development", "test"])
  require "pry"
end

module Captcher
  # Your code goes here...
end

require "rails_helper"

RSpec.describe "Captcha management" do
  it "shows the captcha image" do
    get "/captcher/captcha"
  end

  it "refreshes the state of captcha" do
  end

  it "validates captcha confirmation" do
  end
end

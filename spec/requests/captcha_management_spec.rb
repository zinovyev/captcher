require "rails_helper"

# rubocop:disable Metrics/BlockLength
RSpec.describe "Captcha management" do
  scenario "shows the captcha image" do
    get "/captcher/captcha"
    expect(response.status).to eq(200)
  end

  scenario "captcha payload remains unchanged between requests" do
    get "/captcher/captcha"
    payload1 = session[Captcher::BaseCaptcha::SESSION_KEY][:payload]

    get "/captcher/captcha"
    payload2 = session[Captcher::BaseCaptcha::SESSION_KEY][:payload]
    expect(payload1).to eq(payload2)
  end

  scenario "refresh the state of captcha" do
    post "/captcher/captcha/refresh"
    expect(response.status).to eq(204)
    payload1 = session[Captcher::BaseCaptcha::SESSION_KEY][:payload]

    post "/captcher/captcha/refresh"
    payload2 = session[Captcher::BaseCaptcha::SESSION_KEY][:payload]
    expect(payload1).to_not eq(payload2)
  end

  scenario "submit valid captcha confirmation" do
    get "/captcher/captcha"
    payload = session[Captcher::BaseCaptcha::SESSION_KEY][:payload]

    post "/captcher/captcha/validate", params: { confirmation: payload }
    expect(response.status).to eq(204)
  end

  scenario "submit invalid captcha confirmation" do
    post "/captcher/captcha/validate", params: { confirmation: "IIIII" }
    expect(response.status).to eq(422)
  end
end
# rubocop:enable Metrics/BlockLength


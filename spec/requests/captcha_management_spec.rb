require "rails_helper"

# rubocop:disable Metrics/BlockLength
RSpec.describe "Captcha management" do
  def captcha_payload
    session[Captcher::BaseCaptcha::SESSION_KEY][:payload] ||
      session[Captcher::BaseCaptcha::SESSION_KEY]["payload"]
  end

  scenario "shows the captcha image" do
    get "/captcher/captcha"
    expect(response.status).to eq(200)
  end

  scenario "captcha payload remains unchanged between requests" do
    get "/captcher/captcha"
    payload1 = captcha_payload

    get "/captcher/captcha"
    payload2 = captcha_payload
    expect(payload1).to eq(payload2)
  end

  scenario "refresh the state of captcha" do
    post "/captcher/captcha/refresh"
    expect(response.status).to eq(200)
    payload1 = captcha_payload

    post "/captcher/captcha/refresh"
    payload2 = captcha_payload
    expect(payload1).to_not eq(payload2)
  end

  scenario "submit valid captcha confirmation" do
    get "/captcher/captcha"
    payload = captcha_payload

    post "/captcher/captcha/confirm", params: { confirmation: payload }
    expect(response.status).to eq(200)
  end

  scenario "submit invalid captcha confirmation" do
    post "/captcher/captcha/confirm", params: { confirmation: "IIIII" }
    expect(response.status).to eq(422)
  end
end
# rubocop:enable Metrics/BlockLength


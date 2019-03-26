require "rails_helper"

RSpec.describe Captcher::Captchas::CodeCaptcha do
  let(:config) { Captcher.config }
  let(:own_config) { config[:code_captcha] }
  let(:captcha) { described_class.new(config: config) }

  describe "#initialize" do
    it "receives config for code_captcha" do
      expect(captcha.own_config).to eq(own_config.with_indifferent_access)
    end

    it "generates a text when initialized" do
      expect(captcha.payload.size).to eq(5)
    end
  end

  describe "#represent" do
    let(:raw_image) { captcha.represent(:html) }
    let(:image_path) { "#{tmp_dir}/test.png" }
    let(:validate_img) { system("convert #{image_path} -", out: "/dev/null") }

    it "produces a valid png image" do
      save_image(raw_image, image_path)
      expect(File).to exist(image_path)
      expect(validate_img).to eq(true)
    end
  end

  describe "#validate" do
    let(:payload) { "LVsll" }
    let(:captcha) { described_class.new(config: config, payload: payload) }

    it "accepts a valid confirmation code" do
      expect(captcha.validate("  LVsll  ")).to eq(true)
      expect(captcha.validate("lvsll")).to eq(true)
      expect(captcha.validate("LVSLL")).to eq(true)
    end

    it "declines invalid confirmation code" do
      expect(captcha.validate("IIIII")).to eq(false)
      expect(captcha.validate("")).to eq(false)
    end
  end
end

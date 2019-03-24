require "rails_helper"

# rubocop:disable Metrics/BlockLength
RSpec.describe Captcher::Config do
  def init_config(c)
    c.foo 1
    c.boo 2
    c.bar { |b| b.boo { |bb| bb.foo 3 } }
  end

  def init_config2(c)
    c.foo 2
    c.baz 2
  end

  let(:config) { described_class.new }

  let(:config2) { described_class.new }

  describe "#to_h" do
    before { init_config(config) }

    it "sets up config and translates it to hash" do
      expected_result = { foo: 1, boo: 2, bar: { boo: { foo: 3 } } }
      expect(config.to_h).to eq(expected_result)
    end
  end

  describe "#merge" do
    before do
      init_config(config)
      init_config2(config2)
    end

    it "merges two configs" do
      expected_result = { foo: 2, boo: 2, baz: 2, bar: { boo: { foo: 3 } } }
      expect(config.merge(config2)).to eq(expected_result)
    end
  end
end
# rubocop:enable Metrics/BlockLength

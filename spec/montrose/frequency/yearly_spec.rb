# frozen_string_literal: true

require "spec_helper"

describe Montrose::Frequency::Yearly do
  let(:now) { time_now }

  before do
    Timecop.freeze(now)
  end

  describe "#include?" do
    it "is true when matches default yearly interval" do
      frequency = new_frequency(every: :year)

      assert frequency.include? now
      assert frequency.include? now + 2.years
      assert frequency.include? now + 30.years
    end

    it "is true when matches given yearly interval" do
      frequency = new_frequency(every: :year, interval: 5)

      assert frequency.include? now
      assert frequency.include? now + 5.years
      assert frequency.include? now + 10.years
    end

    it "is false when does not match given yearly interval" do
      frequency = new_frequency(every: :year, interval: 5)

      refute frequency.include? now + 1.years
      refute frequency.include? now + 3.years
    end
  end
  describe "#to_cron" do
    let(:now) { Time.new(2018, 5, 31, 16, 30, 0) }

    it "returns a valid crontab with no interval" do
      frequency = new_frequency(every: :year)

      assert_equal frequency.to_cron, "30 16 31 5 *"
    end

    it "raises on non-yearly interval" do
      frequency = new_frequency(every: :year, interval: 3)

      assert_raises(RuntimeError) { frequency.to_cron }
    end
  end
end

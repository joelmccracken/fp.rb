require 'test_helper'

describe FP::Fn do
  it "creates accessors for arguments that may be used for parameters" do
    math_calc_by_name = Class.new(FP::Fn) do

      arguments :a, :b, by: :name

      def call(c, d)
        pm(a) + pm(b)
      end

      private

      def pm(var)
        var * b
      end
    end

    results = math_calc_by_name.(a: 1, b: 2)
    results.must_equal 6
  end

  describe "fn parameter specs" do
    it "allows for named parameters" do
      math_calc_by_name = Class.new(FP::Fn) do
        arguments :a, :b, by: :name

        def call
          pm(a) + pm(b)
        end

        private

        def pm(var)
          var * b
        end
      end

      results = math_calc_by_name.(a: 1, b: 2)
      results.must_equal 6
    end

    it "allows for positional parameters" do
      math_calc_by_name = Class.new(FP::Fn) do
        arguments :a, :b, by: :position

        def call
          pm(a) + pm(b)
        end

        private

        def pm(var)
          var * b
        end
      end

      results = math_calc_by_name.(2, 3)
      results.must_equal 15
    end
  end

  it "creates class-level methods for public instance methods that wrap the instance creation and public method call" do
    math_calc_by_name = Class.new(FP::Fn) do
      arguments :a, :b, by: :position

      def call
        pm(a) + pm(b)
      end

      private

      def pm(var)
        var * b
      end
    end

    results = math_calc_by_name.(3, 4)
    results.must_equal 28
  end

  it "correctly handles this example" do
    class SlowExponentiate < FP::Fn
      arguments :x, :y
      def call
        exponentiate(y)
      end

      private

      def exponentiate(num_left)
        if num_left > 0
          multiply(exponentiate(num_left - 1))
        else
          1
        end
      end

      def multiply(num_left)
        if num_left > 0
          x + multiply(num_left-1)
        else
          0
        end
      end
    end
    SlowExponentiate.(2, 0).must_equal 1
    SlowExponentiate.(2, 1).must_equal 2
    SlowExponentiate.(2, 8).must_equal 256
  end
end

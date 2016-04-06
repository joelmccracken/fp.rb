# FP.rb

This Gem provides functionality that makes it easier to use functional patterns in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fp'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fp

## Usage

## The FP::Fn Base Class

This class provides a way to emulate familiar patterns from functional languages. In most functional
languages,
it is common to define helper functions within the body of functions. These functions have access to
the arguments from the original function, as these are part of the environment in which they are defined.

Imagine that for some reason you had to implement exponentiation yourself, and only had addition to work with.
Since multiplication can be define as a series of additions, and exponentiation is defined as a series of
multiplications, you can use addition and recursive function calls to solve the problem.


In Haskell, this solution would look something like this:

    slowExponentiate x y =
      let exponentiate_x 0 = 1
          exponentiate_x num_left = multiply_x(exponentiate_x(num_left - 1))
          multiply_x 0 = 0
          multiply_x num_left = x + multiply_x(num_left - 1)
      in exponentiate_x y

Here is similar code in JavaScript:

    function slowExponentiate(x, y) {
      var multiplyX = function(num_left) {
        if(num_left > 0) {
          return x + multiplyX(num_left - 1);
        } else {
          return 1;
        }
      }

      var exponentiateX = function(num_left){
        if(num_left > 0) {
          multiplyX(exponentiateX(num_left - 1);
        } else {
          return 0
        }
      }

      return exponentiate(y);
    }

In Ruby, the closest example would look something like this:

    def slow_exponentiate(x, y)
      multiply_x = ->(num_left) {
        if num_left > 0
          x + multiply_x.(num_left - 1)
        else
          0
        end
      }

      exponentiate_x = ->(num_left) {
        if num_left > 0
          multiply_x.(exponentiate_x.(num_left - 1))
        else
          1
        end
      }

      exponentiate_x.(y)
    end


The thing is, many would consider this code to be ugly.
The FP::Fn gives you the best of both worlds: the familiar syntax of
Ruby with this powerful functional idiom.

    class SlowExponentiate < FP::Fn
      def call(x, y)
        exponentiate_x(y)
      end

      private
      def exponentiate_x(num_left)
        if num_left > 0
          multiply_x(exponentiate_x(num_left - 1))
        else
          1
        end
      end

      def multiply_x(num_left)
        if num_left > 0
          x + multiply_x(num_left-1)
        else
          0
        end
      end
    end

    SlowExponentiate.(2, 0) # => 1
    SlowExponentiate.(2, 1) # => 2
    SlowExponentiate.(2, 8) # => 256

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joelmccracken/fp.rb.

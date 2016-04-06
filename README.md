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

### The FP::Fn Base Class

The FP::Fn class simulates closure-like behavior with classes and familiar class syntax. It eliminates
the boilerplate that is otherwise necessary when using classes in a functional style.

This class provides a way to emulate familiar patterns from functional languages. In most functional
languages, it is common to define functions within the body of other functions to help
with computation.
These inner functions have access to
the arguments that outer function are called with, as these are part of the environment in which they are defined.

Lets look at an example:
Imagine that for some reason you had to implement exponentiation yourself, and only had addition to work with.
Since multiplication can be define as a series of additions, and exponentiation is defined as a series of
multiplications, you can use addition and recursive function calls to solve the problem.

In Ruby, the closest example would look something like this:

````ruby
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
````
In Haskell, this solution would look something like this:

````haskell
slowExponentiate x y =
  let exponentiate_x 0 = 1
      exponentiate_x num_left = multiply_x(exponentiate_x(num_left - 1))
      multiply_x 0 = 0
      multiply_x num_left = x + multiply_x(num_left - 1)
  in exponentiate_x y
````

Here is similar code in JavaScript:

````javascript
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
````

The thing is, many would consider this code to be ugly.
The FP::Fn gives you the best of both worlds: the familiar syntax of
Ruby with this powerful functional idiom.

````ruby
class SlowExponentiate < FP::Fn
  arguments :x, :y, by: :position

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
````

What *exactly* does it do? Well, it:

- Creates class methods that correspond to public instance methods that
  creates a `new` instance and calls the method on that instance, returning the result.

- Provides an `arguments` class method to specify the arguments that will become part of this "closure".

Doing the same thing with classes normally would look something like this:

````ruby
class SlowExponentiate
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def call
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

SlowExponentiate.new(2, 8).call # => 256
````

Over time, the initialization overhead adds up, slowly making it harder to add more functionality to your code. Additionally, there are many different ways
to write above code in pure Ruby, each with different tradeoffs.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joelmccracken/fp.rb.

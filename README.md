# ruby-maybe

[![Build Status](https://travis-ci.org/seadowg/ruby-maybe.png?branch=master)](https://travis-ci.org/seadowg/ruby-maybe)

![](http://f.cl.ly/items/2o2A3k1N2d3a1b0V3V0T/maybe.png)

## Installation

Either include in your Gemfile:

    gem 'ruby-maybe'

Or, install for your system:

    > gem install ruby-maybe

## Usage

### The Basics

'Maybe' not 'Maeby'. This is an implementation of the 'Maybe' or 'Option' monad similar to that used
[Haskell](http://www.haskell.org/haskellwiki/Maybe). Monads provide a
safe way to create non deterministic programs (for example, when not all
values are known at compile time). The Maybe monad allows programmers to
deal with values that may or may not be undefined.

Imagine we are access accessing an array via a method:

    array = [1,2,3]

    def access(n)
      array[n]
    end

    access(1) # => 2
    access(5) # => nil

Now what if we want to take some index and add `5` to the array value
stored there?

    access(5) + 5 # => NoMethodError: undefined method `+' for nil:NilClass

Hmmm, that fails pretty miserably. We can solve this with `Maybe`. Lets
rewrite `access`:

    def access(n)
      if array[n]
        Just.new(array[n])
      else
        Nothing
      end
    end

`Nothing` and `Just` used here are both instances of `Maybe`. This means
that they will both respond to the `bind` method:

    access(1).bind { |val| Just.new(val + 5) } # => Just.new(7)
    access(5).bind { |val| Just.new(val + 5) } # => Nothing.new

For instances of `Just`, `bind` will execute the passed block with
respect to its contained value and for `Nothing` it will skip the block
and simply return another instance of `Nothing`. This allows a neat
mechanism for dealing with non determinitic methods such as `access`
without having them throw exceptions or simply return `nil`.

`Maybe` is a very basic monad and at first might not seem that powerful
but after using it instead of the more verbose control flow it replaces
you might just learn to love it.

### Method Lifting

Ok so using `bind` to operate on Maybe is all well and good, but what if
you want to add three Maybe's together:

    x.bind { |x_val|
      y.bind { |y_val|
        z.bind { |z_val|
          Just.new(x + y + z)
        }
      }
    }

Yeah... I don't think so. In languages like Haskell we can use [Applicative Functors](http://learnyouahaskell.com/functors-applicative-functors-and-monoids)
to deal with making expressions like the above less verbose. You can go read about them but that's not really important.
With ruby-maybe methods on the contained object in a Maybe can be lifted to operate on the Maybe:

    Just.new(5) + Just.new(6) # => Just.new(11)
    Just.new("OMG").downcase # => Just.new("omg")
    Just.new([1,2]).inject(Just.new(0), :+) # => Just.new(3)

All operations can be lifted like this and you can mix and match actual values and Maybes in the arguments. This also
works for Nothing:

    Nothing.new + Just.new(5) # => Nothing.new
    Just.new(0) * Nothing.new / Just.new(1) # => Nothing.new

### Extracting Values from a Maybe

Try not to do this. Please. Monads are best used when we play nice and let the monad look after our values. Of course,
you're thinking "well at some point I have to take it out to write it out or stick it in a web response on something
right?". Yes, of course. But its best if these cases have abstractions that can receive monads or are structured as
Monads themselves (some languages like Haskell include monads for IO, Web request processing [etc](http://learnyouahaskell.com/a-fistful-of-monads)).

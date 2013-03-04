# ruby-maybe

[![Build Status](https://travis-ci.org/oetzi/ruby-maybe.png?branch=master)](https://travis-ci.org/oetzi/ruby-maybe)

![](http://f.cl.ly/items/2o2A3k1N2d3a1b0V3V0T/maybe.png)

## Description

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
I think you might learn to love it.

## Installation

Either include in your Gemfile:

    gem 'ruby-maybe'

Or, install for your system:

    > gem install ruby-maybe

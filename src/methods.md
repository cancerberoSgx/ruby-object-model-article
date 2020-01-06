
<i id="appendix-more-on-methods"></i>

## Appendix: More on methods

This section describes techniques available in Ruby regarding method dispatch, proxies and hooks. It's somewhat related with what we call meta programming. 


<i id="method-objects"></i>

### Method objects

Methods can also be manipulated as objects by using `Kernel#method` method. It will return the method itself as a `Method` object that can be later executed using `Method#call`.

```rb
class MyClass
  def initialize(value)
    @x = value
  end
  def my_method
    @x
  end
end
object = MyClass.new(1)
m = object.method :my_method
m.call # => 1
```

The same applies to singleton methods by using `Kernel#singleton_method`.


<i id="dynamic-methods"></i>

### Dynamic methods

We can call any method dynamically using `Object#send`, even private methods: 

```rb
class MyClass
  def my_method(my_arg)
    my_arg*2
  end
end
object = MyClass.new
p object.send(:my_method, 2) # => 4
p 1.send(:+, 2)              # => 3
```

And regarding dynamically defining methods, we've already done that in [Section Flat Scope](#flat-scope) using `define_method`.


<i id="method_missing"></i>

### method_missing

In Ruby there's no compiler to verify that a method actually exists when we call it. If we call a method that doesn't exists there will be a runtime error `NoMethodError`. When Ruby can't find a method while looking up through the class hierarchy it will end up calling the private method `BaseObject#method_missing` which by default throws an error like `NoMethodError: undefined method 'my_method' for #<MyClass>`. 

So, it's possible to override `BaseObject#method_missing` to implement custom behavior when this happens: 

```rb
class MyClass
  def method_missing(method, *args)
    p "You called: #{method}(#{args.join(', ')})"
    p "(You also passed it a block)" if block_given?
  end
end
obj = MyClass.new
obj.non_existent_method('a', 3.14) { }
```

It will print:

```
You called: non_existent_method(a, 3.14)
(You also passed it a block)
```

<i id="ghost-methods-and-dynamic-proxies"></i>

### Ghost methods and dynamic proxies

As seen in previous section, using by overriding `BaseObject#method_missing` we can implement methods such as, from the point of view of the caller they will look like simple method calls, but on the receiver's side they have no corresponding method implementation. This technique is often called *Ghost Method*. 

Let's implement a class which purpose is to be a Hash-like structure, but unlike Ruby's `Hash`, properties can be accessed using the accessor operator `.` and assigned using `=`:

```rb
class MyHash
  def initialize
    @data = {}
  end
  def method_missing(method, *args)
    name = method.to_s
    if name.end_with? '='
      @data[name.slice(0, name.length - 1)] = args[0]
    else
      @data[name]
    end
  end
end
hash = MyHash.new
hash.foo = 1
p hash.foo # => 1
```

<i id="respond_to_missing"></i>

### respond_to_missing

Since Ruby object's also support the method `respond_to?` for knowing if an object understand a certain method, when implementing ghost methods, we might want to include them in `respond_to?`. For this we need to override `respond_to_missing` to return our ghost method names.

In the past, Ruby coders used to override `respond_to?` directly but now that practice is considered somewhat dirty and overriding `respond_to_missing` is preferred.


<i id="blank-slates"></i>

### Blank slates

When implementing dynamic proxies, like our `MyHash` class shown above, existing `Object` methods (which are not few) could collide with our ghost methods. In our example, since `Object` already has a method called `display`, hash keys named `display` won't work as expected: 

```rb
hash = MyHash.new
hash.display = 'hello'
p hash.display  # => #<MyHash:0x00007fce330638b8>nil
```

A way to workaround this problem is to extend from `BaseObject` instead of `Object` since it has only a couple of instance methods so these kind of collisions are less probable:

```rb
class MyHash < BaseObject
  def initialize
    @data = {}
  end
  def method_missing(method, *args)
    name = method.to_s
    if name.end_with? '='
      @data[name.slice(0, name.length - 1)] = args[0]
    else
      @data[name]
    end
  end
end
hash = MyHash.new
hash.display = 'hello'
p hash.display  # => hello
```

And if you need even more control, we could even use `undef_method` to remove existing methods.
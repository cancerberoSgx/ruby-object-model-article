## More on methods

This section describes techniques available in Ruby regarding method dispatch, proxies and hooks. It's somewhat related with what we call meta programming. 

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

### method_missing

### Blank slates
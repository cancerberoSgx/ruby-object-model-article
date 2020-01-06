

<i id="messages-&-methods"></i>

## Messages & methods

Like in other programming languages, the concept of sending a message to an object (or in other words invoking an object's method), is done using the dot operator `.`, like in `tv.change_channel('bbc')`. 

### Simple example

User optionally passes a list of arguments and given object method is invoked using the *target object* as `self` in the method's body code. The expression evaluates in whatever the method returns: 

```rb
class Car
  def turn(where)
    @direction = where
    @@degrees[where]
  end
end
car = Car.new
degrees = car.turn(:left)
```



<i id="message-syntax"></i>

### Message syntax

What's interesting of Ruby is that it support more than one flavor to write message expressions: 

```rb
result = my_object.remove_obsolete(:serie1, [a, b])
result = my_object.remove_obsolete :serie1, [a, b]
```

Another cool syntax alternative for these call expressions are *keyword* arguments. instead of passing a list of unnamed arguments, pass a hash of named arguments. This is particularly useful when building APIs with many arguments:

```rb
result = my_object.players(serie_id: :serie1, filters: [a, b], round: 1)
result = my_object.players serie_id: :serie1, filters: [a, b], round: 1
```



<i id="method-syntax"></i>

### Method syntax

Now how is it implemented each of the message syntax above ?

```rb
class Foo
  def remove_obsolete(serie_id, filter = [])
  end
  def players(serie_id: nil, filter: [], round: nil)
    remove_obsolete(serie_id, filter).select { |person| person.is_playing }
  end
end
```



<i id="method-lookup"></i>

### Method lookup

When you call a method, Ruby does two things:

 1. It finds the method. This is a process called *method lookup*
 2. It executes the method for which it needs to know the *current object* `self`

Although *method lookup* is a process known in most object oriented languages, it's important to understand how this exactly works in Ruby.

Remember how, in [Section Methods](#methods) we said that instance variables are owned nby the instances but instance method's are owned by the class ? So in the simplest case, when Ruby finds an expression like `foo.bar()` it will look for the method `bar` in `foo.class`'s class. 

Because methods could be defined in super classes or in modules [refining](#refinements) super classes, more generally, Ruby will look up for methods by climbing up the object's class ancestors chain. 

**Tip**: Ruby classes support the method `ancestors` which returns the class' ancestors chain, in order, from the class itself, up to `BaseObject`, including modules used or refining the object's class hierarchy. Example: 

```rb
MySubclass.ancestors # => [MySubclass, MyClass, Object, Kernel, BasicObject]
```

Notice that `Kernel`, which is a module, not a class, is also included in the ancestors of `MySubclass`, just like any class.



<i id="message-block"></i>

### Message block

What's unusual in Ruby compared to other languages is that besides the list of arguments, methods also accepts a code block that they can `yield` whatever times they need. For example, in the expression `[1, 2, 3].each() { |item| p item}` we are invoking the method `each` with no arguments and passing a message block right after the call expression. `Array.each` will execute this block passing each of the array's items as argument. 

Let's implement JavaScript `Array.prototype.some` which executes given block on each item until the block returns truthy:

```rb
class Array
  def some
    throw 'No block passed' unless block_given?
    i = 0
    while i < length
      result = yield self[i]
      return self[i] if result
      i += 1
    end
  end
end
# prints "123"
[1, 2, 3, 4, 5].some() do |n|
  print n
  n > 2
end
```

As you can see in the last statement, `some()` is invoked without passing any arguments and next to the call, there's a block expression `do |n| ...`. This is what we call the message block, which is invoked in `some`'s body, using the `yield` expression `result = yield self[i]`. `result` will contain whatever value was returned by given  block.

Also notice how we use `block_given?` to know if a message block was passed.

As a last example, here is a method that accepts both, a callback argument and a message block. In this case, instead of using `yield` and the implicit block, we use an alternative syntax by declaring a last argument starting with `&` in which case it will be the passed block object, if any. Notice how, instead of using `yield` we use `block.call`:

```rb
def set_interval
  # artificial event loop listener
end
def wait_for(predicate, &block)
  timer = set_interval do 
    if predicate
      clear_interval timer
      block.call
    end
  end
end
t = Time.now + 1
wait_for(proc { Time.now > t }) { print '1 second passed' }
```

#### yield_self, a.k.a then

Ruby objects support the method `yield_self` (and its alias `then`). The idea is simple, just pass `self` as the argument to the message block. 

In the snippet `print 2.yield_self { |n| n * 3.14 }` we send the yield_self message to the object `2` which causes given message block to be invoked passing `2` as argument. In the previous code, parameter `n`'s value will be `2`.

Using its alias `then` we can write data transformation as a series of `then`s - feels familiar to JavaScript promises or Elixir pipe operator (`|>`):

```rb
def name_starts_with(data, name_prefix)
  data
    .then { |persons| persons.map { |person| person[:name] } }
    .then { |names| names.select { |name| name.start_with? name_prefix } }
    .then { |names| names.sort }
end
p name_starts_with [{ name: 'andrew' }, { name: 'laura' }], 'a'
```

Note: Ruby objects also support `tap` method but unlike `yield_self`, it yields `self` and returns `self`.

<div class="page-break"></div>



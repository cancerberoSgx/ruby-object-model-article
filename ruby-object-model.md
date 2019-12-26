# The Ruby Object Model

## Contents

<!-- toc -->

  * [About this document](#about-this-document)
  * [scope and context object](#scope-and-context-object)
    + [self: the default object](#self-the-default-object)
    + [scope and class declarations](#scope-and-class-declarations)
  * [declarations](#declarations)
  * [class and module](#class-and-module)
    + [module declarations](#module-declarations)
  * [messages](#messages)
    + [message syntax](#message-syntax)
    + [method syntax](#method-syntax)
    + [message block](#message-block)
      - [yield_self, a.k.a then](#yield_self-aka-then)
  * [variables](#variables)
    + [accessors](#accessors)
    + [accessor methods](#accessor-methods)
  * [Operators](#operators)
  * [Blocks](#blocks)
- [TODO](#todo)
    + [the instance scope](#the-instance-scope)
    + [the class scope](#the-class-scope)
    + [the singleton scope](#the-singleton-scope)

<!-- tocstop -->

## About this document

When it comes to modeling a problem using an object oriented fashion, each language has its own peculiarities when it comes to, declaring objects and classes, code scope, object instantiation, etc. 

When we talk about *object model* we are referring basically to these aspects:

 * how to create an object
 * how to send a message to an object
 * how to declare object methods and properties
 * how to declare object classes, instance methods, properties, etc
 * how to declare class inheritance and access the class hierarchy (call super)

This document tries to give a detailed description of how these things works and can be written in Ruby. Particular emphasis is made on Ruby peculiarities compared to other programming languages. So, more than an Object Oriented Programming manual for Ruby, this document should be considered as descriptions on how objects work, understanding class declarations and Ruby peculiarities when dealing with objects and classes.

It assumes the reader has some background on object oriented programming such as the concepts of object, class, message, method and inheritance. Basic Ruby background is recommended although not needed since the code snippets are simple and commented.

## scope and context object

Although the concept of *scope* might seem not directly related with objects and classes, it plays a critical role while dealing with objects and classes in ruby. That's why this document starts describing it.

Similar to other scripting languages understanding the rules for the scope on which the code we write is evaluated is critical. And also like other languages, there's a particular object in the scope that represents *"the thing we are talking about now"*, more formally often called the *context object*. 

Most languages represent this object with a keyword, in Ruby the keyword `self` is used, while in other programming languages the `this` keyword os often used.

Depending on which part of the code you are, `self` represents different things. It's always present in any piece of code is evaluated. And, in Ruby, it cannot be re-assigned. 

### self: the default object

The primordial operation objects must support is to receive messages. The context object, this is `self`, acts as the default object when the message receiver is not specified. For example, the following two statements are equivalent:

```rb
a = self.to_s
b = to_s
```

As you can see in the second line, we send a message `to_s` without providing the target object, so the message will be actually be dispatched to `self`, the context object.

### scope and class declarations

Besides being the default object for messages, in Ruby, the context object plays a principal role while declaring classes.

In ruby, there is no real distinction between code that defines a class and code of any other kind. In a sense, the `class` keyword is more like a *scope operator* than a class declaration. Yes, it creates classes that don't yet exist, but this could be considered just as a nice side effect: the core job of `class` is to *move you to the scope of a class* so you can declare methods. 

For declaring classes we must change the scope (`self`) using `class`, and `def` expressions. 

Inside a method declaration, `self` references *the instance*, similar to the `this` keyword in other programming languages. 

Inside a class declaration and outside a method, `self` references *the class*.

The following code tries to illustrate how the scope changes through different parts of the code. Notice how `class` and `def` are used to change the context object (`self`) where written code runs:

```rb
# outside a class or module, "self" references the "main" context object
p self.instance_variables # []
# declaring a variable outside class or module is equivalent to declare an instance variable on "self.class"
@foo = 1
p self.instance_variables # [:foo]

class Class1
  # inside a class but outside methods, "self" references the class
  p self # Class1

  # instance method declaration:
  def method1
    # inside an instance method, "self" references the instance
    p self # #<Class1:0x00007fc66691d938>
  end

  # class method declaration ("self" here references the class)
  def self.method2
    # inside a class method, "self" references the class
    p self # Class1
  end
end

a = Class1.new
a.method1
Class1.method2
```

## declarations

we've already seen in [Scope and class declarations](#scope-and-class-declarations), how to change the scope using `class` to declare a new class and `def` to declare instance methods.

`class` declarations like previously shown have some peculiarities in ruby compared to other programming languages. As said at TODO, these declarations can be understood as scope change so "multiple declarations" are allowed and each of them will be incrementally modifying that class or module context object, this is `self`. 

This allows to partition a class declaration in several files:

```rb
class Sample
  def method1
    'method1'
  end
end
# perhaps in another file
class Sample 
  def method2
    'method2'
  end
end
p Sample.new.method1, Sample.new.method2
```

Also, this allows to add or modify the behavior of standard classes as well:

```rb
class String
  def trim
    self.strip
  end
end
p '  asd ss '.trim
```


<!-- 

## class and module
  runs scope on the code rubs which methods run or are declared, is very important and in the scope there is a  and represented with a keyword, `self` in the case of Ruby.
Any code that is evaluated, it is so, in association with a context object. This object is the default object for messages without a receiver -->



### module declarations

The keyword `module` can be used to change the scope to a `class` with the only difference that instead of common class inheritance where the parent class is declared, a `module` is `include`d explicitly by any class. Since a class can `include` several modules, this provides with an alternative to class inheritance when multiple inheritance is needed. This somewhat remembers JavaScript object mixin. 

Think of modules as a syntax to declare the "composition" part in "composition vs inheritance" discussions (TODO link).

Similarly to what we've shown in [Scope and class declarations](#scope-and-class-declarations), the following snippet illustrates the basics of Ruby modules and also how `self` is changed in `module` declarations:

```rb
module Module1
  # inside the module scope and outside method declarations, self represent the module 
  p self # Module1
  p self.class # Module
  def method1
    p self # #<A:0x00007fab94822a48>
  end
end
class A
  p self # A
  include Module1
  def method2
    p self # #<A:0x00007fab94822a48>
  end
  def self.class_method1
    p self # A
  end
end
a = A.new
a.method1
```

TODO: how to declare instance variables or class method from module ? 

## messages

This section focus on Ruby ways of writing code that sends messages to an object. Later, in TODO, the method declaration that handles the message is detailed. 

Like in other programming languages, the concept of sending a message to an object (or in other words invoking an object's method), is done using the dot operator `.`, like in `tv.change_channel('espn')`. 

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

### message syntax

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

### method syntax

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
### message block

What's unusual in ruby is that besides the list of arguments, Ruby methods also accepts a code block that they can `yield` whatever times they need. Let's implement JavaScript `Array.prototype.some` which executes given block on each item until the block returns truthy:

```rb
class Array
  def some
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

To know if a message block was passed we use  TODO

As a last example, here is a method that accepts both, a callback argument and a message block.

```rb
def wait_for(predicate)
  timer = set_interval 0.3 do 
    if predicate
      clear_interval timer
      yield
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



## variables

 * they are always associated with an object or class?

### accessors

TODO

```
attr :foo
attr_writable :bar
etc
```

### accessor methods

TODO

```
def foo=(value)
  @foo = value
end
TODO: getter
```

## Operators

 * relationship between operators and methods 
 * operators are methods
 * can be overridde - even Number ? 

## Blocks

A block is a special kind of object that contains executable code. In fact, all Ruby code is evaluated in the context of a block. Many other blocks can be declared and since they are just objects they can be used like any object. Particularly, as seen in [message block](#message-block), they can be passed in the payload of a message.

TODO: 

 * proc vs lambda vs etc and which allows to change scope.

# TODO

### the instance scope
### the class scope
### the singleton scope
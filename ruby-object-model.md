# The Ruby Object Model

## Contents

<!-- toc -->

  * [About this document](#about-this-document)
  * [The basics](#the-basics)
    + [Objects and classes](#objects-and-classes)
    + [Instance variables](#instance-variables)
    + [Methods](#methods)
    + [Reflection helpers](#reflection-helpers)
    + [Classes](#classes)
  * [Scope and the current object](#scope-and-the-current-object)
    + [self: the default object](#self-the-default-object)
    + [Scope Gates `class`, `module` and `def`](#scope-gates-class-module-and-def)
    + [Flat Scope](#flat-scope)
  * [declarations](#declarations)
    + [Open class](#open-class)
    + [class declaration](#class-declaration)
    + [module declaration](#module-declaration)
  * [message & method](#message--method)
    + [simple example](#simple-example)
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

<!-- tocstop -->

## About this document

When it comes to modeling a problem using an object oriented fashion, each language has its own peculiarities when it comes to, declaring objects and classes, code scope, object instantiation, etc. 

When we talk about *object model* we are referring basically to these aspects:

 * how to create an object
 * how to send a message to an object
 * how to declare object methods and properties 
 * how to declare object classes, instance methods, instance variables, etc
 * how to declare class inheritance and access the class hierarchy (call super)

This document tries to give a detailed description of how these things works and can be written in Ruby. Particular emphasis is made on Ruby peculiarities compared to other programming languages such as scope, class expressions, . So, more than an Object Oriented Programming manual for Ruby, this document should be considered as descriptions on how objects work, understanding class declarations and Ruby peculiarities when dealing with objects and classes.

It assumes the reader has some background on object oriented programming such as the concepts of object, class, message, method and inheritance. Basic Ruby background is recommended although not needed since the code snippets are simple and commented.

Aside, this is a millennial-friendly document: short paragraphs and code snippets right away!

## The basics

Let's start by explaining how to define a class and create new object instances in Ruby. In following sections we will be explaining exactly what's happening and how it works in detail, right now the objective is just making sure we know how to do it. 

The following code defines a class named `Orc`, with a method `eat`. When `eat` method is called an instance variable `@energy` is created by assigning it to a value. After the class definition, we then create an `Orc` instance and store it in local variable `fred`:

```rb
class Orc
  def eat
    @energy = 100
  end
end
fred = Orc.new
```



<!-- As you can see, we used `class` to declare a new class. 
The class defines two methods: `initialize` and `eat`. The method `initialize` is analogous to Java or JavaScript `constructor` in the sense that will be called when new instances are created. On it we define an *instance variable* called `@energy` by just assigning it a value. -->

<!--    Relationship between objects, classes, methods and variables -->


### Objects and classes

**In Ruby everything is an object**, and **every object is associated with a class** of which we say it's an *instance* of. An object's class can be accessed through the method `class`. 

And since everything is an object, classes themselves are instances of a class named `Class`. The following code tries to describe this:

```rb
fred = Orc.new
fred.class # => Orc
Orc.class  # => Class
```

Note that in the previous code, the expression `Orc.new` is calling a method on the object `Orc` which is an instance of Class. That method `new` is therefore an instance method of `Class`, that's how the object `Orc` is able to understand the `:new` message. 

This will be described with more detail later, right now, the important thing to understand it that everything is an object which are always associated with a class. And that classes also are objects, instances of `Class`.

### Instance variables

Unlike in Java or other static languages, in Ruby there is no connection between an object's class and its instance variables. Instance variables just spring into existence when you assign them a value. In the previous example, the instance variable `@energy` is assigned only when the method `eat` is called. If it's not then the instance variable is never defined. In conclusion we could have Orcs with and without `@energy` instance variable. 

You can think of the names and values of instance variables as keys and values in a hash. Both the keys and the values can be different for each object.

### Methods

Besides instance variables objects also have methods. But unlike instance variables, objects that share the same class also share the same methods, so methods are stored in the object's class and not in the object itself as instance variables.

The following image tries to illustrate the relationship between objects, classes, instance variables and methods using the previous "orcs" example code. 

![Figure 1-1](diagrams/instance_variables_methods_classes_objects.png)

So, when we say "the method `eat` of object `fred`" we will be actually referring, generally, to the *instance method* `eat` of `fred`'s class, in our case `Orc`. 

Strictly speaking, when talking about classes and methods, it would be incorrect to say "the method `eat` of `Orc`". `Orc`, viewed as an object, won't understand the message `Orc.eat`. Instead we should say "the *instance method* `eat` of `Orc`". It would be correct to also say "the method `new` of `Orc`" though, since `Orc.new` makes sense.

### Reflection helpers

Now that you know about instance methods, this little section explains how to use two utility methods supported in ruby to inspect our object and classes methods. 

In Ruby any object supports the message `:methods` which will return the array of method names that the receiver object understand. Also, `Class` instances supports the message `:instance_methods` which will return the array of instance method names (passing false will ignore inherited instance methods). The following example try to describe these meta-programming helpers:

```

```



### Classes

As said in the previous section, methods of an object are actually instance methods of its class. So in our example, `fred` methods like `eat` are actually *instance methods* of `Orc`. The interesting part is that the same applies to `Orc` viewed as an object. Methods of `Orc`, like `Orc.new`, are *instance methods* of `Class`:

```rb
fred = Orc.new
fred.eat
p fred.class # Orc
p Orc.instance_methods(false) # [:eat]
p Orc.class  # Class
p Class.instance_methods(false) # [:allocate, :superclass, :new]
```

So, if classes are also objects, instances of `Class`, could we just use `Class.new` to define a new class? Of course: See [Flat Scope](#flat-scope) section which contains a snippet that defines a our `Orc` using `Class.new`.

## Scope and the current object

Although the concept of *scope* might seem not directly related with objects and classes, it plays a critical role while dealing with them in Ruby. 

Similar to other scripting languages understanding the rules for the scope on which the code we write runs is critical. And also like other languages, there's a particular object in the scope that represents *"the thing we are talking about now"*, more formally often called the *current object*. 

Most languages represent this object with a keyword, in Ruby the keyword `self` is used, while in other programming languages the `this` keyword is often used.

Depending on which part of the code you are, `self` represents different things. It's always present and, in Ruby, it cannot be re-assigned. 

### self: the default object

The primordial operation objects must support is to receive messages. The current object, this is `self`, acts as the default object when the message receiver is not specified. For example, the following two statements are equivalent:

```rb
a = self.to_s
b = to_s
```

As you can see in the second line, we send a message `to_s` without providing the target object, so the message will be actually be dispatched to `self`, the current object.

### Scope Gates `class`, `module` and `def`

<!-- Besides being the default object for messages, `self` plays an important role while declaring classes.  -->

In ruby, there is no real distinction between code that defines a class and code of any other kind. In a sense, the `class` keyword is more like a *scope operator* than a class declaration. Yes, it creates classes that don't yet exist, but this could be considered just as a nice side effect: the core job of `class` is to *move you to the scope of a class* so you can declare methods. 

There are exactly three places where a program leaves the previous scope behind and opens a new one: 

 * Class definitions
 * Module definitions
 * Methods

And these three places are respectively marked with the keywords `class`, `module`, `def`. When opening one of these *scope gates*, the current scope is replaced so current local variables won't be visible form within the new `class` code.

<!-- For declaring classes we must change the `self` using `class`, and `def` expressions.  -->

The following tries to illustrate how the scope changes through different parts of the code when defining a class. Notice how `class` and `def` are used to change the meaning of `self`, first to a new class `Class1` and then referencing the instance, so we are able to declare classes, instance methods, class methods, etc:

```rb
p self # main
x = 1
class Class1
  # previous local variable "x" is not visible from here

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

Notice how:

 * Inside a method declaration, `self` references *the instance*, similar to the `this` keyword in other programming languages. 
 * Inside a class declaration and outside a method, `self` references *the class*.

### Flat Scope

Using Scope Gates like `class` has many advantages since the inner code runs with a fresh scope. But sometimes we need to access outer local variables from inside a class which is not possible if using scope gates as shown in the previous section. 

To workaround this problem, classes can be defined using `Class.new` instead the `class` scope gate. 

Also, for outside local variables to be available inside methods, we need to use `Module#define_method` which allows to define new methods imperatively, without using the scope gate `def`:

```rb
initial_energy = 100
Orc = Class.new do
  define_method :eat do
    @energy = initial_energy
  end
end
```

TODO: more about Class.new and define_method : links or show the signatures


## declarations

We've already seen in [Scope Gates](#scope-gates), how to change the scope using `class` to declare classes and `def` to declare methods.

### Open class

`class` being a scope gate instead of a declaration, has a practical consequence: we can *reopen existing classes* - even standard library's like String or Array - and modify them on the fly. This technique is often known as *Open Class* or more despectively as *Monkeypatch*.

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

### class declarations

TODO: expand previous example with inheritance, super, class variables, class method


### Modules

TODO: Class is a Module  Class < Module < BaseObject. TODO: snippet

So classes are modules with some utilities like `Class#new`. So everything said here about modules also applies to classes.

modules can be explicitly `include`d in other classes to augment their instance methods, and instance variables.


<!-- module declaration -->

<!-- The keyword `module` can be used to change the scope to a `class` with the only difference that instead of common class inheritance where the parent class is declared, a `module` is `include`d explicitly by any class. Since a class can `include` several modules, this provides with an alternative to class inheritance when multiple inheritance is needed. This somewhat remembers JavaScript object mixin. 

Think of modules as a syntax to declare the "composition" part in "composition vs inheritance" discussions (TODO link). -->

Similarly to what we've shown in [Scope Gates](#scope-gates), the following snippet illustrates the basics of Ruby modules and also how `self` is changed in `module` declarations:

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




## message & method

This section focus on Ruby ways of writing code that sends messages to an object. Later, in TODO, the method declaration that handles the message is detailed. 

Like in other programming languages, the concept of sending a message to an object (or in other words invoking an object's method), is done using the dot operator `.`, like in `tv.change_channel('espn')`. 

### simple example

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
 * Closures procs evaluate with a new scope, this is, the scope when the proc is defined. if we pass a block to an instance method, the proc will evaluate with its original scope and not with the instance scope.
   * 
 * proc vs lambda vs etc and which allows to change scope.

# TODO

```
### the instance scope
### the class scope
### the singleton scope


TODO: model object - 

 * obj.class, Class.superclass
 * classes are objects and unlike other OOP languages, class objects can be manipulated. 
 * methods are inside the class, variables are inside objects. 

TODO: modules class.superclass==Module - classes are modules with three additional instance method (new, allocate and superclass) that allows the creation of objects or arrange classes into hierarchies
```
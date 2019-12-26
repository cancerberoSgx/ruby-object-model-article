# The Ruby Object Model

## About this document

When it comes to modeling a problem using an object oriented fashion, each language has its own peculiarities when it comes to defining new objects, declaring classes, object instantiation, code scope, etc. 

This document tries to give a detailed description of how these things works in Ruby putting particular emphasis on on those things that are peculiar in Ruby when compared to other OOP languages.

It assumes the reader has some background of object oriented programming such as the concept of objects, classes, messages/methods, class hierarchy.

## scope and context object

Although the concept of scope might seem not directly related with objects and classes, it plays an important role in Ruby and that's why this document starts describing it.

Similar to other scripting languages understanding the rules for the scope on which the code is evaluated is critical. And also like other languages, there's a particular object in the scope that represents *"the thing we are talking about now"*, more formally often called the *context object*. 

Most languages represent this object with a keyword, in Ruby the keyword `self` is used, while in other programming languages one can access the context object using `this` keyword.

Depending on which part of the code you are, `self` represents different things. It's always present and, in Ruby, it cannot be re-assigned. 

### self: the default namespace

The primordial operation objects must perform is to send messages. The context object, this is `self`, acts as the default object when the message receiver is not specified. For example, the following two statements are equivalent:

```rb
a = self.to_s
b = to_s
```

As you can see in the second line, we send a message `to_s` without providing the target object, so the message will be actually be dispatched to `self`, the context object.

### scope and declarations

Besides being the default object for messages, in Ruby, the context object plays an important role while declaring classes.

In ruby, there is no real distinction between code that defines a class and code of any other kind. In a sense, the `class` keyword is more like a scope operator than a class declaration. Yes, it creates classes that don't yet exist, but this could be considered just as a nice side effect: the core job of `class` is to *move you to the scope of a class* so you can declare methods. 

In ruby, classes are declared by basically changing the scope (`self`) by using `class`, `module` and `def` expressions. 

Inside a method declaration, `self` references *the instance*, similar to the `this` keyword in other programming languages. 

Inside a class declaration and outside a method, `self` references *the class*.

The following code tries to illustrate how the scope changes through different parts of the code. Notice how `class` and `def` are used to change the context object (`self`) where the code runs:

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




### global context


## class and module


  runs scope on the code rubs which methods run or are declared, is very important and in the scope there is a  and represented with a keyword, `self` in the case of Ruby.

Any code that is evaluated, it is so, in association with a context object. This object is the default object for messages without a receiver


### the instance scope


### the singleton scope


## messages

Like in other programming languages, the concept of sending a message to an object (or in other words invoking an object's method), is done using the dot operator `.`. User optionally passes a list of arguments and given object method is invoked using the object as `self` in the method's body. The expression evaluates in whatever the method returns: 

```rb
car = Car.new
degrees = car.turn(:left)
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

## Operators

 * relationship between operators and methods 
 * operators are methods
 * can be overridde - even Number ? 

## Blocks

A block is a special kind of object that contains executable code. In fact, all Ruby code is evaluated in the context of a block. Many other blocks can be declared and since they are just objects they can be used like any object. Particularly, as seen they can be passed in the payload of a message.
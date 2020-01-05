## The basics

Let's start by explaining how to define a class and create new object instances in Ruby. In following sections we will be explaining exactly what's happening and how it works in detail, right now the objective is just making sure we know how to do it. 

The following code defines a *class* named `Orc`, with a *method* `eat`. *When* `eat` method is called an *instance variable* `@energy` is created by assigning it to a value. After the class definition, we then create an `Orc` *instance* and store it in *local variable* `fred`:

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

Note that in the previous code, the expression `Orc.new` is calling a method on the object `Orc` which is an instance of `Class`. That method `new` is therefore an instance method of `Class`, that's how the object `Orc` is able to understand the `:new` message. 

This will be described with more detail later, right now, the important thing to understand it that everything is an object which are always associated with a class. And that classes also are objects, instances of `Class`.

### Instance variables

Unlike in Java or other static languages, in Ruby there is no connection between an object's class and its instance variables. Instance variables just spring into existence when you assign them a value. In the previous example, the instance variable `@energy` is assigned only when the method `eat` is called. If it's not then the instance variable is never defined. In conclusion we could have Orcs with and without `@energy` instance variable. 

You can think of the names and values of instance variables as keys and values in a hash. Both the keys and the values can be different for each object.

### Methods

Besides instance variables objects also have methods. But unlike instance variables, objects that share the same class also share the same methods, so **methods are stored in the object's class and not in the object itself** as instance variables.

So, when we say "the method `eat` of object `fred`" we will be actually referring, generally, to the *instance method* `eat` of `fred`'s class, in our case `Orc`. 

Strictly speaking, when talking about classes and methods, it would be incorrect to say "the method `eat` of `Orc`". `Orc`, viewed as an object, won't understand the message `Orc.eat`. Instead we should say "the *instance method* `eat` of `Orc`". It would be correct to also say "the method `new` of `Orc`" though, since `Orc.new` makes sense.

### Object, class, method, instance variable relationship

The following image tries to illustrate the relationship between objects, classes, instance variables and methods using the previous "orcs" example code. 

![Figure instance variables, methods, classes and object relationship](diagrams/instance_variables_methods_classes_objects.png)


<!-- 

Reflection helpers

Now that you know about instance methods, this little section explains how to use two utility methods supported in ruby to inspect our object and classes methods. 

In Ruby any object supports the message `:methods` which will return the array of method names that the receiver object understand. Also, `Class` instances supports the message `:instance_methods` which will return the array of instance method names (passing false will ignore inherited instance methods). The following example try to describe these meta-programming helpers:

```

``` -->
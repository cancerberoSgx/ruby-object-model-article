
<i id="the-singleton-scope"></i>

## The singleton scope

Remember how we [said before](#methods) that an object's methods are actually part of the object's class and not the object itself? The implication is that objects of the same class share their methods. 

Sometimes though, is useful to support custom object's behavior independently of a particular class, this is, given an object patch the object itself with custom behavior, without impacting the object's class. 

This makes 

Although this is often not supported by static languages like Java or C++, other scripting languages like JavaScript supports this very straightforward:

<!-- belong to an object class not to the object itself, then all instances of a class are not part of instances but part of the instance's class. -->

<!-- This section describe how Ruby's solves this problemsingleton methods and singleton classes a Ruby way of defining per-object custom behavior. -->


<!-- Until now, objects of the same class have the same methods since methods are defined at the class level.  -->
<!-- If you came from other scripting languages, such as JavaScript, then you know it's possible to define new methods to a single object without affecting its class as simply as: -->

```js
var obj = new MyClass
obj.method1 = function() { 
  return 'hello' 
}
```

Can we accomplish this in Ruby? The answer to this question will give us the chance to learn Ruby language core features: *singleton methods* and *singleton classes*.

<i id="singleton-methods"></i>

### Singleton methods

The Ruby code equivalent to previous JavaScript snippet could be something like:

```rb
obj = MyClass.new
def obj.method1
  'hello'
end
```

As you can see we've defined a new method `method1` but just for the instance `obj`. The rest of `MyClass` instances won't have it.

Notice how we use the scope gate `def` to define method `obj.method1` without using the `class` operator. 
<!-- We already made something similar when we used `def self.my_method` to define class methods, but this time we use `obj` instead of `self` - both `self` and `obj` are objects and we can use the same synyax without scope gate `class` to define  -->

The same as before but using `define_singleton_method` so we don't need to use `class` scope gate:

```rb
obj = MyClass.new
obj.define_singleton_method(:method1) { 'hello' }
```

An interesting fact is that, **class methods are actually singleton methods of the class**. For example in `MyClass.my_class_method()`, `my_class_method` is actually a singleton method of `MyClass`.

<i id="singleton-classes"></i>

### Singleton classes

So, where do these *singleton methods* live ? As we [said](#methods), methods are not part of instances but part of the instance's class. On the other side, singleton methods couldn't be part of the object class since if so, all instances of the class would support them. So, where are singleton methods stored in the Ruby Object Model ? 

In Ruby, objects are associated not only with a class but also with what we call *the object's singleton class*

<!-- When you ask an object for its class, Ruby, doesn't always tell you the whole truth. Instead of the class that you see, an object can have its own special hidden class. That's called the *singleton class* of the object. (Also called the *metaclass* or the *eigenclass*). -->
So while we use `obj.class` to access an object "normal" class, we use `obj.singleton_class` to access an object singleton class. 

#### `class << obj` - the singleton class scope gate

Ruby also supports another syntax besides `singleton_class` to access an object's singleton class which is based on the `class` keyword:

<!-- (BTW, before Ruby TODO.TODO this was the only way to access an object singleton class):  -->

```rb
obj = MyClass.new
class << obj
  def method1
    'hello'
  end
end
```

Remember how we said `class` is a scope gate ? Well in this case the expression `class << obj` opens the scope to `obj`'s singleton class the same way `class C` opens the scope to a "normal" `C` class. Methods and instance variables defined inside will belong to `obj`'s singleton class. 

<!-- TODO: singleton class notation (obj - MyClass, #obj) - #obj represents the singleton class of object `obj` -->

TODO: `obj.singleton_class` extends `obj.class`

TODO: golden object model rules - pg 125


### Method lookup and singleton classes

Previously, in [Method lookup](#method-lookup), we explained how the Ruby interpreter finds a method. Well, that was without considering singleton classes. Now that we know they exists, the missing part is the role of singleton methods in this scenario. 

Heads up: We represent the singleton class of an object `obj` with `#obj`.

```rb
class MyClass
  def method1; end
end
obj = MyClass.new
def obj.method2; end
```

![Method lookup and singleton classes](diagrams/method-lookup-singleton-class.png)


### Inheritance and singleton classes

As we said previously we represent the singleton class of an object named `obj` with `#obj`. Also, since classes are also objects, we represent the singleton class of a class named `MyClass` with `#MyClass`. As said before, class methods are methods of the class's singleton class, so class methods of `MyClass` are actually singleton methods of `#MyClass`. 

The following diagram shows the relationship between `class`, `singleton_class` and `superclass`.

![Singleton classes and superclass](diagrams/singleton_class-superclass.jpg)


### The 7 Rules of the Ruby Object Model

In this mix of classes, singleton classes, instance methods, class methods and singleton methods, a Ruby developer could have a hard time answering questions like: "Which method in this complicated hierarchy gets called first?" or "Can I call this method from that object?". The following seven rules describe the relationwhip between classes, singleton classes, instance methods, class methods and singleton methods and also gives a recipe on how method lookup works, now considering singleton classes and singleton methods:

 1. There is only one kind of object - be it a regular object or a module.
 2. There is only one kind of module - be it a regular module, a class or a singleton class. 
 3. There is only one kind of method, and it lives in a module - most often in a class.
 4. Every object, class included, has its own "real class", be it a regular class or a singleton class. 
 5. Every class, with the exception of `basicObject`, has exactly one ancestor - either a superclass or a module. This means you have a single chain of ancestors from any class up to `BasicObject`.
 6. The superclass of a singleton class of an object is the object's class. The superclass of the singleton class of a class is the singleton class of the class's superclass. (Yes, it sounds like a tongue twister, we tried to describe this in [Inheritance and singleton classes](#inheritance-and-singleton-classes)).
 7. When you call a method, Ruby goes "right" in the receiver's real class and then "up" the ancestors chain. That's all there's to know about the way Ruby finds methods. 

<div class="page-break"></div>






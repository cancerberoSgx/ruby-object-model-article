

<i id="scope"></i>

## Scope

Although the concept of *scope* might seem not directly related with objects and classes, it plays a critical role while dealing with them in Ruby. 

Similar to other scripting languages like JavaScript, understanding the rules for the scope on which the code runs is basic to write object oriented code in Ruby. 

What do we exactly refer to when we say "scope" ? At *any* part of Ruby code, we say that at that moment, the **scope is all the names we can reference** from there, like local variables, instance and class variables, methods, constants, classes, modules, etc.




<i id="self-the-current-object"></i>

### self: the current object

There's a particular object in the scope that represents "*the thing we are talking about now*", in Ruby more formally often called the **current object**. Most languages represent this object with a keyword, in Ruby the keyword `self` is used, while in other programming languages the `this` keyword is often used.

Depending on which part of the code you are, `self` represents different things. It's always present and, in Ruby, it cannot be re-assigned. 

The primordial operation objects must support is to receive messages. The *current object*, this is `self`, acts as the default object when the message receiver is not specified. For example, the following two statements are equivalent:

```rb
a = self.to_s
b = to_s
```

As you can see in the second line, we send a message `to_s` without providing the target object, so the message will be actually be dispatched by `self`, the current object.




<i id="scope-gates-class-module-and-def"></i>
<i id="scope-gates"></i>

### Scope Gates `class`, `module` and `def`

<!-- Besides being the current object for messages, `self` plays an important role while declaring classes.  -->

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




<i id="flat-scope"></i>

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



<div class="page-break"></div>



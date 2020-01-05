

## Classes

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

### Inheritance

In Ruby, the operator `<` is used to extend a class, in other words, to define a subclass. The following snippet which makes our `Orc` extend a base class `Unit`:

```rb
class Unit
  def die
    @energy = 0
  end
end
class Orc < Unit
  def eat
    @energy = 100
  end
end
fred = Orc.new
```

### Method override and `super`

From the previous example, we will override `Unit#die` to customize `Orc`'s behaviors. Notice how we call `super` to execute the original `Unit#die`: 

```rb
class Unit
  def die
    @energy = 0
  end
end
class Orc < Unit
  def die
    super
    p 'Ouch!'
  end
end
```


### Class methods and class variables

The following example shows how to declare class level variables using `@@` and declare class level methods using `def self.`. 

```rb
class Node
  @@default_style = {bg: 'blue', fg: 'white'}
  def render(style = @@default_style)
    p style
  end
  def self.load_from_file(file)
    Node.new # TODO
  end
end
Node.new.render
Node.load_from_file('widget1.json').render
```


### The Ruby class hierarchy

<!-- TODO: diagram of ruby class hierarch (baseObject, object, Class, Module, Kernel) -->

The following diagram shows main classes of standard Ruby class hierarchy and a example method implemented by each.

![Figure Ruby class hierarchy](diagrams/ruby-class-hierarchy.png)

Some interesting considerations:

 * Although by default, new classes extends from `Object` the root class in the hierarchy is not `Object` but `BaseObject`.
 * `Class` extends `Module` so all classes are also modules.


### Superclass

Similarly than any `Object` instance knows its `class`, also any `Class` instance knows its `superclass`. When defining a new class, if no superclass is specified, new classes extend `Object`.

Let's consider a small example code and represent the `class` and `superclass` relationships between instances and the standard Ruby classes in a diagram: 

```rb
class MyClass
end
obj1 = MyClass.new
p obj1.class # => MyClass
p MyClass.class.superclass # => Module
p MyClass.class.superclass.superclass # => Object
```

![Figure superclass](diagrams/ruby-class-hierarchy-superclass.png)


### Constants

TODO: pg 21

TODO: filesystem-like analogy vs variables (in other languages constants are just like variables but will throw if re-assigned)
TODO: class names are constants




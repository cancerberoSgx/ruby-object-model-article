
## Declarations

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

### Modules

<!-- TODO: Class is a Module  Class < Module < BaseObject. TODO: snippet -->


<!-- modules can be explicitly `include`d in other classes to augment their instance methods, and instance variables. On this regard, one can think of modules as an alternative to inheritance that supports multiple inheritance or in other words, as a syntax to declare the "composition" part in "composition vs inheritance" discussions (TODO link).  -->


<!-- module declaration -->

<!-- The keyword `module` can be used to change the scope to a `class` with the only difference that instead of common class inheritance where the parent class is declared, a `module` is `include`d explicitly by any class. Since a class can `include` several modules, this provides with an alternative to class inheritance when multiple inheritance is needed. This somewhat remembers JavaScript object mixin. 
 -->

Formally, the keyword `module`, similarly as `class` is a scope gate that can be used to declare instance methods and variables that can be `include`d by classes or other modules. 

An important fact to understand, as shown [before](#the-ruby-class-hierarchy) is that **`class` is a `module`, or in other words, `Class` extends `Module`**.
<!-- by the following is that **classes are modules** -->

Similarly to what we've shown in [Scope Gates](#scope-gates), the following snippet illustrates the basics of Ruby modules and how `self` changes in `module` declarations:

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

<!-- TODO: how to declare instance variables or class method from module ?  -->

### Refinements

In [Open Class](open-class) we shown how existing classes can be modified by just opening `class` several times. An important consequence is that any of this modifications will impact the rest of the code "globally" which could cause unexpected behaviors other part of the code that rely on a modified behavior. 

To solve this problem, Ruby supports `refine` which basically allows to open classes but only for local code, without affecting outer code at all:

```rb
module StringUtil
  refine String do
    def reverse
      "REVERSED"
    end
  end
end
module IsolatedCode
  using StringUtil
  p 'hello'.reverse  # "REVERSED"
end
p 'hello'.reverse    # "olleh"
```

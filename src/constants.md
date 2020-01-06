

## Appendix: Constants

In Ruby, any reference that **starts with an uppercase letter**, including name of classes and modules, is a *constant*. Ruby constants are very peculiar when compared to other programming language's constants. 

First of all, unlike other programming languages, Ruby constants can be changed and reassigned. For example, try to re-assign constant `String` to break Ruby beyond repair. 

Second, class names and module names are constants. In the following example both `MyClass` and `my_class` references to the same instance of `Class` with the only difference being that `MyClass` is a constant and `my_class` a local variable:

```rb
class MyClass
end
my_class = MyClass
```

So, if we can change the value of a constant, how are they different from a variable? The only important difference has to do with their scope. 

All the constants in a program are arranged in a tree similar to a file system where modules (and classes) are *directories* and regular constants are *files*. Like in a file system, we can have multiple files with the same name as long as they live in different directories. We can even refer to constants by their *path*, as we would do with a file. 

### Constants paths

In the following example we have some modules and classes which defines constants and reference inner and outer constants by their paths. Notice that constants' paths use a double colon as a separator (similar to C++ scope operator). Also, we can reference a constant by its *absolute path* by prefixing the constant path with `::` : 

```rb
X = 'constant 1'
module M
  X = 'constant 2'
  class C
    X = 'constant 3'
    p ::X         # => constant 1
    p ::M::C::X   # => constant 3
  end
end
p X               # => constant 1
p M::X            # => constant 2
p M::C::X         # => constant 3
```

### Module#constants, Module.constants and Module.nesting

Ruby's `Module` class aso provides the instance method `Module#constants` which returns all constants in the current scope, analogous to the `ls` UNIX command. 

Also, the class method `Module.constants` will return all the top-level constants in the current program, including class names. 

Finally, we can use the class method `Module.nesting` to get the *current path*:

```rb
module M
  class C
    module M2
      p Module.nesting   # => [M::C::M2, M::C, M]
      p Module.constants # => [:M2, :C, a lot more...
    end
  end
end
```


<div class="page-break"></div>


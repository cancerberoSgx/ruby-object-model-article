

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
# The Ruby Object Model

Author: Sebastián Gurin - [WyeWorks](wyeworks.com)   

## Contents

<!-- toc -->

- [About this document](#about-this-document)
- [The basics](#the-basics)
  * [Objects and classes](#objects-and-classes)
  * [Instance variables](#instance-variables)
  * [Methods](#methods)
  * [Object, class, method, instance variable relationship](#object-class-method-instance-variable-relationship)
  * [inheritance](#inheritance)
  * [method override with `super`](#method-override-with-super)
  * [class methods and class variables](#class-methods-and-class-variables)
  * [The Ruby class hierarchy](#the-ruby-class-hierarchy)
  * [superclass](#superclass)
  * [Constants](#constants)
- [Scope](#scope)
  * [self: the current object](#self-the-current-object)
  * [Scope Gates `class`, `module` and `def`](#scope-gates-class-module-and-def)
  * [Flat Scope](#flat-scope)
- [Declarations](#declarations)
  * [Open class](#open-class)
  * [Modules](#modules)
  * [Refinements](#refinements)
- [Messages & methods](#messages--methods)
  * [Simple example](#simple-example)
  * [Message syntax](#message-syntax)
  * [Method syntax](#method-syntax)
  * [Method lookup](#method-lookup)
  * [message block](#message-block)
    + [yield_self, a.k.a then](#yield_self-aka-then)
- [More on class members and messages](#more-on-class-members-and-messages)
  * [Method visibility and private](#method-visibility-and-private)
  * [accessors](#accessors)
  * [class macros](#class-macros)
  * [accessor methods](#accessor-methods)
  * [Operator overloading](#operator-overloading)
- [The singleton scope](#the-singleton-scope)
  * [Singleton methods](#singleton-methods)
  * [Singleton classes](#singleton-classes)
    + [`class << obj` - the singleton class scope gate](#class--obj---the-singleton-class-scope-gate)
  * [Method lookup revisited](#method-lookup-revisited)

<!-- tocstop -->

## About this document

When it comes to modeling a problem using an object oriented fashion, each language has its own peculiarities when it comes to, declaring objects and classes, code scope, object instantiation, inheritance, method lookup, etc. 

When we talk about *object model* we are referring basically to these aspects:

 * how to create an object
 * how to send a message to an object
 * how to declare object methods and properties 
 * how to declare object classes, instance methods, instance variables, etc
 * how to declare class inheritance and access the class hierarchy (call super)
 * understand object properties and class members are stored internally
 * how messages are dispatched how method lookup works

This document tries to give a detailed description of how these things works and can be written in Ruby.

 <!-- Particular emphasis is made on Ruby peculiarities compared to other programming languages such as scope, class expressions, .  -->

So, more than an Object Oriented Programming manual for Ruby, this document should be considered as descriptions on how objects work, understanding class declarations and Ruby peculiarities when dealing with objects and classes.

It assumes the reader has some background on object oriented programming such as the concepts of object, class, message, method and inheritance. Basic Ruby background is recommended although not needed since the code snippets are simple and commented.

Aside, this is a millennial-friendly document: short paragraphs and code snippets right away!


# The Ruby Object Model

Sebastián Gurin - [WyeWorks](wyeworks.com)   

## Contents

<!-- toc -->

<!-- tocstop -->

<div class="page-break"></div>

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

So, more than an Object Oriented Programming manual for Ruby, this document should be considered as descriptions on how objects work, understanding class declarations and Ruby peculiarities when dealing with objects, clkasses and methods.

It assumes the reader has some background on object oriented programming such as the concepts of object, class, message, method and inheritance. Basic Ruby background is recommended although not needed since the code snippets are simple and commented.

Aside, this is a millennial-friendly document: short paragraphs and code snippets right away!

<div class="page-break"></div>


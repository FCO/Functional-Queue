[![Actions Status](https://github.com/FCO/Functional-Queue/actions/workflows/test.yml/badge.svg)](https://github.com/FCO/Functional-Queue/actions)

NAME
====

Functional::Queue - Functional queue

SYNOPSIS
========

```raku
my $q1 = Functional::Queue.new;
my :($q2, $) := $q1.enqueue: 1;

my :($q3, $v3) := $q2.dequeue;
say $v3;

Functional::Queue.mutate: {
   for ^10 -> $v { .enqueue: $v }
   say .dequeue while .elems;
}
```

DESCRIPTION
===========

Functional::Queue is a implementation of a functional data structure queue. It's immutable and thread-safe.

It has a `mutate` method that topicalise the object and will always topicalise the new generated stack. And that's gives the impression of mutating and makes it easier to interact with those objects.

AUTHOR
======

Fernando Corrêa de Oliveira <fernando.correa@humanstate.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2024 Fernando Corrêa de Oliveira

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.


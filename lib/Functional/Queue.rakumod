use ValueClass;
use Functional::Stack;
unit value-class Functional::Queue;

my $both-default = True;

has Functional::Stack $.head;
has Functional::Stack $.tail;
has Bool              $.both = $both-default;

submethod TWEAK(|) {
  die "It shouldn't be possible to a queue have a head without a tail" if $!head.elems && !$!tail.elems;
}

multi method mutate(&block) {
  my $*QUEUE = self;
  block $*QUEUE;
  $*QUEUE
}

method !mutable($node, $value, Bool :$both = self.defined ?? $!both !! $both-default, :$internal = False) {
  return $node, $value if $internal;
  do if $*QUEUE !~~ Failure {
    $*QUEUE = $($node);
    $value
  } else {
    return $node, $value if $both;
    $node
  }
}

multi method elems(::?CLASS:U:) { 0 }
multi method elems(::?CLASS:D:) { $!head.elems + $!tail.elems }

multi method enqueue(::?CLASS:U: \value) {
  my ($tail, $) := Functional::Stack.push: value;
  self!mutable: $.new(:$tail), value
}

multi method enqueue(::?CLASS:D: \value) {
  return self.WHAT.enqueue: value unless $!tail;
  my ($head, $) := $!head.push: value;
  self!mutable: $.new(:$head, :$!tail), value
}

method dequeue {
  return $.mutable: self, Any without self;

  my $head = $!head;
  my :($t, \value) := $!tail.pop;
  my $tail = $t;
  unless $tail.elems {
    while $head.elems {
      my :($h, \v) := $head.pop;
      my :($t, $) := $tail.push: v;
      $head := $h;
      $tail := $t;
    }
  }
  self!mutable: $.new(:$head, :$tail), value
}

# method WHICH { ValueObjAt.new: join "|", $.^name, |($!head.WHERE, $!tail.WHERE with self) }

=begin pod

=head1 NAME

Functional::Queue - Functional queue

=head1 SYNOPSIS

=begin code :lang<raku>

my $q1 = Functional::Queue.new;
my :($q2, $) := $q1.enqueue: 1;

my :($q3, $v3) := $q2.dequeue;
say $v3;

Functional::Queue.mutate: {
   for ^10 -> $v { .enqueue: $v }
   say .dequeue while .elems;
}

=end code

=head1 DESCRIPTION

Functional::Queue is a implementation of a functional data structure
queue. It's immutable and thread-safe.

It has a C<mutate> method that topicalise the object and will always topicalise
the new generated stack. And that's gives the impression of mutating and makes
it easier to interact with those objects.

=head1 AUTHOR

Fernando Corrêa de Oliveira <fernando.correa@humanstate.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2024 Fernando Corrêa de Oliveira

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

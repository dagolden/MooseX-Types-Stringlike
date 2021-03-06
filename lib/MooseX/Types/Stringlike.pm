use 5.008001;
use strict;
use warnings;

package MooseX::Types::Stringlike;
# ABSTRACT: Moose type constraints for strings or string-like objects
# VERSION

use MooseX::Types -declare => [ qw/Stringable Stringlike ArrayRefOfStringable ArrayRefOfStringlike / ];
use MooseX::Types::Moose qw/Str Object ArrayRef/;
use overload ();

# Thanks ilmari for suggesting something like this
subtype Stringable,
  as Object,
  where { overload::Method($_, '""') };

subtype Stringlike,
  as Str;

coerce Stringlike,
  from Stringable,
  via { "$_" };


subtype ArrayRefOfStringable,
  as ArrayRef[Stringable];

subtype ArrayRefOfStringlike,
  as ArrayRef[Stringlike];

coerce ArrayRefOfStringlike,
  from ArrayRefOfStringable,
  via { [ map { "$_" } @$_ ] };

1;

=for Pod::Coverage method_names_here

=head1 SYNOPSIS

  package Foo;
  use Moose;
  use MooseX::Types::Stringlike qw/Stringlike Stringable ArrayRefOfStringlike ArrayRefOfStringable/;

  has path => (
    is => 'ro',
    isa => Stringlike,
    coerce => 1
  );

  has stringable_object => (
    is => 'ro',
    isa => Stringable,
  );

  has paths => (
    is => 'ro',
    isa => ArrayRefOfStringlike,
    coerce => 1
  );

  has stringable_objects => (
    is => 'ro',
    isa => ArrayRefOfStringable,
  );

=head1 DESCRIPTION

This module provides a more general version of the C<Str> type.  If coercions
are enabled, it will accepts objects that overload stringification and coerces
them into strings.

=head1 SUBTYPES

This module uses L<MooseX::Types> to define the following subtypes.

=head2 Stringlike

C<Stringlike> is a subtype of C<Str>.  It can coerce C<Stringable> objects into
a string.

=head2 Stringable

C<Stringable> is a subtype of C<Object> where the object has overloaded stringification.

=head2 ArrayRefOfStringlike

C<ArrayRefStringlike> is a subtype of C<ArrayRef[Str]>.  It can coerce C<ArrayRefOfStringable> objects into
an arrayref of strings.

=head2 ArrayRefOfStringable

C<ArrayRefOfStringable> is a subtype of C<ArrayRef[Object]> where the objects have overloaded stringification.

=head1 SEE ALSO

=for :list
* L<Moose::Manual::Types>
* L<MooseX::Types>
* L<MooseX::Types::Moose>

=head1 ACKNOWLEDGMENTS

Thank you to Dagfinn Ilmari Mannsåker for the idea on IRC that led to this module.

=cut

# vim: ts=2 sts=2 sw=2 et:

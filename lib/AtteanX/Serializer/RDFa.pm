use 5.010001;
use strict;
use warnings;

package AtteanX::Serializer::RDFa;

our $AUTHORITY = 'cpan:KJETILK';
our $VERSION   = '0.001';

use Moo;
use Types::Standard qw(Str Maybe HashRef ConsumerOf);
use Encode qw(encode);
use Scalar::Util qw(blessed);
use Attean;
use Attean::ListIterator;
use namespace::clean;
use Attean::RDF qw(iri);
use RDF::RDFa::Generator;


has 'canonical_media_type' => (is => 'ro', isa => Str, init_arg => undef, default => 'application/xhtml+xml');

with 'Attean::API::TripleSerializer';
with 'Attean::API::AbbreviatingSerializer';

has 'style' => (is => 'ro', isa => Maybe[Str]); # TODO: might be improved with OptList?

has 'generator_options' => (is => 'ro', isa => HashRef, default => sub { return {} });

has _opts => (is => 'rw', isa => HashRef, lazy => 1, builder => '_build_opts');

sub _build_opts {
  my $self = shift;
  my $base = defined($self->base) ? $self->base->abs : undef;
  my %opts = (
				  style => $self->style,
				  namespacemap => $self->namespaces,
				  base => $base
				 );
  return \%opts;
}


sub media_types {
  return [qw(application/xhtml+xml text/html)];
}

sub _make_document {
  my ($self, $iter) = @_;
  my $store = Attean->get_store('Memory')->new();
  $store->add_iter($iter->as_quads(iri('http://graph.invalid/')));
  my $model = Attean::QuadModel->new( store => $store );
  return RDF::RDFa::Generator->new(%{$self->_opts})->create_document($model, %{$self->generator_options});
}

sub serialize_iter_to_io {
  my ($self, $io, $iter) = @_;
  my $document = $self->_make_document($iter);
  return $document->toFH($io);

}

sub serialize_iter_to_bytes {
  my ($self, $iter) = @_;
  my $document = $self->_make_document($iter);
  return $document->toString;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

AtteanX::Serializer::RDFa - RDFa Serializer for Attean

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 BUGS

Please report any bugs to
L<https://github.com/kjetilk/p5-atteanx-serializer-rdfa/issues>.

=head1 SEE ALSO

=head1 AUTHOR

Kjetil Kjernsmo E<lt>kjetilk@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2017, 2018 by Kjetil Kjernsmo.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.


=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.


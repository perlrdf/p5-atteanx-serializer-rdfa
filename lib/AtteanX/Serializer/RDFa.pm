use 5.010001;
use strict;
use warnings;

package AtteanX::Serializer::RDFa;

our $AUTHORITY = 'cpan:KJETILK';
our $VERSION   = '0.001';

use Moo;
use Types::Standard qw(Str ArrayRef HashRef);
use Encode qw(encode);
use Scalar::Util qw(blessed);
use Attean;
use Attean::ListIterator;
use namespace::clean;
use Attean::RDF qw(iri);
 
has 'canonical_media_type' => (is => 'ro', isa => Str, init_arg => undef, default => 'application/xhtml+xml');

sub media_types {
  return [qw(application/xhtml+xml text/html)];
}

sub serialize_iter_to_io {
  my ($self, $io, $iter) = @_;

}

sub serialize_iter_to_bytes {
  my ($self, $iter) = @_;
  my $store = Attean->get_store('Memory')->new();
  $store->add_iter($iter->as_quads(iri('http://graph.invalid/')));
  my $model = Attean::QuadModel->new( store => $store );
  my %opts = (namespacemap => $self->namespaces,
				  base => $self->base);
  my $document = RDF::RDFa::Generator->new(%opts)->create_document($model);
  return $document->toString;
}

with 'Attean::API::TripleSerializer';
with 'Attean::API::AbbreviatingSerializer';

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


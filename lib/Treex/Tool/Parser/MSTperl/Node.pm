package Treex::Tool::Parser::MSTperl::Node;
BEGIN {
  $Treex::Tool::Parser::MSTperl::Node::VERSION = '0.07298';
}

use Moose;

has config => (
    isa      => 'Treex::Tool::Parser::MSTperl::Config',
    is       => 'ro',
    required => '1',
);

has fields => (
    isa      => 'ArrayRef[Str]',
    is       => 'rw',
    required => '1',
);

has ord => (
    isa => 'Int',
    is  => 'rw',
);

has parent => (
    isa => 'Maybe[Treex::Tool::Parser::MSTperl::Node]',
    is  => 'rw',
);

has parentOrd => (
    isa     => 'Int',
    is      => 'rw',
    default => 0,
);

has children => (
    isa     => 'ArrayRef[Treex::Tool::Parser::MSTperl::Edge]',
    is      => 'rw',
    default => sub { [] },
);

has label => (
    isa     => 'Str',
    is      => 'rw',
    default => '_',
);

sub BUILD {
    my ($self) = @_;

    # handle parentOrd

    my $parentOrdIndex = $self->config->parent_ord_field_index;
    my $parentOrd      = $self->fields->[$parentOrdIndex];

    # if parent is set (i.e. not filled with dummy value)
    if ( $parentOrd != -2 ) {

        # set the parentOrd field
        $self->parentOrd($parentOrd);

        # fill with dummy value as this must not not used
        # (use node->parentOrd instead)
        $self->fields->[$parentOrdIndex] = -2;
    }

    # handle label

    my $labelIndex = $self->config->label_field_index;

    # if label is used
    if ( defined $labelIndex ) {
        my $label = $self->fields->[$labelIndex];

        # if label is set (i.e. not filled with dummy value)
        if ( $label ne '_' ) {

            # set the label field
            $self->label($label);

            # fill with dummy value as this must not not used
            # (use node->label instead)
            $self->fields->[$labelIndex] = '_';
        }
    }

    #     my $debug = join ',', @{$self->fields};
    #     warn "$debug\n";

    return;
}

sub copy_nonparsed {
    my ($self) = @_;

    my $copy = Treex::Tool::Parser::MSTperl::Node->new(
        fields => $self->fields,
        config => $self->config,
    );

    return $copy;
}

sub copy_nonlabelled {
    my ($self) = @_;

    my $copy = Treex::Tool::Parser::MSTperl::Node->new(
        fields    => $self->fields,
        config    => $self->config,
        parentOrd => $self->parentOrd,
    );

    return $copy;
}

1;

__END__

=pod

=for Pod::Coverage BUILD

=encoding utf-8

=head1 NAME

Treex::Tool::Parser::MSTperl::Node

=head1 VERSION

version 0.07298

=head1 DESCRIPTION

Represents a word in a sentence.
Contains its node features, such as form, lemma or pos tag.
It may also point to its parent node.

=head1 FIELDS

=head2 Required or automatically filled fields

=over 4

=item fields

Fields read from input and directly stored here,
such as word form, morphological lemma, morphological tag etc.
See L<Treex::Tool::Parser::MSTperl::Config> for details.

=item ord

1-based position of the word in the sentence.
The ord is set automatically when a sentence containing the node is created
(see L<Treex::Tool::Parser::MSTperl::Sentence>).

=back

=head2 Parse tree related fields

These fields are filled in only if the sentence containing the node has been
parsed.

=over 4

=item parent

Reference to the node's parent in the dependency tree. Default value is C<0>,
which means that the node is a child of the root node.

=item parentOrd

Semantically this is an alias of C<parent->ord>, although technically the value
is copied here, as it is used more often than the C<parent> field itself.

=back

=head1 METHODS

=over 4

=item my $node = my $node = Treex::Tool::Parser::MSTperl::Node->new(
    fields => [@fields],
    featuresControl => $featuresControl,
);

Creates a new node with the given field values (C<fields>)
and using the given L<Treex::Tool::Parser::MSTperl::Config> instance
(C<featuresControl>).

=item my $node_copy = $node->copy_nonparsed()

Copies the node without the parse information
(i.e. without the info about its parent).

=back

=head1 AUTHORS

Rudolf Rosa <rosa@ufal.mff.cuni.cz>

=head1 COPYRIGHT AND LICENSE

Copyright © 2011 by Institute of Formal and Applied Linguistics, Charles
University in Prague

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
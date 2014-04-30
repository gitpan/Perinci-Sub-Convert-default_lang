package Perinci::Sub::Convert::default_lang;

use 5.010001;
use strict;
use warnings;

use Exporter qw(import);
our @EXPORT_OK = qw(convert_property_default_lang);

our $VERSION = '0.01'; # VERSION
our $DATE = '2014-04-30'; # DATE

our %SPEC;

$SPEC{convert_property_default_lang} = {
    v => 1.1,
    summary => 'Convert default_lang property in Rinci function metadata',
    args => {
        meta => {
            schema  => 'hash*', # XXX defhash
            req     => 1,
            pos     => 0,
        },
        new => {
            summary => 'New value',
            schema  => ['str*'],
            req     => 1,
            pos     => 1,
        },
    },
    result_naked => 1,
};
sub convert_property_default_lang {
    my %args = @_;

    my $meta = $args{meta} or die "Please specify meta";
    my $new  = $args{new} or die "Please specify new";

    # collect defhashes
    my @dh = ($meta);
    push @dh, @{ $meta->{links} } if $meta->{links};
    push @dh, @{ $meta->{examples} } if $meta->{examples};
    push @dh, $meta->{result} if $meta->{result};
    push @dh, values %{ $meta->{args} } if $meta->{args};
    push @dh, grep {ref($_) eq 'HASH'} @{ $meta->{tags} };

    my $i = 0;
    for my $dh (@dh) {
        $i++;
        my $old = $dh->{default_lang} // "en_US";
        return if $old eq $new && $i == 1;
        $dh->{default_lang} = $new;
        for my $prop (qw/summary description/) {
            my $propold = "$prop.alt.lang.$old";
            my $propnew = "$prop.alt.lang.$new";
            next unless defined($dh->{$prop}) ||
                defined($dh->{$propold}) || defined($dh->{$propnew});
            if (defined $dh->{$prop}) {
                $dh->{$propold} //= $dh->{$prop};
            }
            if (defined $dh->{$propnew}) {
                $dh->{$prop} = $dh->{$propnew};
            } else {
                delete $dh->{$prop};
            }
            if (defined $dh->{$propnew}) {
                delete $dh->{$propnew};
            }
        }
    }
    $meta;
}

1;
# ABSTRACT: Convert default_lang property value in Rinci function metadata

__END__

=pod

=encoding UTF-8

=head1 NAME

Perinci::Sub::Convert::default_lang - Convert default_lang property value in Rinci function metadata

=head1 VERSION

This document describes version 0.01 of Perinci::Sub::Convert::default_lang (from Perl distribution Perinci-Sub-Convert-default_lang), released on 2014-04-30.

=head1 SYNOPSIS

 use Perinci::Sub::Convert::default_lang qw(convert_property_default_lang);
 convert_property_default_lang(meta => $meta, new => 'id_ID');

=head1 FUNCTIONS


=head2 convert_property_default_lang(%args) -> [status, msg, result, meta]

Convert default_lang property in Rinci function metadata.

Arguments ('*' denotes required arguments):

=over 4

=item * B<meta>* => I<hash>

=item * B<new>* => I<str>

New value.

=back

Return value:

Returns an enveloped result (an array).

First element (status) is an integer containing HTTP status code
(200 means OK, 4xx caller error, 5xx function error). Second element
(msg) is a string containing error message, or 'OK' if status is
200. Third element (result) is optional, the actual result. Fourth
element (meta) is called result metadata and is optional, a hash
that contains extra information.

=head1 SEE ALSO

L<Rinci>

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Perinci-Sub-Convert-default_lang>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-Perinci-Sub-Convert-default_lang>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=Perinci-Sub-Convert-default_lang>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

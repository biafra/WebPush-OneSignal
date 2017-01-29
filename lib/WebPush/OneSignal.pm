package WebPush::OneSignal;

use 5.006;
use strictures 2;

use Class::Tiny::Antlers;
use Encode;
use Net::Curl::Easy qw(/^CURLOPT_.*/);

use Try::Tiny;


has app_id       => (is => 'ro');
has rest_api_key => (is => 'ro');

=head1 NAME

WebPush::OneSignal - The great new WebPush::OneSignal!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use WebPush::OneSignal;

    my $foo = WebPush::OneSignal->new(
        app_id       => '...',
        rest_api_key => '...'
    );

    $foo->send_notification( ... );
    $foo->edit_device( ... );
    ...

=head1 METHODS

=head2 function1

=cut

sub send_notification {
    my $self = shift;
    my %p    = @_;

    my $curl = Net::Curl::Easy->new;
    my $json = JSON->new();
    my $response_body;

    my $os;

    $os->{app_id} = $self->app_id;

    if (exists $p{icon_url}) {
        $os->{chrome_web_icon} = $p{icon_url};
        $os->{firefox_icon}    = $p{icon_url};
        $os->{large_icon}      = $p{icon_url};
        $os->{big_picture}     = $p{icon_url};
    }

    $os->{contents}           = $p{contents};
    $os->{headings}           = $p{headings}        if exists $p{headings};
    $os->{url}                = $p{link_url}        if exists $p{link_url};
    $os->{include_player_ids} = $p{players_id_list} if exists $p{players_id_list};

    $os->{tags}             = $p{tags} if exists $p{tags};
    $os->{tags}             = [
        {
                "key"      => "user_id",
                "relation" => "=",
                "value"    => $p{user_id}
        },
        # Isto é totó. A notif são para ser sempre enviadas. Pode estar
        # offline da web mas receber as notif noutro device qualquer
        # que não controlamos *** Volto atrás. Isto existe por o browser
        # não receber avisos se o player tiver feito logout - num PC que
        # não é dele por exemplo.
        {
                "key"      => "online",
                "relation" => "=",
                "value"    => "true"
        }
    ]                                  if exists $p{user_id};
    $os->{include_segments} = ["All"]  if exists $p{tags};

    my $json_string = Encode::decode_utf8( $json->encode( $os ) );

    $curl->setopt( CURLOPT_URL, 'https://onesignal.com/api/v1/notifications');
    $curl->setopt( CURLOPT_SSL_VERIFYHOST , 0);
    $curl->setopt( CURLOPT_SSL_VERIFYPEER , 0);
    $curl->setopt( CURLOPT_HTTPHEADER , [
            'Content-Type: application/json' ,
            "Authorization: Basic ". $self->rest_api_key
        ]);
    $curl->setopt( CURLOPT_POST       , 1);
    $curl->setopt( CURLOPT_POSTFIELDS , $json_string);

    $curl->setopt( CURLOPT_WRITEDATA  , \$response_body);

    try {
        $curl->perform;
    };

    #TODO: what to do with the response ?
}

=head2 edit_device

=cut

sub edit_device {
    my $self = shift;
    my %p    = @_;

    my $curl = Net::Curl::Easy->new;
    my $json = JSON->new();
    my $response_body;

    my $os;

    $os->{app_id} = $self->app_id;

    $os->{tags}     = $p{tags}     if exists $p{tags};
    $os->{language} = $p{language} if exists $p{language};
    $os->{playerid} = $p{playerid} if exists $p{playerid};

    my $playerid = $os->{playerid};

    return unless $playerid;

    my $json_string = Encode::decode_utf8( $json->encode( $os ) );

    $curl->setopt( CURLOPT_URL, "https://onesignal.com/api/v1/players/$playerid");
    $curl->setopt( CURLOPT_SSL_VERIFYHOST , 0);
    $curl->setopt( CURLOPT_SSL_VERIFYPEER , 0);

    $curl->setopt( CURLOPT_HTTPHEADER, [
            'Content-Type: application/json' ,
            "Authorization: Basic ". $self->rest_api_key
        ]);
    $curl->setopt( CURLOPT_CUSTOMREQUEST , 'PUT');
    $curl->setopt( CURLOPT_POSTFIELDS    , $json_string);

    $curl->setopt( CURLOPT_WRITEDATA     , \$response_body);

    mytry {
        $curl->perform;
    };


    #TODO: what to do with the response ?
}

=head1 AUTHOR

Biafra, C<< <biafra at bodogemu.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<https://github.com/biafra/WebPush-OneSignal/issues>
I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebPush::OneSignal


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebPush-OneSignal>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebPush-OneSignal>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebPush-OneSignal>

=item * Search CPAN

L<http://search.cpan.org/dist/WebPush-OneSignal/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2017 Biafra.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of WebPush::OneSignal

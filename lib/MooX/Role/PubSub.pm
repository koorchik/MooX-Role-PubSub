package MooX::Role::PubSub;

our $VERSION = '0.01';

use Moo::Role;
use Carp;

has '_event_listeners' => (
    is      => 'ro',
    default => sub { +{} }
);

sub trigger {
    my $self = shift;
    my $event_name = shift;

    my $listeners = $self->_event_listeners->{$event_name} or return;

    foreach my $listener (@$listeners) {
        $listener->($self, @_);
    }
}

sub on {
    my ($self, $event_name, $cb) = @_;

    croak 'event name required' unless defined $event_name && length($event_name);
    croak 'callback required' unless $cb && ref($cb) eq 'CODE';

    push @{$self->_event_listeners->{$event_name}}, $cb;
}

sub off {
    my ($self, $event_name, $cb) = @_;
    
    croak 'event name required' unless defined $event_name && length($event_name);
    croak 'callback is not CODE ref' if $cb && ref($cb) ne 'CODE';

    my $listeners = $self->_event_listeners->{$event_name} or return;

    if ($cb) {
        @$listeners = grep {$_ ne $cb} @$listeners; 
    } else {
        delete $self->_event_listeners->{$event_name};
    }
}

1;


=head1 NAME

MooX::Role::PubSub - Publisher-Subscriber (Observer) functionality for your classes

=head1 SYNOPSIS

    # Simple class
    package MyClass;
    use Moo;
    with 'MooX::Role::PubSub';

    sub method1 {
        my $self = shift;
        # .. do sonme staff and notify about it
        $self->trigger('someting_happend', $optional_data );
    }

    ...

    # somewhere
    my $obj = MyClass->new();
    $obj->on('someting_happend' => sub {
        my ($obj, $data) = @_;
    });
    
    # You can hava as many listeners as you want
    $obj->on('someting_happend' => sub { });

    # Unsubscribe all listeners of 'someting_happend' happend event
    $obj->off('someting_happend');

    # You can unscubscribe one listener passing the same callback
    my $listener = sub { };
    $obj->on('someting_happend' => $listener );
    $obj->off('someting_happend' => $listener );


=head1 METHODS

=head2 $self->on($EVENT_NAME, $CALLBACK )
    
    Adds event listeners. With method you can subsribe for an event

=head2 $self->off($EVENT_NAME [, $CALLBACK])

    Removes event listeners. With method you can ubsubsribe for an event

=head2 $self->trigger($EVENT_NAME [, $EXTRA_DATA] )
    
    Emits event. Optionally you can pass additional data

=head1 AUTHOR

Viktor Turskyi, C<< <koorchik at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moox-role-pubsub at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooX-Role-PubSub>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooX::Role::PubSub


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooX-Role-PubSub>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooX-Role-PubSub>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooX-Role-PubSub>

=item * Search CPAN

L<http://search.cpan.org/dist/MooX-Role-PubSub/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Viktor Turskyi.

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

1; # End of MooX::Role::PubSub

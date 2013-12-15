package MooX::Role::PubSub;

use strict;
use warnings;

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

Viktor Turskyi <koorchik@cpan.org>

=head1 BUGS

Please report any bugs or feature requests to Github L<https://github.com/koorchik/MooX-Role-PubSub>

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Viktor Turskyi.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

=cut

1; # End of MooX::Role::PubSub

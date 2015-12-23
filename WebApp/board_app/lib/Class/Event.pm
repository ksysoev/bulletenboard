package Class::Event;

sub new {
    my ( $class, %values ) = @_;
    my $self = {
        type => $values{'type'},
        message=> $values{'message'}
    };
    bless $self, $class;
    $self->init(%values);
    return $self;
}

sub get {
    my ( $self, $key ) = @_;
    return $self->{$key}  ;
}

1;

package Class::Message;
use Encode qw(decode);

sub new {
    my ( $class, %values ) = @_;
    my $self = {
        advert_id    => { value => '' },
        name         => { value => '', is_ok => 0 },
        email        => { value => '', is_ok => 0 },
        message      => { value => '', is_ok => 0 },
        email_to     => { value => '' },
        copy         => { value => '' },
        date         => { value => '' },
        advert_title => { value => '' },
        is_ok => 1
    };
    bless $self, $class;
    $self->init(%values);
    return $self;
}

sub init {
    my ( $self, %values ) = @_;
    foreach my $key ( keys %values ) {
        $self->set_name( $values{$key} )    if $key eq 'name';
        $self->set_email( $values{$key} )   if $key eq 'email';
        $self->set_message( $values{$key} ) if $key eq 'message';
        $self->{$key}->{value} = $values{$key} if $key eq 'advert_id';
        $self->{$key}->{value} = $values{$key} if $key eq 'email_to';
        $self->{$key}->{value} = $values{$key} if $key eq 'copy';
        $self->{$key}->{value} = $values{$key} if $key eq 'date';
        $self->{$key}->{value} = $values{$key} if $key eq 'advert_title';
    }
}

sub set_name {
    my ( $self, $name ) = @_;
    $self->{name}->{value} = $name;
    if ( $name =~ m/^(\w|\s){2,20}$/ and !( $name =~ m/^\s+$/ ) ) {
        $self->{name}->{is_ok} = 1;
    }
    else {
        $self->{is_ok} = 0;
    }
}

sub set_email {
    my ( $self, $email ) = @_;
    $self->{email}->{value} = $email;
    if ( Email::Valid->address( -address => $email, -mxcheck => 0 ) ) {
        $self->{email}->{is_ok} = 1;
    }
    else {
        $self->{is_ok} = 0;
    }
}

sub set_message {
    my ( $self, $message ) = @_;
    $self->{message}->{value} = $message;
    if ( $message =~ m/^.{2,1000}$/ms and !( $message =~ m/^\s+$/ms ) ) {
        $self->{message}->{is_ok} = 1;
    }
    else {
        $self->{is_ok} = 0;
    }
}

sub key_get {
    my ( $self, $key ) = @_;
    return $self->{$key}->{value};
}

sub key_status {
    my ( $self, $key ) = @_;
    return $self->{$key}->{is_ok};
}

sub status {
    my $self = shift;
    return $self->{is_ok};
}

sub write {
    my $self = shift;
    return {
        name    => $self->{name}->{value},
        email   => $self->{email}->{value},
        message => $self->{message}->{value},
        date    => $self->{date}->{value}
    };
}

sub get_date {
    my $self  = shift;
    my @month = (
        'января',     'февраля',
        'марта',       'апреля',
        'мая',           'июня',
        'июля',         'августа',
        'сентября', 'октября',
        'ноября',     'декабря'
    );
    my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) =
      localtime( $self->{date}->{value} );
    return decode( "UTF-8",
            $mday . ' '
          . $month[$mon] . ' '
          . $hour . ':'
          . sprintf( "%02d", $min ) );
}



1;

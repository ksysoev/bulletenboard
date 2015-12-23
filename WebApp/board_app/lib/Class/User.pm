package Class::User;

sub new {
    my ( $class, %values ) = @_;
    my $self = {
        name      => { value => '', is_ok => 0 },
        email     => { value => '', is_ok => 0, exist => 0 },
        telephone => { value => '', is_ok => 0, exist => 0 },
        password  => { value => '', is_ok => 0, wrong => 0 },
        password1   => { is_ok => 0 },
        reg_date    => { value => '', is_ok => 0 },
        role        => { value => 'user', is_ok => 1 },
        type        => { value => 'individ', is_ok => 1 },
        eula        => { is_ok => 0 },
        email_check => { value => 0, key => 0, is_ok => 1 },
        subscription => { value => 0, is_ok => 1 },
        recovery     => { value => 0, is_ok => 1 },
        is_ok        => 1
    };
    bless $self, $class;
    $self->init(%values);
    return $self;
}

sub init {
    my ( $self, %values ) = @_;
    foreach ( keys %values ) {
        $self->set_name( $values{$_} )      if $_ eq 'name';
        $self->set_email( $values{$_} )     if $_ eq 'email';
        $self->set_telephone( $values{$_} ) if $_ eq 'telephone';
        $self->set_password( $values{$_} )  if $_ eq 'password';
        $self->eq_passwords( $values{'password'}, $values{$_} )
          if $_ eq 'password1';
        $self->{$_}->{value} = $values{$_} if $_ eq 'reg_date';
        $self->{$_}->{value} = $values{$_} if $_ eq 'role';
        $self->{$_}->{value} = $values{$_} if $_ eq 'type';
        $self->{$_}->{value} = $values{$_} if $_ eq 'email_check';
        $self->{email_check}->{key} = $self->generate_email_key
          if ( $_ eq 'generate_email_key' and $values{$_} );
        $self->{$_}->{value} = $values{$_} if $_ eq 'subscription';
        $self->{$_}->{is_ok} = $values{$_} if $_ eq 'eula';
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
    $self->{email}->{value} = lc $email;
    if ( Email::Valid->address( -address => $email, -mxcheck => 0 ) ) {
        $self->{email}->{is_ok} = 1;
    }
    else {
        $self->{is_ok} = 0;
    }
}

sub set_telephone {
    my ( $self, $telephone ) = @_;
    $telephone =~ s/(-|\(|\)|\s)//g;
    $self->{telephone}->{value} = $telephone;
    if ( $telephone =~ m/^\+{0,1}\d{6,14}$/ ) {
        $self->{telephone}->{is_ok} = 1;
    }
    else {
        $self->{is_ok} = 0;
    }
}

sub set_password {
    my ( $self, $password ) = @_;
    $self->{password}->{value} =
      Digest::SHA->sha512_base64(
        '!!!VeryStrong!!!' . $password . '123Solt***???' );
    if (   $password =~ m/[a-z]/
        or $password =~ m/[A-Z]/
        or $password =~ m/[0-9]/
        && length($password) >= 8 )
    {
        $self->{password}->{is_ok} = 1;
    }
    else {
        $self->{is_ok} = 0;
    }
}

sub generate_password {
    my $self      = shift;
    my @chars     = ( "A" .. "Z", "a" .. "z", 0 .. 9 );
    my @numbers   = ( 0 .. 9 );
    my @lowercase = ( "a" .. "z" );
    my @uppercase = ( "A" .. "Z" );
    my $password =
        $uppercase[ rand @chars ]
      . $lowercase[ rand @chars ]
      . $numbers[ rand @chars ];
    $password .= $chars[ rand @chars ] for 1 .. 7;
    $self->{password}->{value} =
      Digest::SHA->sha512_base64(
        '!!!VeryStrong!!!' . $password . '123Solt***???' );
    return $password;
}

sub generate_email_key {
    my @chars = ( "A" .. "Z", "a" .. "z", 0 .. 9 );
    my $string;
    $string .= $chars[ rand @chars ] for 1 .. 10;
    return $string;
}

sub eq_passwords {
    my ( $self, $password, $password1 ) = @_;
    if ( $password eq $password1 ) {
        $self->{password1}->{is_ok} = 1;
    }
    else {
        $self->{is_ok} = 0;
    }
}

sub email_exist {
    my $self = shift;
    $self->{email}->{exist} = 1;
    $self->{is_ok} = 0;
}

sub email_login_exist {
    my $self = shift;
    $self->{email}->{exist} = 1;
}

sub email_login_not_exist {
    my $self = shift;
    $self->{is_ok} = 0;
}

sub telephone_exist {
    my $self = shift;
    $self->{telephone}->{exist} = 1;
    $self->{is_ok} = 0;
}

sub password_wrond {
    my $self = shift;
    return $self->{password}->{wrong};
}

sub status {
    my $self = shift;
    return $self->{is_ok};
}

sub key_status {
    my ( $self, $key ) = @_;
    return $self->{$key}->{is_ok};
}

sub key_exist {
    my ( $self, $key ) = @_;
    return $self->{$key}->{exist};
}

sub key_get {
    my ( $self, $key ) = @_;
    return $self->{$key}->{value};
}

sub get_email_key {
    my ($self) = @_;
    return $self->{email_check}->{key};
}

sub write {
    my $self = shift;
    return name    => $self->{name}->{value},
      email        => $self->{email}->{value},
      telephone    => $self->{telephone}->{value},
      password     => $self->{password}->{value},
      role         => $self->{role}->{value},
      type         => $self->{type}->{value},
      reg_date     => $self->{reg_date}->{value},
      email_check  => $self->{email_check}->{value},
      email_key    => $self->{email_check}->{key},
      subscription => $self->{subscription}->{value};
}

sub update_profile {
    my $self = shift;
    return name => $self->{name}->{value},
      telephone => $self->{telephone}->{value};
}

sub update_password {
    my $self = shift;
    return password => $self->{password}->{value},
      recovery_key  => '';
}

sub write_session {
    my $self = shift;
    return name   => $self->{name}->{value},
      email       => $self->{email}->{value},
      email_check => $self->{email_check}->{value},
      telephone   => $self->{telephone}->{value},
      role        => $self->{role}->{value},
      type        => $self->{type}->{value},
      ;
}

sub check_password {
    my ( $self, $password ) = @_;
    unless ( $password eq $self->{password}->{value} ) {
        $self->{is_ok} = 0;
        $self->{password}->{wrong} = 1;
    }
}

sub read_for_login {
    my ( $self, $user ) = @_;
    $self->{name}->{value}        = $user->{name};
    $self->{telephone}->{value}   = $user->{telephone};
    $self->{role}->{value}        = $user->{role};
    $self->{type}->{value}        = $user->{type};
    $self->{email_check}->{value} = $user->{email_check};
    $self->check_password( $user->{password} );
}

sub password_recovery_key {
    my $self = shift;
    my @chars = ( "A" .. "Z", "a" .. "z", "0" .. "9" );
    my $recovery_key;
    $recovery_key .= $chars[ rand @chars ] for 1 .. 16;
    $self->{recovery}->{value} = $recovery_key;
    return recovery_key => $recovery_key;
}

1;

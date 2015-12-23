package Class::Advert;
use Encode qw(decode);

require "$FindBin::Bin/../lib/Class/classfieds.pm";

sub new {
    my ( $class, %values ) = @_;
    my $self = {
        id        => { value => '' },
        name      => { value => '', is_ok => 0 },
        email     => { value => '', is_ok => 0, exist => 0 },
        telephone => { value => '', is_ok => 0, exist => 0 },
        subscription     => { value => 0,                     is_ok => 1 },
        show             => { value => 0 },
        add_date         => { value => '' },
        last_change_date => { value => '' },
        title            => { value => '',                    is_ok => 0 },
        description      => { value => '',                    is_ok => 0 },
        price            => { value => '',                    is_ok => 0 },
        currency         => { value => $values{currency},     is_ok => 0 },
        category         => { value => $values{category},     is_ok => 0 },
        subcategory      => { value => $values{subcategory},  is_ok => 0 },
        advert_param     => { value => $values{advert_param}, is_ok => 0 },
        advert_sec_parametr =>
          { value => $values{advert_sec_parametr}, is_ok => 0 },
        status     => { value => '' },
        subscript  => { value => 0 },
        images     => [],
        images_min => [],
        images_dir => { value => '' },
        is_ok      => 1
    };
    bless $self, $class;
    $self->init(%values);
    return $self;
}

sub init {
    my ( $self, %values ) = @_;
    foreach my $key ( keys %values ) {
        $self->set_name( $values{$key} )         if $key eq 'name';
        $self->set_email( $values{$key} )        if $key eq 'email';
        $self->set_telephone( $values{$key} )    if $key eq 'telephone';
        $self->set_title( $values{$key} )        if $key eq 'title';
        $self->set_description( $values{$key} )  if $key eq 'description';
        $self->set_price( $values{$key} )        if $key eq 'price';
        $self->set_currency( $values{$key} )     if $key eq 'currency';
        $self->set_category( $values{$key} )     if $key eq 'category';
        $self->set_subcategory( $values{$key} )  if $key eq 'subcategory';
        $self->set_advert_param( $values{$key} ) if $key eq 'advert_param';
        $self->set_advert_sec_parametr( $values{$key} )
          if $key eq 'advert_sec_parametr';
        $self->{$key}->{value} = $values{$key} if $key eq 'subscription';
        $self->{$key}->{is_ok} = $values{$key} if $key eq 'eula';
        $self->{$key}->{value} = $values{$key} if $key eq 'add_date';
        $self->{$key}->{value} = $values{$key} if $key eq 'last_change_date';
        $self->{$key}->{value} = $values{$key} if $key eq 'images_dir';
        $self->{$key}          = $values{$key} if $key eq 'images';
        $self->{$key}          = $values{$key} if $key eq 'images_min';
        $self->{$key}->{value} = $values{$key} if $key eq 'id';
        $self->{$key}->{value} = $values{$key} if $key eq 'show';
        $self->{$key}->{value} = $values{$key} if $key eq 'status';
        $self->{$key}->{value} = $values{$key} if $key eq 'subscript';
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

sub email_exist {
    my $self = shift;
    $self->{email}->{exist} = 1;
    $self->{is_ok} = 0;
}

sub set_description {
    my ( $self, $description ) = @_;
    $self->{description}->{value} = $description;
    $description =~ s/</&lt;/gms;
    $description =~ s/>/&gt;/gms;
    if ( $description =~ m/^.{2,3000}$/ms)
    {
        $self->{description}->{is_ok} = 1;
    }
    else {
        $self->{is_ok} = 0;
    }
}

sub get_description {
    my $self = shift;
    my $description = $self->{description}->{value};
    $description =~ s/\n/<br\/>/gms;
    return $description;
}

sub set_title {
    my ( $self, $title ) = @_;
    $self->{title}->{value} = $title;
    if ( $title =~ m/^.{2,50}$/ and !( $title =~ m/^\s+$/ ) ) {
        $self->{title}->{is_ok} = 1;
    }
    else {
        $self->{is_ok} = 0;
    }
}

sub set_price {
    my ( $self, $price ) = @_;
    $price = $price / 21000 if $self->{currency}->{value} eq 'USD';
    $self->{price}->{value} = $price;
    if ( $price =~ m/^\d{1,20}$/ and !( $price =~ m/^0+$/ ) ) {
        $self->{price}->{is_ok} = 1;
    }
    else {
        $self->{is_ok} = 0;
    }
}

sub set_id {
    my ( $self, $advert_id ) = @_;
    $self->{id}->{value} = $advert_id;
}

sub set_currency {
    my ( $self, $currency ) = @_;
    $self->{currency}->{value} = $currency;
    if ( $currency =~ m/(USD|VND)/ ) {
        $self->{currency}->{is_ok} = 1;
    }
    else {
        $self->{is_ok} = 0;
    }
}

sub set_images_dir {
    my ( $self, $images_dir ) = @_;
    $self->{images_dir}->{value} = $images_dir;
}

sub key_get {
    my ( $self, $key ) = @_;
    return $self->{$key}->{value};
}

sub key_exist {
    my ( $self, $key ) = @_;
    return $self->{$key}->{exist};
}

sub key_status {
    my ( $self, $key ) = @_;
    return $self->{$key}->{is_ok};
}

sub status {
    my $self = shift;
    return $self->{is_ok};
}

sub set_category {
    my ( $self, $category ) = @_;
    $self->{category}->{value} = $category;
    if ( $classfieds{$category}->{name} ) {
        $self->{category}->{is_ok} = 1;
    }
    else {
        $self->{is_ok} = 0;
    }
}

sub get_last_change_date {
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
      localtime( $self->{last_change_date}->{value} );
    return decode( "UTF-8",
            $mday . ' '
          . $month[$mon] . ' '
          . $hour . ':'
          . sprintf( "%02d", $min ) );
}

sub get_category {
    my $self = shift;
    if ( $classfieds{ $self->{category}->{value} }->{name} ) {
        return decode( "UTF-8",
            $classfieds{ $self->{category}->{value} }->{name} );
    }
    return decode( "UTF-8", 'Выберите категорию' );
}

sub show_category {
    my $self = shift;
    if ( $classfieds{ $self->{category}->{value} }->{name} ) {
        return decode( "UTF-8",
            $classfieds{ $self->{category}->{value} }->{name} );
    }
    return;
}

sub get_status {
    my $self = shift;
    return decode( "UTF-8", 'Опубликовано' )
      if $self->{status}->{value} eq 'public';
    return decode( "UTF-8", 'Черновик' )
      if $self->{status}->{value} eq 'stash';
    return decode( "UTF-8", 'Продано' )
      if $self->{status}->{value} eq 'sold';
    return decode( "UTF-8", 'Неизвестен' );
}

sub add_image {
    my ( $self, $filename ) = @_;
    push @{ $self->{images} }, $filename;
}

sub add_image_min {
    my ( $self, $filename ) = @_;
    push @{ $self->{images_min} }, $filename;
}

sub get_images {
    my $self = shift;
    return $self->{images};
}

sub get_images_min {
    my $self = shift;
    return $self->{images_min};
}


sub get_one_image {
    my $self = shift;
    return $self->{images_min}->[0];
}

sub set_subcategory {
    my ( $self, $subcategory ) = @_;
    $self->{subcategory}->{value} = $subcategory;
    if ( $classfieds{ $self->{category}->{value} }->{subcategory}
        ->{$subcategory}->{name} )
    {
        $self->{subcategory}->{is_ok} = 1;
    }
    else {
        $self->{is_ok} = 0;
    }
}

sub get_subcategory {
    my $self = shift;
    if ( $classfieds{ $self->{category}->{value} }->{subcategory}
        ->{ $self->{subcategory}->{value} }->{name} )
    {
        return decode( "UTF-8",
            $classfieds{ $self->{category}->{value} }->{subcategory}
              ->{ $self->{subcategory}->{value} }->{name} );
    }
    return decode( "UTF-8", 'Выберите вид' );
}

sub show_subcategory {
    my $self = shift;
    if ( $classfieds{ $self->{category}->{value} }->{subcategory}
        ->{ $self->{subcategory}->{value} }->{name} )
    {
        return decode( "UTF-8",
            $classfieds{ $self->{category}->{value} }->{subcategory}
              ->{ $self->{subcategory}->{value} }->{name} );
    }
    return;
}

sub get_subcategory_list {
    my $self = shift;
    my @subcategurys;
    foreach my $key (
        sort keys $classfieds{ $self->{category}->{value} }->{subcategory} )
    {
        push @subcategurys,
          decode( "UTF-8",
            $classfieds{ $self->{category}->{value} }->{subcategory}->{$key}
              ->{name} );
    }
    return @subcategurys;
}

sub set_advert_param {
    my ( $self, $advert_param ) = @_;
    $self->{advert_param}->{value} = $advert_param;
    if ( $classfieds{ $self->{category}->{value} }->{subcategory}
        ->{ $self->{subcategory}->{value} }->{advert_param}->{$advert_param}
        ->{name} )
    {
        $self->{advert_param}->{is_ok} = 1;
    }
    else {
        my @advert_params =
          keys $classfieds{ $self->{category}->{value} }->{subcategory}
          ->{ $self->{subcategory}->{value} }->{advert_param};
        if ( @advert_params[0] ) {
            $self->{is_ok} = 0;
        }
        else {
            $self->{advert_param}->{is_ok} = 1;
        }
    }
}

sub set_advert_sec_parametr {
    my ( $self, $advert_sec_parametr ) = @_;
    $self->{advert_sec_parametr}->{value} = $advert_sec_parametr;
    if ( $classfieds{ $self->{category}->{value} }->{subcategory}
        ->{ $self->{subcategory}->{value} }->{advert_param}
        ->{ $self->{advert_param}->{value} }->{advert_sec_parametr}
        ->{$advert_sec_parametr}->{name} )
    {
        $self->{advert_sec_parametr}->{is_ok} = 1;
    }
    else {
        my @advert_sec_parametr =
          keys $classfieds{ $self->{category}->{value} }->{subcategory}
          ->{ $self->{subcategory}->{value} }->{advert_param}
          ->{ $self->{advert_param}->{value} }->{advert_sec_parametr};
        if ( @advert_sec_parametr[0] ) {
            $self->{is_ok} = 0;
        }
        else {
            $self->{advert_sec_parametr}->{is_ok} = 1;
        }
    }
}

sub get_advert_param {
    my $self = shift;
    if ( $classfieds{ $self->{category}->{value} }->{subcategory}
        ->{ $self->{subcategory}->{value} }->{advert_param}
        ->{ $self->{advert_param}->{value} }->{name} )
    {
        return decode( "UTF-8",
            $classfieds{ $self->{category}->{value} }->{subcategory}
              ->{ $self->{subcategory}->{value} }->{advert_param}
              ->{ $self->{advert_param}->{value} }->{name} );
    }
    return decode( "UTF-8", 'Выберите вид' );
}

sub get_advert_sec_parametr {
    my $self = shift;
    if ( $classfieds{ $self->{category}->{value} }->{subcategory}
        ->{ $self->{subcategory}->{value} }->{advert_param}
        ->{ $self->{advert_param}->{value} }->{advert_sec_parametr}
        ->{ $self->{advert_sec_parametr}->{value} }->{name} )
    {
        return decode( "UTF-8",
            $classfieds{ $self->{category}->{value} }->{subcategory}
              ->{ $self->{subcategory}->{value} }->{advert_param}
              ->{ $self->{advert_param}->{value} }->{advert_sec_parametr}
              ->{ $self->{advert_sec_parametr}->{value} }->{name} );
    }
    return decode( "UTF-8", 'Выберите вид' );
}

sub show_advert_param {
    my $self = shift;
    if ( $classfieds{ $self->{category}->{value} }->{subcategory}
        ->{ $self->{subcategory}->{value} }->{advert_param}
        ->{ $self->{advert_param}->{value} }->{name} )
    {
        return decode( "UTF-8",
            $classfieds{ $self->{category}->{value} }->{subcategory}
              ->{ $self->{subcategory}->{value} }->{advert_param}
              ->{ $self->{advert_param}->{value} }->{name} );
    }
    return;
}

sub show_advert_sec_parametr {
    my $self = shift;
    if ( $classfieds{ $self->{category}->{value} }->{subcategory}
        ->{ $self->{subcategory}->{value} }->{advert_param}
        ->{ $self->{advert_param}->{value} }->{advert_sec_parametr}
        ->{ $self->{advert_sec_parametr}->{value} }->{name} )
    {
        return decode( "UTF-8",
            $classfieds{ $self->{category}->{value} }->{subcategory}
              ->{ $self->{subcategory}->{value} }->{advert_param}
              ->{ $self->{advert_param}->{value} }->{advert_sec_parametr}
              ->{ $self->{advert_sec_parametr}->{value} }->{name} );
    }
    return;
}

sub get_advert_param_list {
    my $self = shift;
    my @advert_params;
    foreach my $key (
        sort keys $classfieds{ $self->{category}->{value} }->{subcategory}
        ->{ $self->{subcategory}->{value} }->{advert_param} )
    {
        push @advert_params,
          decode( "UTF-8",
            $classfieds{ $self->{category}->{value} }->{subcategory}
              ->{ $self->{subcategory}->{value} }->{advert_param}->{$key}
              ->{name} );
    }
    return @advert_params;
}

sub get_advert_sec_parametr_list {
    my $self = shift;
    my @advert_sec_parametr;
    foreach my $key (
        sort keys $classfieds{ $self->{category}->{value} }->{subcategory}
        ->{ $self->{subcategory}->{value} }->{advert_param}
        ->{ $self->{advert_param}->{value} }->{advert_sec_parametr} )
    {
        push @advert_sec_parametr,
          decode( "UTF-8",
            $classfieds{ $self->{category}->{value} }->{subcategory}
              ->{ $self->{subcategory}->{value} }->{advert_param}
              ->{ $self->{advert_param}->{value} }->{advert_sec_parametr}
              ->{$key}->{name} );
    }
    return @advert_sec_parametr;
}

sub images_remove {
    my $self = shift;
    $self->{images} = ();
}

sub write {
    my $self = shift;
    my $price;
    if ( $self->{currency}->{value} eq 'USD' ) {
        $price = $self->{price}->{value} * 21000;
    }
    else {
        $price = $self->{price}->{value};
    }

    return name           => $self->{name}->{value},
      email               => $self->{email}->{value},
      telephone           => $self->{telephone}->{value},
      subscription        => $self->{subscription}->{value},
      add_date            => $self->{add_date}->{value},
      last_change_date    => $self->{last_change_date}->{value},
      title               => $self->{title}->{value},
      description         => $self->{description}->{value},
      price               => $price,
      currency            => $self->{currency}->{value},
      category            => $self->{category}->{value},
      subcategory         => $self->{subcategory}->{value},
      advert_param        => $self->{advert_param}->{value},
      advert_sec_parametr => $self->{advert_sec_parametr}->{value},
      images              => [ @{ $self->{images} } ],
      images_min          => [ @{ $self->{images_min} } ],
      images_dir          => $self->{images_dir}->{value},
      status              => $self->{status}->{value},
      subscript           => $self->{subscript}->{value};
}

sub update {
    my $self = shift;
    my $price;
    if ( $self->{currency}->{value} eq 'USD' ) {
        $price = $self->{price}->{value} * 21000;
    }
    else {
        $price = $self->{price}->{value};
    }

    return name           => $self->{name}->{value},
      email               => $self->{email}->{value},
      telephone           => $self->{telephone}->{value},
      last_change_date    => $self->{last_change_date}->{value},
      title               => $self->{title}->{value},
      description         => $self->{description}->{value},
      price               => $price,
      currency            => $self->{currency}->{value},
      category            => $self->{category}->{value},
      subcategory         => $self->{subcategory}->{value},
      advert_param        => $self->{advert_param}->{value},
      advert_sec_parametr => $self->{advert_sec_parametr}->{value},
      images              => [ @{ $self->{images} } ],
      images_min              => [ @{ $self->{images_min} } ],
      images_dir          => $self->{images_dir}->{value};
}

1;

package Class::Pagination;

sub new {
    my ( $class, %values ) = @_;
    my $self = {
        page_id              => $values{page_id},
        total_page           => $values{total_page},
        url                  => $values{url},
        pagination_max_pages => $values{pagination_max_pages},
        first_page           => '',
        last_page            => '',
        list                 => ''
    };
    bless $self, $class;
    $self->init;
    return $self;
}

sub init {
    $self                 = shift;
    $page_id              = $self->{page_id};
    $total_page           = $self->{total_page};
    $pagination_max_pages = $self->{pagination_max_pages};

    if ( $page_id > $total_page ) {
        $page_id = $total_page;
    }
    elsif ( !$page_id or $page_id < 0 ) {
        $page_id = 1;
    }
    $self->{page_id} = $page_id;

    my $first_page = $page_id - int( $pagination_max_pages / 2 );
    if ( $first_page <= 1 ) {
        $first_page = 1;
    }
    else {
        if ( ( $total_page - $first_page ) < $pagination_max_pages ) {
            $first_page = $total_page - $pagination_max_pages + 1;
            if ( $first_page <= 1 ) {
                $first_page = 1;
            }
        }
    }

    $self->{first_page} = $first_page;

    my $last_page = $first_page + $pagination_max_pages - 1;

    if ( $last_page > $total_page ) {
        $last_page = $total_page;
    }

    $self->{last_page} = $last_page;

    $self->{url} =~ s!/(.+?)\?(.*)!$1!;
    $self->{params} = $2;

}

sub get_list {
    $self = shift;
    my @pagination;

    if ( $self->{first_page} != 1 ) {
        push @pagination, '<';
    }

    for ( my $i = $self->{first_page} ; $i <= $self->{last_page} ; $i++ ) {
        push @pagination, $i;
    }

    if ( $self->{last_page} < $self->{total_page} ) {
        push @pagination, '>';
    }

    return @pagination;
}

sub get {
    my ( $self, $key ) = @_;
    return $self->{$key};
}

sub get_url_for_page {
    my ( $self, $page_id ) = @_;
    my $url = $self->{url};
    $url =~ s/\d+$//;
    unless ( $url =~ m/\/$/ ) { $url .= '/'; }
    $url .= 'page/' unless $url =~ m!page!;
    $url .= '/'     unless $url =~ m!/$!;
    $url .= $page_id;
    $url .= '?' . $self->{params} if $self->{params};
    return $url;
}

sub get_url_for_sort {
    my $self = shift;
    my $url;
    if ( $self->{params} ) {
        $url = $self->{url} . '?' . $self->{params};
    }
    else {
        $url = $self->{url};
    }
    $url =~ s/&*sort=\d//;
    if   ( $url =~ m/\?/ ) { $url =~ s/$/&/ }
    else                   { $url =~ s/$/?/ }
    return $url;
}

1;

package BoardApp::Controller::Advert::Manage;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

sub List {
    my $self = shift;

    unless ( $self->session('auth') ) {
        return $self->redirect_to('/login');
    }

    my @adverts;
    my $adverts_coll = $self->coll('adverts');

    my $adverts_count =
      $adverts_coll->find( { email => $self->session('email') } )->count;
    my $total_page = $adverts_count / $self->config('advert_per_page');
    $total_page++ if ( $adverts_count % $self->config('advert_per_page') ) > 0;

    my $pagination = Class::Pagination->new(
        page_id              => $self->stash('page_id'),
        total_page           => $total_page,
        url                  => $self->url_for,
        pagination_max_pages => $self->config('pagination_max_pages')
    );

    $self->stash( pagination => $pagination );
    my $page_id = $pagination->get('page_id');

    my $cursor =
      $adverts_coll->find( { email => $self->session('email') } )
      ->sort( { last_change_date => -1 } )
      ->limit( $self->config('advert_per_page') )
      ->skip( ( $page_id - 1 ) * $self->config('advert_per_page') );
    my @adverts_collection = $cursor->all;

    foreach my $advert (@adverts_collection) {
        push @adverts,
          Class::Advert->new(
            id                  => $advert->{_id},
            name                => $advert->{name},
            email               => $advert->{email},
            telephone           => $advert->{telephone},
            add_date            => $advert->{add_date},
            last_change_date    => $advert->{last_change_date},
            title               => $advert->{title},
            description         => $advert->{description},
            price               => $advert->{price},
            currency            => $advert->{currency},
            category            => $advert->{category},
            subcategory         => $advert->{subcategory},
            advert_param        => $advert->{advert_param},
            advert_sec_parametr => $advert->{advert_sec_parametr},
            images_dir          => $advert->{images_dir},
            images              => $advert->{images},
            images_min          => $advert->{images_min},
            status              => $advert->{status},
            subscript           => $advert->{subscript}
          );
    }
    $self->stash( adverts => [@adverts] );
    $self->render( template => "advert/manage" );
}

sub Publish {
    my $self = shift;
    print $self->session('email') . "\n";
    unless ( $self->session('email') ) {
        return $self->redirect_to('/login');
    }
    my $adverts_coll = $self->coll('adverts');

    if (
        $self->session('email')
        and $adverts_coll->find(
            {
                email => $self->session('email'),
                "_id" => MongoDB::OID->new( value => $self->stash('advert_id') )
            }
        )->count
      )
    {

        $adverts_coll->update(
            {
                email => $self->session('email'),
                "_id" => MongoDB::OID->new( value => $self->stash('advert_id') )
            },
            { '$set' => { 'status' => 'public' } }
        );
        if ( $self->session('auth') ) {
            $self->redirect_to('/account/adverts?success_publish=1');
        }
        else {
            $self->redirect_to('/?success_publish=1');
        }
    }
    else {
        $self->res->code(404);
        $self->render( template => "not_found" );
    }
}

sub Unpublish {
    my $self = shift;

    unless ( $self->session('auth') ) {
        return $self->redirect_to('/login');
    }

    my $adverts_coll = $self->coll('adverts');

    if (
        $self->session('email')
        and $adverts_coll->find(
            {
                email => $self->session('email'),
                "_id" => MongoDB::OID->new( value => $self->stash('advert_id') )
            }
        )->count
      )
    {

        $adverts_coll->update(
            {
                email => $self->session('email'),
                "_id" => MongoDB::OID->new( value => $self->stash('advert_id') )
            },
            { '$set' => { 'status' => 'stash' } }
        );
        $self->redirect_to('/account/adverts');
    }
    else {
        $self->res->code(404);
        $self->render( template => "not_found" );
    }
}

sub Remove {
    my $self = shift;

    my $adverts_coll = $self->coll('adverts');
    if (
        $self->session('email')
        and $adverts_coll->find(
            {
                email => $self->session('email'),
                "_id" => MongoDB::OID->new( value => $self->stash('advert_id') )
            }
        )->count
      )
    {
        my $advert = $adverts_coll->find_one(
            {
                "_id" => MongoDB::OID->new( value => $self->stash('advert_id') )
            },
            {
                images_dir => 1,
                images     => 1,
                status     => 1
            }
        );

        unless ( $self->session('auth') ) {
            if ( $advert->{status} eq 'public' ) {
                return $self->redirect_to('/login');
            }
        }
        foreach my $image ( @{ $advert->{images} } ) {
            eval { unlink "$FindBin::Bin/../public" . $image; };
            warn $@ if $@;
            $self->error(
                "Error remove image $FindBin::Bin/../public" . $image )
              if $@;
        }

        eval { rmdir "$FindBin::Bin/../public" . $advert->{images_dir} };
        $self->error( "Error remove image dir $FindBin::Bin/../public"
              . $advert->{images_dir} )
          if $@;
        $adverts_coll->remove(
            {
                email => $self->session('email'),
                "_id" => MongoDB::OID->new( value => $self->stash('advert_id') )
            }
        );
        if ( $self->session('auth') ) {
            $self->redirect_to('/account/adverts?success_remove=1');
        }
        else {
            $self->redirect_to('/?success_remove=1');
        }
    }
    else {
        $self->res->code(404);
        $self->render( template => "not_found" );
    }

}

sub Control {
    my $self      = shift;
    my $advert_id = $self->stash('advert_id');

    unless ( $self->session('auth') ) {
        return $self->redirect_to('/login');
    }
    my $adverts_coll = $self->coll('adverts');
    if (
        $self->session('email')
        and $adverts_coll->find(
            {
                email => $self->session('email'),
                "_id" => MongoDB::OID->new( value => $self->stash('advert_id') )
            }
        )->count
      )
    {
        my $advert_form_db = $adverts_coll->find_one(
            {
                email => $self->session('email'),
                "_id" => MongoDB::OID->new( value => $self->stash('advert_id') )
            }
        );

        my $advert = Class::Advert->new(
            id                  => $advert_form_db->{_id},
            name                => $advert_form_db->{name},
            email               => $advert_form_db->{email},
            telephone           => $advert_form_db->{telephone},
            add_date            => $advert_form_db->{add_date},
            last_change_date    => $advert_form_db->{last_change_date},
            title               => $advert_form_db->{title},
            description         => $advert_form_db->{description},
            price               => $advert_form_db->{price},
            currency            => $advert_form_db->{currency},
            category            => $advert_form_db->{category},
            subcategory         => $advert_form_db->{subcategory},
            advert_param        => $advert_form_db->{advert_param},
            advert_sec_parametr => $advert_form_db->{advert_sec_parametr},
            images_dir          => $advert_form_db->{images_dir},
            images              => $advert_form_db->{images},
            images_min          => $advert_form_db->{images_min},
            show                => $advert_form_db->{show},
            status              => $advert_form_db->{status},
            subscript           => $advert_form_db->{subscript}
        );
        $self->stash( advert => $advert );
        $self->render( template => "advert/control" );
    }
    else {
        $self->render( template => "advert/error_access_devied_advert" );
    }
}

1;

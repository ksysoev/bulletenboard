package BoardApp::Controller::Advert::Edit;
use Mojo::Base 'Mojolicious::Controller';
use File::Path qw(make_path);
use MIME::Base64 qw( encode_base64 );
use Encode qw(encode);
use Data::Dumper;

sub Form {
    my $self = shift;

    unless ( $self->session('auth') ) {
        $self->redirect_to('/login');
    }

    my $adverts_coll = $self->coll('adverts');

    if (
        $adverts_coll->find(
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
        $self->stash( advert => $advert, error => 0 );
        $self->render( template => "advert/edit" );
    }
    else {
        $self->redirect_to('/');
    }
}

sub Save {
    my $self = shift;

    my $adverts_coll = $self->coll('adverts');
    my $price        = $self->param('price');
    $price = $price * 21000
      if (  $self->param('price')
        and $self->param('currency')
        and $self->param('currency') eq 'USD' );

    my $advert = Class::Advert->new(
        id                  => $self->stash('advert_id'),
        name                => $self->param('name'),
        email               => $self->session('email'),
        telephone           => $self->param('telephone'),
        last_change_date    => time,
        title               => $self->param('title'),
        description         => $self->param('description'),
        price               => $price,
        currency            => $self->param('currency'),
        category            => $self->param('category'),
        subcategory         => $self->param('subcategory'),
        advert_param        => $self->param('advert_param'),
        advert_sec_parametr => $self->param('advert_sec_parametr'),
        images_dir          => $self->param('images_dir'),
        status              => 'public'
    );

    foreach my $image ( @{ $self->every_param('images') } ) {
        $advert->add_image($image);
    }
    foreach my $images_min ( @{ $self->every_param('images_min') } ) {
        $advert->add_image_min($images_min);
    }

    if (
        $adverts_coll->find(
            {
                email => $self->session('email'),
                "_id" => MongoDB::OID->new( value => $self->stash('advert_id') )
            }
        )->count
      )
    {
        if ( $advert->status ) {
            my $advert_photos = $self->req->uploads('advert_photos');
            if ( $self->req->uploads('advert_photos')->[0]->filename ) {
                foreach my $image ( @{ $advert->get_images } ) {
                    unlink "/var/www/public" . $image;
                }
                $advert->{images} = ();
                foreach my $image_min ( @{ $advert->get_images_min } ) {
                    unlink "/var/www/public" . $image_min;
                }
                $advert->{image_min} = ();
                my $i = 1;
                foreach my $foto ( @{$advert_photos} ) {
                    my $filename = $i++;
                    my $filetype = $foto->filename;
                    if ( $filetype =~ m/^.+(\.\w{3,4})$/ ) {
                        $filetype = $1;
                    }
                    $foto->move_to( "/var/www/public"
                          . $self->param('images_dir')
                          . $filename
                          . $filetype );
                    $advert->add_image(
                        $self->param('images_dir') . $filename . $filetype );
                    my $full_image =
                      Image::Imlib2->load( "/var/www/public"
                          . $self->param('images_dir')
                          . $filename
                          . $filetype );
                    my $scale_image =
                      $full_image->create_scaled_image( 0, 140 );
                    $scale_image->save( "/var/www/public"
                          . $self->param('images_dir')
                          . $filename . "-min"
                          . $filetype );
                    $advert->add_image_min( $self->param('images_dir')
                          . $filename . "-min"
                          . $filetype );
                }
            }
            my $adverts_coll = $self->coll('adverts');

            $adverts_coll->update(
                {
                    "_id" =>
                      MongoDB::OID->new( value => $self->stash('advert_id') )
                },
                { $advert->update }
            );

            $self->res->code(302);
            $self->redirect_to(
                '/advert/control/' . $self->stash('advert_id') );
        }
        else {
            $self->stash( advert => $advert, error => 1 );
            $self->render( template => "advert/add" );
        }
    }
    else {
        $self->render( template => "advert/error_access_devied_advert" );
    }
}

1

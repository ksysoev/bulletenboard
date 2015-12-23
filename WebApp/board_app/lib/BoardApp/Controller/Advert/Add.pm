package BoardApp::Controller::Advert::Add;
use Mojo::Base 'Mojolicious::Controller';
use File::Path qw(make_path);
use MIME::Base64 qw( encode_base64 );
use Encode qw(encode);
use Data::Dumper;

sub Form {
    my $self = shift;

    $self->render( template => "advert/add" )

}

sub Add {
    my $self = shift;

    my $users_coll = $self->coll('users');
    my $price      = $self->param('price');
    $price = $price * 21000
      if (  $self->param('price')
        and $self->param('currency')
        and $self->param('currency') eq 'USD' );

    my $advert = Class::Advert->new(
        name                => $self->param('name'),
        email               => $self->param('email'),
        telephone           => $self->param('telephone'),
        add_date            => time,
        last_change_date    => time,
        title               => $self->param('title'),
        description         => $self->param('description'),
        price               => $price,
        currency            => $self->param('currency'),
        category            => $self->param('category'),
        subcategory         => $self->param('subcategory'),
        advert_param        => $self->param('advert_param'),
        advert_sec_parametr => $self->param('advert_sec_parametr'),
        subscript           => $self->param("subscript"),
        status              => 'stash'
    );
    unless ( $self->session('auth') ) {
        if ( $users_coll->find( { email => $self->param('email') } )->count ) {
            $advert->email_exist;
        }
    }

    if ( $advert->status ) {
        my $adverts_coll = $self->coll('adverts');
        if (
            $adverts_coll->find(
                {
                    description => $self->param('description'),
                    title       => $self->param('title')
                }
            )->count
          )
        {
            $self->stash( advert => $advert, exist => 1 );
            return $self->render( template => "advert/add" );

        }
        my $dir = $self->param('email');
        $dir =~ s/(\/|\\|<|>|\||:|&)//g;
        $dir .= '/' . time;
        make_path("/var/www/public/img/items/$dir/");
        $advert->set_images_dir("/img/items/$dir/");
        my $advert_photos = $self->req->uploads('advert_photos');
        if ( $self->req->uploads('advert_photos')->[0]->filename ) {
            my $i = 1;
            foreach my $foto ( @{$advert_photos} ) {
                my $filename = $i++;
                my $filetype = $foto->filename;
                if ( $filetype =~ m/^.+(\.\w{3,4})$/ ) {
                    $filetype = $1;
                }
                $foto->move_to( "/var/www/public/img/items/$dir/"
                      . $filename
                      . $filetype );
                $advert->add_image(
                    "/img/items/$dir/" . $filename . $filetype );

                my $full_image = Image::Imlib2->load(
                        "/var/www/public/img/items/$dir/"
                      . $filename
                      . $filetype );
                my $scale_image = $full_image->create_scaled_image( 0, 140 );
                $scale_image->save( "/var/www/public/img/items/$dir/"
                      . $filename . "-min"
                      . $filetype );
                      $advert->add_image_min(
                          "/img/items/$dir/" . $filename. "-min" . $filetype );
            }
        }
        my $advert_id = $adverts_coll->insert( { $advert->write } );
        unless ( $self->session('auth') ) {
            $self->session(
                name      => $self->param('name'),
                email     => $self->param('email'),
                telephone => $self->param('telephone')
            );
            my $user = Class::User->new(
                name               => $self->param('name'),
                email              => $self->param('email'),
                telephone          => $self->param('telephone'),
                reg_date           => time,
                eula               => $self->param('eula'),
                generate_email_key => 1
            );
            my $password = $user->generate_password;
            $users_coll->insert( { $user->write } );
            my $data = $self->render_mail(
                template => 'email/add_and_registration',
                key      => $user->get_email_key,
                password => $password
            );
            $self->mail(
                mail => {
                    encoding => 'base64',
                    Type     => 'multipart/mixed',
                    To       => $self->param('email'),
                },
                attach => [
                    {
                        Type => 'text/html; charset=UTF-8',
                        Data => $data,
                    }
                ]
            );
        }
        $self->res->code(302);

        $self->redirect_to("/advert/publish/$advert_id");

    }
    else {
        $self->stash( advert => $advert );

        $self->render( template => "advert/add" );

    }
}

sub Preview {
    my $self           = shift;
    my $advert_id      = $self->stash('advert_id');
    my $adverts_coll   = $self->coll('adverts');
    my $advert_form_db = $adverts_coll->find_one(
        {
            email => $self->session('email'),
            "_id" => MongoDB::OID->new( value => $self->stash('advert_id') )
        }
    );
    if ( $advert_form_db->{_id} ) {
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
            show                => $advert_form_db->{show},
            subscript           => $advert_form_db->{subscript}
        );
        $self->stash( advert => $advert );
        $self->render( template => "advert/preview" );
    }
    else {
        $self->res->code(404);
        $self->render( template => "not_found" );
    }
}

1;

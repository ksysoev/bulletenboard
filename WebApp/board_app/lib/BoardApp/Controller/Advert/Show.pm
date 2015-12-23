package BoardApp::Controller::Advert::Show;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

sub Show {
    my $self           = shift;
    my $advert_id      = $self->stash('advert_id');
    my $adverts_coll   = $self->coll('adverts');
    my $advert_form_db = $adverts_coll->find_and_modify(
        {
            query => {
                _id => MongoDB::OID->new( value => $self->stash('advert_id') )
            },
            update => { '$inc' => { 'show' => 1 } }
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
            images_min          => $advert_form_db->{images_min},
            show                => $advert_form_db->{show},
            subscript           => $advert_form_db->{subscript}
        );
        $self->stash( advert => $advert );
        $self->render( template => "advert/show" );
    }
    else {
        $self->res->code(404);
        $self->render( template => "not_found" );
    }
}

1;

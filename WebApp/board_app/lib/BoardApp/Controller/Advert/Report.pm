package BoardApp::Controller::Advert::Report;
use Mojo::Base 'Mojolicious::Controller';

sub Sold {
    my $self         = shift;
    my $adverts_coll = $self->coll('adverts');
    if ( $self->stash('advert_id') ) {
        my $advert_form_db = $adverts_coll->find_and_modify(
            {
                query => {
                    _id =>
                      MongoDB::OID->new( value => $self->stash('advert_id') )
                },
                update => {
                    '$push' => {
                        'reports' => {
                            'email'     => $self->session('email'),
                            'telephone' => $self->session('telephone'),
                            'name'      => $self->session('name'),
                            'date'      => time,
                            'type'      => 'sold',
                            'ip'        => $self->tx->remote_address
                        }
                    }
                }
            }
        );
        if ( $advert_form_db->{_id} ) {
            $self->res->code(302);
            $self->redirect_to( '/' . '?succesfull_report=1' );
        }
        else {
            $self->res->code(404);
            $self->render( template => "not_found" );
        }
    }
    else {
        $self->res->code(404);
        $self->render( template => "not_found" );
    }
}

sub Wrong_Price {
    my $self         = shift;
    my $adverts_coll = $self->coll('adverts');
    if ( $self->stash('advert_id') ) {
        my $advert_form_db = $adverts_coll->find_and_modify(
            {
                query => {
                    _id =>
                      MongoDB::OID->new( value => $self->stash('advert_id') )
                },
                update => {
                    '$push' => {
                        'reports' => {
                            'email'     => $self->session('email'),
                            'telephone' => $self->session('telephone'),
                            'name'      => $self->session('name'),
                            'date'      => time,
                            'type'      => 'wrong_price',
                            'ip'        => $self->tx->remote_address
                        }
                    }
                }
            }
        );
        if ( $advert_form_db->{_id} ) {
            $self->res->code(302);
            $self->redirect_to( '/' . '?succesfull_report=1' );
        }
        else {
            $self->res->code(404);
            $self->render( template => "not_found" );
        }
    }
    else {
        $self->res->code(404);
        $self->render( template => "not_found" );
    }
}

sub Do_Not_Call {
    my $self         = shift;
    my $adverts_coll = $self->coll('adverts');
    if ( $self->stash('advert_id') ) {
        my $advert_form_db = $adverts_coll->find_and_modify(
            {
                query => {
                    _id =>
                      MongoDB::OID->new( value => $self->stash('advert_id') )
                },
                update => {
                    '$push' => {
                        'reports' => {
                            'email'     => $self->session('email'),
                            'telephone' => $self->session('telephone'),
                            'name'      => $self->session('name'),
                            'date'      => time,
                            'type'      => 'do_not_call',
                            'ip'        => $self->tx->remote_address
                        }
                    }
                }
            }
        );
        if ( $advert_form_db->{_id} ) {
            $self->res->code(302);
            $self->redirect_to( '/' . '?succesfull_report=1' );
        }
        else {
            $self->res->code(404);
            $self->render( template => "not_found" );
        }
    }
    else {
        $self->res->code(404);
        $self->render( template => "not_found" );
    }
}

sub Contacs_in_Description {
    my $self         = shift;
    my $adverts_coll = $self->coll('adverts');
    if ( $self->stash('advert_id') ) {
        my $advert_form_db = $adverts_coll->find_and_modify(
            {
                query => {
                    _id =>
                      MongoDB::OID->new( value => $self->stash('advert_id') )
                },
                update => {
                    '$push' => {
                        'reports' => {
                            'email'     => $self->session('email'),
                            'telephone' => $self->session('telephone'),
                            'name'      => $self->session('name'),
                            'date'      => time,
                            'type'      => 'contacs_in_description',
                            'ip'        => $self->tx->remote_address
                        }
                    }
                }
            }
        );
        if ( $advert_form_db->{_id} ) {
            $self->res->code(302);
            $self->redirect_to( '/' . '?succesfull_report=1' );
        }
        else {
            $self->res->code(404);
            $self->render( template => "not_found" );
        }
    }
    else {
        $self->res->code(404);
        $self->render( template => "not_found" );
    }

}

sub Scam {
    my $self         = shift;
    my $adverts_coll = $self->coll('adverts');
    if ( $self->stash('advert_id') ) {
        my $advert_form_db = $adverts_coll->find_and_modify(
            {
                query => {
                    _id =>
                      MongoDB::OID->new( value => $self->stash('advert_id') )
                },
                update => {
                    '$push' => {
                        'reports' => {
                            'email'     => $self->session('email'),
                            'telephone' => $self->session('telephone'),
                            'name'      => $self->session('name'),
                            'date'      => time,
                            'type'      => 'scam',
                            'ip'        => $self->tx->remote_address
                        }
                    }
                }
            }
        );
        if ( $advert_form_db->{_id} ) {
            $self->res->code(302);
            $self->redirect_to( '/' . '?succesfull_report=1' );
        }
        else {
            $self->res->code(404);
            $self->render( template => "not_found" );
        }
    }
    else {
        $self->res->code(404);
        $self->render( template => "not_found" );
    }
}

sub Other {
    my $self         = shift;
    my $adverts_coll = $self->coll('adverts');
    if ( $self->param('report') and $self->stash('advert_id') ) {
        my $advert_form_db = $adverts_coll->find_and_modify(
            {
                query => {
                    _id =>
                      MongoDB::OID->new( value => $self->stash('advert_id') )
                },
                update => {
                    '$push' => {
                        'reports' => {
                            'email'     => $self->session('email'),
                            'telephone' => $self->session('telephone'),
                            'name'      => $self->session('name'),
                            'date'      => time,
                            'report'    => $self->param('report'),
                            'type'      => 'other',
                            'ip'        => $self->tx->remote_address
                        }
                    }
                }
            }
        );
        if ( $advert_form_db->{_id} ) {
            $self->res->code(302);
            $self->redirect_to( '/' . '?succesfull_report=1' );
        }
        else {
            $self->res->code(404);
            $self->render( template => "not_found" );
        }
    }
    else {
        my $advert_form_db = $adverts_coll->find_one(
            {
                _id => MongoDB::OID->new( value => $self->stash('advert_id') )
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
            $self->stash( advert => $advert, report_error => 1 );
            $self->render( template => "advert/show" );
        }
        else {
            $self->res->code(404);
            $self->render( template => "not_found" );
        }

    }
}

1;

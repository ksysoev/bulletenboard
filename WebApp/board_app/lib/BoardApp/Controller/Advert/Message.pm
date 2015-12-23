package BoardApp::Controller::Advert::Message;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

sub Send {
    my $self           = shift;
    my $adverts_coll   = $self->coll('adverts');
    my $advert_form_db = $adverts_coll->find_one(
        {
            "_id" => MongoDB::OID->new( value => $self->stash('advert_id') )
        }
    );

    if ( $advert_form_db->{email} ) {
        my $message = Class::Message->new(
            advert_id => $self->stash('advert_id'),
            name      => $self->param('name'),
            email     => $self->param('email'),
            message   => $self->param('message'),
            email_to  => $advert_form_db->{email},
            date      => time
        );
        $self->stash( message => $message );

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

        if ( $message->status ) {

            my $users_coll  = $self->coll('users');
            my $email_check = $users_coll->find_one(
                { email => $self->param('email') },
                {
                    email_check => 1
                }
            );
            if ( $email_check->{email_check} ) {
                my $data =
                  $self->render_mail( template => 'email/send_message' );
                $self->mail(
                    mail => {
                        encoding => 'base64',
                        Type     => 'multipart/mixed',
                        To       => $message->key_get('email_to')
                    },
                    attach => [
                        {
                            Type => 'text/html; charset=UTF-8',
                            Data => $data,
                        }
                    ]
                );
            }
            $adverts_coll->update(
                {
                    "_id" =>
                      MongoDB::OID->new( value => $self->stash('advert_id') )
                },
                { '$push' => { messages => $message->write } }
            );
            $self->res->code(302);
            $self->redirect_to( '/advert/show/'
                  . $advert_form_db->{_id}
                  . '?succesfull_send=1' );
        }
        else {
            $self->render( template => "advert/show" );
        }
    }
    else {
        $self->res->code(404);
        $self->render( template => "not_found" );
    }
}

sub List {
    my $self = shift;

    unless ( $self->session('auth') ) {
        return $self->redirect_to('/login');
    }

    my $adverts_coll = $self->coll('adverts');

    my $cursor = $adverts_coll->find(
        { email => $self->session('email'), messages => { '$exists' => 1 } },
        { title => 1,                       messages => 1 } );
    my @adverts_collection = $cursor->all;

    my @messages;
    foreach my $advert (@adverts_collection) {
        foreach my $message ( @{ $advert->{messages} } ) {
            push @messages,
              Class::Message->new(
                advert_id    => $advert->{'_id'},
                advert_title => $advert->{'title'},
                name         => $message->{'name'},
                email        => $message->{'email'},
                message      => $message->{'message'},
                date         => $message->{'date'}
              );
        }
    }

    for ( my $i = 0 ; $i < @messages ; $i++ ) {
        for ( my $j = $i ; $j < @messages ; $j++ ) {
            if ( $messages[$i]->{date}->{value} <
                $messages[$j]->{date}->{value} )
            {
                my $tmp = $messages[$j];
                $messages[$j] = $messages[$i];
                $messages[$i] = $tmp;
            }
        }
    }

    my $total_page = ( @messages + 1 ) / $self->config('advert_per_page');
    $total_page++
      if ( ( @messages + 1 ) % $self->config('advert_per_page') ) > 0;

    my $pagination = Class::Pagination->new(
        page_id              => $self->stash('page_id'),
        total_page           => $total_page,
        url                  => $self->url_for,
        pagination_max_pages => $self->config('pagination_max_pages')
    );

    $self->stash( pagination => $pagination );

    my $page_id = $pagination->get('page_id');

    my $first_item = ( $page_id - 1 ) * $self->config('advert_per_page');
    my $last_item  = $first_item + 9;
    $last_item = @messages - 1 if $last_item > @messages;
    @messages = @messages[ $first_item .. $last_item ];
    $self->render( template => "user/messages", messages => [@messages] );

}

sub Remove {
    my $self = shift;
    unless ( $self->session('auth') ) {
        return $self->redirect_to('/login');
    }

    my $adverts_coll = $self->coll('adverts');
    $adverts_coll->update(
        {
            "_id" => MongoDB::OID->new(
                value   => $self->stash('advert_id'),
                'email' => $self->session('email')
            )
        },
        {
            '$pull' => {
                messages => {
                    email => $self->param('email'),
                    date  => int( $self->param('date') )
                }
            }
        }
    );

    $self->redirect_to('/account/messages/?success_remove=1');

}

1;

package BoardApp::Controller::User::Login;
use Mojo::Base 'Mojolicious::Controller';

sub Form {
    my $self = shift;

    if ( $self->session('email') and $self->session('auth') ) {
        $self->redirect_to('/');
    }

    $self->render( template => "user/login" );
}

sub Login {
    my $self = shift;

    if ( $self->session('email') and $self->session('auth') ) {
        $self->redirect_to('/');
    }

    my $users_coll = $self->coll('users');
    my $user       = Class::User->new(
        email    => $self->param('email'),
        password => $self->param('password'),
    );

    if ( $user->key_status('email') ) {
        if ( $users_coll->find( { email => $self->param('email') } )->count ) {
            $user->email_login_exist;
            $user->read_for_login(
                $users_coll->find_one(
                    { email => $self->param('email') },
                    {
                        name        => 1,
                        email       => 1,
                        password    => 1,
                        telephone   => 1,
                        role        => 1,
                        type        => 1,
                        email_check => 1
                    }
                )
            );
        }
        else {
            $user->email_login_not_exist;
        }
    }

    my $session_expiration = '1209600';
    if ( $self->param('quick_expire') ) {
        $session_expiration = '0';
    }

    if ( $user->status ) {
        $self->session(
            expiration => $session_expiration,
            $user->write_session, auth => 1
        );
        $self->res->code(302);
        $self->redirect_to('/');
    }
    else {
        $self->stash( user => $user );
        $self->render( template => "user/login" );
    }
}

sub Logout {
    my $self = shift;

    unless ( $self->session('auth') ) {
        $self->redirect_to('/');
    }

    $self->session( auth => 0 );

    $self->res->code(302);
    $self->redirect_to('/');
}

1;

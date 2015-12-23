package BoardApp::Controller::User::Password::Change;
use Mojo::Base 'Mojolicious::Controller';

sub Edit {
    my $self = shift;
    unless ( $self->session('auth') ) {
        $self->redirect_to('/login');
    }
    $self->render( template => "user/password_change" )

}

sub Save {
    my $self = shift;

    unless ( $self->session('auth') ) {
        $self->redirect_to('/login');
    }

    my $users_coll = $self->coll('users');
    my $user       = Class::User->new(
        email    => $self->session('email'),
        password => $self->param('oldpassword'),
    );

    if ( $user->key_status('email') ) {
        if ( $users_coll->find( { email => $self->session('email') } )->count ) {
            $user->email_login_exist;
            my $password = $users_coll->find_one(
                { email => $self->session('email') },
                {
                    password => 1
                }
            );

            $user->check_password( $password->{password} );
        }
        else {
            $user->email_login_not_exist;
            $self->redirect_to('/logout');
        }
    }else{
      $self->redirect_to('/logout');
    }

    if ( $user->status ) {
        my $new_password = Class::User->new(
            email     => $self->session('email'),
            password  => $self->param('password'),
            password1 => $self->param('password1')
        );
        if ( $new_password->status ) {
            $users_coll->update( { email => $self->session('email') },
                { '$set' => { $new_password->update_password } } );
            $self->res->code(302);
            $self->render( template=>"user/succesfull_password_change")
        }
        else {
            $self->stash( user => $user, new_password => $new_password );
            $self->render( template => "user/password_new" );
        }

    }
    else {
        $self->stash( user => $user );
        $self->render( template => "user/password_change" );
    }
}

1;

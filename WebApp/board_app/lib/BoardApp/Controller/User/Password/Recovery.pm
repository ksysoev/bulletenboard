package BoardApp::Controller::User::Password::Recovery;
use Mojo::Base 'Mojolicious::Controller';

sub Form {
    my $self = shift;

    $self->render( template => "user/password_recovery" );
}

sub Recovery {
    my $self = shift;
    if ( $self->session('email') and $self->session('auth') ) {
        $self->redirect_to('/');
    }
    my $users_coll = $self->coll('users');

    my $user = Class::User->new( email => $self->param('email'), );

    if ( $users_coll->find( { email => $self->param('email') } )->count ) {
        $users_coll->update( { email => $self->param('email') },
            { '$set' => { $user->password_recovery_key } } );

        my $data = $self->render_mail(
            template => 'email/recoverypassword',
            user     => $user
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

        $self->render( template => "user/succesfull_send_recovery_key" );
    }

    else {
        $user->email_login_not_exist;
        $self->stash( user => $user );
        $self->render( template => "user/password_recovery" );
    }

}

sub Check {
    my $self = shift;
    if ( $self->param('email') and $self->param('key') ) {
        my $user = Class::User->new(
            email     => $self->param('email'),
            recovery  => $self->param('key'),
            password  => $self->param('password'),
            password1 => $self->param('password1')
        );
        my $users_coll = $self->coll('users');
        if (
            $self->param('key')
            and $users_coll->find(
                {
                    email        => $self->param('email'),
                    recovery_key => $self->param('key')
                }
            )->count
          )
        {
            if ( $self->param('password') or $self->param('password1') ) {
                if ( $user->status ) {
                    $users_coll->update(
                        { email  => $self->param('email') },
                        { '$set' => { $user->update_password } }
                    );
                    $self->res->code(302);
                    $self->redirect_to('/login');
                }
                else {
                    $self->stash( user => $user );
                    $self->render( template => "user/password_new" );
                }
            }
            else {
                $self->render( template => "user/password_new" );
            }

        }
        else {
            $user->email_login_not_exist;
            $self->stash( user => $user );
            $self->render( template => "user/error_recovery_password" );
        }
    }
    else {
    }
}

1;

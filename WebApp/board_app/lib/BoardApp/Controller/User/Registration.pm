package BoardApp::Controller::User::Registration;
use Mojo::Base 'Mojolicious::Controller';

sub Form {
    my $self = shift;

    if ( $self->session('email') and $self->session('auth') ) {
        $self->redirect_to('/');
    }

    $self->render( template => "user/registration" )

}

sub Add {
    my $self = shift;

    if ( $self->session('email') and $self->session('auth') ) {
        $self->redirect_to('/');
    }

    my $users_coll = $self->coll('users');
    my $user       = Class::User->new(
        name               => $self->param('name'),
        email              => $self->param('email'),
        telephone          => $self->param('telephone'),
        password           => $self->param('password'),
        password1          => $self->param('password1'),
        reg_date           => time,
        eula               => 'on',
        generate_email_key => 1
    );
    if ( $users_coll->find( { email => $self->param('email') } )->count ) {
        $user->email_exist;
    }

    if (
        $users_coll->find( { telephone => $self->param('telephone') } )->count )
    {
        $user->telephone_exist;
    }

    if ( $user->status ) {
        $users_coll->insert( { $user->write } );
        $self->session( expiration => 604800, $user->write_session, auth => 0 );

        my $data = $self->render_mail(
            template => 'email/confirm',
            key      => $user->get_email_key
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
        $self->res->code(302);
        $self->render(template => "user/successful_registration");
    }
    else {
        $self->stash( user => $user );
        $self->render( template => "user/registration" );
    }
}

sub Email_Confirm {
    my $self = shift;
    if (    $self->session('email') eq $self->param('email')
        and $self->session('auth') )
    {
        $self->redirect_to('/');
    }

    my $users_coll = $self->coll('users');
    my $user       = $users_coll->find_one(
        { email => $self->param('email') },
        {
            email_key => 1
        }
    );
    if ( $user->{email_key} eq $self->param('key') ) {
        $users_coll->update(
            { email  => $self->session('email') },
            { '$set' => { email_check => 1 } }
        );
        $self->redirect_to('/?success_confirm_email=1');
    }
    else {
        $self->redirect_to('/?error_confirm_email=1');
    }
}

1;

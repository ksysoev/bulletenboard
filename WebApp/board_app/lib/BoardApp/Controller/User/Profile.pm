package BoardApp::Controller::User::Profile;
use Mojo::Base 'Mojolicious::Controller';

sub Edit {
    my $self = shift;

    unless ( $self->session('auth') ) {
        $self->redirect_to('/login');
    }

    $self->render( template => "user/profile" )

}

sub Save {
    my $self = shift;

    unless ( $self->session('auth') ) {
        $self->redirect_to('/login');
    }

    my $users_coll = $self->coll('users');

    my $user = Class::User->new(
        name      => $self->param('name'),
        telephone => $self->param('telephone')
    );

    if (
        $users_coll->find( { telephone => $self->param('telephone') } )->count )
    {
        my $email_by_telephone = $users_coll->find_one(
            {
                telephone => $self->param('telephone')
            },
            { email => 1 }
        );
        unless ( $email_by_telephone->{email} eq $self->session('email') ) {
            $user->telephone_exist;
        }
    }

    if ( $user->status ) {

        $users_coll->update(
            { email  => $self->session('email') },
            { '$set' => { $user->update_profile } }
        );
        $self->session( $user->update_profile );
        $self->res->code(302);
        $self->redirect_to('/account/profile');
    }
    else {
        $self->stash( user => $user );
        $self->render( template => "user/profile" );
    }
}

1;

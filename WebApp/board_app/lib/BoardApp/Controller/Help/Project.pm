package BoardApp::Controller::Help::Project;
use Mojo::Base 'Mojolicious::Controller';

sub About {
    my $self = shift;
    $self->render('help/about');
}

1;

package BoardApp::Controller::General;
use Mojo::Base 'Mojolicious::Controller';

sub Main_Page {
    my $self = shift;
    $self->db('local');
    my $collection      = $self->coll('news');
    my $cursor          = $collection->find();
    my @news_collection = $cursor->all;
    my @news;
    foreach my $post_news (@news_collection) {
        my $post = Class::Post->new(
            Title   => $post_news->{title},
            Link    => $post_news->{link},
            Content => $post_news->{content},
            Date    => $post_news->{date}
        );
        push @news, $post;
    }
    $self->stash( news => [@news] );
    $self->render();
}


1;

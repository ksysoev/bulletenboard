package BoardApp::Controller::List::Show;
use Mojo::Base 'Mojolicious::Controller';

our %category_list = (
    all           => 'Все категории',
    transport     => 'Транспорт',
    real_estate   => 'Недвижимость',
    job           => 'Работа',
    service       => 'Услуги',
    paraphernalia => 'Личные вещи',
    home          => 'Для дома',
    electronics   => 'Бытовая электроника',
    hobbies       => 'Хобби и отдых',
    animals       => 'Животные',
    for_business  => 'Для бизнеса'
);

sub Show {
    my $self         = shift;
    my $adverts_coll = $self->coll('adverts');

    my @sort = ( last_change_date => -1 );
    @sort = ( price => 1, last_change_date => -1 )
      if ( $self->param('sort') and $self->param('sort') == 1 );
    @sort = ( price => -1, last_change_date => -1 )
      if ( $self->param('sort') and $self->param('sort') == 2 );

    my @query;
    @query = ( '$text' => { '$search' => $self->param('search') } )
      if ( $self->param('search') );

    push @query,
      category => $self->stash('category') || $self->param('category')
      if ( $self->stash('category') || $self->param('category') );
    push @query,
      subcategory => $self->stash('subcategory') || $self->param('subcategory')
      if ( $self->stash('subcategory') || $self->param('subcategory') );
    push @query, advert_param => $self->stash('advert_param')
      || $self->param('advert_param')
      if ( $self->stash('advert_param') || $self->param('advert_param') );

    my $adverts_count =
      $adverts_coll->find( { @query, status => 'public' } )->count;
    my $total_page = $adverts_count / $self->config('advert_per_page');
    $total_page++ if ( $adverts_count % $self->config('advert_per_page') ) > 0;

    my $pagination = Class::Pagination->new(
        page_id              => $self->stash('page_id'),
        total_page           => $total_page,
        url                  => $self->req->url->to_abs,
        pagination_max_pages => $self->config('pagination_max_pages')
    );

    $self->stash( pagination => $pagination );
    my $page_id = $pagination->get('page_id');

    my @adverts;
    my $cursor =
      $adverts_coll->find( { @query, status => 'public' } )->sort( {@sort} )
      ->limit($self->config('advert_per_page'))->skip( ( $page_id - 1 ) * $self->config('advert_per_page') );
    my @adverts_collection = $cursor->all;
    foreach my $advert (@adverts_collection) {
        push @adverts,
          Class::Advert->new(
            id                  => $advert->{_id},
            name                => $advert->{name},
            email               => $advert->{email},
            telephone           => $advert->{telephone},
            add_date            => $advert->{add_date},
            last_change_date    => $advert->{last_change_date},
            title               => $advert->{title},
            description         => $advert->{description},
            price               => $advert->{price},
            currency            => $advert->{currency},
            category            => $advert->{category},
            subcategory         => $advert->{subcategory},
            advert_param        => $advert->{advert_param},
            advert_sec_parametr => $advert->{advert_sec_parametr},
            images_dir          => $advert->{images_dir},
            images              => $advert->{images},
            images_min          => $advert->{images_min}
          );
    }

    $self->stash( category_name => $category_list{'all'} );
    $self->stash( category_name => $category_list{ $self->stash('category') } )
      if ( $self->stash('category') );
    $self->stash( category_name => $category_list{ $self->param('category') } )
      if ( $self->param('category') );

    $self->stash( adverts => [@adverts] );
    $self->render( template => "list/show" );
}

1;

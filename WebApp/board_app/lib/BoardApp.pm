package BoardApp;
use Mojo::Base 'Mojolicious';

use Class::User;
use Class::Advert;
use Class::Pagination;
use Class::Message;

use Email::Valid;
use Digest::SHA;

use Image::Imlib2;

use Data::Dumper;
my $DEBUG = 0;

# This method will run once at server start
sub startup {
    my $self = shift;
    $self->plugin('Config');
    $self->secrets( ['!Very*Storong*Secret*Key*2015!'] );
    $self->log(
        Mojo::Log->new(
            path  => $self->config('http_log'),
            level => $self->config('log_level')
        )
    );
    $self->log->on(
        message => sub {
            my ( $log, $level, @lines ) = @_;
            my $time = localtime;
            if ( $log->is_error or $log->is_warn or $log->is_info ) {
                print $time, " $level: ", @lines, "\n";
            }
            elsif ( $DEBUG and $log->debug ) {
                print $time, " $level: ", @lines, "\n";
            }
        }
    );
    $self->plugin(
        mail => {
            from     => $self->config('smtp_from'),
            encoding => 'base64',
            type     => 'multipart/mixed',
            how      => 'smtps',
            howargs  => [
                $self->config('smtp_host'),
                Port            => $self->config('smtp_port'),
                doSSL           => 'ssl',
                SSL_verify_mode => 'SSL_VERIFY_NONE',
                Debug           => 1
            ],
            AuthUser => $self->config('smtp_user'),
            AuthPass => $self->config('smtp_password')
        }
    );

    unless ( $self->config('mongodb_host') ) {
        $self->get_mongo_db_conf;
    }

    $self->plugin(
        'mongodb',
        {
            host   => $self->config('mongodb_host'),
            port   => $self->config('mongodb_port'),
            helper => 'db',
        }
    );
    $self->db( $self->config('mongodb_db_name') );

    my $r = $self->routes;

    #Опрации с пользователями
    $r->get('/registration')->to('User::Registration#Form');
    $r->post('/registration')->to('User::Registration#Add');
    $r->get('/emailconfirm')->to('User::Registration#Email_Confirm');

    $r->get('/login')->to('User::Login#Form');
    $r->post('/login')->to('User::Login#Login');
    $r->get('/logout')->to('User::Login#Logout');

    $r->get('/account/profile')->to('User::Profile#Edit');
    $r->post('/account/profile')->to('User::Profile#Save');

    $r->get('/account/password')->to('User::Password::Change#Edit');
    $r->post('/account/password')->to('User::Password::Change#Save');

    #Процедура восстановления пароля
    $r->get('/recovery')->to('User::Password::Recovery#Form');
    $r->post('/recovery')->to('User::Password::Recovery#Recovery');
    $r->get('/recovery/check')->to('User::Password::Recovery#Check');

    #Операции с объявлениями
    $r->get('/advert/add')->to('Advert::Add#Form');
    $r->post('/advert/add')->to('Advert::Add#Add');
    $r->get('/advert/preview/:advert_id')->to('Advert::Add#Preview');

    $r->get('/account/adverts')->to('Advert::Manage#List');
    $r->get('/account/adverts/:page_id')->to('Advert::Manage#List');

    $r->get('/advert/publish/:advert_id')->to('Advert::Manage#Publish');
    $r->get('/advert/unpublish/:advert_id')->to('Advert::Manage#Unpublish');

    $r->get('/advert/control/:advert_id')->to('Advert::Manage#Control');

    $r->get('/advert/remove/:advert_id')->to('Advert::Manage#Remove');

    $r->get('/advert/edit/:advert_id')->to('Advert::Edit#Form');
    $r->post('/advert/edit/:advert_id')->to('Advert::Edit#Save');

    $r->get('/advert/show/:advert_id')->to('Advert::Show#Show');

    $r->post('/advert/message/:advert_id')->to('Advert::Message#Send');
    $r->get('/advert/remove_message/:advert_id')->to('Advert::Message#Remove');
    $r->get('/account/messages')->to('Advert::Message#List');
    $r->get('/account/messages/page/:page_id')->to('Advert::Message#List');

    #Оперции со списком объявлений
    $r->get('/')->to('List::Show#Show');
    $r->get('/page/:page_id')->to('List::Show#Show');
    $r->get('/category/:category/')->to('List::Show#Show');
    $r->get('/category/:category/page/:page_id')->to('List::Show#Show');
    $r->get('/category/:category/:subcategory/')->to('List::Show#Show');
    $r->get('/category/:category/:subcategory/page/:page_id')
      ->to('List::Show#Show');
    $r->get('/category/:category/:subcategory/:advert_param')
      ->to('List::Show#Show');
    $r->get('/category/:category/:subcategory/:advert_param/page/:page_id')
      ->to('List::Show#Show');
    $r->get('/')->to('List::Show#Show');

    #Жалобы
    $r->get('/advert/report/sold/:advert_id')->to('Advert::Report#Sold');
    $r->get('/advert/report/wrong_price/:advert_id')
      ->to('Advert::Report#Wrong_Price');
    $r->get('/advert/report/do_not_call/:advert_id')
      ->to('Advert::Report#Do_Not_Call');
    $r->get('/advert/report/contacs_in_description/:advert_id')
      ->to('Advert::Report#Contacs_in_Description');
    $r->get('/advert/report/scam/:advert_id')->to('Advert::Report#Scam');
    $r->post('/advert/report/other/:advert_id')->to('Advert::Report#Other');

    #Помощь
    $r->get('/about')->to('Help::Project#About');

    $r->get('/test')->to('Advert::Admin#get_json');

}

sub get_mongo_db_conf {
    my $self        = shift;
    my $mongodbport = 'PORT_' . $self->config('mongodb_port') . '_TCP_ADDR';
    foreach ( keys(%ENV) ) {
        if (/$mongodbport/) {
            $self->config( mongodb_host => $ENV{$_} );
            return 0;
        }
    }
    $self->log->fatal('Не найден адрес базы данных');
}

1;

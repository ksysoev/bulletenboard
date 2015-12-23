package BoardApp::Controller::Advert::Admin;
use Mojo::Base 'Mojolicious::Controller';

sub get_json {
    my $self       = shift;
    my %classfieds = (
        all => {
            name => 'Все категории',
        },

        transport => {
            name        => 'Транспорт',
            subcategory => {
                all => {
                    name         => 'Все виды',
                    advert_param => {}
                },
                mopeds => {
                    name         => 'Мопеды',
                    advert_param => {
                        all => {
                            name                => 'Все виды',
                            advert_sec_parametr => {}
                        },
                        rent_out => {
                            name                => 'Сдать в аренду',
                            advert_sec_parametr => {
                                all => {
                                    name => 'Все виды'
                                },
                                long => {
                                    name => 'На длительный срок'
                                },
                                short => { name => 'Посуточно' }
                            }
                        },
                        take_off => {
                            name                => 'Взять в аренду',
                            advert_sec_parametr => {
                                all => {
                                    name => 'Все виды'
                                },
                                long => {
                                    name => 'На длительный срок'
                                },
                                short => { name => 'Посуточно' }
                            }
                        },
                        sell => {
                            name                => 'Продать',
                            advert_sec_parametr => {}
                        },
                        buy => {
                            name                => 'Купить',
                            advert_sec_parametr => {}
                        }
                    }
                },
                motorcycles => {
                    name         => 'Мотоциклы',
                    advert_param => {
                        all => {
                            name                => 'Все виды',
                            advert_sec_parametr => {}
                        },
                        rent_out => {
                            name                => 'Сдать в аренду',
                            advert_sec_parametr => {
                                all => {
                                    name => 'Все виды'
                                },
                                long => {
                                    name => 'На длительный срок'
                                },
                                short => { name => 'Посуточно' }
                            }
                        },
                        take_off => {
                            name                => 'Взять в аренду',
                            advert_sec_parametr => {
                                all => {
                                    name => 'Все виды'
                                },
                                long => {
                                    name => 'На длительный срок'
                                },
                                short => { name => 'Посуточно' }
                            }
                        },
                        sell => {
                            name                => 'Продать',
                            advert_sec_parametr => {}
                        },
                        buy => {
                            name                => 'Купить',
                            advert_sec_parametr => {}
                        }
                    }
                },
                cars => {
                    name         => 'Автомобили',
                    advert_param => {}
                },
                water_transport => {
                    name         => 'Водный транспорт',
                    advert_param => {}
                },
                parts_accessories => {
                    name         => 'Запчасти, аксессуары',
                    advert_param => {
                        all => {
                            name                => 'Все виды',
                            advert_sec_parametr => {}
                        },
                        parts => {
                            name                => 'Запчасти',
                            advert_sec_parametr => {}
                        },
                        accessories => {
                            name                => 'Аксессуары',
                            advert_sec_parametr => {}
                        },
                        trunks => {
                            name                => 'Багажники',
                            advert_sec_parametr => {}
                        },
                        instruments => {
                            name                => 'Иструменты',
                            advert_sec_parametr => {}
                        },
                        tuning => {
                            name                => 'Тюнинг',
                            advert_sec_parametr => {}
                        },
                        wheels => {
                            name                => 'Колеса',
                            advert_sec_parametr => {}
                        },
                        equipment => {
                            name                => 'Экипировка',
                            advert_sec_parametr => {}
                        }
                    }
                }
            }
        },
        real_estate => {
            name        => 'Недвижимость',
            subcategory => {
                all => {
                    name => 'Все виды',
                },
                houses_cottages => {
                    name         => 'Дома и коттеджи',
                    advert_param => {
                        all => {
                            name                => 'Все виды',
                            advert_sec_parametr => {}
                        },
                        rent_out => {
                            name                => 'Сдать',
                            advert_sec_parametr => {
                                all => {
                                    name => 'Все виды'
                                },
                                long => {
                                    name => 'На длительный срок'
                                },
                                short => { name => 'Посуточно' }
                            }
                        },
                        take_off => {
                            name                => 'Снять',
                            advert_sec_parametr => {
                                all => {
                                    name => 'Все виды'
                                },
                                long => {
                                    name => 'На длительный срок'
                                },
                                short => { name => 'Посуточно' }
                            }
                        },
                        sell => {
                            name                => 'Продать',
                            advert_sec_parametr => {}
                        },
                        buy => {
                            name                => 'Купить',
                            advert_sec_parametr => {}
                        }
                    }
                },
                apartments => {
                    name         => 'Квартиры',
                    advert_param => {
                        all => {
                            name                => 'Все виды',
                            advert_sec_parametr => {}
                        },
                        rent_out => {
                            name                => 'Сдать',
                            advert_sec_parametr => {
                                all => {
                                    name => 'Все виды'
                                },
                                long => {
                                    name => 'На длительный срок'
                                },
                                short => { name => 'Посуточно' }
                            }
                        },
                        take_off => {
                            name                => 'Снять',
                            advert_sec_parametr => {
                                all => {
                                    name => 'Все виды'
                                },
                                long => {
                                    name => 'На длительный срок'
                                },
                                short => { name => 'Посуточно' }
                            }
                        },
                        sell => {
                            name                => 'Продать',
                            advert_sec_parametr => {}
                        },
                        buy => {
                            name                => 'Купить',
                            advert_sec_parametr => {}
                        }
                    }
                },
                rooms => {
                    name         => 'Комнаты и номера',
                    advert_param => {
                        all => {
                            name                => 'Все виды',
                            advert_sec_parametr => {}
                        },
                        rent_out => {
                            name                => 'Сдать',
                            advert_sec_parametr => {
                                long => {
                                    all => {
                                        name => 'Все виды'
                                    },
                                    name => 'На длительный срок'
                                },
                                short => { name => 'Посуточно' }
                            }
                        },
                        take_off => {
                            name                => 'Снять',
                            advert_sec_parametr => {
                                all => {
                                    name => 'Все виды'
                                },
                                long => {
                                    name => 'На длительный срок'
                                },
                                short => { name => 'Посуточно' }
                            }
                        }
                    }
                },
                commercial => {
                    name => 'Комерческая недвижимость',
                    advert_param => {
                        all => {
                            name                => 'Все виды',
                            advert_sec_parametr => {}
                        },
                        rent_out => {
                            name                => 'Сдать',
                            advert_sec_parametr => {}
                        },
                        take_off => {
                            name                => 'Снять',
                            advert_sec_parametr => {}
                        },
                        sell => {
                            name                => 'Продать',
                            advert_sec_parametr => {}
                        },
                        buy => {
                            name                => 'Купить',
                            advert_sec_parametr => {}
                        }
                    }
                }
            }
        },
        job => {
            name        => 'Работа',
            subcategory => {
                all => {
                    name => 'Все виды',
                },
                vacancies => {
                    name         => 'Вакансии',
                    advert_param => {
                        all => {
                            name                => 'Все виды',
                            advert_sec_parametr => {}
                        },
                        it => {
                            name                => 'IT, интернет',
                            advert_sec_parametr => {}
                        },
                        cars => {
                            name => 'Автомобильный бизнес',
                            advert_sec_parametr => {}
                        },
                        management => {
                            name =>
                              'Административная работа',
                            advert_sec_parametr => {}
                        },
                        art => {
                            name =>
                              'Искусство и развлечения',
                            advert_sec_parametr => {}
                        },
                        counseling => {
                            name => 'Консультирование',
                            advert_sec_parametr => {}
                        },
                        pr => {
                            name => 'Маркетинг, реклама и PR',
                            advert_sec_parametr => {}
                        },
                        health => {
                            name =>
                              'Медицина, фармецевтика',
                            advert_sec_parametr => {}
                        },
                        education => {
                            name                => 'Образование',
                            advert_sec_parametr => {}
                        },
                        sale => {
                            name                => 'Продажи',
                            advert_sec_parametr => {}
                        },
                        tourism => {
                            name => 'Туризм, рестораны',
                            advert_sec_parametr => {}
                        },
                        fitness => {
                            name => 'Фитнес, салоны красоты',
                            advert_sec_parametr => {}
                        },
                        jurisprudence => {
                            name                => 'Юриспруденция',
                            advert_sec_parametr => {}
                        },
                        other => {
                            name                => 'Другое',
                            advert_sec_parametr => {}
                        }
                    }
                },
                cv => {
                    name         => 'Резюме',
                    advert_param => {
                        all => {
                            name                => 'Все виды',
                            advert_sec_parametr => {}
                        },
                        it => {
                            name                => 'IT, интернет',
                            advert_sec_parametr => {}
                        },
                        cars => {
                            name => 'Автомобильный бизнес',
                            advert_sec_parametr => {}
                        },
                        management => {
                            name =>
                              'Административная работа',
                            advert_sec_parametr => {}
                        },
                        art => {
                            name =>
                              'Искусство и развлечения',
                            advert_sec_parametr => {}
                        },
                        counseling => {
                            name => 'Консультирование',
                            advert_sec_parametr => {}
                        },
                        pr => {
                            name => 'Маркетинг, реклама и PR',
                            advert_sec_parametr => {}
                        },
                        health => {
                            name =>
                              'Медицина, фармецевтика',
                            advert_sec_parametr => {}
                        },
                        education => {
                            name                => 'Образование',
                            advert_sec_parametr => {}
                        },
                        sale => {
                            name                => 'Продажи',
                            advert_sec_parametr => {}
                        },
                        tourism => {
                            name => 'Туризм, рестораны',
                            advert_sec_parametr => {}
                        },
                        fitness => {
                            name => 'Фитнес, салоны красоты',
                            advert_sec_parametr => {}
                        },
                        jurisprudence => {
                            name                => 'Юриспруденция',
                            advert_sec_parametr => {}
                        },
                        other => {
                            name                => 'Другое',
                            advert_sec_parametr => {}
                        }
                    }
                }
            }
        },
        service => {
            name        => 'Услуги',
            subcategory => {
                all => {
                    name => 'Все виды',
                },
                offers => {
                    name         => 'Предложения',
                    advert_param => {
                        all => {
                            name                => 'Все виды',
                            advert_sec_parametr => {}
                        },
                        it => {
                            name                => 'IT, интернет',
                            advert_sec_parametr => {}
                        },
                        domestic => {
                            name => 'Бытовые услуги',
                            advert_sec_parametr => {}
                        },
                        business => {
                            name => 'Деловые услуги',
                            advert_sec_parametr => {}
                        },
                        art => {
                            name                => 'Искусство',
                            advert_sec_parametr => {}
                        },
                        health => {
                            name => 'Красота и здоровье',
                            advert_sec_parametr => {}
                        },
                        nannies => {
                            name                => 'Няни и сиделки',
                            advert_sec_parametr => {}
                        },
                        training => {
                            name => 'Обучение, курсы',
                            advert_sec_parametr => {}
                        },
                        eat => {
                            name                => 'Питание',
                            advert_sec_parametr => {}
                        },
                        holidays => {
                            name =>
                              'Праздники, мероприятия',
                            advert_sec_parametr => {}
                        },
                        pr => {
                            name => 'Реклама и полиграфия',
                            advert_sec_parametr => {}
                        },
                        repair => {
                            name                => 'Ремонт',
                            advert_sec_parametr => {}
                        },
                        animal => {
                            name => 'Уход за животными',
                            advert_sec_parametr => {}
                        },
                        photos => {
                            name => 'Фото и видеосъемка',
                            advert_sec_parametr => {}
                        },
                        other => {
                            name                => 'Другое',
                            advert_sec_parametr => {}
                        }
                    }
                },
                request => {
                    name         => 'Спрос',
                    advert_param => {
                        all => {
                            name                => 'Все виды',
                            advert_sec_parametr => {}
                        },
                        it => {
                            name                => 'IT, интернет',
                            advert_sec_parametr => {}
                        },
                        domestic => {
                            name => 'Бытовые услуги',
                            advert_sec_parametr => {}
                        },
                        business => {
                            name => 'Деловые услуги',
                            advert_sec_parametr => {}
                        },
                        art => {
                            name                => 'Искусство',
                            advert_sec_parametr => {}
                        },
                        health => {
                            name => 'Красота и здоровье',
                            advert_sec_parametr => {}
                        },
                        nannies => {
                            name                => 'Няни и сиделки',
                            advert_sec_parametr => {}
                        },
                        training => {
                            name => 'Обучение, курсы',
                            advert_sec_parametr => {}
                        },
                        eat => {
                            name                => 'Питание',
                            advert_sec_parametr => {}
                        },
                        holidays => {
                            name =>
                              'Праздники, мероприятия',
                            advert_sec_parametr => {}
                        },
                        pr => {
                            name => 'Реклама и полиграфия',
                            advert_sec_parametr => {}
                        },
                        repair => {
                            name                => 'Ремонт',
                            advert_sec_parametr => {}
                        },
                        animal => {
                            name => 'Уход за животными',
                            advert_sec_parametr => {}
                        },
                        photos => {
                            name => 'Фото и видеосъемка',
                            advert_sec_parametr => {}
                        },
                        other => {
                            name                => 'Другое',
                            advert_sec_parametr => {}
                        }
                    }
                }
            }
        },
        paraphernalia => {
            name        => 'Личные вещи',
            subcategory => {
                all => {
                    name => 'Все виды',
                },
                clothing => {
                    name => 'Одежда, обувь, аксессуары',
                    advert_param => {}
                },
                goods_for_children => {
                    name         => 'Товары для детей',
                    advert_param => {}
                },
                watches => {
                    name         => 'Часы и украшения',
                    advert_param => {}
                },
                health => {
                    name         => 'Красота и здоровье',
                    advert_param => {}
                }
              }

        },
        home => {
            name        => 'Для дома',
            subcategory => {
                all => {
                    name => 'Все виды',
                },
                appliances => {
                    name         => 'Бытовая техника',
                    advert_param => {}
                },
                furniture => {
                    name         => 'Мебель',
                    advert_param => {}
                },
                cookware => {
                    name => 'Посуда и товары для кухни',
                    advert_param => {}
                },
                foodstuffs => {
                    name         => 'Продукты питания',
                    advert_param => {}
                },
                plants => {
                    name         => 'Растения',
                    advert_param => {}
                }
              }

        },
        electronics => {
            name        => 'Бытовая электроника',
            subcategory => {
                all => {
                    name => 'Все виды',
                },
                audio_video => {
                    name         => 'Аудио и видео',
                    advert_param => {}
                },
                computer => {
                    name         => 'Компьютерная техника',
                    advert_param => {}
                },
                plates => {
                    name         => 'Планшеты',
                    advert_param => {}
                },
                phones => {
                    name         => 'Телефоны',
                    advert_param => {}
                },
                photo => {
                    name         => 'Фототехника',
                    advert_param => {}
                }
            }
        },
        hobbies => {
            name        => 'Хобби и отдых',
            subcategory => {
                all => {
                    name => 'Все виды',
                },
                tickets => {
                    name         => 'Билеты и путешествия',
                    advert_param => {}
                },
                bicycles => {
                    name         => 'Велосипеды',
                    advert_param => {}
                },
                books => {
                    name         => 'Книги и журналы',
                    advert_param => {}
                },
                musical => {
                    name => 'Музыкальные инструменты',
                    advert_param => {}
                },
                sport => {
                    name         => 'Спорт и отдых',
                    advert_param => {}
                }
              }

        },
        animals => {
            name        => 'Животные',
            subcategory => {
                all => {
                    name => 'Все виды',
                },
                dogs => {
                    name         => 'Собаки',
                    advert_param => {}
                },
                cats => {
                    name         => 'Кошки',
                    advert_param => {}
                },
                birds => {
                    name         => 'Птицы',
                    advert_param => {}
                },
                other => {
                    name         => 'Другие животные',
                    advert_param => {}
                },
                products_animals => {
                    name         => 'Товары для животных',
                    advert_param => {}
                }
              }

        },
        for_business => {
            name        => 'Для бизнеса',
            subcategory => {
                all => {
                    name => 'Все виды',
                },
                sale => {
                    name         => 'Готовый бизнес',
                    advert_param => {}
                },
                equipment => {
                    name => 'Оборудование для бизнеса',
                    advert_param => {}
                }
            }
        }
    );

    foreach my $category ( keys %classfieds ) {
        foreach
          my $subcategory ( keys %{ $classfieds{$category}{subcategory} } )
        {
            foreach my $advert_param (
                keys %{
                    $classfieds{$category}{subcategory}{$subcategory}
                      {advert_param}
                }
              )
            {

                foreach my $advert_sec_parametr (
                    keys %{
                        $classfieds{$category}{subcategory}{$subcategory}
                          {advert_param}{$advert_param}{advert_sec_parametr}
                    }
                  )
                {
                    my $advert_sec_parametr_name =
                      $classfieds{$category}->{subcategory}->{$subcategory}
                      ->{advert_param}->{$advert_param}->{advert_sec_parametr}
                      ->{$advert_sec_parametr}->{name};
                    $classfieds{$category}->{subcategory}->{$subcategory}
                      ->{advert_param}->{$advert_param}->{advert_sec_parametr}
                      ->{$advert_sec_parametr_name} =
                      $classfieds{$category}->{subcategory}->{$subcategory}
                      ->{advert_param}->{$advert_param}->{advert_sec_parametr}
                      ->{$advert_sec_parametr};
                    delete $classfieds{$category}->{subcategory}
                      ->{$subcategory}->{advert_param}->{$advert_param}
                      ->{advert_sec_parametr}->{$advert_sec_parametr};
                    $classfieds{$category}->{subcategory}->{$subcategory}
                      ->{advert_param}->{$advert_param}->{advert_sec_parametr}
                      ->{$advert_sec_parametr_name}->{name} =
                      $advert_sec_parametr;

                }

                my $advert_param_name =
                  $classfieds{$category}->{subcategory}->{$subcategory}
                  ->{advert_param}->{$advert_param}->{name};
                $classfieds{$category}->{subcategory}->{$subcategory}
                  ->{advert_param}->{$advert_param_name} =
                  $classfieds{$category}->{subcategory}->{$subcategory}
                  ->{advert_param}->{$advert_param};
                delete $classfieds{$category}->{subcategory}->{$subcategory}
                  ->{advert_param}->{$advert_param};
                $classfieds{$category}->{subcategory}->{$subcategory}
                  ->{advert_param}->{$advert_param_name}->{name} =
                  $advert_param;
            }
            my $subcategory_name =
              $classfieds{$category}->{subcategory}->{$subcategory}->{name};
            $classfieds{$category}->{subcategory}->{$subcategory_name} =
              $classfieds{$category}->{subcategory}->{$subcategory};
            delete $classfieds{$category}->{subcategory}->{$subcategory};
            $classfieds{$category}->{subcategory}->{$subcategory_name}->{name}
              = $subcategory;
        }
        my $category_name = $classfieds{$category}->{name};
        $classfieds{$category_name} = $classfieds{$category};
        delete $classfieds{$category};
        $classfieds{$category_name}->{name} = $category;
    }

    $self->render( json => {%classfieds} )

}

1;

$('.category li').click(function(e){
  e.preventDefault();
  var selected = $(this).text();
  $('#ddcategory').html(selected);
  $('#ddcategory-xs').html(selected);
  $('#ddsubcategory').html('Все виды');

  $('#subcategory').val('all');
  $('#advert-param').val('');

  $('#div-subcategory').show();
  $('#div-advert-parametr').hide();

  switch (selected){
    case "Все категории" :
      $('#category').val('all');
      $('#div-advert-parametr').hide();
      $('#div-subcategory').hide();
    break;

    case "Транспорт" :
      $('#category').val('transport');
      $('#subcategory-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>Мопеды</a></li>\
         <li><a>Мотоциклы</a></li>\
         <li><a>Автомобили</a></li>\
         <li><a>Водный транспорт</a></li>\
         <li><a>Запчасти, аксессуары</a></li>'); 
    break;

    case "Недвижимость" :
      $('#category').val('real_estate');
      $('#subcategory-menu').html(
        '<li><a>Все виды</a>\
         <li><a>Дома и коттеджи</a></li>\
         <li><a>Квартиры</a></li>\
         <li><a>Комнаты и номера</a></li>\
         <li><a>Комерческая недвижимость</a></li>'); 
    break;

    case "Работа" :
      $('#category').val('job');
      $('#subcategory-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>Вакансии</a></li>\
         <li><a>Резюме</a></li>'); 
    break;

    case "Услуги" :
      $('#category').val('service');
      $('#subcategory-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>Предложения</a></li>\
         <li><a>Спрос</a></li>'); 
    break;

    case "Личные вещи" :
      $('#category').val('paraphernalia');
      $('#subcategory-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>Одежда, обувь, аксессуары</a></li>\
         <li><a>Товары для детей</a></li>\
         <li><a>Часы и украшения</a></li>\
         <li><a>Красота и здоровье</a></li>'); 
    break;

    case "Для дома" :
      $('#category').val('home');
      $('#subcategory-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>Бытовая техника</a></li>\
         <li><a>Мебель</a></li>\
         <li><a>Посуда и товары для кухни</a></li>\
         <li><a>Продукты питания</a></li>\
         <li><a>Растения</a></li>'); 
    break;

    case "Бытовая электроника" :
      $('#category').val('electronics');
      $('#subcategory-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>Аудио и видео</a></li>\
         <li><a>Компьютерная техника</a></li>\
         <li><a>Планшеты</a></li>\
         <li><a>Телефоны</a></li>\
         <li><a>Фототехника</a></li>'); 
    break;

    case "Хобби и отдых" :
      $('#category').val('hobbies');
      $('#subcategory-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>Билеты и путешествия</a></li>\
         <li><a>Велосипеды</a></li>\
         <li><a>Книги и журналы</a></li>\
         <li><a>Музыкальные инструменты</a></li>\
         <li><a>Спорт и отдых</a></li>'); 
    break;

    case "Животные" :
      $('#category').val('animals');
      $('#subcategory-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>Собаки</a></li>\
         <li><a>Кошки</a></li>\
         <li><a>Птицы</a></li>\
         <li><a>Другие животные</a></li>\
         <li><a>Товары для животных</a></li>'); 
    break;

    case "Для бизнеса" :
      $('#category').val('for_business');
      $('#subcategory-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>Готовый бизнес</a></li>\
         <li><a>Оборудование для бизнеса</a></li>'); 
    break;
  }
});

$('#subcategory-menu').on('click', 'a',function(e){
  e.preventDefault();
  var selected = $(this).text();
  $('#ddsubcategory').html(selected);
  $('#ddparam').html('Все виды');

  $('#advert-param').val('');

  $('#div-advert-parametr').hide();

  switch (selected){
    case "Все категории" :
      $('#subcategory').val('all');
      $('#div-advert-parametr').hide();
    break;
    case "Запчасти, аксессуары" :
      $('#subcategory').val('parts_accessories');
      $('#advert-param').val('all');
      $('#div-advert-parametr').show();
      $('#advert-param-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>Запчасти</a></li>\
         <li><a>Аксессуары</a></li>\
         <li><a>Багажники</a></li>\
         <li><a>Иструменты</a></li>\
         <li><a>Тюнинг</a></li>\
         <li><a>Колеса</a></li>\
         <li><a>Экипировка</a></li>'); 
    break;
    case "Дома и коттеджи" :
      $('#subcategory').val('houses_cottages');
      $('#advert-param').val('all');
      $('#div-advert-parametr').show();
      $('#advert-param-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>Сдать</a></li>\
         <li><a>Снять</a></li>\
         <li><a>Продать</a></li>\
         <li><a>Купить</a></li>'); 
    break;
    case "Квартиры" :
      $('#subcategory').val('apartments');
      $('#advert-param').val('all');
      $('#div-advert-parametr').show();
      $('#advert-param-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>Сдать</a></li>\
         <li><a>Снять</a></li>\
         <li><a>Продать</a></li>\
         <li><a>Купить</a></li>'); 
    break;
    case "Комнаты и номера" :
      $('#subcategory').val('rooms');
      $('#advert-param').val('all');
      $('#div-advert-parametr').show();
      $('#advert-param-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>Сдать</a></li>\
         <li><a>Снять</a></li>'); 
    break;
    case "Комерческая недвижимость" :
      $('#subcategory').val('commercial');
      $('#advert-param').val('all');
      $('#div-advert-parametr').show();
      $('#advert-param-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>Сдать</a></li>\
         <li><a>Снять</a></li>\
         <li><a>Продать</a></li>\
         <li><a>Купить</a></li>'); 
    break;
    case "Вакансии" :
      $('#subcategory').val('vacancies');
      $('#advert-param').val('all');
      $('#div-advert-parametr').show();
      $('#advert-param-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>IT, интернет</a></li>\
         <li><a>Автомобильный бизнес</a></li>\
         <li><a>Административная работа</a></li>\
         <li><a>Искусство и развлечения</a></li>\
         <li><a>Консультирование</a></li>\
         <li><a>Маркетинг, реклама и PR</a></li>\
         <li><a>Медицина, фармецевтика</a></li>\
         <li><a>Образование</a></li>\
         <li><a>Продажи</a></li>\
         <li><a>Туризм, рестораны</a></li>\
         <li><a>Фитнес, салоны красоты</a></li>\
         <li><a>Юриспруденция</a></li>\
         <li><a>Другое</a></li>'); 
    break;
    case "Резюме" :
      $('#subcategory').val('cv');
      $('#advert-param').val('all');
      $('#div-advert-parametr').show();
      $('#advert-param-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>IT, интернет</a></li>\
         <li><a>Автомобильный бизнес</a></li>\
         <li><a>Административная работа</a></li>\
         <li><a>Искусство и развлечения</a></li>\
         <li><a>Консультирование</a></li>\
         <li><a>Маркетинг, реклама и PR</a></li>\
         <li><a>Медицина, фармецевтика</a></li>\
         <li><a>Образование</a></li>\
         <li><a>Продажи</a></li>\
         <li><a>Туризм, рестораны</a></li>\
         <li><a>Фитнес, салоны красоты</a></li>\
         <li><a>Юриспруденция</a></li>\
         <li><a>Другое</a></li>'); 
    break;
    case "Предложения" :
      $('#subcategory').val('offers');
      $('#advert-param').val('all');
      $('#div-advert-parametr').show();
      $('#advert-param-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>IT, интернет</a></li>\
         <li><a>Бытовые услуги</a></li>\
         <li><a>Деловые услуги</a></li>\
         <li><a>Искусство</a></li>\
         <li><a>Красота и здоровье</a></li>\
         <li><a>Няни и сиделки</a></li>\
         <li><a>Обучение, курсы</a></li>\
         <li><a>Питание</a></li>\
         <li><a>Праздники, мероприятия</a></li>\
         <li><a>Реклама и полиграфия</a></li>\
         <li><a>Ремонт</a></li>\
         <li><a>Уход за животными</a></li>\
         <li><a>Фото и видеосъемка</a></li>\
         <li><a>Другое</a></li>'); 
    break;
    case "Спрос" :
      $('#subcategory').val('request');
      $('#advert-param').val('all');
      $('#div-advert-parametr').show();
      $('#advert-param-menu').html(
        '<li><a>Все виды</a></li>\
         <li><a>IT, интернет</a></li>\
         <li><a>Бытовые услуги</a></li>\
         <li><a>Деловые услуги</a></li>\
         <li><a>Искусство</a></li>\
         <li><a>Красота и здоровье</a></li>\
         <li><a>Няни и сиделки</a></li>\
         <li><a>Обучение, курсы</a></li>\
         <li><a>Питание</a></li>\
         <li><a>Праздники, мероприятия</a></li>\
         <li><a>Реклама и полиграфия</a></li>\
         <li><a>Ремонт</a></li>\
         <li><a>Уход за животными</a></li>\
         <li><a>Фото и видеосъемка</a></li>\
         <li><a>Другое</a></li>'); 
    break;
    case "Мопеды" :
      $('#subcategory').val('mopeds');
    break;
    case "Мотоциклы" :
      $('#subcategory').val('motorcycles');
    break;
    case "Автомобили" :
      $('#subcategory').val('cars');
    break;
    case "Водный транспорт" :
      $('#subcategory').val('water_transport');
    break;
    case "Одежда, обувь, аксессуары" :
      $('#subcategory').val('clothing');
    break;
    case "Товары для детей" :
      $('#subcategory').val('goods_for_children');
    break;
    case "Часы и украшения" :
      $('#subcategory').val('watches');
    break;
    case "Красота и здоровье" :
      $('#subcategory').val('health');
    break;
    case "Бытовая техника" :
      $('#subcategory').val('appliances');
    break;
    case "Мебель" :
      $('#subcategory').val('furniture');
    break;
    case "Посуда и товары для кухни" :
      $('#subcategory').val('cookware');
    break;
    case "Продукты питания" :
      $('#subcategory').val('foodstuffs');
    break;
    case "Растения" :
      $('#subcategory').val('plants');
    break;
    case "Аудио и видео" :
      $('#subcategory').val('audio_video');
    break;
    case "Компьютерная техника" :
      $('#subcategory').val('computer');
    break;
    case "Планшеты" :
      $('#subcategory').val('plates');
    break;
    case "Телефоны" :
      $('#subcategory').val('phones');
    break;
    case "Фототехника" :
      $('#subcategory').val('photo');
    break;
    case "Билеты и путешествия" :
      $('#subcategory').val('tickets');
    break;
    case "Велосипеды" :
      $('#subcategory').val('bicycles');
    break;
    case "Книги и журналы" :
      $('#subcategory').val('books');
    break;
    case "Музыкальные инструменты" :
      $('#subcategory').val('musical');
    break;
    case "Спорт и отдых" :
      $('#subcategory').val('sport');
    break;
    case "Собаки" :
      $('#subcategory').val('dogs');
    break;
    case "Кошки" :
      $('#subcategory').val('cats');
    break;
    case "Птицы" :
      $('#subcategory').val('birds');
    break;
    case "Другие животные" :
      $('#subcategory').val('other');
    break;
    case "Товары для животных" :
      $('#subcategory').val('products_animals');
    break;
    case "Готовый бизнес" :
      $('#subcategory').val('sale');
    break;
    case "Оборудование для бизнеса" :
      $('#subcategory').val('equipment');
    break;
  }
});

$('#advert-param-menu').on('click', 'a',function(e){
  e.preventDefault();
  var selected = $(this).text();
  $('#ddparam').html(selected);

  switch (selected){
    case "Все виды" :
      $('#advert-param').val('all');

    break;
    case "Запчасти" :
      $('#advert-param').val('parts');
    break;
    case "Аксессуары" :
      $('#advert-param').val('accessories');
    break;
    case "Багажники" :
      $('#advert-param').val('trunks');
    break;
    case "Иструменты" :
      $('#advert-param').val('instruments');
    break;
    case "Тюнинг" :
      $('#advert-param').val('tuning');
    break;
    case "Колеса" :
      $('#advert-param').val('wheels');
    break;
    case "Экипировка" :
      $('#advert-param').val('equipment');
    break;
    case "Сдать" :
      $('#advert-param').val('rent_out');
    break;
    case "Снять" :
      $('#advert-param').val('take_off');
    break;
    case "Продать" :
      $('#advert-param').val('sell');
    break;
    case "Купить" :
      $('#advert-param').val('buy');
    break;
    case "IT, интернет" :
      $('#advert-param').val('it');
    break;
    case "Автомобильный бизнес" :
      $('#advert-param').val('cars');
    break;
    case "Административная работа" :
      $('#advert-param').val('management');
    break;
    case "Искусство и развлечения" :
      $('#advert-param').val('art');
    break;
    case "Консультирование" :
      $('#advert-param').val('counseling');
    break;
    case "Маркетинг, реклама и PR" :
      $('#advert-param').val('pr');
    break;
    case "Медицина, фармецевтика" :
      $('#advert-param').val('health');
    break;
    case "Образование" :
      $('#advert-param').val('education');
    break;
    case "Продажи" :
      $('#advert-param').val('sale');
    break;
    case "Туризм, рестораны" :
      $('#advert-param').val('tourism');
    break;
    case "Фитнес, салоны красоты" :
      $('#advert-param').val('fitness');
    break;
    case "Юриспруденция" :
      $('#advert-param').val('jurisprudence');
    break;
    case "Другое" :
      $('#advert-param').val('other');
    break;
    case "IT, интернет" :
      $('#advert-param').val('it');
    break;
    case "Бытовые услуги" :
      $('#advert-param').val('domestic');
    break;
    case "Деловые услуги" :
      $('#advert-param').val('business');
    break;
    case "Искусство" :
      $('#advert-param').val('art');
    break;
    case "Красота и здоровье" :
      $('#advert-param').val('health');
    break;
    case "Няни и сиделки" :
      $('#advert-param').val('nannies');
    break;
    case "Обучение, курсы" :
      $('#advert-param').val('training');
    break;
    case "Питание" :
      $('#advert-param').val('eat');
    break;
    case "Праздники, мероприятия" :
      $('#advert-param').val('holidays');
    break;
    case "Реклама и полиграфия" :
      $('#advert-param').val('pr');
    break;
    case "Ремонт" :
      $('#advert-param').val('repair');
    break;
    case "Уход за животными" :
      $('#advert-param').val('animal');
    break;
    case "Фото и видеосъемка" :
      $('#advert-param').val('photos');
    break;
  }

});

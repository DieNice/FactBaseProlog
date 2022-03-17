/* Запуск программы */
run:-
     retractall(iron/3),
     consult('db.txt'),
     menu.

/* Формирование меню */
menu:-
      repeat,
          write('-----------------------'),nl,nl,
      write('База данных о металлах'),nl,nl,
      write('1–Просмотр базы'),nl,
      write('2–Добавить новый вид металла'),nl,
      write('3-Удалить вид металла'),nl,
      write('4-Сохранить базу в файл'),nl,
      write('5-Поиск металла с минимальной удельной проводимостью'),nl,
      write('6–Выход'),nl,
          write('--------------------------------'),nl,
      write('Выберите пункт меню: (1-6) '),
      read(X),
      X<7,
      process(X),
      X=6,!.

process(1):-view_iron.
process(2):-add_iron,!.
process(3):-remove_iron,!.
process(4):-db_save_iron,!.
process(5):-find_iron,!.
process(6):-retractall(iron/3),!.

/* Чтение файла и просмотр базы данных */
view_iron:-
                iron(Iron,Provod,Price),
                write('Наименование металла: '), write(Iron),nl,
                write('Удельная проводимость металла: '), write(Provod),nl,
                write('Стоимость металла: '), write(Price),nl,
                write('-------------------------------'),nl.

/* Добавление вида металла*/
add_iron:-
        write('Добавить металл:'),nl,nl,
        write('Наименование металла: '),
        read(Iron),
        write('Удельная проводимость металла: '),
        read(Provod),
        write('Стоимость металла: '),
        read(Price),
        assertz(iron(Iron,Provod,Price)),
        quest,!.

quest:-
       write('Ввести еще один вид металла? y/n '),
       read(A),
       answer(A).

answer(_):-fail.
answer(y):-fail.
answer(n).

/* Сохранение динамической БД в файл */
db_save_iron:-
        tell('db.txt'),
        listing(iron),
        told,
        write('Файл базы дынных db.txt сохранен!').

/* Удаление вида металла*/
remove_iron:-
           write('Удаление вида металла'),nl,nl,
           write('Введите вид металла: '),
           read(Iron),
           retract(iron(Iron,_,_)),
           write('Вид удален!'),nl,nl.

/* Поиск металла по условию */
find_iron:-
           findall(Provod,iron(Iron,Provod,Price),Sp),
           min(Sp,Rezult),
           iron(Iron,Provod,Price),
           Provod = Rezult,
           write('Наименование металла: '), write(Iron),nl,
           write('Удельная проводимость металла: '), write(Provod),nl,
           write('Стоимость металла: '), write(Price),nl,
           write('-------------------------------'),nl,
           fail.

/* Поиск минимального элемента */
min([Head|Tail],Rezult):-min(Tail,Rezult),Rezult < Head,!.
min([Head|_],Head).
% тестовая база фактов
%
:- dynamic(base1/3).

% соответствия файлов
%
% входной файл в формате CSV
file(base1, csv, '/home/pda/Documents/Projects/Prolog/FactBaseProlog/src/file1.csv').
% база фактов
file(base1, base, '/home/pda/Documents/Projects/Prolog/FactBaseProlog/src/file1.pl').

% импорт из csv файла и обработка
%
import_base:-
    % найти имя файла
    file(base1, csv, File),
    % импорт из файла c разделителем ";" в список [row(..., ..., ...), ...]
    csv_read_file(File, RowList, [ separator(;)]),
    % -- очистить базу
    abolish(base1/3),
    % обработать и добавить факты
    perform_row1(RowList),!.

% обработка списка и добавление фактов
%
% список пуст - закончить поиск.

perform_row([]).
% выбрать голову списка
perform_row([row(N1, N2, _, N3,_)|T]):-
    % добавить факт, только нужные поля
    assert(base1(N1,N2,N3)),
    !,
    % обработать хвост списка
    perform_row(T).

% альтернативный вариант обработки списков
% 
perform_row1(RowList):-
    % выполнить для всех альтернатив поиска: найти все элементы списка
    forall(member(row(N1, N2, _, N3,_),RowList),
          % добавить факт
          assert(base1(N1,N2,N3))).

% сохранить базу в файле
%
save_base:-
    % найти имя файла
    file(base1, base, F),
    % открыть файл, установить стандартный поток вывода в файл
    tell(F),
    % выполнить для всех альтернатив поиска: найти все факты
    forall( base1(N1,N2,N3),
        % печать факта
        (writeq( base1(N1,N2,N3)), write('.'), nl)
        ),
    told.

% загрузить базу фактов
%
load_base:-
    % найти файл
    file(base1, base, File),
    % загрузить
    consult(File).
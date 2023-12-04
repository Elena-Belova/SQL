TASK 2
-- База данных «Интернет-магазин книг» - запросы корректировки

/* Создать таблицу author заданной структуры: */
CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author	VARCHAR(50));
	
/* Заполнить таблицу author, включить следующих авторов: Булгаков М.А., Достоевский Ф.М.,
Есенин С.А., Пастернак Б.Л.*/
INSERT INTO author(name_author)
VALUES ('Булгаков М.А.'),
       ('Достоевский Ф.М.'),
       ('Есенин С.А.'),
       ('Пастернак Б.Л.');

/* Перепишите запрос на создание таблицы book, чтобы ее структура соответствовала структуре,
 показанной на логической схеме. Для genre_id ограничение о недопустимости 
 пустых значений не задавать. В качестве главной таблицы для описания поля  
 genre_id использовать таблицу genre заданной структуры */
 CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id),
    FOREIGN KEY (genre_id)   REFERENCES genre (genre_id));

/* Создать таблицу book, чтобы ее структура соответствовала структуре на логической схеме. 
Для genre_id ограничение о недопустимости пустых значений не задавать. В качестве главной таблицы 
для описания поля genre_id использовать таблицу genre заданной структуры. При удалении автора из таблицы author, 
должны удаляться все записи о книгах из таблицы book, написанные этим автором, при удалении жанра из таблицы genre 
для соответствующей записи book установить значение Null в столбце genre_id.  */
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(50), 
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8,2), 
    amount INT, 
    FOREIGN KEY (author_id)  REFERENCES author (author_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id)   REFERENCES genre (genre_id)   ON DELETE SET NULL);

/* Добавьте три последние записи (с ключевыми значениями 6, 7, 8) в таблицу book */
INSERT INTO book(title, author_id, genre_id, price, amount)
VALUES ('Стихотворения и поэмы', 3, 2, 650.00, 15),
       ('Черный человек', 3, 2, 570.20, 6),
       ('Лирика', 4, 2, 518.99, 2);
	   
/* Для книг, которые уже есть на складе (в таблице book), но по другой цене, чем в поставке (supply),
необходимо в таблице book увеличить количество на значение, указанное в поставке, и пересчитать цену,
в таблице supply обнулить количество этих книг */
UPDATE book 
       JOIN author 
	   ON author.author_id = book.author_id
       JOIN supply 
	   ON book.title = supply.title 
       AND supply.author = author.name_author
   SET book.price = (book.price * book.amount + supply.price * supply.amount)/(book.amount + supply.amount),
       book.amount = book.amount + supply.amount,
       supply.amount = 0   
 WHERE book.price != supply.price;

/* Включить новых авторов в таблицу author с помощью запроса на добавление, а затем вывести все данные из таблицы author. 
Новыми считаются авторы, которые есть в таблице supply, но нет в таблице author */
INSERT INTO author(name_author)
SELECT supply.author
  FROM author 
       RIGHT JOIN supply 
       ON author.name_author = supply.author
 WHERE name_author IS Null;

/* Добавить новые записи о книгах, которые есть в таблице supply и нет в таблице book. Поскольку в таблице supply не 
 указан жанр книги, оставить его пустым. Добавить новые книги из таблицы supply в таблицу book */
INSERT INTO book(title, author_id, price, amount)
SELECT title, author_id, price, amount
  FROM author 
       JOIN supply 
       ON author.name_author = supply.author
 WHERE amount <> 0;

/* Занести для книги «Стихотворения и поэмы» Лермонтова жанр «Поэзия», для книги «Остров сокровищ» Стивенсона 
- «Приключения»,(использовать два запроса)*/
UPDATE book
   SET genre_id = 
       (SELECT genre_id 
          FROM genre 
         WHERE name_genre = 'Поэзия')
 WHERE book_id = 10;

UPDATE book
   SET genre_id = 
       (SELECT genre_id 
          FROM genre 
         WHERE name_genre = 'Приключения')
 WHERE book_id = 11;

/* Удалить всех авторов и все их книги, общее количество книг которых меньше 20. Для подсчета количества книг 
каждого автора используйте вложенный запрос */
DELETE FROM author
 WHERE author_id IN 
       (SELECT author_id
          FROM book
         GROUP BY author_id
        HAVING SUM(amount) < 20);

/* Удалить все жанры, к которым относится меньше 4-х наименований книг. В таблице book для этих жанров установить значение Null.*/
DELETE FROM genre
 WHERE genre_id IN
       (SELECT genre_id
          FROM book
         GROUP BY genre_id
        HAVING COUNT(title) <4);

/* Удалить всех авторов, которые пишут в жанре "Поэзия". Из таблицы book удалить все книги этих авторов. 
В запросе для отбора авторов использовать полное название жанра, а не его id. */
DELETE FROM author
 USING author 
       JOIN book ON author.author_id = book.author_id
       JOIN genre ON genre.genre_id = book.genre_id
WHERE name_genre = 'Поэзия';


/* Включить нового человека в таблицу с клиентами. Его имя Попов Илья, его email popov@test, проживает он в Москве.*/
INSERT INTO client(name_client, city_id, email) 
SELECT 'Попов Илья', city_id, 'popov@test'
  FROM city
 WHERE city_id = 1;

/* Создать новый заказ для Попова Ильи. Его комментарий для заказа: «Связаться со мной по вопросу доставки».*/
INSERT INTO buy(buy_description, client_id) 
SELECT 'Связаться со мной по вопросу доставки', client_id
  FROM client
 WHERE name_client = 'Попов Илья';

/* В таблицу buy_book добавить заказ с номером 5. Этот заказ должен содержать книгу Пастернака «Лирика» 
в количестве двух экземпляров и книгу Булгакова «Белая гвардия» в одном экземпляре. 
Для вставки каждой книги используйте отдельный запрос. */
INSERT INTO buy_book(buy_id, book_id, amount)
SELECT 5, book_id, 2
  FROM book
       INNER JOIN author
       ON book.author_id = author.author_id
 WHERE name_author = 'Пастернак Б.Л.'
   AND book.title = 'Лирика';

INSERT INTO buy_book(buy_id, book_id, amount)
SELECT 5, book_id, 1
  FROM book
       INNER JOIN author
       ON book.author_id = author.author_id
 WHERE name_author = 'Булгаков М.А.'
   AND book.title = 'Белая гвардия';

/* Количество тех книг на складе, которые были включены в заказ с номером 5, уменьшить на то количество, 
которое в заказе с номером 5 указано */
UPDATE book, buy_book
   SET book.amount = book.amount - buy_book.amount
 WHERE book.book_id = buy_book.book_id
   AND buy_book.buy_id = 5;

/* Создать счет (таблицу buy_pay) на оплату заказа с номером 5, в который включить 
название книг, их автора, цену, количество заказанных книг и стоимость. Последний столбец назвать Стоимость. 
Информацию в таблицу занести в отсортированном по названиям книг виде */
CREATE TABLE buy_pay AS
SELECT book.title, author.name_author, book.price, buy_book.amount, 
       book.price * buy_book.amount AS 'Стоимость'
  FROM book
       INNER JOIN author 
	   ON book.author_id = author.author_id
       INNER JOIN buy_book 
	   ON book.book_id = buy_book.book_id
 WHERE buy_book.buy_id = 5
 ORDER BY book.title;

/* Создать общий счет (таблицу buy_pay) на оплату заказа с номером 5. Куда включить номер заказа, 
количество книг в заказе (название столбца Количество) и его общую стоимость (название столбца Итого) */
CREATE TABLE buy_pay AS
    SELECT buy_book.buy_id, 
	       SUM(buy_book.amount) AS 'Количество', 
           SUM(book.price * buy_book.amount) AS 'Итого'
      FROM buy_book
           INNER JOIN book 
		   ON buy_book.book_id = book.book_id
     WHERE buy_book.buy_id = 5
     GROUP BY buy_book.buy_id;

/* В таблицу buy_step для заказа с номером 5 включить все этапы из таблицы step, 
которые должен пройти этот заказ. В столбцы date_step_beg и date_step_end всех записей занести Null.*/
INSERT INTO buy_step(buy_id, step_id)
SELECT buy.buy_id, step.step_id
  FROM buy
       CROSS JOIN step
 WHERE buy.buy_id = 5
 ORDER BY buy.buy_id, step.step_id;

/* В таблицу buy_step занести дату 12.04.2020 выставления счета на оплату заказа с номером 5 */
UPDATE buy_step
   SET date_step_beg = '2020.04.12'
 WHERE buy_id = 5
   AND step_id = 1;

/* Завершить этап «Оплата» для заказа с номером 5, вставив в столбец date_step_end дату 13.04.2020, 
и начать следующий этап («Упаковка»), задав в столбце date_step_beg для этого этапа ту же дату.
Реализовать два запроса для завершения этапа и начала следующего */
UPDATE buy_step
   SET date_step_end = '2020.04.13'
 WHERE buy_id = 5
   AND step_id = 1;
  
UPDATE buy_step
   SET date_step_beg = '2020.04.13'
 WHERE buy_id = 5
   AND step_id = 2;

/* Необходимо узнать на каком сейчас этапе все незавершённые заказы. Создать таблицу step_now 
с указанием Имени клиента, даты текущего этапа и названия этапа */
CREATE TABLE step_now AS
    SELECT client.name_client, buy_step.date_step_beg, step.name_step
      FROM buy_step
           INNER JOIN step USING (step_id)
           INNER JOIN buy USING (buy_id)
           INNER JOIN client USING (client_id)
     WHERE date_step_end IS NULL 
       AND date_step_beg IS NOT NULL;
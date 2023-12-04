TASK 1
-- База данных «Интернет-магазин книг» - запросы на выборку

/* Вывести название, жанр и цену тех книг,количество которых больше 8, в отсортированном по убыванию цены виде */
SELECT title, name_genre, price
  FROM book
       INNER JOIN genre
       ON book.genre_id = genre.genre_id
 WHERE amount > 8
 ORDER BY price DESC;

/* Вывести все жанры, которые не представлены в книгах на складе */
SELECT name_genre
  FROM genre 
       LEFT JOIN book
       ON genre.genre_id = book.genre_id
 WHERE book.title IS NULL;

/* Есть список городов, хранящийся в таблице city: Необходимо в каждом городе провести выставку книг каждого автора 
в течение 2020 года. Дату проведения выставки выбрать случайным образом. Создать запрос, который выведет город, автора 
и дату проведения выставки. Последний столбец назвать Дата. Информацию вывести, отсортировав сначала в алфавитном 
порядке по названиям городов, а потом по убыванию дат проведения выставок */
SELECT name_city AS 'Город', 
       name_author AS 'Автор',
       DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND() * 365) DAY) AS 'Дата'
  FROM city 
       CROSS JOIN author
 ORDER BY 1, 3 DESC;

/* Вывести информацию о книгах (жанр, книга, автор), относящихся к жанру, включающему слово «роман» 
в отсортированном по названиям книг виде */
SELECT name_genre, title, name_author
  FROM author 
       INNER JOIN book 
	   ON author.author_id = book.author_id
       INNER JOIN genre 
	   ON genre.genre_id = book.genre_id
 WHERE name_genre = "Роман" 
 ORDER BY title;

/* Посчитать количество экземпляров  книг каждого автора из таблицы author. Вывести тех авторов, 
количество книг которых меньше 10, в отсортированном по возрастанию количества виде. 
Последний столбец назвать Количество */
SELECT name_author, 
       SUM(amount) AS 'Количество' 
  FROM author 
       LEFT JOIN book
       ON author.author_id = book.author_id
 GROUP BY name_author
HAVING SUM(amount) <10
    OR COUNT(title) = 0
 ORDER BY 'Количество';

/* Вывести в алфавитном порядке всех авторов, которые пишут только в одном жанре */
SELECT name_author
  FROM author
       INNER JOIN book
       ON author.author_id = book.author_id
 GROUP BY name_author
HAVING COUNT(DISTINCT genre_id) =1;

/* Вывести информацию о книгах (название книги, фамилию и инициалы автора, название жанра,цену и 
количество экземпляров книги), написанных в самых популярных жанрах, в отсортированном в алфавитном порядке 
по названию книг виде. Самым популярным считать жанр, общее количество экземпляров книг которого на складе максимально */
SELECT title, name_author, name_genre, price, amount
  FROM author 
       INNER JOIN book 
	   ON author.author_id = book.author_id
       INNER JOIN genre 
	   ON  book.genre_id = genre.genre_id
 WHERE genre.genre_id IN
                        (SELECT query_in_1.genre_id
                           FROM 
                                (SELECT genre_id, SUM(amount) AS sum_amount
                                   FROM book
                                  GROUP BY genre_id) query_in_1
                                INNER JOIN
                                (SELECT genre_id, SUM(amount) AS sum_amount
                                   FROM book
                                  GROUP BY genre_id
                                  ORDER BY sum_amount DESC
                                  LIMIT 1) query_in_2
                                ON query_in_1.sum_amount = query_in_2.sum_amount)
 ORDER BY title;

/* Если в таблицах supply и book есть одинаковые книги, которые имеют равную цену, вывести их название 
и автора,посчитать общее количество экземпляров книг в таблицах supply и book, столбцы назвать Название, Автор и Количество */
SELECT book.title AS 'Название', 
       name_author AS 'Автор',
       supply.amount + book.amount AS 'Количество'
  FROM book
       JOIN author 
       USING (author_id)   
       JOIN supply 
       ON book.title = supply.title 
       AND author.name_author = supply.author
       AND book.price = supply.price; 

/* Нужно разослать книги по книжным магазинам в города из таблицы city. Книги распределяем пропорционально: 
в Москву 50%, в Санкт-Петербург 30%, во Владивосток 20%. Вывести город, названия книг, имена авторов 
и количество книг к отправке. Отсортировать по городу, потом по названию книги */
SELECT name_city AS 'Город',
       book.title AS 'Название',
       author.name_author AS 'Автор',
       ROUND(IF(name_city = 'Москва', book.amount * 0.5, 
                IF(name_city = 'Санкт-Петербург', book.amount * 0.3, book.amount * 0.2)))
                AS 'К_отправке'
  FROM city
       CROSS JOIN book
       INNER JOIN author
       ON book.author_id = author.author_id
 ORDER BY 1, 2 ;

/* Вывести все заказы Баранова Павла (id заказа, какие книги, по какой цене и в каком количестве он заказал) в отсортированном 
по номеру заказа и названиям книг виде */
SELECT buy.buy_id, title, price, buy_book.amount
  FROM client
       JOIN buy 
	   ON client.client_id = buy.client_id
       JOIN buy_book 
	   ON buy_book.buy_id = buy.buy_id
       JOIN book 
	   ON buy_book.book_id = book.book_id
 WHERE client.name_client = 'Баранов Павел'
 ORDER BY buy.buy_id, title;

/* Посчитать, сколько раз была заказана каждая книга, для книги вывести ее автора (посчитать, в каком количестве
заказов фигурирует каждая книга), вывести фамилию и инициалы автора, название книги, последний столбец назвать 
 Количество. Результат отсортировать сначала по фамилиям авторов, потом по названиям книг */
SELECT name_author, title, 
       COUNT(buy_book.book_id) AS 'Количество'
  FROM author
       INNER JOIN book 
	   ON author.author_id = book.author_id
       LEFT JOIN buy_book 
	   ON buy_book.book_id = book.book_id
 GROUP BY name_author, title
 ORDER BY name_author, title;

/* Вывести города, в которых живут клиенты, оформлявшие заказы в интернет-магазине. Указать количество заказов 
в каждый город, этот столбец назвать Количество. Информацию вывести по убыванию количества заказов, затем в алфавитном порядке по названию городов */
SELECT name_city, 
       COUNT(buy.buy_id) AS 'Количество'
  FROM city
       JOIN client 
	   ON city.city_id = client.city_id
       JOIN buy 
	   ON client.client_id = buy.client_id
 GROUP BY name_city
 ORDER BY 'Количество', name_city;

/* Вывести номера всех оплаченных заказов и даты, когда они были оплачены */
SELECT buy_id, date_step_end
  FROM buy_step
 WHERE step_id = 1
   AND date_step_end IS NOT NULL;
  
/* Вывести информацию о каждом заказе: его номер, кто его сформировал (фамилия пользователя) и его стоимость, в отсортированном по номеру заказа виде.
Последний столбец назвать Стоимость */
SELECT buy.buy_id, client.name_client,
       SUM(book.price * buy_book.amount) AS 'Стоимость'
  FROM buy
       JOIN client
       ON buy.client_id = client.client_id
       JOIN buy_book
       ON buy.buy_id = buy_book.buy_id
	   JOIN book
       ON buy_book.book_id = book.book_id
 GROUP BY buy.buy_id;

/* Вывести номера заказов (buy_id) и названия этапов, на которых они в данный момент находятся. Если заказ доставлен
 – информацию о нем не выводить. Информацию отсортировать по возрастанию buy_id. Текущим считается тот этап, 
для которого заполнена дата начала этапа и не заполнена дата его окончания */
SELECT buy_id, name_step
  FROM buy_step
       JOIN step
       ON buy_step.step_id = step.step_id
 WHERE date_step_beg IS NOT NULL
   AND date_step_end IS NULL
 ORDER BY buy_id;
 
/* В таблице city для каждого города указано количество дней, за которые заказ может быть доставлен 
в этот город (рассматривается только этап Транспортировка). Для тех заказов, которые прошли этап транспортировки,
вывести количество дней за которое заказ реально доставлен в город. А также,если заказ доставлен с опозданием, 
указать количество дней задержки, в противном случае вывести 0. В результат включить номер заказа (buy_id),
вычисляемые столбцы Количество_дней и Опоздание. Информацию вывести в отсортированном по номеру заказа виде. */
SELECT buy_step.buy_id, 
       DATEDIFF(date_step_end, date_step_beg) AS 'Количество_дней',
       IF(DATEDIFF(date_step_end, date_step_beg) > city.days_delivery, 
          DATEDIFF(date_step_end, date_step_beg) - city.days_delivery, 0) AS 'Опоздание'
  FROM buy_step
       JOIN buy
       ON buy_step.buy_id = buy.buy_id
       JOIN client
       ON buy.client_id = client.client_id
       JOIN city
       ON client.city_id = city.city_id    
 WHERE step_id = 3
   AND date_step_end IS NOT NULL
 ORDER BY buy_step.buy_id;

/* Выбрать всех клиентов, которые заказывали книги Достоевского, информацию вывести в отсортированном по алфавиту виде. 
В решении используйте фамилию автора, а не его id.*/
SELECT name_client 
  FROM client
       JOIN buy
       ON client.client_id = buy.client_id
       JOIN buy_book
       ON buy.buy_id = buy_book.buy_id
       JOIN book
       ON buy_book.book_id = book.book_id
       JOIN author
       ON book.author_id = author.author_id
 WHERE name_author LIKE "%Достоевский%"
 GROUP BY name_client
 ORDER BY name_client;
 
/* Вывести жанр (или жанры), в котором было заказано больше всего экземпляров книг, указать это количество. 
Последний столбец назвать Количество.*/
SELECT name_genre, 
       SUM(buy_book.amount) AS 'Количество'
  FROM genre
       INNER JOIN book 
	   ON genre.genre_id = book.genre_id
       INNER JOIN buy_book 
	   ON book.book_id = buy_book.book_id
 GROUP BY name_genre
HAVING SUM(buy_book.amount) = 
          (SELECT MAX(sum_amount) AS sum_amount       
             FROM
          (SELECT book.genre_id, SUM(buy_book.amount) AS sum_amount 
             FROM buy_book 
                  INNER JOIN book 
				  ON buy_book.book_id = book.book_id
                  GROUP BY book.genre_id) query_in);

/* Сравнить ежемесячную выручку от продажи книг за текущий и предыдущий годы. Для этого вывести год, месяц,
сумму выручки в отсортированном сначала по возрастанию месяцев, затем по возрастанию лет виде. 
Название столбцов: Год, Месяц, Сумма. Информация о продажах предыдущего года хранится в
 архивной таблице buy_archive, которая создается в конце года на основе информации из таблиц базы данных  */
SELECT YEAR(date_payment) AS 'Год',
       MONTHNAME(date_payment) AS 'Месяц',
       SUM(price * amount) AS 'Сумма'
  FROM buy_archive
 GROUP BY MONTHNAME(date_payment), YEAR(date_payment)

UNION 

SELECT YEAR(buy_step.date_step_end) AS 'Год',
       MONTHNAME(buy_step.date_step_end) AS 'Месяц',
       SUM(book.price * buy_book.amount) AS 'Сумма'
  FROM buy_step
       INNER JOIN buy_book 
	   ON buy_step.buy_id = buy_book.buy_id
       INNER JOIN book 
	   ON buy_book.book_id = book.book_id
 WHERE buy_step.date_step_end IS NOT Null 
   AND buy_step.step_id = 1
 GROUP BY MONTHNAME(buy_step.date_step_end), YEAR(buy_step.date_step_end)
 ORDER BY 2, 1

/* Для каждой отдельной книги необходимо вывести информацию о количестве проданных экземпляров и их стоимости за 2020 и 2019 год. 
Вычисляемые столбцы назвать Количество и Сумма. Информацию отсортировать по убыванию стоимости */
SELECT title,
       SUM(book_amount) AS 'Количество',
       SUM(price_sum) AS 'Сумма'
  FROM
       (SELECT book.title, 
               SUM(buy_book.amount) AS book_amount,
               SUM(book.price * buy_book.amount) AS price_sum
          FROM buy_book
               INNER JOIN book 
			   ON buy_book.book_id = book.book_id
               INNER JOIN buy_step 
			   ON buy_book.buy_id = buy_step.buy_id
         WHERE buy_step.date_step_end IS NOT Null 
           AND buy_step.step_id = 1
         GROUP BY book.title
         UNION
        SELECT book.title, 
               SUM(buy_archive.amount) AS book_amount,
               SUM(buy_archive.price * buy_archive.amount) AS price_sum
          FROM buy_archive
               INNER JOIN book 
			   ON buy_archive.book_id = book.book_id
         GROUP BY book.title) query_in
 GROUP BY title
 ORDER BY 3 DESC

/* Вывести названия книг, которые ни разу не были заказаны, отсортировав в алфавитном порядке */
SELECT book.title 
  FROM book
       LEFT JOIN buy_book 
	   ON book.book_id = buy_book.book_id
 WHERE buy_book.amount IS NULL
 ORDER BY 1;




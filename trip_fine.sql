TASK 1
-- Таблица "Командировки" - выборка данных

/* Вывести из таблицы trip информацию о командировках тех сотрудников, фамилия которых заканчивается 
на букву «а», в отсортированном по убыванию даты последнего дня командировки виде, в результат включить 
столбцы name, city, per_diem, date_first, date_last */
SELECT name, city, per_diem, date_first, date_last
  FROM trip
 WHERE name LIKE "%_а %"
 ORDER BY date_last DESC;

/* Вывести в алфавитном порядке фамилии и инициалы тех сотрудников,которые были в командировке в Москве */
SELECT name
  FROM trip
 WHERE city = 'Москва'
 GROUP BY name
 ORDER BY name;

/* Для каждого города посчитать, сколько раз сотрудники в нем были.Информацию вывести в отсортированном 
в алфавитном порядке по названию городов. Вычисляемый столбец назвать Количество */
SELECT city, 
       COUNT(city) AS 'Количество'
  FROM trip
 GROUP BY city
 ORDER BY city;

/* Вывести два города, в которых чаще всего были в командировках сотрудники. Вычисляемый столбец назвать Количество */
SELECT city, 
       COUNT(city) AS 'Количество'
  FROM trip
 GROUP BY city
 ORDER BY 'Количество' DESC
 LIMIT 2;

/* Вывести информацию о командировках во все города кроме Москвы и Санкт-Петербурга (фамилии и инициалы сотрудников, город,
длительность командировки в днях, при этом первый и последний день относится к периоду командировки). Последний столбец 
назвать Длительность. Информацию вывести в упорядоченном по убыванию длительности поездки, а потом по убыванию 
названий городов (в обратном алфавитном порядке) */
SELECT name, city,
       DATEDIFF(date_last, date_first) + 1 AS 'Длительность'
  FROM trip
 WHERE city NOT IN ('Москва', 'Санкт-Петербург')
 ORDER BY 'Длительность' DESC, city DESC;

/* Вывести информацию о командировках сотрудника(ов), которые были самыми короткими по времени. В результат включить 
столбцы name, city, date_first, date_last. */
SELECT name, city, date_first, date_last
  FROM trip
 WHERE DATEDIFF(date_last, date_first) IN 
              (SELECT MIN(DATEDIFF(date_last, date_first))
                 FROM trip);

/* Вывести информацию о командировках, начало и конец которых относятся к одному месяцу (год может быть любой). 
В результат включить столбцы name, city, date_first, date_last. Строки отсортировать сначала в алфавитном порядке 
по названию города, а затем по фамилии сотрудника */
SELECT name, city, date_first, date_last
  FROM trip
 WHERE MONTH(date_first) = MONTH(date_last)
 ORDER BY city, name;

/* Вывести название месяца и количество командировок для каждого месяца. Командировка относится к некоторому месяцу, 
если она началась в этом месяце. Информацию вывести сначала в отсортированном по убыванию количества, а потом в алфавитном
 порядке по названию месяца виде. Название столбцов – Месяц и Количество */
SELECT MONTHNAME(date_first) AS 'Месяц',
       COUNT(date_first) AS 'Количество' 
  FROM trip
 GROUP BY MONTHNAME(date_first)
 ORDER BY 'Количество' DESC, 'Месяц';

/* Вывести общую сумму суточных для командировок, первый день которых пришелся на февраль или март 2020 года. 
Значение суточных для каждой командировки занесено в столбец per_diem. Вывести фамилию и инициалы сотрудника,
город, первый день командировки и сумму суточных. Последний столбец назвать Сумма. Информацию отсортировать 
сначала в алфавитном порядке по фамилиям сотрудников, а затем по убыванию суммы суточных */
SELECT name, city, date_first,
       per_diem * (DATEDIFF(date_last, date_first) +1) AS 'Сумма' 
  FROM trip
  WHERE MONTH(date_first) IN (2, 3)
    AND YEAR(date_first) = 2020
  ORDER BY name, 'Сумма' DESC;

/* Вывести фамилию с инициалами и общую сумму суточных, полученных за все командировки для тех сотрудников, 
которые были в командировках больше чем 3 раза, в отсортированном по убыванию сумм суточных виде. Последний столбец назвать Сумма */
SELECT name, 
       SUM(per_diem * (DATEDIFF(date_last, date_first) +1)) AS 'Сумма'
  FROM trip
 WHERE name IN (SELECT name FROM trip
                 GROUP BY name
                HAVING COUNT(name) >3)
 GROUP BY name
 ORDER BY 'Сумма' DESC;


TASK 2
-- Таблица "Нарушения ПДД" - запросы корректировки

/* Создать таблицу fine заданной структуры: */
CREATE TABLE fine (
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    number_plate VARCHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8,2),
    date_violation DATE,
    date_payment DATE);

/* Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии 
с данными из таблицы traffic_violation. При этом суммы заносить только в пустые поля столбца sum_fine */
UPDATE fine AS f, traffic_violation AS tv
   SET f.sum_fine = tv.sum_fine
 WHERE f.violation = tv.violation
   AND f.sum_fine IS NULL;
  
/* Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили 
одно и то же правило два и более раз. При этом учитывать все нарушения, независимо от того оплачены они или нет.
Информацию отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по номеру машины и, наконец, по нарушению.*/
SELECT name, number_plate, violation
  FROM fine
 GROUP BY name, number_plate, violation
HAVING COUNT(*) >1
 ORDER BY name, number_plate, violation;

/* В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей */
UPDATE fine, 
       (SELECT name, number_plate, violation
          FROM fine
         GROUP BY name, number_plate, violation
        HAVING COUNT(*) >= 2) query_in
   SET fine.sum_fine = fine.sum_fine *2
 WHERE fine.name = query_in.name
   AND fine.number_plate = query_in.number_plate
   AND fine.violation = query_in.violation
   AND fine.date_payment IS NULL;

/* Водители оплачивают свои штрафы. В таблице payment занесены даты их оплаты. Необходимо: в таблицу fine 
занести дату оплаты соответствующего штрафа из таблицы payment; уменьшить начисленный штраф в таблице 
fine в два раза (только для тех штрафов, информация о которых занесена в таблицу payment), если оплата 
произведена не позднее 20 дней со дня нарушения */
UPDATE fine AS f, payment AS p
   SET f.date_payment = p.date_payment,
       f.sum_fine = IF(DATEDIFF(p.date_payment, p.date_violation)<=20, f.sum_fine/2, f.sum_fine)
 WHERE f.name = p.name
   AND f.number_plate = p.number_plate
   AND f.violation = p.violation
   AND f.date_payment IS NULL;

/* Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах (Фамилию и инициалы водителя, 
номер машины, нарушение, сумму штрафа, дату нарушения) из таблицы fine */
CREATE TABLE back_payment AS 
SELECT name, number_plate, violation, sum_fine, date_violation
  FROM fine
 WHERE date_payment IS NULL;

/* Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года */
DELETE FROM fine
 WHERE date_violation < '2020-02-01';




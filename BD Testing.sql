TASK 1
-- База данных «Тестирование» - запросы на выборку

/* Вывести студентов, которые сдавали дисциплину «Основы баз данных», указать дату попытки и результат. 
Информацию вывести по убыванию результатов тестирования.*/
SELECT name_student, date_attempt, result
  FROM attempt
       INNER JOIN student
       ON attempt.student_id = student.student_id
       INNER JOIN subject
       ON attempt.subject_id = subject.subject_id
 WHERE name_subject = 'Основы баз данных'
 ORDER BY result DESC;

/* Вывести,сколько попыток сделали студенты по каждой дисциплине, а также средний результат попыток, который округлить 
до 2 знаков после запятой. Под результатом попытки понимается процент правильных ответов на вопросы теста, 
который занесен в столбец result. В результат включить название дисциплины, вычисляемые столбцы Количество и Среднее. 
Информацию вывести по убыванию средних результатов */
SELECT name_subject, 
       COUNT(attempt_id) AS 'Количество',
       ROUND(AVG(result), 2) AS 'Среднее'
  FROM subject
       LEFT JOIN attempt
       ON subject.subject_id = attempt.subject_id
 GROUP BY name_subject
 ORDER BY 3 DESC;

/* Вывести студентов (различных студентов), имеющих максимальные результаты попыток. Информацию отсортировать 
в алфавитном порядке по фамилии студента. Максимальный результат не обязательно будет 100%, поэтому явно это значение в запросе не задавать. */
SELECT name_student, result
  FROM student
       INNER JOIN attempt 
	   ON student.student_id = attempt.student_id
 WHERE result = (SELECT MAX(result)
                   FROM attempt)
 ORDER BY name_student;

/* Если студент совершал несколько попыток по одной и той же дисциплине, то вывести разницу в днях между первой и 
последней попыткой. В результат включить фамилию и имя студента, название дисциплины и вычисляемый столбец Интервал.
Информацию вывести по возрастанию разницы. Студентов, сделавших одну попытку по дисциплине, не учитывать */
SELECT name_student, name_subject,
       DATEDIFF(MAX(date_attempt), MIN(date_attempt)) AS 'Интервал'
  FROM attempt
       INNER JOIN student 
	   ON attempt.student_id = student.student_id
       INNER JOIN subject 
	   ON attempt.subject_id = subject.subject_id
 GROUP BY name_student, name_subject
HAVING COUNT(attempt_id) > 1
 ORDER BY 3;

/* Студенты могут тестироваться по одной или нескольким дисциплинам (не обязательно по всем). Вывести дисциплину и 
количество уникальных студентов (столбец назвать Количество), которые по ней проходили тестирование. Информацию 
отсортировать сначала по убыванию количества, а потом по названию дисциплины. В результат включить и дисциплины, 
тестирование по которым студенты еще не проходили, в этом случае указать количество студентов 0. */
SELECT name_subject, 
       COUNT(DISTINCT(student_id)) AS 'Количество'
  FROM subject
       LEFT JOIN attempt 
	   ON subject.subject_id = attempt.subject_id
 GROUP BY name_subject
 ORDER BY 2 DESC, name_subject;

/* Случайным образом отберите 3 вопроса по дисциплине «Основы баз данных». В результат включите столбцы 
question_id и name_question */
SELECT question_id, name_question
  FROM question
       INNER JOIN subject 
	   ON question.subject_id = subject.subject_id
 WHERE subject.name_subject = 'Основы баз данных'
 ORDER BY RAND()
 LIMIT 3;

/* Вывести вопросы, которые были включены в тест для Семенова Ивана по дисциплине 
«Основы SQL» 2020-05-17 (значение attempt_id для этой попытки равно 7). Указать, какой ответ дал студент 
и правильный он или нет (вывести Верно или Неверно). В результат включить вопрос, ответ и вычисляемый столбец Результат */
SELECT name_question, name_answer,
       IF(is_correct = true, 'Верно', 'Неверно') AS 'Результат'
  FROM testing
       INNER JOIN question 
	   ON testing.question_id = question.question_id
       INNER JOIN answer 
	   ON testing.answer_id = answer.answer_id
 WHERE attempt_id = 7

/* Посчитать результаты тестирования. Результат попытки вычислить как количество правильных ответов, 
деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100. Результат округлить до двух 
знаков после запятой. Вывести фамилию студента, название предмета, дату и результат. Последний столбец назвать Результат.
Информацию отсортировать сначала по фамилии студента, потом по убыванию даты попытки */
SELECT name_student, name_subject, date_attempt,
       ROUND(SUM(is_correct)/3*100, 2) AS 'Результат'
  FROM answer
       JOIN testing 
	   ON answer.answer_id = testing.answer_id
       JOIN attempt 
	   ON testing.attempt_id = attempt.attempt_id
       JOIN subject 
	   ON attempt.subject_id = subject.subject_id     
       JOIN student 
	   ON attempt.student_id = student.student_id
 GROUP BY name_student, name_subject, date_attempt
 ORDER BY name_student, date_attempt DESC;

/* Для каждого вопроса вывести процент успешных решений, то есть отношение количества верных ответов 
к общему количеству ответов, значение округлить до 2-х знаков после запятой. Также вывести название предмета, к которому 
относится вопрос, и общее количество ответов на этот вопрос. В результат включить название дисциплины, 
вопросы по ней (столбец назвать Вопрос), а также два вычисляемых столбца Всего_ответов и Успешность. Информацию
отсортировать сначала по названию дисциплины, потом по убыванию успешности, а потом по тексту вопроса в алфавитном порядке.
Поскольку тексты вопросов могут быть длинными, обрезать их 30 символов и добавить многоточие "..." */
SELECT name_subject, 
       CONCAT(LEFT(name_question, 30), '...') AS 'Вопрос',
       COUNT(testing.answer_id) AS 'Всего_ответов',
       ROUND((SUM(answer.is_correct)/COUNT(testing.answer_id) * 100), 2) AS 'Успешность'
 FROM  testing
       JOIN answer 
	   ON testing.answer_id = answer.answer_id
       JOIN question 
	   ON testing.question_id = question.question_id
       JOIN subject 
	   ON question.subject_id = subject.subject_id
 GROUP BY name_subject, name_question
 ORDER BY name_subject, 4 DESC, name_question;

/* Сделать "шпаргалку" по всем предметам (для которых в базе есть вопросы) с ответами */
SELECT name_subject AS 'Предмет',
       LEFT(name_question, 40) AS 'Вопрос',
       LEFT(name_answer, 40) AS 'Ответ'
  FROM subject
       JOIN question ON subject.subject_id = question.subject_id
       JOIN answer ON question.question_id = answer.question_id
 WHERE is_correct = true
 ORDER BY name_subject, 2;

TASK 2
-- База данных «Тестирование» - запросы корректировки

/* В таблицу attempt включить новую попытку для студента Баранова Павла по дисциплине «Основы баз данных». 
Установить текущую дату в качестве даты выполнения попытки */
INSERT INTO attempt(student_id, subject_id, date_attempt)
SELECT student_id, 
       (SELECT subject_id
          FROM subject
         WHERE name_subject = 'Основы баз данных'), 
       NOW()
  FROM student
 WHERE name_student = 'Баранов Павел';

/* Случайным образом выбрать три вопроса (запрос) по дисциплине, тестирование по которой 
собирается проходить студент, занесенный в таблицу attempt последним, и добавить их в таблицу testing. 
id последней попытки получить как максимальное значение id из таблицы attempt. */
INSERT INTO testing(attempt_id, question_id)
SELECT (SELECT MAX(attempt_id)
          FROM attempt), 
       question_id
  FROM question
       JOIN attempt 
	   ON question.subject_id = attempt.subject_id
 WHERE attempt_id = (SELECT MAX(attempt_id)
                       FROM attempt)
 ORDER BY RAND()
 LIMIT 3;

/* Студент прошел тестирование (все его ответы занесены в таблицу testing), необходимо вычислить 
результат(запрос) и занести его в таблицу attempt для соответствующей попытки. Результат попытки вычислить как количество 
правильных ответов, деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100. Результат округлить до целого. 
Будем считать, что мы знаем id попытки, для которой вычисляется результат, в нашем случае это 8 */
UPDATE attempt, 
       (SELECT ROUND(SUM(is_correct)/3*100) AS result
          FROM answer
          JOIN testing
            ON answer.answer_id = testing.answer_id
         WHERE testing.attempt_id = 8) query_in
   SET attempt.result = query_in.result    
 WHERE attempt.attempt_id = 8;

/* Удалить из таблицы attempt все попытки, выполненные раньше 1 мая 2020 года. Также удалить и все соответствующие этим попыткам вопросы из 
 таблицы testing. */
DELETE FROM attempt
 WHERE date_attempt < '2020-05-01'; 

-- в таблице testing - ON DELETE CASCADE

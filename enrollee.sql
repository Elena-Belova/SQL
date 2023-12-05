TASK 1
-- База данных «Абитуриент» - запросы на выборку

/* Вывести абитуриентов, которые хотят поступать на образовательную программу «Мехатроника и робототехника» 
в отсортированном по фамилиям виде */
SELECT name_enrollee
  FROM enrollee
       JOIN program_enrollee
       ON enrollee.enrollee_id = program_enrollee.enrollee_id
       JOIN program
       ON program_enrollee.program_id = program.program_id
 WHERE name_program = 'Мехатроника и робототехника'
 ORDER BY name_enrollee;

/* Вывести образовательные программы, на которые для поступления необходим предмет «Информатика». 
Программы отсортировать в обратном алфавитном порядке */
SELECT name_program
  FROM program
       JOIN program_subject
       ON program.program_id = program_subject.program_id
       JOIN subject
       ON program_subject.subject_id = subject.subject_id
 WHERE name_subject = 'Информатика'
 ORDER BY name_program DESC;

/*Выведите количество абитуриентов, сдавших ЕГЭ по каждому предмету, максимальное, минимальное и 
среднее значение баллов по предмету ЕГЭ. Вычисляемые столбцы назвать Количество, Максимум, Минимум, 
Среднее. Информацию отсортировать по названию предмета в алфавитном порядке, среднее значение округлить 
до одного знака после запятой */
SELECT name_subject,
       COUNT(enrollee_id) AS 'Количество',
       MAX(result) AS 'Максимум',
       MIN(result) AS 'Минимум',
       ROUND(AVG(result), 1) AS 'Среднее'
  FROM enrollee_subject
       JOIN subject
       ON enrollee_subject.subject_id = subject.subject_id
 GROUP BY name_subject
 ORDER BY name_subject;

/* Вывести образовательные программы, для которых минимальный балл ЕГЭ по каждому предмету больше или равен 40 баллам. 
Программы вывести в отсортированном по алфавиту виде */
SELECT name_program
  FROM program
       JOIN program_subject
       ON program.program_id = program_subject.program_id
 GROUP BY name_program
HAVING MIN(min_result) >= 40
 ORDER BY name_program;

/* Вывести образовательные программы, которые имеют самый большой план набора, вместе с этой величиной */
SELECT name_program, plan
  FROM program
 WHERE plan IN(SELECT MAX(plan)
                 FROM program);
			   
/* Посчитать, сколько дополнительных баллов получит каждый абитуриент. Столбец с дополнительными баллами 
назвать Бонус. Информацию вывести в отсортированном по фамилиям виде */
SELECT name_enrollee, 
       IF(SUM(bonus) IS NULL, 0, SUM(bonus)) AS 'Бонус'
  FROM achievement 
       INNER JOIN enrollee_achievement USING(achievement_id)
       RIGHT JOIN enrollee USING(enrollee_id)
 GROUP BY name_enrollee
 ORDER BY name_enrollee;

/* Выведите сколько человек подало заявление на каждую образовательную программу и конкурс на нее (число поданных заявлений 
деленное на количество мест по плану), округленный до 2-х знаков после запятой. В запросе вывести название факультета, 
к которому относится образовательная программа, название образовательной программы, план набора абитуриентов, количество 
поданных заявлений (Количество) и Конкурс. Информацию отсортировать в порядке убывания конкурса */
SELECT name_department, name_program, plan, 
       COUNT(enrollee_id) AS 'Количество',
       ROUND((COUNT(enrollee_id)/plan),2) AS 'Конкурс'
  FROM program_enrollee
       JOIN program
       ON program_enrollee.program_id = program.program_id
       JOIN department
       ON program.department_id = department.department_id
 GROUP BY name_department, name_program, plan
 ORDER BY 5 DESC;

/* Вывести образовательные программы, на которые для поступления необходимы предмет «Информатика» и «Математика» 
в отсортированном по названию программ виде */
SELECT name_program
  FROM program_subject
       JOIN program 
	   ON program_subject.program_id = program.program_id
       JOIN subject 
	   ON program_subject.subject_id = subject.subject_id
 WHERE name_subject IN ('Информатика','Математика')
 GROUP BY name_program
HAVING COUNT(name_subject) = 2
 ORDER BY name_program;

/* Посчитать количество баллов каждого абитуриента на каждую образовательную программу, на которую он подал заявление, 
по результатам ЕГЭ. В результат включить название образовательной программы, фамилию и имя абитуриента, столбец с суммой баллов (itog).
Информацию вывести в отсортированном сначала по образовательной программе, а потом по убыванию суммы баллов виде */
SELECT name_program, name_enrollee,
       SUM(enrollee_subject.result) AS itog
  FROM enrollee
       JOIN program_enrollee 
	   ON enrollee.enrollee_id = program_enrollee.enrollee_id
       JOIN program 
	   ON program_enrollee.program_id = program.program_id
       JOIN program_subject 
	   ON program.program_id = program_subject.program_id
       JOIN subject 
	   ON program_subject.subject_id = subject.subject_id
       JOIN enrollee_subject 
       ON subject.subject_id = enrollee_subject.subject_id 
       AND enrollee_subject.enrollee_id = enrollee.enrollee_id
 GROUP BY name_enrollee, name_program
 ORDER BY name_program, 3 DESC;

/* Вывести название образовательной программы и фамилию тех абитуриентов, которые подавали документы на эту образовательную 
программу, но не могут быть зачислены на нее. Эти абитуриенты имеют результат по одному или нескольким предметам ЕГЭ, необходимым 
для поступления на эту образовательную программу, меньше минимального балла. Информацию вывести в отсортированном сначала 
по программам, а потом по фамилиям абитуриентов виде */
SELECT name_program, name_enrollee
 FROM enrollee
       JOIN program_enrollee 
	   ON enrollee.enrollee_id = program_enrollee.enrollee_id
       JOIN program 
	   ON program_enrollee.program_id = program.program_id
       JOIN program_subject 
	   ON program.program_id = program_subject.program_id
       JOIN subject 
	   ON program_subject.subject_id = subject.subject_id
       JOIN enrollee_subject 
       ON subject.subject_id = enrollee_subject.subject_id 
       AND enrollee_subject.enrollee_id = enrollee.enrollee_id
 WHERE result < min_result    
 ORDER BY name_program, name_enrollee;

/* Вывести название программы, фамилии студентов, которые подали заявку на эту программу, сумму баллов по всем необходимым предметам, 
сумму баллов за прочие достижения, общую сумму баллов */
SELECT name_program, name_enrollee,
       SUM(enrollee_subject.result) AS 'Результат',
       bonus AS 'Достижения',
       bonus + SUM(enrollee_subject.result) AS 'Итог'
  FROM enrollee
       JOIN program_enrollee 
       ON enrollee.enrollee_id = program_enrollee.enrollee_id
       JOIN program 
       ON program_enrollee.program_id = program.program_id
       JOIN program_subject 
       ON program.program_id = program_subject.program_id
       JOIN subject 
       ON program_subject.subject_id = subject.subject_id
       JOIN enrollee_subject 
       ON subject.subject_id = enrollee_subject.subject_id 
       AND enrollee_subject.enrollee_id = enrollee.enrollee_id
       JOIN enrollee_achievement 
       ON enrollee.enrollee_id = enrollee_achievement.enrollee_id
       JOIN achievement 
       ON enrollee_achievement.achievement_id = achievement.achievement_id
 GROUP BY name_enrollee, name_program, bonus
 ORDER BY name_program, name_enrollee;


TASK 2
-- База данных «Абитуриент» - запросы корректировки

/* Создать вспомогательную таблицу applicant, куда включить id образовательной программы, id абитуриента, сумму баллов абитуриентов 
(столбец itog) в отсортированном сначала по id образовательной программы, а потом по убыванию суммы баллов виде */
CREATE TABLE applicant AS
SELECT program_enrollee.program_id, program_enrollee.enrollee_id,
       SUM(enrollee_subject.result) AS itog
  FROM program_enrollee
       JOIN program_subject 
	   ON program_enrollee.program_id = program_subject.program_id
       JOIN enrollee_subject 
       ON program_subject.subject_id = enrollee_subject.subject_id 
       AND enrollee_subject.enrollee_id = program_enrollee.enrollee_id
 GROUP BY program_enrollee.program_id, program_enrollee.enrollee_id
 ORDER BY program_enrollee.program_id, 3 DESC;

/* Из таблицы applicant удалить записи, если абитуриент на выбранную образовательную программу не набрал 
минимального балла хотя бы по одному предмету */
DELETE FROM applicant
 USING applicant
       JOIN enrollee_subject 
	   ON applicant.enrollee_id = enrollee_subject.enrollee_id
       JOIN program_subject 
	   ON applicant.program_id = program_subject.program_id
       AND enrollee_subject.subject_id = program_subject.subject_id
 WHERE result < min_result;

/* Повысить итоговые баллы абитуриентов в таблице applicant на значения дополнительных баллов */
UPDATE applicant
INNER JOIN 
      (SELECT enrollee_id, 
              IF(SUM(bonus) IS NULL, 0, SUM(bonus)) AS bonus
         FROM achievement 
              INNER JOIN enrollee_achievement USING(achievement_id)
              RIGHT JOIN enrollee USING(enrollee_id)
        GROUP BY enrollee_id) query_in
ON applicant.enrollee_id = query_in.enrollee_id
SET itog = itog + query_in.bonus;

/* Необходимо создать новую таблицу applicant_order на основе таблицы applicant. При создании таблицы данные нужно отсортировать 
сначала по id образовательной программы, потом по убыванию итогового балла. Таблицу applicant, которая была создана 
как вспомогательная, удалить */
CREATE TABLE applicant_order AS
SELECT program_id, enrollee_id, itog
  FROM applicant
 ORDER BY program_id, itog DESC;

DROP TABLE applicant;

/* Включить в таблицу applicant_order новый столбец str_id целого типа, расположить его перед первым */
ALTER TABLE applicant_order 
  ADD str_id INT FIRST;

/* Занести в столбец str_id таблицы applicant_order нумерацию абитуриентов, которая начинается с 1 для каждой образовательной программы */
SET @num_pr := 0;
SET @row_num := 1;

UPDATE applicant_order
INNER JOIN
     (SELECT *, 
             IF(program_id = @num_pr, @row_num := @row_num + 1, @row_num := 1) AS str_num,
             @num_pr := program_id AS add_var 
        FROM applicant_order) query_in
ON applicant_order.program_id = query_in.program_id
AND applicant_order.enrollee_id = query_in.enrollee_id
SET applicant_order.str_id = query_in.str_num;

/*Создать таблицу student, в которую включить абитуриентов, которые могут быть рекомендованы к зачислению 
в соответствии с планом набора. Информацию отсортировать сначала в алфавитном порядке по названию программ, 
а потом по убыванию итогового балла */
CREATE TABLE student AS
SELECT name_program, name_enrollee, itog
  FROM applicant_order
       JOIN program 
	   ON applicant_order.program_id = program.program_id
       JOIN enrollee 
	   ON applicant_order.enrollee_id = enrollee.enrollee_id
 WHERE applicant_order.str_id <= program.plan
 ORDER BY name_program, itog DESC;

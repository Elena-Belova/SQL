TASK 1
-- Запрос, который выведет из таблицы "Студенты" столбцы с фамилией, именем и размером стипендии: 
SELECT surname, name, stipend 
  FROM students;
  
-- Запрос для таблицы «Предметы», который покажет только название предмета и количество часов:
SELECT name, hours
  FROM subjects;
  
-- Запрос, который выведет студентов, проживающих в г. Остергард:
SELECT * FROM students
 WHERE city = 'Остергард';
 
-- Запрос, который выведет студентов, проживающих не в г. Дольче-Габановск:
SELECT * FROM students
 WHERE city != 'Дольче-Габановск';
 
-- Запрос, который выведет студентов первого курса:
SELECT * FROM students
 WHERE course = 1;

-- Запрос, который выведет студентов, получающих стипендию равную или больше 600 руб:
SELECT * FROM students
 WHERE stipend >= 600;

-- Запрос, который выведет студентов, учащихся на втором курсе и более старших курсах:
SELECT * FROM students
 WHERE course >= 2;
 
-- Запрос, который выведет студентов мужского пола:
SELECT * FROM students
 WHERE gender = 'm';
 
-- Запрос, который выведет студентов с именем Ольга:
SELECT * FROM students
 WHERE name = 'Ольга';
 
-- Запрос, который выведет студентов 1990 года рождения и младше, которые учатся на первом и втором курсе:
SELECT * FROM students
 WHERE birthday >= "1990-01-01" 
   AND course < 3;

-- Запрос, который выведет студентов 1990 года рождения и старше или которые учатся на первом и втором курсе:
SELECT * FROM students
 WHERE birthday <= "1990-01-01" 
    OR course < 3;

-- Запрос, который выведет студентов женского пола из Остергарда, учащихся от четвёртого курса и выше:
SELECT * FROM students
 WHERE gender = 'f' 
   AND city = 'Остергард'
   AND course > 3;

-- Запрос, который выведет студентов женского пола из Остергарда или студентов мужского пола из Лемурова:
SELECT * FROM students
 WHERE (gender = 'f' AND city = 'Остергард')
    OR (gender = 'm' AND city = 'Лемуров');

-- Запрос, который выведет студентов с именами или Ольга, или Виталий или Дмитрий:
SELECT * FROM students
 WHERE name IN ('Ольга', 'Виталий', 'Дмитрий');

TASK 2
-- Запрос, который выведет преподавателей из г. Остергард и из университета с ID = 6:
SELECT * FROM lecturers
 WHERE city = 'Остергард' 
   AND univ_id = 6;

-- Запрос, который выведет преподавателей из городов Колымагиновск, Лемуров, Хобитов:
SELECT * FROM lecturers
 WHERE city IN ('Колымагиновск', 'Лемуров', 'Хобитов');
 
-- Запрос, который выведет преподавателей не из городов Колымагиновск, Лемуров, Хобитов:
SELECT * FROM lecturers
 WHERE city NOT IN ('Колымагиновск', 'Лемуров', 'Хобитов');
 
-- Запрос, который выведет студентов со стипендией от 650 до 750 руб:
SELECT * FROM students
 WHERE stipend BETWEEN 650 AND 750;

-- Запрос, который выведет студентов со стипендией вне суммы от 700 до 800 руб:
SELECT * FROM students
 WHERE stipend NOT BETWEEN 700 AND 800;

-- Запрос, который выведет студентов из городов Зернотаун, Лемуров, Айфончиков, учащихся со второго по четвёртый курс:
SELECT * FROM students
 WHERE city IN ('Зернотаун', 'Лемуров', 'Айфончиков')
   AND course BETWEEN 2 AND 4;

-- Запрос, который выведет студентов, содержащих в имени "Дани":
SELECT * FROM students
 WHERE name LIKE "Дани%";

-- Запрос, который выведет список городов, из которых приехали студенты без дублирования названий:
SELECT DISTINCT city
  FROM students;

-- Запрос, который выведет уникальные города в списке преподавателей:
SELECT DISTINCT city
  FROM lecturers;

-- Запрос, который выведет список городов студентов по алфавиту от A:
SELECT city
  FROM students
 ORDER BY city;

-- Запрос, который выведет список городов студентов по алфавиту без дублирования названий:
SELECT DISTINCT city
  FROM students
 ORDER BY city;

-- Запрос, который выведет список всех курсов по убыванию:
SELECT DISTINCT course
  FROM students
 ORDER BY course DESC;

-- Запрос, который выведет список студентов в алфавитном порядке:
SELECT * FROM students
 ORDER BY surname;

-- Запрос, который выведет с какого по какой курс учатся студенты города Айфончиков?
SELECT course, city
  FROM students
 WHERE city = 'Айфончиков'
 ORDER BY course;

-- Запрос, который выведет список студентов женского пола со стипендией от большей к меньшей без дублирования данных:
SELECT DISTINCT stipend, gender 
  FROM  students
 WHERE gender = 'f'
 ORDER BY stipend DESC;

-- Запрос, который выведет общую сумму стипендии студентов:
SELECT SUM(stipend)
  FROM students;

-- Запрос, который выведет сумму стипендии студентов по городам, отсортированные по сумме:
SELECT city, SUM(stipend)
  FROM students
 GROUP BY city
 ORDER BY SUM(stipend);

-- Запрос, который выведет максимальную сумму стипендии у студентов женского и мужского пола:
SELECT MAX(stipend), gender
  FROM students
 GROUP BY gender;

-- Запрос, который выведет сколько студентов из каждого города (от меньшего к большему):
SELECT COUNT(city), city
  FROM students
 GROUP BY city
 ORDER BY COUNT(city);

-- Запрос, который выведет число преподавателей из г. Остергард:
SELECT COUNT(city)
  FROM lecturers
 WHERE city = 'Остергард';

-- Запрос, который выведет сумму рейтинга университетов из городов Зернотаун и Лемуров:
SELECT SUM(rating)
  FROM universities
 WHERE city IN ('Зернотаун', 'Лемуров');

-- Запрос, который выведет минимальный рейтинг в таблице университетов для городов Зернотаун, Лемуров, Хобитов:
SELECT MIN(rating)
  FROM universities
 WHERE city IN ('Зернотаун', 'Лемуров', 'Хобитов');
 
-- Запрос, который выведет названия городов преподавателей, упорядочивая их по алфавиту, и количество повторений города:
SELECT city, COUNT(city)
  FROM lecturers
 GROUP BY city
 ORDER BY city;
 
TASK 3
-- Запрос, который выведет, кто из студентов в каком университете учится:
SELECT surname, course, universities.name AS U_name
  FROM students
       JOIN universities
       ON univ_id = universities.id
 ORDER BY U_name;
	
-- Запрос, который выведет, фамилии преподавателей и название университета:
SELECT surname AS 'Фамилия', 
       universities.name AS 'Университет'
  FROM lecturers
       JOIN universities
       ON univ_id = universities.id;


-- Запрос, который выведет, кто из студентов сдавал экзамены и на какую оценку:
SELECT surname AS 'Фамилия', 
       students.name AS 'Имя', 
       subjects.name AS 'Предмет', 
       mark AS 'Оценка'
  FROM exam_marks
       JOIN students
       ON student_id = students.id
       JOIN subjects
       ON subj_id = subjects.id;

-- Запрос, который выведет список оценок только по английскому языку:
SELECT surname AS 'Фамилия', 
       students.name AS 'Имя', 
       subjects.name AS 'Предмет', 
       mark AS 'Оценка'
  FROM exam_marks
       JOIN students
       ON student_id = students.id
       JOIN subjects
       ON subj_id = subjects.id;
 WHERE subjects.name = 'Английский'

-- Запрос, который выведет фамилии (без имён) всех студентов и название предмета для предметов, сданных на отлично:
SELECT surname, subjects.name
  FROM exam_marks
       JOIN students
       ON student_id = students.id
       JOIN subjects
       ON subj_id = subjects.id
 WHERE mark = 5;

-- Запрос, который выведет сколько и каких оценок по предметам получили студенты:
SELECT subjects.name, mark, COUNT(mark)
  FROM exam_marks
       JOIN students
       ON student_id = students.id
       JOIN subjects
       ON subj_id = subjects.id
 GROUP BY subjects.name, mark
 ORDER BY subjects.name;

-- Запрос, который выведет средний балл студентов:
SELECT surname, AVG(mark)
  FROM exam_marks
       JOIN students
       ON student_id = students.id
       JOIN subjects
       ON subj_id = subjects.id
 GROUP BY surname
 ORDER BY surname;

-- Запрос, который выведет список университетов, в которых меньше всего преподавателей:
SELECT universities.name, COUNT(universities.name)
  FROM lecturers
       JOIN universities
       ON univ_id = universities.id
 GROUP BY univ_id
 ORDER BY COUNT(universities.name);

-- Запрос, который выведет только фамилию преподавателя и название предмета, который он преподаёт, упорядочить по названию предмета:
SELECT surname, subjects.name
  FROM lecturers
       JOIN subj_lect
       ON lecturer_id = lecturers.id
       JOIN subjects
       ON subj_id = subjects.id
 ORDER BY subjects.name;
 
 -- Запрос, который выведет фамилии студентов, название предметов, которые он изучает на текущем курсе, и количество лекционных часов:
SELECT surname AS 'Фамилия', 
       subjects.name AS 'Предмет', 
	   hours AS 'Часы'
 FROM students
      JOIN subjects
      ON students.course = subjects.course
ORDER BY surname;

TASK 4
-- Запрос, который проверит данные преподавателей на наличие NULL:
SELECT * FROM lecturers
 WHERE surname IS NULL
    OR name IS NULL
    OR city IS NULL
    OR univ_id IS NULL;

-- Запрос, который выведет у какого преподавателя не назначен университет:
SELECT surname AS 'Фамилия', 
       universities.name AS 'Университет'
  FROM lecturers 
       LEFT JOIN universities
       ON lecturers.univ_id = universities.id 
 WHERE universities.name IS NULL;

-- Запрос, который покажет университеты без привязанных преподавателей:
SELECT surname AS 'Фамилия', 
       universities.name AS 'Университет'
  FROM lecturers 
       RIGHT JOIN universities 
       ON lecturers.univ_id = universities.id 
 WHERE surname IS NULL; 

-- Запрос, который объединит данные об университетах без преподавателей и о преподавателях без университета:
SELECT surname AS 'Фамилия', 
       universities.name AS 'Университет'
  FROM lecturers 
       LEFT JOIN universities
       ON lecturers.univ_id = universities.id 
 WHERE universities.name IS NULL
 UNION ALL
SELECT surname AS 'Фамилия', 
       universities.name AS 'Университет'
  FROM lecturers 
       RIGHT JOIN universities
       ON lecturers.univ_id = universities.id  
 WHERE surname IS NULL;










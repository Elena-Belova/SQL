# Реляционные Базы Данных. SQL-запросы.

**Решение задач по SQL**<br>
Примеры моих запросов (простых и средней сложности)

<img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/postgresql-original-wordmark.svg" alt="PostgreSQL" height="50" />  <img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/mysql-original-wordmark.svg" alt="MySQL" height="60" />   

Для работы с БД использовала инструменты: _phpMyAdmin_,  _pgAdmin_,  _DBeaver_ 

<details>
<summary><kbd><b>ЗНАНИЕ SQL</b></kbd></summary><br>
<blockquote>
  <ul>
    <li><b>DDL</b>: CREATE, ALTER, DROP</li>
    <li><b>DML</b>: SELECT, INSERT, UPDATE, DELETE</li>
    <li>условия выборки и сортировки данных: DISTINCT, IF(CASE), WHERE, AND, OR, IN, IS, BETWEEN, NOT, LIKE, GROUP BY (HAVING), ORDER BY (ASC/DESC), LIMIT</li>
    <li>агрегация данных: COUNT, SUM, AVG, MAX, MIN </li>
    <li>простые арифметические операции и функции (ROUND, CEILING, FLOOR, DIV, ABS)</li>
    <li>операции над датами: DATEDIFF, DATE_ADD, DAY, MONTH, MONTHNAME, YEAR</li>
    <li>объединение 2х и более таблиц: JOIN (INNER, CROSS, LEFT, RIGHT, FULL)</li>
    <li>объединение 2х и более SQL запросов: UNION, INTERSECT, EXCEPT</li>
  </ul>
</blockquote>
</details>

<hr>

**Различные виды запросов, построенных на связанных таблицах**

:floppy_disk: **БД "Абитуриент"**
<details>
<summary>Схема БД</summary>
  
![enr](https://github.com/Elena-Belova/SQL/assets/148638077/71f076db-8786-4f60-ac68-1f81651144ae)
</details>

&#8594; [Запросы на выборку/запросы корректировки.sql](https://github.com/Elena-Belova/SQL/blob/53c1dcb2e390f2364c7bc053a839f1561939231b/enrollee.sql)
<hr>

:floppy_disk: **БД "Тестирование on-line"**
<details>
<summary>Схема БД</summary>

![cxтест](https://github.com/Elena-Belova/SQL/assets/148638077/01073338-0458-49e0-a3e9-4373388a4417)
</details>

&#8594; [Запросы на выборку/запросы корректировки.sql](https://github.com/Elena-Belova/SQL/blob/53c1dcb2e390f2364c7bc053a839f1561939231b/BD%20Testing.sql)
<hr>

:floppy_disk: **БД "Интернет-магазин книг"**
<details>
<summary>Схема БД</summary>
  
![book](https://github.com/Elena-Belova/SQL/assets/148638077/ef814b4f-4cfe-4bc2-9948-d1dae42b3fff)
</details>

&#8594; [Запросы на выборку.sql](https://github.com/Elena-Belova/SQL/blob/53c1dcb2e390f2364c7bc053a839f1561939231b/DB%20book%20store1.sql)

&#8594; [Запросы корректировки.sql](https://github.com/Elena-Belova/SQL/blob/53c1dcb2e390f2364c7bc053a839f1561939231b/DB%20book%20store2.sql)
<hr>

:floppy_disk: **БД "Студенты"**

<details>
<summary>Схема БД</summary>
  
  ![model db](https://github.com/Elena-Belova/SQL/assets/148638077/de2a3579-2c1a-4700-8471-69d334f00d35)
</details>

&#8594; [Запросы на выборку.sql](https://github.com/Elena-Belova/SQL/blob/53c1dcb2e390f2364c7bc053a839f1561939231b/students.sql)
<hr>

**Простые SQL запросы к одной таблице БД**

:small_blue_diamond: Запросы для таблицы "Командировки": выборка данных, групповые операции, вложенные запросы
  
:small_blue_diamond: Запросы для таблицы "Нарушения ПДД": запросы корректировки

:small_blue_diamond: Запросы для таблицы "book": выборка данных, групповые операции, вложенные запросы / корректировка данных

&#8594; [Запросы "Командировки"/"Нарушения ПДД".sql](https://github.com/Elena-Belova/SQL/blob/53c1dcb2e390f2364c7bc053a839f1561939231b/trip_fine.sql)

&#8594; [Запросы "book".sql](https://github.com/Elena-Belova/SQL/blob/53c1dcb2e390f2364c7bc053a839f1561939231b/book.sql)

<hr>

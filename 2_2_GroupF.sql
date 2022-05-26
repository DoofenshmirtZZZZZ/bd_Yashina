/*1.Выведите на экран номера групп и количество студентов, обучающихся в них*/

SELECT groupp, COUNT(*)
FROM student
GROUP BY groupp

/* 2.Выведите на экран для каждой группы максимальный средний балл*/

SELECT groupp, MAX(score)
FROM student
GROUP BY groupp

/* 3 . Подсчитать количество студентов с каждой фамилией */

SELECT surname, COUNT(surname)
FROM student
GROUP BY surname

/* 4 . Подсчитать студентов, которые родились в каждом году*/

SELECT date_birth, count(date_birth)
FROM student
GROUP BY date_birth

/* 7  Для каждой группы подсчитать средний балл, вывести на экран только те номера групп и их средний балл, в которых он менее или равен 3.5. Отсортировать по от меньшего среднего балла к большему.*/

SELECT groupp, AVG(score)
FROM student
GROUP BY groupp
HAVING AVG(score)>= 4.5
ORDER BY AVG(score) ASC

/* У меня нет меньше 3.5 в таблице, взяла 4.5*/

/* 8.Для каждой группы в одном запросе вывести количество студентов, максимальный балл в группе, средний балл в группе, минимальный балл в группе*/

SELECT groupp, COUNT(name),MAX(score),AVG(score),MIN(score)
FROM student
GROUP BY groupp

/* 9.Вывести студента/ов, который/ые имеют наибольший балл в заданной группе*/

SELECT name, MAX(score), groupp
FROM student
WHERE groupp = 2254
GROUP BY groupp,name
HAVING MAX(score) >= 4

/* 10.Аналогично 9 заданию, но вывести в одном запросе для каждой группы студента с максимальным баллом */

SELECT distinct groupp, name ,MAX(score)
FROM student
WHERE score = (SELECT MAX(score) from student)
GROUP BY groupp,name

/*1.Вывести все имена и фамилии студентов, и название хобби, которым занимается этот студент.*/

SELECT st.name, st.surname, hb.name
FROM student st, hobby hb, student_hobby sh
WHERE sh.student_id = st.id AND sh.hobby_id = hb.id;

/*2.Вывести информацию о студенте, занимающимся хобби самое продолжительное время.*/

SELECT st.name, st.surname, sh.started_at
FROM student st, student_hobby sh
WHERE st.id = sh.student_id AND sh.finished_ad IS NULL
ORDER BY sh.started_at
LIMIT 1

/*3.Вывести имя, фамилию, номер зачетки и дату рождения для студентов, средний балл которых выше среднего, а сумма риска всех хобби, которыми он занимается в данный момент, больше 0.9.*/

SELECT DISTINCT st.score, st.name, st.surname, st.year_of_birth
FROM student st
INNER JOIN(SELECT SUM(hb.risk) as st.r_summ, sh.student_id
FROM hobby hb, student_hobby sh
WHERE hb.id= sh.hobby_id AND sh.finished_ad IS NULL
GROUP BY sh.student_id)
ON st.id = st.student_id
AND st.r_summ > 0.9
WHERE st.score >(SELECT AVG(score)::numeric(3,2)
FROM student)

/*4Вывести фамилию, имя, зачетку, дату рождения, название хобби и длительность в месяцах, для всех завершенных хобби Диапазон дат.*/

SELECT st.name, st.surname, st.n_group, st.year_of_birth, tt.monthes, tt.name
FROM student st
INNER JOIN
SELECT (to_char(sh.finished_ad, 'MM')::numeric(10,0) + to_char(sh.finished_ad, 'YYYY')::numeric(10,0) * 12) - (to_char(sh.finished_ad, 'MM')::numeric(10,0) + to_char(sh.started_at, 'YYYY')::numeric(10,0) * 12) as monthes, sh.id, hb.name
FROM student_hobby sh, hobby hb
WHERE hb.id = sh.id 
ON tt.id = st.id

/*5 Вывести фамилию, имя, зачетку, дату рождения студентов, которым исполнилось N полных лет на текущую дату, и которые имеют более 1 действующего хобби.*/

SELECT st.name, st.surname, st.n_group, st.year_of_birth
FROM student st
INNER JOIN
(SELECT count(sh.hobby_id), sh.id
FROM student_hobby sh, hobby hb
WHERE hb.id = sh.hobby_id
GROUP BY sh.id
HAVING count(sh.hobby_id) > 1) tt
ON tt.id = st.id
WHERE 3 = ((to_char('2024-03-19'::date, 'YYYY')::int * 12 * 30 + to_char('2024-03-19'::date, 'MM')::int * 30 + to_char('2024-03-19'::date, 'DD')::int) - (to_char(st.year_of_birth, 'YYYY')::int * 12 * 30 + to_char(st.year_of_birth, 'MM')::int * 30 + to_char(st.year_of_birth, 'DD')::int))/ 30 / 12

/*6 Найти средний балл в каждой группе, учитывая только баллы студентов, которые имеют хотя бы одно действующее хобби.*/

SELECT DISTINCT st.n_group, avg(st.score)::numeric(3,2)
FROM student st
INNER JOIN(SELECT DISTINCT sh.id
FROM student_hobby sh, hobby hb
WHERE sh.hobby_id = hb.id AND sh.finished_ad IS NULL) tt
ON tt.id = st.id
GROUP BY st.n_group

/*7 Найти название, риск, длительность в месяцах самого продолжительного хобби из действующих, указав номер зачетки студента.*/

SELECT hb.name, hb.risk, -1 * (to_char(tt.dlit, 'YYYY')::numeric(5,0) * 12 + to_char(tt.dlit, 'MM')::numeric(5,0)) + (to_char(now(), 'YYYY')::numeric(5,0) * 12 + to_char(now(),'MM')::numeric(5,0))
FROM hobby hb
INNER JOIN(
SELECT sh.hobby_id, min(sh.started_at) as dlit, sh.id
FROM student_hobby sh
GROUP BY sh.id, sh.hobby_id
HAVING sh.id = 3
LIMIT 1) tt
ON tt.hobby_id = hb.id

/*8 Найти все хобби, которыми увлекаются студенты, имеющие максимальный балл.*/

SELECT hb.name
FROM student st
INNER JOIN student_hobby sh on sh.id = st.id
INNER JOIN hobby hb on hb.id = sh.hobby_id
WHERE st.score = (SELECT max(st.score)
FROM student st)

/*9 Найти все действующие хобби, которыми увлекаются троечники 2-го курса.*/

SELECT hb.name
FROM hobby hb
INNER JOIN student_hobby sh on sh.hobby_id = hb.id AND sh.finished_ad IS NULL
INNER JOIN student st on st.id = sh.students_id
WHERE SUBSTRING(st.n_group::varchar, 1,1) = '2' AND st.score >= 3 AND st.score < 4

/*10 Найти номера курсов, на которых более 50% студентов имеют более одного действующего хобби.*/

SELECT SUBSTRING(st.n_group::varchar,1,1) as course
FROM student st
INNER JOIN(SELECT SUBSTRING(st.n_group::varchar,1,1) as course, count(st.id) as countofstd
FROM student st
INNER JOIN(SELECT sh.student_id, count(sh.hobby_id)
FROM student_hobby sh
WHERE sh.finished_ad IS NULL
GROUP BY sh.student_id
HAVING count(sh.student_id) > 1) tt
ON tt.student_id = st.id
GROUP BY SUBSTRING(st.n_group::varchar,1,1)) ttend
ON SUBSTRING(st.n_group::varchar,1,1) = ttend.course
INNER JOIN(SELECT SUBSTRING(st.n_group::varchar,1,1) as course, count(st.id) as countofstd
FROM student st
GROUP BY SUBSTRING(st.n_group::varchar,1,1)) ttnext
ON SUBSTRING(st.n_group::varchar,1,1) = ttnext.course
WHERE ttnext.countofstd / 2 + ttnext.countofstd % 2 <= ttend.countofstd
GROUP BY SUBSTRING(st.n_group::varchar,1,1)

/*11 Вывести номера групп, в которых не менее 60% студентов имеют балл не ниже 4.*/

SELECT DISTINCT st.n_group
FROM student st
INNER JOIN(SELECT st.n_group, count(st.id) as countofstd, sum(st.score)
FROM student st
WHERE st.score >= 4
GROUP BY st.n_group) tt
ON st.n_group = tt.n_group
INNER JOIN(SELECT st.n_group, count(st.id) as countofstd
FROM student st
GROUP BY st.n_group) ttt
ON st.n_group = ttt.n_group
WHERE ttt.countofstd / 100 * 60 <= ttt.countofstd

/*12 Для каждого курса подсчитать количество различных действующих хобби на курсе.*/

SELECT count(sh.student_id), SUBSTRING(st.n_group::varchar, 1,1)
FROM student_hobby sh, student st
WHERE sh.finished_ad IS NULL AND sh.student_id = st.id
GROUP BY SUBSTRING(st.n_group::varchar,1,1)

/*13 Вывести номер зачётки, фамилию и имя, дату рождения и номер курса для всех отличников, не имеющих хобби. Отсортировать данные по возрастанию в пределах курса по убыванию даты рождения.*/

SELECT st.id, st.name, st.surname, st.year_of_birth, SUBSTRING(st.n_group::varchar,1,1) as course
FROM student st
WHERE st.score = 5
EXCEPT SELECT DISTINCT stb.id, stb.name, stb.surname, stb.year_of_birth, SUBSTRING(stb.n_group::varchar,1,1) as course
FROM student_hobby sh, student stb
WHERE stb.id = sh.student_id AND sh.finished_ad IS NULL
ORDER BY course, year_of_birth
 
 /*14 Создать представление, в котором отображается вся информация о студентах, которые продолжают заниматься хобби в данный момент и занимаются им как минимум 5 лет.*/

CREATE OR REPLACE VIEW Student_yearhobby AS
SELECT st.*
FROM student st, student_hobby sh
WHERE st.id = sh.student_id AND sh.finished_ad IS NULL AND (to_char('2025-05-10'::date, 'YYYY')::int * 12 * 30 + to_char('2025-05-10'::date, 'MM')::int * 30 + to_char('2025-05-10'::date, 'DD')::int - to_char(sh.started_at, 'YYYY')::int * 12 * 30 + to_char(sh.started_at, 'MM')::int * 30 + to_char(sh.started_at, 'DD')::int) / 30 / 12 >= 5

/*15 Для каждого хобби вывести количество людей, которые им занимаются.*/

SELECT hb.name, tt.countOfHobby
FROM hobby hb
INNER JOIN
(SELECT count(sh.student_id) as countOfHobby, sh.hobby_id
FROM student_hobby sh
WHERE sh.finished_ad IS NULL
GROUP BY sh.hobby_id) tt
ON tt.hobby_id = hb.id

/*16 Вывести ИД самого популярного хобби.*/

SELECT hb.name
FROM hobby hb
INNER JOIN
(SELECT count(sh.student_id) as countOfHobby, sh.hobby_id
FROM student_hobby sh
GROUP BY sh.hobby_id) tt
ON tt.hobby_id = hb.id
ORDER BY tt.countOfHobby DESC
LIMIT 1

/*17 Вывести всю информацию о студентах, занимающихся самым популярным хобби.*/


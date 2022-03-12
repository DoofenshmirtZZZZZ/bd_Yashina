/*1.Вывести всеми возможными способами имена и фамилии студентов, средний балл которых от 4 до 4.5*/

SELECT name, surname
FROM student WHERE score>=4 AND score<=4.5

SELECT name, surname
FROM student WHERE score=4 OR score=4.1 OR score=4.2 OR score=4.3 OR score=4.4 OR score=4.5

/2. *знакомиться с функцией CAST. Вывести при помощи неё студентов заданного курса (использовать Like)*/

SELECT name, surname, cast (groupp as varchar(1))
FROM student
WHERE groupp LIKE '2%';

/*3.Вывести всех студентов, отсортировать по убыванию номера группы и имени от а до я*/

SELECT name, surname, groupp
FROM student ORDER BY groupp DESC, name ASC;

/*4.Вывести студентов, средний балл которых больше 4 и отсортировать по баллу от большего к меньшему*/

SELECT name, surname, score
FROM student
WHERE score>4
ORDER BY score DESC

/*5.Вывести на экран название и риск Баскетбол и Волейбол*/
SELECT name, risk
FROM hobby
WHERE id = 1 OR id = 2;

/*6.Вывести id хобби и id студента которые начали заниматься хобби между двумя заданными датами (выбрать самим) и студенты должны до сих пор заниматься хобби*/

SELECT id_hobby, n_z, date_start, date_finish
FROM student_hobby
WHERE date_start > '2005-05-01' AND date_start < '2015-02-03' AND date_finish IS NULL;

/*7.Вывести студентов, средний балл которых больше 4.5 и отсортировать по баллу от большего к меньшему*/

SELECT name, surname, score
FROM student
WHERE score > 4.5
ORDER BY score DESC;

/*8.Из запроса №7 вывести несколькими способами на экран только 5 студентов с максимальным баллом*/

SELECT name, surname, score
FROM student
WHERE score = (SELECT max(score) FROM student)
LIMIT 5;

/*9.Выведите хобби и с использованием условного оператора сделайте риск словами:

> =8 - очень высокий
=6 & <8 - высокий
=4 & <8 - средний
=2 & <4 - низкий
<2 - очень низкий*/
> 

SELECT name,
CASE
WHEN risk >=8 then 'очень высокий'
WHEN risk >=6 AND risk <8 then 'высокий'
WHEN risk >=4 AND risk <8 then 'средний'
WHEN risk >=2 AND risk <4 then 'низкий'
WHEN risk < 2 then 'очень низкий'
end
FROM hobby

/*10.Вывести 3 хобби с максимальным риском( почему то с селект макс выводил только 1 хобби,решил так сделать)*/

SELECT name, risk
FROM hobby
WHERE risk >= 1
ORDER BY risk DESC
LIMIT 3;

/*1.Вывести всеми возможными способами имена и фамилии студентов, средний балл которых от 4 до 4.5*/

SELECT name,surname FROM students WHERE score >= 4.0 AND score <= 4.5

/*2.знакомиться с функцией CAST. Вывести при помощи неё студентов заданного курса (использовать Like)*/

SELECT * FROM students st WHERE LEFT(st.group_num::VARCHAR,1) = '2'

/*3.Вывести всех студентов, отсортировать по убыванию номера группы и имени от а до я*/

SELECT * FROM students st ORDER BY st.group_num DESC, st.name

/*4.Вывести студентов, средний балл которых больше 4 и отсортировать по баллу от большего к меньшему*/

SELECT * FROM students st WHERE st.score >= 4.0 ORDER BY st.score DESC

/*5.Вывести на экран название и риск Баскетбол и Волейбол*/

SELECT h.name, h.risk FROM hobby h WHERE h.name = 'Баскетбол' OR h.name = 'Волейбол'

/*6.Вывести id хобби и id студента которые начали заниматься хобби между двумя заданными датами (выбрать самим) и студенты должны до сих пор заниматься хобби*/

SELECT st_h.n_z, st_h.id_hobby FROM student_hobby st_h WHERE st_h.date_start > '2005-01-01' AND st_h.date_start < '2020-01-01' AND st_h.date_end IS NULL

/*7.Вывести студентов, средний балл которых больше 4.5 и отсортировать по баллу от большего к меньшему*/

SELECT * FROM students st WHERE st.score >= 4.5 ORDER BY st.score DESC

/*8.Из запроса №7 вывести несколькими способами на экран только 5 студентов с максимальным баллом*/

SELECT * FROM students st WHERE st.score >= 4.5 ORDER BY st.score DESC LIMIT 3

/*9.Выведите хобби и с использованием условного оператора сделайте риск словами:

> =8 - очень высокий
=6 & <8 - высокий
=4 & <8 - средний
=2 & <4 - низкий
<2 - очень низкий*/

SELECT h.name,
CASE 
WHEN h.risk < 2 THEN 'Очень низкий'
WHEN h.risk >= 2 AND h.risk < 4 THEN 'Низкий'
WHEN h.risk >= 4 AND h.risk < 6 THEN 'Средний'
WHEN h.risk >= 6 AND h.risk < 8 THEN 'Высокий'
WHEN h.risk >= 8 THEN 'Очень высокий'
END risk
FROM hobby h 

/*10.Вывести 3 хобби с максимальным риском( почему то с селект макс выводил только 1 хобби,решил так сделать)*/

SELECT * FROM hobby h ORDER BY h.risk DESC LIMIT 3

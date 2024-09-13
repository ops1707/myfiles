DROP TABLE IF EXISTS students; # Make sure you do not have table with same name
DROP TABLE IF EXISTS classes;

CREATE TABLE classes # creating new table "classes" with columns "id","class_name"
(
    id integer PRIMARY KEY , 
    class_name  varchar(50) NOT NULL
);

CREATE TABLE students # creating new table "students" with columns "id","name","class_id"
(
    id integer PRIMARY KEY ,
    name varchar(100) NOT NULL ,
    class_id integer REFERENCES classes(id) NOT NULL
);

INSERT INTO classes  # adding data into table "classes" 
VALUES // its for unique
(1,'Math'),
(2,'Science'),
(3,'History');

INSERT INTO students
VALUES
(1,'Alice',1),
(2,'Bob',1),
(3,'Charlie',2),
(4,'David',3),
(5,'Eva',2);

SELECT classes.class_name AS subjects,
       count(students.id) AS quantity_of_studets,
       string_agg(students.name,',') AS student_list
FROM students
INNER JOIN classes ON students.class_id = classes.id
GROUP BY classes.class_name
ORDER BY quantity_of_studets DESC
LIMIT 2;

SELECT students.name
FROM students
LEFT JOIN classes ON students.class_id = classes.id
WHERE classes.id IS NULL;

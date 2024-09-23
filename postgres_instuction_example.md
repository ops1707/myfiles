# Make sure you do not have table with same name
    DROP TABLE IF EXISTS students;
    DROP TABLE IF EXISTS classes;

# Creating new table "classes" with columns "id","class_name"
    CREATE TABLE classes
    (
        id integer PRIMARY KEY , 
        class_name  varchar(50) NOT NULL
    );

# Creating new table "students" with columns "id","name","class_id"
    CREATE TABLE students
    (
        id integer PRIMARY KEY ,
        name varchar(100) NOT NULL ,
        class_id integer REFERENCES classes(id) NOT NULL
    );

# Adding data into table "classes" and "students"
    INSERT INTO classes  
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
# Task 1 Print class name and list of students which related to this class 
    SELECT classes.class_name AS Subjects,
        string_agg(students.name,',')
    FROM students
    INNER JOIN classes ON students.class_id = classes.id
    GROUP BY classes.class_name;
    
 # Task 2 Find the class with the most students
    SELECT classes.class_name AS subjects,
       count(students.id) AS quantity_of_studets
    FROM students
    INNER JOIN classes ON students.class_id = classes.id
    GROUP BY classes.class_name
    ORDER BY quantity_of_studets DESC
    LIMIT 1;
# Find the students who have not joined any courses
    SELECT students.name
    FROM students
    LEFT JOIN classes ON students.class_id = classes.id
    WHERE classes.id IS NULL;

-- menampilkan daftar siswa beserta kelas dan guru yang mengajar kelas tersebut
SELECT 
    students.name AS student_name,
    classes.name AS class_name,
    teachers.name AS teacher_name
FROM 
    students
JOIN 
    classes ON students.class_id = classes.id
JOIN 
    teachers ON classes.teacher_id = teachers.id;

-- menampilkan daftar kelas yang diajar oleh guru yang sama
SELECT 
    teachers.name AS teacher_name,
    GROUP_CONCAT(classes.name) AS class_list
FROM 
    classes
JOIN 
    teachers ON classes.teacher_id = teachers.id
GROUP BY 
    teachers.name;

-- membuat view siswa, kelas, dan guru yang mengajar
CREATE VIEW student_class_teacher AS
SELECT 
    students.name AS student_name,
    classes.name AS class_name,
    teachers.name AS teacher_name
FROM 
    students
JOIN 
    classes ON students.class_id = classes.id
JOIN 
    teachers ON classes.teacher_id = teachers.id;

-- membuat stored procedure
DELIMITER $$

CREATE PROCEDURE GetStudentClassTeacher()
BEGIN
    SELECT 
        students.name AS student_name,
        classes.name AS class_name,
        teachers.name AS teacher_name
    FROM 
        students
    JOIN 
        classes ON students.class_id = classes.id
    JOIN 
        teachers ON classes.teacher_id = teachers.id;
END$$

DELIMITER ;

-- memasukkan data dengan warning error jika ada data yang sama
DELIMITER $$

CREATE PROCEDURE InsertStudent(IN student_name VARCHAR(100), IN student_age INT, IN student_class_id INT)
BEGIN
    IF EXISTS (SELECT 1 FROM students WHERE name = student_name AND age = student_age AND class_id = student_class_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Duplicate data entry';
    ELSE
        INSERT INTO students (name, age, class_id) VALUES (student_name, student_age, student_class_id);
    END IF;
END$$

DELIMITER ;

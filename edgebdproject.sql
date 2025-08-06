##part A

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100),
    dob DATE,
    department_id INT
);

CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    department_id INT
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade DECIMAL(3,2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
CREATE VIEW TopStudents AS
SELECT 
    s.student_id,
    s.name,
    AVG(e.grade) AS average_grade
FROM 
    Students s
JOIN 
    Enrollments e ON s.student_id = e.student_id
GROUP BY 
    s.student_id, s.name
HAVING 
    AVG(e.grade) > 3.5;

DELIMITER //

CREATE PROCEDURE IncreaseGrade(IN input_course_id INT)
BEGIN
    UPDATE Enrollments
    SET grade = LEAST(grade + 0.5, 4.0)
    WHERE course_id = input_course_id;
END //

DELIMITER ;
SELECT 
    s.student_id,
    s.name,
    e.course_id,
    e.grade
FROM 
    Students s
JOIN 
    Enrollments e ON s.student_id = e.student_id
WHERE 
    e.grade = (
        SELECT MAX(e2.grade)
        FROM Enrollments e2
        WHERE e2.course_id = e.course_id
    );


##part B

SELECT 
    d.department_name,
    COUNT(DISTINCT s.student_id) AS total_students,
    AVG(e.grade) AS average_grade,
    COUNT(DISTINCT c.course_id) AS number_of_courses
FROM 
    Departments d
JOIN 
    Students s ON d.department_id = s.department_id
JOIN 
    Enrollments e ON s.student_id = e.student_id
JOIN 
    Courses c ON d.department_id = c.department_id
GROUP BY 
    d.department_id, d.department_name
HAVING 
    COUNT(DISTINCT c.course_id) >= 2
ORDER BY 
    average_grade DESC;


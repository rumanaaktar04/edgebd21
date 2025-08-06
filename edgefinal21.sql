##part A

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    dob DATE,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

INSERT INTO Students (student_id, name, email, dob, department_id)
VALUES 
    (101, 'John Doe', 'john@example.com', '2002-06-15', 2),
    (102, 'Jane Smith', 'jane@example.com', '2001-10-30', 1);

SELECT * 
FROM Students
WHERE dob > '2002-12-31'
ORDER BY name DESC;

SELECT department_id, COUNT(*) AS total_students
FROM Students
GROUP BY department_id;

DELETE FROM Students
WHERE dob < '2000-01-01';

##part B

SELECT s.name, d.department_name
FROM Students s
JOIN Departments d ON s.department_id = d.department_id;

SELECT c.course_name, AVG(e.grade) AS avg_grade
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name
HAVING AVG(e.grade) > 3.0;

SELECT s.*
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

SELECT c.course_name, COUNT(e.student_id) AS num_students
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY num_students DESC;

SELECT s.student_id, s.name, e.course_id, e.grade
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
WHERE e.grade > (
    SELECT AVG(e2.grade)
    FROM Enrollments e2
    WHERE e2.course_id = e.course_id
);

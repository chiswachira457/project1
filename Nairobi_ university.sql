-- Create Database
CREATE DATABASE Nairobi_university_database;
USE Nairobi_university_database;

-- =========================
-- Departments Table
-- =========================
CREATE TABLE Departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE
);

-- =========================
-- Courses Table
-- =========================
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_duration VARCHAR(45) NOT NULL,
    course_mode VARCHAR(56) NOT NULL,
    dept_id INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

-- =========================
-- Students Table
-- =========================
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(70) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    contact VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    age INT CHECK (age >= 18)
);

-- =========================
-- Trainers (Lecturers/Professors) Table
-- =========================
CREATE TABLE Trainers (
    trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(70) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    contact_info VARCHAR(80) NOT NULL,
    email VARCHAR(60) NOT NULL UNIQUE,
    dept_id INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

-- =========================
-- Enrollment Table (Students <-> Courses Many-to-Many)
-- =========================
CREATE TABLE Enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL ,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    UNIQUE(student_id, course_id)  -- prevent duplicate enrollment
);

-- =========================
-- Academic Records Table
-- =========================
CREATE TABLE Academic_Records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    trainer_id INT NOT NULL,
    grade CHAR(2),   -- e.g., A, B, C, D, F
    semester VARCHAR(20),
    year INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id)
);

-- =========================
-- Admin Table (System Staff)
-- =========================
CREATE TABLE Admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(70) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contact VARCHAR(20) NOT NULL,
    role ENUM('Registrar', 'Dean', 'System Admin', 'Clerk') NOT NULL,
    password_hash VARCHAR(255) NOT NULL -- For authentication
);

-- =========================
-- Classrooms Table
-- =========================
CREATE TABLE Classrooms (
    classroom_id INT AUTO_INCREMENT PRIMARY KEY,
    building_name VARCHAR(100) NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

-- =========================
-- Timetable Table
-- =========================
CREATE TABLE Timetable (
    timetable_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    trainer_id INT NOT NULL,
    classroom_id INT NOT NULL,
    day_of_week ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    semester VARCHAR(20) NOT NULL,
    year INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id),
    FOREIGN KEY (classroom_id) REFERENCES Classrooms(classroom_id),
    CONSTRAINT chk_time CHECK (end_time > start_time)
);

USE Nairobi_university_database;

-- =========================
-- Programs/Degrees
-- =========================
CREATE TABLE Programs (
    program_id INT AUTO_INCREMENT PRIMARY KEY,
    program_name VARCHAR(100) NOT NULL,
    degree_type ENUM('Diploma','Bachelors','Masters','PhD') NOT NULL,
    duration_years INT NOT NULL,
    dept_id INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

-- Link Courses to Programs
CREATE TABLE Program_Courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    program_id INT NOT NULL,
    course_id INT NOT NULL,
    FOREIGN KEY (program_id) REFERENCES Programs(program_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    UNIQUE(program_id, course_id)
);

-- =========================
-- Fees & Payments
-- =========================
CREATE TABLE Fees (
    fee_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    amount_due DECIMAL(10,2) NOT NULL,
    due_date DATE NOT NULL,
    status ENUM('Pending','Paid','Overdue') DEFAULT 'Pending',
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    fee_id INT NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    method ENUM('Cash','Bank','Mpesa','Card'),
    FOREIGN KEY (fee_id) REFERENCES Fees(fee_id)
);

-- =========================
-- Library System
-- =========================
CREATE TABLE Library_Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100),
    isbn VARCHAR(30) UNIQUE,
    published_year INT,
    available_copies INT DEFAULT 1
);

CREATE TABLE Borrow_Records (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    book_id INT NOT NULL,
    borrow_date DATE ,
    return_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (book_id) REFERENCES Library_Books(book_id),
    UNIQUE(student_id, book_id, borrow_date)
);

-- =========================
-- Exams & Results
-- =========================
CREATE TABLE Exams (
    exam_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    exam_date DATE NOT NULL,
    exam_type ENUM('CAT','Final','Supplementary') NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Exam_Results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT NOT NULL,
    student_id INT NOT NULL,
    marks DECIMAL(5,2) NOT NULL,
    grade CHAR(2),
    FOREIGN KEY (exam_id) REFERENCES Exams(exam_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    UNIQUE(exam_id, student_id)
);

-- =========================
-- Attendance
-- =========================
CREATE TABLE Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    timetable_id INT NOT NULL,
    status ENUM('Present','Absent','Late') NOT NULL,
    date DATE NOT NULL ,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (timetable_id) REFERENCES Timetable(timetable_id)
);

USE Nairobi_university_database;

-- =========================
-- Departments
-- =========================
INSERT INTO Departments (dept_name)
VALUES ('Computer Science'),
       ('Business Administration'),
       ('Medicine'),
       ('Engineering');

-- =========================
-- Programs
-- =========================
INSERT INTO Programs (program_name, degree_type, duration_years, dept_id)
VALUES ('BSc Computer Science', 'Bachelors', 4, 1),
       ('MBA Business Admin', 'Masters', 2, 2),
       ('MBBS Medicine', 'Bachelors', 6, 3),
       ('BSc Mechanical Engineering', 'Bachelors', 5, 4);

-- =========================
-- Courses
-- =========================
INSERT INTO Courses (course_name, course_duration, course_mode, dept_id)
VALUES ('Database Systems', '1 Semester', 'Full-time', 1),
       ('Software Engineering', '1 Semester', 'Full-time', 1),
       ('Accounting Basics', '1 Semester', 'Part-time', 2),
       ('Business Ethics', '1 Semester', 'Full-time', 2),
       ('Human Anatomy', '2 Semesters', 'Full-time', 3),
       ('Thermodynamics', '1 Semester', 'Full-time', 4);

-- =========================
-- Students
-- =========================
INSERT INTO Students (first_name, last_name, email, gender, contact, date_of_birth, age)
VALUES ('John', 'Mwangi', 'john.mwangi@students.uon.ac.ke', 'Male', '0712345678', '2002-05-12', 23),
       ('Mary', 'Wanjiku', 'mary.wanjiku@students.uon.ac.ke', 'Female', '0722334455', '2001-08-24', 24),
       ('Kevin', 'Otieno', 'kevin.otieno@students.uon.ac.ke', 'Male', '0733445566', '2000-11-05', 25),
       ('Aisha', 'Hassan', 'aisha.hassan@students.uon.ac.ke', 'Female', '0744556677', '1999-02-14', 26);

-- =========================
-- Trainers
-- =========================
INSERT INTO Trainers (first_name, last_name, contact_info, email, dept_id)
VALUES ('James', 'Kamau', '0722001100', 'j.kamau@uon.ac.ke', 1),
       ('Grace', 'Njeri', '0722112233', 'g.njeri@uon.ac.ke', 2),
       ('Peter', 'Mutiso', '0722334455', 'p.mutiso@uon.ac.ke', 3),
       ('Sarah', 'Odhiambo', '0722445566', 's.odhiambo@uon.ac.ke', 4);

-- =========================
-- Classrooms
-- =========================
INSERT INTO Classrooms (building_name, room_number, capacity, dept_id)
VALUES ('Main Building', 'A101', 100, 1),
       ('Business Block', 'B201', 80, 2),
       ('Medical School', 'M301', 120, 3),
       ('Engineering Complex', 'E401', 90, 4);

-- =========================
-- Timetable
-- =========================
INSERT INTO Timetable (course_id, trainer_id, classroom_id, day_of_week, start_time, end_time, semester, year)
VALUES (1, 1, 1, 'Monday', '09:00:00', '11:00:00', 'Semester 1', 2025),
       (2, 1, 1, 'Wednesday', '14:00:00', '16:00:00', 'Semester 1', 2025),
       (3, 2, 2, 'Tuesday', '10:00:00', '12:00:00', 'Semester 1', 2025),
       (5, 3, 3, 'Friday', '08:00:00', '10:00:00', 'Semester 1', 2025);

-- =========================
-- Enrollment
-- =========================
INSERT INTO Enrollment (student_id, course_id)
VALUES (1, 1), (1, 2),  -- John takes DB + SE
       (2, 3),          -- Mary takes Accounting
       (3, 5),          -- Kevin takes Anatomy
       (4, 6);          -- Aisha takes Thermodynamics

-- =========================
-- Fees
-- =========================
INSERT INTO Fees (student_id, amount_due, due_date, status)
VALUES (1, 50000, '2025-03-15', 'Pending'),
       (2, 60000, '2025-03-15', 'Paid'),
       (3, 45000, '2025-03-15', 'Pending'),
       (4, 55000, '2025-03-15', 'Overdue');

-- Payments
INSERT INTO Payments (fee_id, amount_paid, payment_date, method)
VALUES (2, 60000, '2025-02-10', 'Mpesa');

-- =========================
-- Library
-- =========================
INSERT INTO Library_Books (title, author, isbn, published_year, available_copies)
VALUES ('Database Management Systems', 'Raghu Ramakrishnan', '9780072465631', 2015, 5),
       ('Business Management', 'Peter Drucker', '9780066620992', 2010, 3),
       ('Human Anatomy Atlas', 'Frank Netter', '9780323393225', 2018, 2);

INSERT INTO Borrow_Records (student_id, book_id, borrow_date)
VALUES (1, 1, '2025-02-20'),
       (2, 2, '2025-02-21');

-- =========================
-- Exams & Results
-- =========================
INSERT INTO Exams (course_id, exam_date, exam_type)
VALUES (1, '2025-04-20', 'Final'),
       (3, '2025-04-22', 'Final');

INSERT INTO Exam_Results (exam_id, student_id, marks, grade)
VALUES (1, 1, 78.5, 'B'),
       (2, 2, 85.0, 'A');

-- =========================
-- Attendance
-- =========================
INSERT INTO Attendance (student_id, timetable_id, status, date)
VALUES (1, 1, 'Present', '2025-03-01'),
       (1, 2, 'Absent', '2025-03-03'),
       (2, 3, 'Present', '2025-03-02');

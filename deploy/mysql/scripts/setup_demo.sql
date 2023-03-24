--changeset m.w:101 endDelimiter:/
CREATE TABLE `departments` (`dept_no` char(4) NOT NULL,`dept_name` varchar(40) NOT NULL,PRIMARY KEY (`dept_no`),UNIQUE KEY `dept_name` (`dept_name`));/
CREATE TABLE `employees` (`emp_no` int NOT NULL,`birth_date` date NOT NULL,`first_name` varchar(14) NOT NULL,`last_name` varchar(16) NOT NULL,`gender` enum('M','F') NOT NULL,`hire_date` date NOT NULL,PRIMARY KEY (`emp_no`));/
CREATE TABLE `dept_emp` (`emp_no` int NOT NULL,`dept_no` char(4) NOT NULL,`from_date` date NOT NULL,`to_date` date NOT NULL,PRIMARY KEY (`emp_no`,`dept_no`),KEY `emp_no` (`emp_no`),KEY `dept_no` (`dept_no`),CONSTRAINT `dept_emp_ibfk_1` FOREIGN KEY (`emp_no`) REFERENCES `employees` (`emp_no`) ON DELETE CASCADE,  CONSTRAINT `dept_emp_ibfk_2` FOREIGN KEY (`dept_no`) REFERENCES `departments` (`dept_no`) ON DELETE CASCADE);/

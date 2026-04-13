An advanced database project demonstrating the use of active database objects (Triggers) to automate business logic and maintain audit trails within a university faculty management system.

## 🚀 System Logic: Automated Increments
The system automatically calculates and applies increments based on academic performance and tenure:
* **20% Increase:** Duration > 1 year AND Publications > 4.
* **10% Increase:** Duration > 1 year AND Publications = 2 or 3.
* **5% Increase:** Duration > 1 year AND Publications = 1.
* **0% Increase:** New employees (≤ 1 year) or zero publications.

## 🛠️ Database Schema
The database `faculty_trigger_lab` consists of two primary tables:
1.  **EMPLOYEE**: Stores primary faculty data including tenure and publication counts.
2.  **SALARY_LOG**: An automated audit table that captures the history of salary changes, including old values, new values, timestamps, and descriptive notes.

## ⚙️ Trigger Implementations
* **BEFORE UPDATE (`trg_calculate_increment`)**: Intercepts update commands to calculate the `IncrementRate` and `UpdatedSalary` using tenure logic before the data is written to the disk.
* **AFTER UPDATE (`trg_log_salary_change`)**: Detects changes in the salary field and automatically inserts a record into the `SALARY_LOG` for auditing purposes.

## 📊 Sample Records & Testing
The project includes a test suite that covers all policy cases using real-world scenarios:
* **Case 1:** Senior faculty with high research output (20% logic).
* **Case 2:** Mid-level faculty with steady publications (10% logic).
* **Case 3:** Junior faculty with initial publications (5% logic).
* **Case 4:** New recruits (No increment logic).

## 📂 Visual Documentation
| Faculty Records | Salary Audit Log |
| :--- | :--- |
| ![Employee Table](https://raw.githubusercontent.com/placeholder/emp.jpg) | ![Salary Log](https://raw.githubusercontent.com/placeholder/log.jpg) |

---
*Created for Database Systems Laboratory Practice - focusing on Active Databases.*
"""
  

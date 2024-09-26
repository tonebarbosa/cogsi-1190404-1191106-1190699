package payroll;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class EmployeeTest {

        @Test
        public void testEmployee() {
            Employee emp = new Employee("name", "role" );
            emp.setJobYears(5);
            Employee emp2 = new Employee("name", "role", 5);
            assertEquals(emp, emp2);
        }
}

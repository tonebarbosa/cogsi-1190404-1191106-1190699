package integrationTest.java;

import org.junit.jupiter.api.Test;
import payroll.Employee;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class EmployeeIntegrationTest {
    @Test
    public void testEmployee() {
        Employee emp = new Employee("name", "role" );
        emp.setJobYears(5);
        Employee emp2 = new Employee("name", "role", 5);
        assertEquals(emp, emp2);
    }

    @Test
    public void testEmployee2() {
        Employee emp = new Employee("name", "role",5);
        emp.setEmail("1240000@isep.ipp.pt");
        Employee emp2 = new Employee("name", "role", 5,"1240000@isep.ipp.pt");
        assertEquals(emp, emp2);
    }

    @Test
    public void setEmail(){
        Employee emp2 = new Employee("name", "role", 5,"1240000@isep.ipp.pt");
        String email = "1240000@isep.ipp.pt";
        assertEquals(emp2.getEmail(),email);
    }

}

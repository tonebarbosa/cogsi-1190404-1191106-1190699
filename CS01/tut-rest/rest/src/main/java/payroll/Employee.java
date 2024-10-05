package payroll;

import java.util.Objects;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Entity
class Employee {

	private @Id @GeneratedValue Long id;
	private String name;
	private String role;
	private int jobYears;
	private String email;

	public Employee() {}

	Employee(String name, String role) {

		this.name = name;
		this.role = role;
	}
	Employee(String name, String role,int jobYears ) {

		this.name = name;
		this.role = role;
		this.jobYears = jobYears;
	}

	public Employee(String name, String role, int jobYears, String email) {
		this.name = name;
		this.role = role;
		this.jobYears = jobYears;
		setEmail(email);
	}

	public Long getId() {
		return this.id;
	}

	public String getName() {
		return this.name;
	}

	public String getRole() {
		return this.role;
	}
	public int getJobYears() {
		return this.jobYears;
	}
	public String getEmail() { return email; }
	public void setId(Long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setRole(String role) {
		this.role = role;
	}
	public void setJobYears(int jobYears) {
		this.jobYears = jobYears;
	}
	public void setEmail(String email) {
		if(email.contains("@")) this.email = email;
	}

	@Override
	public boolean equals(Object o) {

		if (this == o)
			return true;
		if (!(o instanceof Employee))
			return false;
		Employee employee = (Employee) o;
		return Objects.equals(this.id, employee.id) && Objects.equals(this.name, employee.name)
				&& Objects.equals(this.role, employee.role)&& Objects.equals(this.jobYears, employee.jobYears) && Objects.equals(this.email,employee.email);
	}


	@Override
	public int hashCode() {
		return Objects.hash(this.id, this.name, this.role);
	}

	@Override
	public String toString() {
		return "Employee{" + "id=" + this.id + ", name='" + this.name + '\'' + ", role='" + this.role + '\'' + '}';
	}
}

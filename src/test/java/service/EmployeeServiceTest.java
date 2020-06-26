package service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.van.service.IEmployeeService;

/**
 * 员工service层测试类
 * 
 * @author Van
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
public class EmployeeServiceTest {
	@Autowired
	IEmployeeService employeeService;

	@Test
	public void testQueryEmployeeByEmpId() {
		System.out.println(employeeService.queryEmployeeByEmpId(1));
	}

	@Test
	public void testQueryAllEmployees() {
		System.out.println(employeeService.queryAllEmployees());
	}

	@Test
	public void testAddEmployee() {
		employeeService.addEmployee("John", "M", "", 3);
	}

	@Test
	public void testQueryEmployeeByEmpName() {
		System.out.println(employeeService.queryEmployeeByEmpName("Costa"));
	}
}

package dao;

import java.util.LinkedList;
import java.util.List;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.van.bean.Department;
import com.van.bean.Employee;
import com.van.dao.IEmployeeDao;

/**
 * EmployeeDao的单元测试类
 * 
 * @author Van
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
public class EmployeeDaoTest {
	@Autowired
	IEmployeeDao employeeDao;
	@Autowired
	SqlSession sqlSession;

	@Test
	public void testSelectEmployeeByEmpId() {
		System.out.println(employeeDao.queryEmployeeByEmpId(1));
	}

	@Test
	public void testQueryAllEmployees() {
		System.out.println(employeeDao.queryAllEmployees());
	}

	@Test
	public void testAddEmployee() {
		employeeDao.addEmployee(new Employee(null, "Linda", "W", "666@atguigu.com", new Department(1, null)));
	}

	/**
	 * 批量插入1000条员工记录
	 */
	@Test
	public void testAddManyEmployees() {
		IEmployeeDao mapper = (IEmployeeDao) sqlSession.getMapper(IEmployeeDao.class);
		for (int i = 0; i < 1000; i++) {
			String uid = UUID.randomUUID().toString().substring(0, 5) + i;
			mapper.addEmployee(new Employee(null, uid, "M", uid + "@atguigu.com", 1));
		}
		System.out.println("批量插入完成");
	}

	@Test
	public void testQueryEmployeeByEmpName() {
		System.out.println(employeeDao.queryEmployeeByEmpName("Costa"));
	}

	@Test
	public void testDeleteSelectedEmployees() {
		List<Integer> empIdList = new LinkedList<Integer>();
		empIdList.add(19);
		empIdList.add(20);
		employeeDao.deleteSelectedEmployees(empIdList);
	}
}

package dao;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.van.dao.IDepartmentDao;

/**
 * JUnit test of department's DAL
 * 
 * @author Van
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
public class DepartmentDaoTest {
	@Autowired
	IDepartmentDao departmentDao;

	@Test
	public void testQueryAllDepartments() {
		System.out.println(departmentDao.queryAllDepartments());
	}
}

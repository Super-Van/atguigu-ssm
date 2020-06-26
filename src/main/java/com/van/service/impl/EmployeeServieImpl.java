package com.van.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.van.bean.Department;
import com.van.bean.Employee;
import com.van.dao.IEmployeeDao;
import com.van.service.IEmployeeService;

/**
 * 员工service层实现类
 * 
 * @author Van
 */
@Service
public class EmployeeServieImpl implements IEmployeeService {
	@Autowired
	IEmployeeDao employeeDao;

	@Override
	public Employee queryEmployeeByEmpId(int empId) {
		return employeeDao.queryEmployeeByEmpId(empId);
	}

	@Override
	public List<Employee> queryAllEmployees() {
		return employeeDao.queryAllEmployees();
	}

	@Override
	public PageInfo<Employee> queryEmployeesByPage(Integer pageNum, int pageSize) {
		// 引入分页插件pageHelper进行分页查询
		// 传入当前页号和每页记录数
		PageHelper.startPage(pageNum, pageSize);
		// 查询所有员工
		List<Employee> employees = queryAllEmployees();
		// 用pageInfo包装查询结果，传入结果和每页记录数
		PageInfo<Employee> pageInfo = new PageInfo<Employee>(employees, pageSize);
		return pageInfo;
	}

	@Override
	public void addEmployee(String empName, String empGender, String empEmail, int deptId) {
		Department department = new Department(deptId, null);
		Employee employee = new Employee(null, empName, empGender, empEmail, department);
		employeeDao.addEmployee(employee);
	}

	@Override
	public Employee queryEmployeeByEmpName(String empName) {
		return employeeDao.queryEmployeeByEmpName(empName);
	}

	@Override
	public void updateEmployeeByEmpName(Employee employee) {
		employeeDao.updateEmployeeByEmpName(employee);
	}

	@Override
	public void deleteEmployee(Integer empId) {
		employeeDao.deleteEmployee(empId);
	}

	@Override
	public void deleteSelectedEmployees(List<Integer> empIdList) {
		employeeDao.deleteSelectedEmployees(empIdList);
	}

}

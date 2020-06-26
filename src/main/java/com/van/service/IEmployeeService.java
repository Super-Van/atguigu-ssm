package com.van.service;

import java.util.List;

import com.github.pagehelper.PageInfo;
import com.van.bean.Employee;

/**
 * 员工service层接口
 * 
 * @author Van
 */
public interface IEmployeeService {
	/**
	 * 根据员工号查询某个员工
	 * 
	 * @param empId 员工号
	 * @return 员工对象
	 */
	Employee queryEmployeeByEmpId(int empId);

	/**
	 * 查询所有员工
	 * 
	 * @return 员工对象列表
	 */
	List<Employee> queryAllEmployees();

	/**
	 * 分页查询员工
	 * 
	 * @param pageNum  当前页号
	 * @param pageSize 每页显示的记录数
	 * @return 员工对象列表
	 */
	PageInfo<Employee> queryEmployeesByPage(Integer pageNum, int pageSize);

	/**
	 * 插入一个员工
	 * 
	 * @param empName   姓名
	 * @param empGender 性别
	 * @param empEmail  邮箱
	 * @param deptId    部门号
	 */
	void addEmployee(String empName, String empGender, String empEmail, int deptId);

	/**
	 * 根据员工号查询一个员工
	 * 
	 * @param empName 员工号
	 * @return
	 */
	Employee queryEmployeeByEmpName(String empName);

	/**
	 * 根据员工名修改员工数据
	 * 
	 * @param employee 员工对象
	 */
	void updateEmployeeByEmpName(Employee employee);

	/**
	 * 根据员工号删除员工
	 * 
	 * @param empId 员工号
	 */
	void deleteEmployee(Integer empId);

	/**
	 * 删除若干个员工
	 * 
	 * @param empIdList 员工号列表
	 */
	void deleteSelectedEmployees(List<Integer> empIdList);
}

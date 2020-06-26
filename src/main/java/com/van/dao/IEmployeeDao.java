package com.van.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.van.bean.Employee;

/**
 * 员工dao层接口
 * 
 * @author Van
 */
public interface IEmployeeDao {
	/**
	 * 根据员工号查询某个员工
	 * 
	 * @param employeeId 员工号
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
	 * 插入一个员工
	 * 
	 * @param employee 员工对象
	 */
	void addEmployee(Employee employee);

	/**
	 * 根据与员工名查询一个员工
	 * 
	 * @param empName 员工名
	 * @return
	 */
	Employee queryEmployeeByEmpName(String empName);

	/**
	 * 根据员工名更新员工信息
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
	void deleteSelectedEmployees(@Param("empIdList") List<Integer> empIdList);
}

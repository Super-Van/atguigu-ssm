package com.van.dao;

import java.util.List;

import com.van.bean.Department;

/**
 * DAL of department
 * 
 * @author Van
 */
public interface IDepartmentDao {
	/**
	 * 查询所有部门
	 * 
	 * @return
	 */
	List<Department> queryAllDepartments();
}

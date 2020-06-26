package com.van.service;

import java.util.List;

import com.van.bean.Department;

/**
 * business logic layer of department
 * 
 * @author Van
 */
public interface IDepartmentService {
	/**
	 * query all departments
	 * 
	 * @return list of departments
	 */
	List<Department> queryAllDepartments();
}

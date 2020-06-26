package com.van.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.van.bean.Department;
import com.van.dao.IDepartmentDao;
import com.van.service.IDepartmentService;

/**
 * implementation of IDepartmentSerivce
 * 
 * @author Van
 */
@Service
public class DepartmentServiceImpl implements IDepartmentService {
	@Autowired
	IDepartmentDao departmentDao;

	@Override
	public List<Department> queryAllDepartments() {
		return departmentDao.queryAllDepartments();
	}

}

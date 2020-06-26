package com.van.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.van.bean.Department;
import com.van.bean.Msg;
import com.van.service.IDepartmentService;

/**
 * USL of department
 * 
 * @author Van
 */
@Controller
public class DepartmentController {
	@Autowired
	IDepartmentService departmentService;

	/**
	 * 获取所有部门
	 * 
	 * @return
	 */
	@RequestMapping("showDepartmentList")
	@ResponseBody
	public Msg showDepartmentList() {
		// 查询所有部门
		List<Department> departmentList = departmentService.queryAllDepartments();
		Msg msg = Msg.success("departmentList", departmentList);
		return msg;
	}
}

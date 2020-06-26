package com.van.controller;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.van.bean.Employee;
import com.van.bean.Msg;
import com.van.service.IEmployeeService;

/**
 * 员工控制层
 * 
 * @author Van
 */
@Controller
public class EmployeeController {
	@Autowired
	IEmployeeService employeeService;
	// 单页数据量
	private static final int PAGESIZE = 7;
	// 默认页号
	private static final int DEFAULTPAGENUM = 1;

	/**
	 * 旧式的员工列表展示
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "employee")
	public String employee(Model model, @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum) {
		PageInfo<Employee> pageInfo = employeeService.queryEmployeesByPage(pageNum, PAGESIZE);
		model.addAttribute("pageInfo", pageInfo);
		return "listFormer";
	}

	/**
	 * 返回json格式的所有员工数据
	 * 
	 * @param model
	 * @param pageNum 当前页号
	 * @return
	 */
	@RequestMapping(value = "employeeWithJson")
	@ResponseBody
	public Msg employeeWithJson(Model model, @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum) {
		PageInfo<Employee> pageInfo = employeeService.queryEmployeesByPage(pageNum, PAGESIZE);
		return Msg.success("pageInfo", pageInfo);
	}

	/**
	 * 校验用户名是否可用（重复）
	 * 
	 * @param empName 用户名
	 * @return
	 */
	@RequestMapping(value = "checkEmpName")
	@ResponseBody
	public Msg checkEmpName(String empName) {
		// 检查员工名是否存在
		if (employeeService.queryEmployeeByEmpName(empName) == null)
			// null：不存在，即此员工名可用
			return Msg.success();
		else {
			return Msg.fail();
		}
	}

	/**
	 * 添加一个员工
	 * 
	 * @param employee 员工对象
	 * @param result   异常结果
	 * @return
	 */
	@RequestMapping(value = "addEmployee")
	@ResponseBody
	public Msg addEmployee(@Valid Employee employee, BindingResult result) {
		// 封装错误信息
		Map<String, Object> fieldErrors = new HashMap<>();
		// 员工名和邮箱地址的格式校验
		if (result.hasErrors()) {
			for (FieldError fieldError : result.getFieldErrors()) {
				fieldErrors.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			// 返回错误信息，在页面显示
			return Msg.fail("fieldErrors", fieldErrors);
		} else if (employeeService.queryEmployeeByEmpName(employee.getEmpName()) == null) {
			// 员工名重复性校验
			fieldErrors.put("empName", "员工名已存在");
			return Msg.fail("fieldErrors", fieldErrors);
		} else {
			// 添加一个员工
			employeeService.addEmployee(employee.getEmpName(), employee.getEmpGender(), employee.getEmpEmail(),
					employee.getDepartment().getDeptId());
			PageInfo<Employee> pageInfo = employeeService.queryEmployeesByPage(DEFAULTPAGENUM, PAGESIZE);
			return Msg.success("pageInfo", pageInfo);
		}
	}

	/**
	 * 获取某个员工的数据
	 * 
	 * @param empId 员工号
	 * @return
	 */
	@RequestMapping(value = "getEmployee", method = RequestMethod.POST)
	@ResponseBody
	public Msg getEmployee(Integer empId) {
		// 根据员工号查询员工
		Employee employee = employeeService.queryEmployeeByEmpId(empId);
		// 返回本员工数据
		return Msg.success("employee", employee);
	}

	/**
	 * 更新某员工数据
	 * 
	 * @param employee 员工对象
	 * @param result   异常结果
	 * @return
	 */
	@RequestMapping(value = "updateEmployee", method = RequestMethod.PUT)
	@ResponseBody
	public Msg updateEmployee(@Valid Employee employee, BindingResult result) {
		// 封装错误信息
		Map<String, Object> fieldErrors = new HashMap<>();
		// 邮箱地址的格式校验
		if (result.hasErrors()) {
			for (FieldError fieldError : result.getFieldErrors()) {
				fieldErrors.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			// 返回错误信息，在页面显示
			return Msg.fail("fieldErrors", fieldErrors);
		} else {
			// 更新数据
			employeeService.updateEmployeeByEmpName(employee);
			// 返回成功
			return Msg.success();
		}
	}

	/**
	 * 删除某个员工；删除多个员工
	 * 
	 * @param empId 员工号
	 * @return
	 */
	@RequestMapping(value = "deleteEmployee", method = RequestMethod.DELETE)
	@ResponseBody
	public Msg deleteEmployee(String empId) {
		// 批量删除
		if (empId.contains("-")) {
			// 剥离横杠，把员工号序列拆成员工号数组
			String[] empIds = empId.split("-");
			// 把字符串数组重装为整形列表
			List<Integer> empIdList = new LinkedList<Integer>();
			for (String empIdItem : empIds) {
				empIdList.add(Integer.parseInt(empIdItem));
			}
			// 删除多个员工
			employeeService.deleteSelectedEmployees(empIdList);
			// 返回成功
			return Msg.success();
		} else {
			// 删除一个员工
			employeeService.deleteEmployee(Integer.parseInt(empId));
			// 返回成功
			return Msg.success();
		}
	}
}

package com.van.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 页面访问控制层
 * 
 * @author Van
 */
@Controller
public class ApplicationController {
	/**
	 * 访问list.jsp
	 * 
	 * @return
	 */
	@RequestMapping(value = "toList")
	public String toList() {
		return "list";
	}
}

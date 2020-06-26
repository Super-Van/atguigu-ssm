package com.van.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * 封装各式控制信息的json返回对象
 * 
 * @author Van
 */
public class Msg {
	// 状态码：520表成功；250表失败
	private int code;
	// 成功与否提示信息
	private String info;
	// 返回的主要对象映射
	private Map<String, Object> extend = new HashMap<String, Object>();

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}

	public Map<String, Object> getExtend() {
		return extend;
	}

	public void setExtend(Map<String, Object> extend) {
		this.extend = extend;
	}

	@Override
	public String toString() {
		return "Msg [code=" + code + ", info=" + info + ", extend=" + extend + "]";
	}

	/**
	 * 后台成功返回，带数据（对象、映射、列表等）
	 * 
	 * @param key   数据名
	 * @param value 数据值
	 * @return
	 */
	public static Msg success(String key, Object value) {
		Msg result = new Msg();
		result.code = 520;
		result.info = "处理成功";
		result.extend.put(key, value);
		return result;
	}

	/**
	 * 后台成功返回，不带数据
	 * 
	 * @return
	 */
	public static Msg success() {
		Msg result = new Msg();
		result.code = 520;
		result.info = "处理成功";
		return result;
	}

	/**
	 * 后台返回失败
	 * 
	 * @return
	 */
	public static Msg fail() {
		Msg result = new Msg();
		result.code = 250;
		result.info = "处理失败";
		return result;
	}

	/**
	 * 后台返回失败，带数据
	 * 
	 * @param key
	 * @param value
	 * @return
	 */
	public static Msg fail(String key, Object value) {
		Msg result = new Msg();
		result.code = 250;
		result.info = "处理失败";
		result.extend.put(key, value);
		return result;
	}
}

<!--
 * @Author: Van
 * @Date: 2020-05-18 11:28:24
 * @LastEditTime: 2020-06-01 16:26:21
 * @Description: listFormer.jsp
-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>

<head>
	<% pageContext.setAttribute("appPath",request.getContextPath()); %>
	<meta charset="UTF-8">
	<title>员工列表展示</title>
	<link rel="stylesheet" href="${appPath}/static/css/bootstrap.css">
	<script src="${appPath}/static/js/jquery-3.3.1.js"></script>
	<script src="${appPath}/static/js/bootstrap.js"></script>

	<style>
		.container {
			width: 800px;
			height: auto;
		}
	</style>
</head>

<body>
	<h2>雷丰阳-尚硅谷-SSM</h2>
	<div class="container">
		<div class="row">
			<table class="table table-hover">
				<tr>
					<th>编号</th>
					<th>姓名</th>
					<th>性别</th>
					<th>邮箱</th>
					<th>部门</th>
				</tr>
				<c:forEach items="${pageInfo.list }" var="employee">
					<tr>
						<td>${employee.empId }</td>
						<td>${employee.empName }</td>
						<td>${employee.empGender == "M" ? "男" : "女" }</td>
						<td>${employee.empEmail }</td>
						<td>${employee.department.deptName }</td>
					</tr>
				</c:forEach>
			</table>
		</div>
		<div class="row">
			<div class="col-md-6">
				<h4>
					总记录数：<span>${pageInfo.total }</span>，总页数：<span>${pageInfo.pages
						}</span>，当前页：<span>${pageInfo.pageNum }</span>
				</h4>
			</div>
			<div class="col-md-6">
				<nav aria-label="Page navigation">
					<ul class="pagination">
						<c:if test="${pageInfo.hasPreviousPage }">
							<li>
								<a href="${appPath }/employee?pageNum=${pageInfo.pageNum - 1}" aria-label="Previous">
									<span aria-hidden="true">&laquo;</span>
								</a>
							</li>
						</c:if>
						<c:forEach items="${pageInfo.navigatepageNums }" var="pageItem">
							<li class="${pageInfo.pageNum == pageItem ? 'active' : '' }"><a
									href="${appPath }/employee?pageNum=${pageItem }">${pageItem
									}</a></li>
						</c:forEach>
						<c:if test="${pageInfo.hasNextPage }">
							<li>
								<a href="${appPath }/employee?pageNum=${pageInfo.pageNum + 1 }" aria-label="Next">
									<span aria-hidden="true">&raquo;</span>
								</a>
							</li>
						</c:if>
					</ul>
				</nav>
			</div>
		</div>
	</div>
</body>

</html>
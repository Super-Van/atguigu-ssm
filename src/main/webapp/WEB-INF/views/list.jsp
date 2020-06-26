<!--
 * @Author: Van
 * @Date: 2020-05-22 12:05:06
 * @LastEditTime: 2020-06-23 17:42:56
 * @Description: list.jsp
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
        .header {
            width: 1000px;
            height: auto;
        }

        .content {
            width: 1000px;
            height: auto;
        }
    </style>
</head>
<script>
    // 全局变量
    var currentPage;// 当前页号
    /**
     * @description: 解析并显示员工列表
     * @param {type} ajax返回的数据
     * @return: 
     */
    function constructEmpTb(result) {
        // 清空表格
        $('#empTb thead tr').empty();
        $('#empTb tbody').empty();
        // 填充表头
        $('#empTb thead tr')
            .append('<th><input type="checkbox" id="checkAll"/></th>')
            .append('<th>编号</th><th>姓名</th><th>性别</th><th>邮箱</th><th>部门</th><th>操作</th>');
        // 填充表体
        $.each(result.extend.pageInfo.list, function (index, item) {
            var tdCheckbox = $('<td><input type="checkbox" class="check-item"/></td>');
            var tdEmpId = $('<td></td>').append(item.empId);
            var tdEmpName = $('<td></td>').append(item.empName);
            var tdEmpGender = $('<td></td>').append(item.empGender == 'M' ? '男' : '女');
            var tdEmpEmail = $('<td></td>').append(item.empEmail);
            var tdDeptName = $('<td></td>').append(item.department.deptName);
            var editBtn = $('<button></button>')
                .append('编辑')
                .addClass('btn btn-primary btn-sm edit-btn')
                .attr('empId', item.empId);
            var deleteBtn = $('<button></button>')
                .append('删除')
                .addClass('btn btn-danger btn-sm delete-btn');
            var tdOperateBtn = $('<td></td>').append(editBtn).append('&ensp;').append(deleteBtn);
            $('<tr></tr>')
                .append(tdCheckbox)
                .append(tdEmpId)
                .append(tdEmpName)
                .append(tdEmpGender)
                .append(tdEmpEmail)
                .append(tdDeptName)
                .append(tdOperateBtn)
                .appendTo('#empTb tbody');
        });
    }
    /**
     * @description: 解析并显示分页信息
     * @param {type} ajax返回的数据
     * @return: 
     */
    function constructPageMsg(result) {
        // 清空分页信息
        $('#pageMsg').empty();
        $('#pageMsg')
            .append('总记录数：' + result.extend.pageInfo.total + '，总页数：' + result.extend.pageInfo.pages + '，当前页：' + result.extend.pageInfo.pageNum);
        // 记下当前页
        currentPage = result.extend.pageInfo.pageNum;
    }
    /**
     * @description: 解析并显示分页栏
     * @param {type}  ajax返回的数据
     * @return: 
     */
    function constructPageNav(result) {
        //清空分页栏
        $('#pageNav').empty();
        // 当前如果是第一页，即无上一页，则不显示上一页按钮
        if (result.extend.pageInfo.hasPreviousPage === false)
            $('#previousPageLi').css('display', 'none');
        //当前如果是最后一页，即无下一页，则不显示下一页按钮
        if (result.extend.pageInfo.hasNextPage === false)
            $('#nextPageLi').css('display', 'none');
        //单击以展示上一页
        $('#previousPage').click(function () {
            toSomePage(result.extend.pageInfo.pageNum - 1);
        });
        //单击以展示下一页
        $('#nextPage').click(function () {
            toSomePage(result.extend.pageInfo.pageNum + 1);
        });
        //展示中部连续若干页
        $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
            $('<li></li>').append($('<a></a>').append(item).click(function () {
                toSomePage(item);
            })).attr('class', item == result.extend.pageInfo.pageNum ? 'active' : '').appendTo('#pageNav');
        });
    }
    /**
     * @description: 用ajax访问某页
     * @param {type} 页号
     * @return: 
     */
    function toSomePage(pageNum) {
        $.ajax({
            url: '${appPath}/employeeWithJson',
            data: { "pageNum": pageNum },
            type: 'POST',
            success: function (result) {
                // 解析并显示员工列表
                constructEmpTb(result);
                // 解析并显示分页信息
                constructPageMsg(result);
                // 解析并显示分页栏
                constructPageNav(result);
            }
        });
    }
    /**
     * @description: 显示校验信息与样式
     * @param {type}
     * @return: 
     */
    function showValidateResult(elem, status, msg) {
        // 清空输入框样式及提示
        elem.parent().removeClass('has-success').removeClass('has-error');
        elem.next().empty();
        if (status === "has-success") {
            elem.parent().addClass('has-success');
            elem.next().text(msg);
        } else {
            elem.parent().addClass('has-error');
            elem.next().text(msg);
        }
    }
    /**
     * @description: 员工名校验
     * @param {type} 员工名
     * @return: 
     */
    function validateEmpName(empName) {
        // 格式
        var pattern = /^[a-zA-Z0-9_\u4e00-\u9fa5-]+$/;
        if (!pattern.test(empName)) {
            showValidateResult($('input[name="empName"]'), "has-error", "员工名格式不正确");
            $('#saveBtn').attr('nameValid', '0');
            return;
        }
        // 不能重名
        $.ajax({
            url: 'checkEmpName',
            data: { 'empName': empName },
            type: 'post',
            success: function (result) {
                if (result.code === 250) {
                    showValidateResult($('input[name="empName"]'), "has-error", "员工名已存在");
                    $('#saveBtn').attr('nameValid', '0');
                } else {
                    showValidateResult($('input[name="empName"]'), "has-success", "");
                    $('#saveBtn').attr('nameValid', '1');
                }
            }
        });
    }
    /**
     * @description: 邮箱校验
     * @param {type} 邮箱地址
     * @return: 
     */
    function validateEmail(empEmail) {
        var pattern = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!pattern.test(empEmail)) {
            showValidateResult($('#addEmpForm input[name="empEmail"]'), "has-error", "邮箱格式不正确");
            $('#saveBtn').attr('emailValid', '0');
            return false;
        }
        showValidateResult($('#addEmpForm input[name="empEmail"]'), "has-success", "");
        $('#saveBtn').attr('emailValid', '1');
    }
    /**
     * @description: 加载部门列表
     * @param {type} 
     * @return: 
     */
    function constructdeptList(elem) {
        // 清空部门列表
        $(elem).empty();
        // 解析并显示部门列表
        $.ajax({
            url: '${appPath}/showDepartmentList',
            type: 'post',
            success: function (result) {
                // 遍历部门列表
                $.each(result.extend.departmentList, function (index, item) {
                    // 填充值和内容，纳入select元素
                    $('<option></option>').val(item.deptId).append(item.deptName).appendTo(elem);
                });
            }
        });
    }
    $(function () {
        // 默认访问第1页
        toSomePage(1);
        // 单击添加按钮
        $('#addEmpBtn').click(function () {
            // 并预先加载部门列表
            constructdeptList('#deptListForAdd')
            // 弹出添加员工模态框
            $('#addEmpModal').modal();
        });
        // 单击保存按钮
        $('#saveBtn').click(function () {
            // 表单校验
            var empName = $('#addEmpForm input[name="empName"]').val();
            var empEmail = $('#addEmpForm input[name="empEmail"]').val();
            validateEmpName(empName);
            validateEmail(empEmail);
            if ($('#saveBtn').attr('nameValid') === '1' && $('#saveBtn').attr('emailValid') === '1') {
                // 校验无误则发送添加员工请求
                $.ajax({
                    url: '${appPath}/addEmployee',
                    data: $('#addEmpForm').serialize(),
                    type: 'post',
                    success: function (result) {
                        // 后台校验无误
                        if (result.code === 520) {
                            // 关闭模态框
                            $('#addEmpModal').modal('hide');
                            // 访问最后一页
                            toSomePage(result.extend.pageInfo.pages);
                        } else {
                            // 某字段有误则显示错误信息
                            if (result.extend.fieldErrors.empName !== undefined) {
                                showValidateResult($('#addEmpForm input[name="empName"]'), "has-error", result.extend.fieldErrors.empName);
                            }
                            if (result.extend.fieldErrors.empEmail !== undefined)
                                showValidateResult($('#addEmpForm input[name="empEmail"]'), "has-error", result.extend.fieldErrors.empEmail);
                        }
                    }
                });
            }
        });
        // 单击编辑按钮，注意on函数的用法
        $(document).on('click', '.edit-btn', function () {
            // 加载部门列表
            constructdeptList('#deptListForEdit');
            // 弹出修改员工模态框
            $('#editEmpModal').modal();
            // 从编辑按钮结点的员工号属性中取员工号
            var empId = $(this).attr('empId');
            // 获取本员工信息，并填入模态框
            $.ajax({
                url: '${appPath}/getEmployee',
                data: { 'empId': empId },
                type: 'post',
                success: function (result) {
                    // 根据员工号查到的员工
                    var employee = result.extend.employee;
                    // 填充信息
                    $('#editEmpModal input[name=empName]').val(employee.empName);// 用于后端取员工名
                    $('#empName').text(employee.empName);// 用于前端展示
                    $('#empEmail').val(employee.empEmail);
                    $('#editEmpModal input[name=empGender]').val([employee.empGender]);// 注意这里的写法
                    $('#deptListForEdit').val([employee.department.deptId]);
                }
            });
        });
        // 编辑完成，单击更新按钮
        $('#updateBtn').click(function () {
            // 邮箱校验
            var empEmail = $('#editEmpModal input[name=empEmail]').val();
            var pattern = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if (!pattern.test(empEmail)) {
                showValidateResult($('#editEmpForm input[name="empEmail"]'), "has-error", "邮箱格式不正确");
                $('#updateBtn').attr('emailValid', '0');
                return false;
            } else {
                showValidateResult($('#editEmpForm input[name="empEmail"]'), "has-success", "");
                $('#updateBtn').attr('emailValid', '1');
            }
            // 校验无误则更新本用户数据
            if ($('#updateBtn').attr('emailValid') === '1') {
                $.ajax({
                    url: '${appPath}/updateEmployee',
                    type: 'post',
                    data: $('#editEmpForm').serialize() + '&_method=PUT',// 表单序列化
                    success: function (result) {
                        // 后台校验无误
                        if (result.code === 520) {
                            // 关闭模态框
                            $('#editEmpModal').modal('hide');
                            // 访问本页
                            toSomePage(currentPage);
                        } else {
                            // 邮箱地址有误则显示错误信息
                            if (result.extend.fieldErrors.empEmail !== undefined)
                                showValidateResult($('#editEmpForm input[name="empEmail"]'), "has-error", result.extend.fieldErrors.empEmail);
                        }
                    }
                });
            }
        });
        // 单击单个员工的删除按钮
        $(document).on('click', '.delete-btn', function () {
            // 在删除确认模态框里填充包含员工名的提示信息
            $('#confirmDeleteModal p').text('确定删除员工 ' + $(this).parents('tr').find('td:eq(2)').text() + ' 吗？');
            // 弹出删除确认模态框
            $('#confirmDeleteModal').modal();
            // 把员工号传给确认（删除）按钮的empId属性
            $('#confirmDeleteBtn').attr('empId', $(this).parents('tr').find('td:eq(1)').text());
        });
        // 单击确认（删除）按钮
        $('#confirmDeleteBtn').click(function () {
            $.ajax({
                url: '${appPath}/deleteEmployee',
                type: 'post',
                data: {
                    'empId': $('#confirmDeleteBtn').attr('empId'),
                    '_method': 'DELETE'
                },
                success: function (result) {
                    // 删除成功
                    if (result.code === 520) {
                        // 关闭模态框
                        $('#confirmDeleteModal').modal('hide');
                        // 访问本页
                        toSomePage(currentPage);
                    }
                }
            });
        });
        // 单击全选框
        $(document).on('click', '#checkAll', function () {
            // 让所有员工记录的复选框与全选框的状态报纸一致
            $('.check-item').prop('checked', $(this).prop('checked'));
        });
        // 单击某个员工记录里的复选框
        $(document).on('click', '.check-item', function () {
            // 当选中的个数等于本页员工记录里复选框总数，全选框被选中，否则不选中
            $('#checkAll').prop('checked', $('.check-item:checked').length === $('.check-item').length);
        });
        // 单击批量删除按钮
        $('#deleteSomeEmpBtn').click(function () {
            // 员工名序列
            var empNames = ''
            // 员工号序列
            var empIds = ''
            // 遍历选中的员工，填充员工名序列和员工号序列
            $.each($('.check-item:checked'), function () {
                empNames += $(this).parents('tr').find('td:eq(2)').text() + "，&ensp;";
                empIds += $(this).parents('tr').find('td:eq(1)').text() + "-";
            });
            // 切掉多员工名字符串最后一个逗号
            empNames = empNames.substring(0, empNames.length - 7);
            // 切掉多员工号字符串最后一个横杠
            empIds = empIds.substring(0, empIds.length - 1);
            // 把员工号序列传给确认（删除）按钮的empId属性
            $('#confirmDeleteBtn').attr('empId', empIds);
            // 将员工号序列填入确认删除模态框
            $('#confirmDeleteModal p').html('确定要删除：' + empNames + '&ensp;这些员工吗？');
            // 弹出删除确认模态框
            $('#confirmDeleteModal').modal();
        });
    });
</script>

<body>
    <h4>根目录：${appPath}</h4>
    <div class="container header">
        <div class="row">
            <div class="col-md-6">
                <h2>雷丰阳-尚硅谷-SSM</h2>
            </div>
            <div class="col-md-6 text-center">
                <button id="addEmpBtn" class="btn btn-info">添加员工</button>
                <button id="deleteSomeEmpBtn" class="btn btn-danger">批量删除</button>
            </div>
        </div>
    </div>
    <div class="container content">
        <div class="row">
            <table id="empTb" class="table table-hover">
                <thead>
                    <tr></tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
        <div class="row">
            <div class="col-md-6">
                <h4 id="pageMsg"></h4>
            </div>
            <div class="col-md-6">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li id="previousPageLi">
                            <a id="previousPage" href="#" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li id="nextPageLi">
                        <ul class="pagination" id="pageNav"></ul>
                        <li id="nextPageLi">
                            <a id="nextPage" href="#" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
    <!-- 添加员工模态框 -->
    <div id="addEmpModal" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">添加员工</h4>
                </div>
                <div class="modal-body">
                    <!-- 信息填写表单 -->
                    <form id="addEmpForm" class="form-horizontal" method="POST">
                        <!-- 姓名 -->
                        <div class="form-group">
                            <label>姓名</label>
                            <input type="text" name="empName" class="form-control" placeholder="input your name">
                            <span class="help-block"></span>
                        </div>
                        <!-- 性别 -->
                        <div class="form-group">
                            <label class="col-sm-2 control-label">性别</label>
                            <label class="radio-inline">
                                <input type="radio" name="empGender" value="M"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="empGender" value="W"> 女
                            </label>
                        </div>
                        <!-- 电子邮箱 -->
                        <div class="form-group">
                            <label>邮箱地址</label>
                            <input type="email" name="empEmail" class="form-control"
                                placeholder="input your e-mail address">
                            <span class="help-block"></span>
                        </div>
                        <!-- 所属部门 -->
                        <div class="form-group">
                            <label>部门</label>
                            <select id="deptListForAdd" name="department.deptId" class="form-control">
                                <option selected hidden></option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="saveBtn" emailValid="0" nameValid="0" type="button" class="btn btn-primary">保存</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    <!-- 修改员工模态框 -->
    <div id="editEmpModal" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">修改员工</h4>
                </div>
                <div class="modal-body">
                    <!-- 信息修改表单 -->
                    <form id="editEmpForm" class="form-horizontal" method="POST">
                        <!-- 姓名 -->
                        <div class="form-group">
                            <input type="text" name="empName" hidden>
                            <label class="col-sm-2 control-label">姓名</label>
                            <div class="col-sm-10">
                                <p id="empName" class="form-control-static"></p>
                            </div>
                        </div>
                        <!-- 性别 -->
                        <div class="form-group">
                            <label class="col-sm-2 control-label">性别</label>
                            <label class="radio-inline">
                                <input type="radio" name="empGender" value="M"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="empGender" value="W"> 女
                            </label>
                        </div>
                        <!-- 电子邮箱 -->
                        <div class="form-group">
                            <label class="col-sm-2 control-label">邮箱地址</label>
                            <input type="email" id="empEmail" name="empEmail" class="form-control"
                                placeholder="input your e-mail address">
                            <span class="help-block"></span>
                        </div>
                        <!-- 所属部门 -->
                        <div class="form-group">
                            <label class="col-sm-2 control-label">部门</label>
                            <select id="deptListForEdit" name="department.deptId" class="form-control"></select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="updateBtn" emailValid="0" nameValid="0" type="button"
                        class="btn btn-primary">更新</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    <!-- 删除确认模态框 -->
    <div id="confirmDeleteModal" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">确认删除</h4>
                </div>
                <div class="modal-body">
                    <p></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button empId="0" id="confirmDeleteBtn" type="button" class="btn btn-primary">确认</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
</body>

</html>
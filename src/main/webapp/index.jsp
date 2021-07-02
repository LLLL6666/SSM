<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <%request.setAttribute("APP_PATH", request.getContextPath());%>
    <title>员工列表</title>
    <%--web路径：不以 / 开始的相对路径，找资源，以当资源的路径为基本，经常容易出问题
        以 / 开始的相对路径，找资源以服务器的路径为基准，但是只到端口号
        需要添加项目名称--%>
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-1.12.4.min.js"></script>
    <link href="${APP_PATH}/static/bootstrap-3.4.1-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>
</head>
<body>
    <%--员工信息修改的模态框--%>
    <div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">员工修改</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                            <div class="col-sm-10">
                                <p class="form-control-static" id="empName_update_static"></p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="email_add_input" class="col-sm-2 control-label">email</label>
                            <div class="col-sm-10">
                                <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@qq.com">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label  class="col-sm-2 control-label">gender</label>
                            <div class="col-sm-10">
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label  class="col-sm-2 control-label">deptName</label>
                            <div class="col-sm-4">
                                <%--部门提交部门ID，先查询出来--%>
                                <select class="form-control" name="deptId" id="dept_update_select"></select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="emp_update_save">更新</button>
                </div>
            </div>
        </div>
    </div>


    <!-- 员工添加的模态框 -->
    <div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">员工添加</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                            <div class="col-sm-10">
                                <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="email_add_input" class="col-sm-2 control-label">email</label>
                            <div class="col-sm-10">
                                <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@qq.com">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label  class="col-sm-2 control-label">gender</label>
                            <div class="col-sm-10">
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label  class="col-sm-2 control-label">deptName</label>
                            <div class="col-sm-4">
                                <%--部门提交部门ID，先查询出来--%>
                                <select class="form-control" name="deptId" id="dept_add_select"></select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="emp_add_save">保存</button>
                </div>
            </div>
        </div>
    </div>

    <%--搭建显示页面--%>
    <div class="container">
        <%--标题--%>
        <div class="row">
            <div class="col-md-12">
                <h1>SSM-CRUD</h1>
            </div>
        </div>
        <%--按钮--%>
        <div class="row">
            <div class="col-md-4 col-md-offset-8">
                <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
                <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
            </div>
        </div>
        <%--显示表格数据--%>
        <div class="row">
            <div class="col-md-12">
                <table class="table table-hover" id="emps_table">
                    <thead>
                        <tr>
                            <th><input type="checkbox" id="check_all"/></th>
                            <th>#</th>
                            <th>empName</th>
                            <th>gender</th>
                            <th>email</th>
                            <th>deptName</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>

                    </tbody>
                </table>
            </div>
        </div>
        <%--显示分页信息--%>
        <div class="row">
            <%--分页文字信息--%>
            <div class="col-md-6" id="page_info_area"></div>
            <%--分页条信息--%>
            <div class="col-md-6" id="page_nav_area"></div>
        </div>
    </div>

    <%--页面加载完成之后，发送ajax请求--%>
    <script type="text/javascript" >
        var totalRecord,currentPage;
        $(function () {
            // 一进来就去分页第一页
            to_page(1);
        });

        function to_page(pn) {
            $.ajax({
                url:"${APP_PATH}/emps",
                // 请求要带的数据
                data:"pn=" + pn,
                type:"GET",
                success:function (result) {
                    // 1、解析员工数据
                    build_emps_table(result)
                    // 2、显示分页信息数据
                    build_page_info(result)
                    // 3、显示分页条信息数据
                    build_page_nav(result)
                    // 4、清除全选框
                    $("#check_all").prop("checked",false);
                }
            });
        }

        function build_emps_table(result){
            // 每次构建前，先清空table表单，因为异步不会刷新
            $("#emps_table tbody").empty();

            var emps = result.extend.pageInfo.list;
            $.each(emps,function (index,item) {
                var checkboxTd = $("<td><input type='checkbox' class='check_item' /></td>")
                var empIdTd = $("<td></td>").append(item.empId);
                var empNameTd = $("<td></td>").append(item.empName);
                var genderTd = $("<td></td>").append(item.gender==="M"?"男":"女");
                var emailTd = $("<td></td>").append(item.email);
                var deptNameTd = $("<td></td>").append(item.department.deptName);

                var editBtn = $("<button>").addClass("btn btn-primary btn-sm edit_btn")
                            .append($("<span>").addClass("glyphicon glyphicon-pencil").append("编辑"));
                // 将员工id设置进编辑按钮参数
                editBtn.attr("edit_id",item.empId);
                var deleteBtn = $("<button>").addClass("btn btn-danger btn-sm delete_btn")
                    .append($("<span>").addClass("glyphicon glyphicon-trash").append("删除"));
                deleteBtn.attr("del_id",item.empId);
                $("<tr></tr>").append(checkboxTd)
                    .append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append($("<td>").append(editBtn).append(" ").append(deleteBtn))
                    .appendTo("#emps_table tbody");
            });
        }

        function build_page_info(result){
            // 每次构建前，先清空页面信息，因为异步不会刷新
            $("#page_info_area").empty();

            $("#page_info_area").append("当前第 " + result.extend.pageInfo.pageNum + " 页，总共 " +
                result.extend.pageInfo.pages + " 页，总计 " +
                result.extend.pageInfo.total + " 条记录");
            totalRecord = result.extend.pageInfo.total;
            currentPage = result.extend.pageInfo.pageNum;
        }

        function build_page_nav(result){
            // 每次构建前，先清空分页条信息，因为异步不会刷新
            $("#page_nav_area").empty();

            //page_nav_area
            var ul = $("<ul></ul>").addClass("pagination");
            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
            var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
            //判断是否在首页，让首页、上一页按钮失效
            if (result.extend.pageInfo.hasPreviousPage===false){
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            }else {
                //为元素添加事件
                firstPageLi.click(function () {
                    to_page(1);
                });
                prePageLi.click(function () {
                    to_page(result.extend.pageInfo.prePage);
                })
            }

            var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
            var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"))
            //判断是否在末页，让末页、下一页按钮失效
            if (result.extend.pageInfo.hasNextPage===false){
                nextPageLi.addClass("disabled");
                lastPageLi.addClass("disabled");
            }else {
                //为元素添加事件
                nextPageLi.click(function () {
                    to_page(result.extend.pageInfo.pageNum+1);
                })
                lastPageLi.click(function () {
                    to_page(result.extend.pageInfo.pages);
                })
            }

            ul.append(firstPageLi).append(prePageLi);
            // 遍历页码号
            $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
                var numLi = $("<li>").append($("<a>").append(item));
                if (result.extend.pageInfo.pageNum === item) {
                    numLi.addClass("active");
                }
                numLi.click(function () {
                    to_page(item)
                });
                ul.append(numLi);
            });
            ul.append(nextPageLi).append(lastPageLi);
            //把ul加入nav中
            var navEle = $("<nav></nav>").append(ul);
            navEle.appendTo($("#page_nav_area"));
        }

        // 清楚表单样式方法
        function reset_form(ele) {
            $(ele)[0].reset();
            $(ele).find("*").removeClass("has-success has-error");
            $(ele).find(".help-block").text("");
        }

        $("#emp_add_modal_btn").click(function () {
            // 清除表单数据，避免用户信息存留，无法进行用户名验证
            // jquery没有reset方法，使用js的dom的reset()
            reset_form($("#empAddModal form"));
            // 发送ajax请求，查出部门信息，显示在下拉列表中
            getDepts("#dept_add_select");
            $("#empAddModal").modal({
                // 背景不删除
                backdrop:"static"
            });
        });

        // 查出全部的部门信息并显示在下来列表中
        function getDepts(ele) {
            $(ele).empty();
            $.ajax({
                url: "${APP_PATH}/depts",
                type: "GET",
                success:function (result) {
                    $.each(result.extend.depts,function (index,item) {
                        // 提交返回的值是部门的id号，显示的是部门的部门名
                        $(ele).append($("<option>").append(item.deptName).attr("value",item.deptId));
                    });
                }
            });
        }

        // 校验表单数据
        function validate_add_form() {
            // 1、拿到要校验的数据，使用正则表达式
            var empName = $("#empName_add_input").val();
            var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
            if (!regName.test(empName)) {
                show_validate_msg("#empName_add_input","error","用户名必须是2-5位中文或6-16位英文和数字的组合")
                return false;
            } else {
                if ($("#emp_add_save").attr("ajax-va") === "success") {
                    show_validate_msg("#empName_add_input","success","用户名可用")
                }
            }

            // 2、验证邮箱信息
            var email = $("#email_add_input").val();
            var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if (!regEmail.test(email)) {
                show_validate_msg("#email_add_input","error","邮箱格式不合法")
                return false;
            }else {
                show_validate_msg("#email_add_input","error","")
            }

            return true;
        }

        //显示校验结果的提示信息
        function show_validate_msg(ele,status,msg){
            //清除当前元素的校验状态
            $(ele).parent().removeClass("has-success has-error")
            $(ele).next("span").text("");

            if ("success"==status){
                $(ele).parent().addClass("has-success");
                $(ele).next("span").text(msg);
            }else if ("error"==status){
                $(ele).parent().addClass("has-error");
                $(ele).next("span").text(msg);
            }

        }

        // 校验用户名是否可用
        $("#empName_add_input").change(function () {
            var empName = this.value;
            $.ajax({
                url:"${APP_PATH}/checkUser",
                data:"empName=" + empName,
                type:"GET",
                success:function (result) {
                    if (result.code == 100 ) {
                        // 显示用户信息可用
                        show_validate_msg("#empName_add_input","success","用户名可用！");
                        // 给保存按钮设置一个参数判断是否验证成功
                        $("#emp_add_save").attr("ajax-va","success");
                    } else {
                        // 显示用户信息不可用
                        show_validate_msg("#empName_add_input","error",result.extend.va_msg);
                        $("#emp_add_save").attr("ajax-va","error");
                    }
                }
            });
        });
        
        // 提交按钮的单击事件保存
        $("#emp_add_save").click(function () {
            // 数据发送之前，先进行数据校验,前端校验
            if (!validate_add_form()) {
                return false;
            }
            // 对用户名信息是否可用进行一个判断
            if ($(this).attr("ajax-va") === "error") {
                return false;
            }
           $.ajax({
                url:"${APP_PATH}/emps",
                type:"POST",
               // 拿到表单序列化后的结果
                data: $("#empAddModal form").serialize(),
                success:function (result) {
                    if (result.code === 100) {
                        // 关闭模态框
                        $("#empAddModal").modal('hide');
                        // 显示最后一页数据
                        to_page(totalRecord);
                    } else {
                        // 失败显示失败信息
                        if (undefined !== result.extend.errorFields.empName ) {
                            // 显示员工名字的错误信息
                            show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName);
                        }
                        if (undefined !== result.extend.errorFields.email ) {
                            // 显示员工邮箱的错误信息
                            show_validate_msg("#email_add_input","error",result.extend.errorFields.email)

                        }
                    }
                }
            });
        });

        // 给编辑按钮绑定单击事件，但是事件是页面加载就完成了，而按钮是页面加载之后发送ajax请求创建的
        // live过期，on可以为后来创建的节点绑定单击事件,为document的edit_btn子节点绑定click事件
        $(document).on("click",".edit_btn",function () {
            // 表单下拉列表显示部门信息
            getDepts("#dept_update_select");
            // 获取员工信息并回显
            getEmp($(this).attr("edit_id"));
            // 给更新按钮添加一个员工信息的属性
            $("#emp_update_save").attr("edit_id",$(this).attr("edit_id"));
            $("#empUpdateModal").modal({
                // 背景不删除
                backdrop:"static"
            });
        })

        // 发送请求，获取员工信息，显示到编辑的表单中
        function getEmp(id) {
            $.ajax({
                url:"${APP_PATH}/emp/" + id,
                type:"GET",
                success:function (result) {
                    var empData = result.extend.emp;
                    $("#empName_update_static").text(empData.empName);
                    $("#email_update_input").val(empData.email);
                    // 单选框选中，传入一个值，下拉列表传入数组
                    $("#empUpdateModal input[name = gender]").val([empData.gender]);
                    $("#empUpdateModal select").val([empData.deptId]);
                }
            });
        }

        // 点击更新，更新员工信息
        $("#emp_update_save").click(function () {
            // 1、验证邮箱信息
            var email = $("#email_update_input").val();
            var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if (!regEmail.test(email)) {
                show_validate_msg("#email_update_input","error","邮箱格式不合法")
                return false;
            }else {
                show_validate_msg("#email_update_input","error","")
            }
            // 2、发送ajax请求，保存修改的员工信息
            $.ajax({
                url:"${APP_PATH}/emp/" + $(this).attr("edit_id"),
                type:"PUT",
                data:$("#empUpdateModal form").serialize(),
                success:function (result) {
                    // 1、关闭模态框
                    $("#empUpdateModal").modal('hide');
                    // 2、回到当前页
                    to_page(currentPage);
                }
            });
        });

        // 删除按钮单击事件
        $(document).on("click",".delete_btn",function () {
            var empName = $(this).parents("tr").find("td:eq(2)").text();
            var empId = $(this).attr("del_id");
            if (confirm("确认删除【"+ empName +"】吗？")) {
                $.ajax({
                    url:"${APP_PATH}/emp/" + empId,
                    type:"DELETE",
                    success:function (result) {
                        to_page(currentPage);
                    }
                });
            }
        });

        // 全选和全不选
        $("#check_all").click(function () {
            // prop 获取dom原生的属性值，attr获取自定义的属性值
            $(".check_item").prop("checked",$(this).prop("checked"));
        });
        // 给单个check_item绑定单击事件，如果页面都选满了，就全选
        $(document).on("click",".check_item",function () {
            var flag = $(".check_item:checked").length === $(".check_item").length;
            $("#check_all").prop("checked",flag);
        })
        
        // 删除多个单击事件
        $("#emp_delete_all_btn").click(function () {
            var empNames = "";
            var del_idStr = "";
            $.each($(".check_item:checked"),function () {
                empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
                del_idStr += $(this).parents("tr").find("td:eq(1)").text() + "-";
            })
            empNames = empNames.substring(0,empNames.length-1);
            del_idStr = del_idStr.substring(0,del_idStr.length-1);
            if (confirm("你确定要删除【" + empNames + "】吗？")) {
                $.ajax({
                    url:"${APP_PATH}/emp/" + del_idStr,
                    type:"DELETE",
                    success:function (result) {
                        to_page(currentPage);
                    }
                });
            }
        });
    </script>
</body>
</html>

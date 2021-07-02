package com.study.controller;

import com.study.bean.Department;
import com.study.bean.Msg;
import com.study.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @description:
 * @Author:
 * @date: 2021/6/19 - 14:04
 */
@Controller
public class DepartmentController {
    @Autowired
    DepartmentService departmentService;

    /**
     * 返回所有的部门信息
     * @return: com.study.bean.Msg
     */
    @ResponseBody
    @RequestMapping("/depts")
    public Msg getDepts() {
        List<Department> list = departmentService.getDepts();
        Msg depts = Msg.success().add("depts", list);
        return depts;
    }
}

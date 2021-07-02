package com.study.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.study.bean.Employee;
import com.study.bean.Msg;
import com.study.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.*;

/**
 * @description:
 * @Author:
 * @date: 2021/6/15 - 9:12
 */
@Controller
public class EmployeeController {
    @Autowired
    EmployeeService employeeService;

    /**
     * 通过员工id删除员工信息,单个或者批量删除
     * @param id
     * @return: com.study.bean.Msg
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteEmpById(@PathVariable("ids") String ids) {
        if (ids.contains("-")) {
            String[] idStr = ids.split("-");
            List<Integer> del_ids = new ArrayList<>();
            for (String id: idStr) {
                del_ids.add(Integer.parseInt(id));
            }
            employeeService.deleteEmpList(del_ids);
        } else {
            Integer id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }

        return Msg.success();
    }

    /**
     * 修改员工信息，如果占位符的名称跟对象属性一致，可以直接封装进对象
     * 注意：ajax发送post请求，Tomcat会将数据封装为map集合
     * 如果发送put请求，Tomcat会跳过封装map这一步，导致无法将数据封装到对象
     * @param employee
     * @return: com.study.bean.Msg
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public Msg updateEmp(Employee employee) {
        System.out.println(employee);
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    // 查询员工信息
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id) {
        Employee emp = employeeService.getEmp(id);
        return Msg.success().add("emp",emp);
    }


    // 查询分页对象信息
    @ResponseBody
    @RequestMapping(value = "/emps",method = RequestMethod.GET)
    public Msg getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn) {
        // 使用分页插件
        PageHelper.startPage(pn,5);
        List<Employee> emps = employeeService.getAll();
        // 使用pageInfo包装查询之后的结果 第二个参数是传入连续显示5页
        PageInfo pageInfo = new PageInfo(emps,5);
        return Msg.success().add("pageInfo",pageInfo);
    }

    @ResponseBody
    @RequestMapping(value = "/emps",method = RequestMethod.POST)
    public Msg saveEmp(@Valid Employee employee, BindingResult bindingResult){
        if (bindingResult.hasErrors()) {
            // 校验失败，返回校验信息,使用map集合保存，添加到Msg对象中去
            Map<String, Object> map = new HashMap<>();
            List<FieldError> fieldErrors = bindingResult.getFieldErrors();
            for (FieldError fieldError : fieldErrors) {
                map.put(fieldError.getField(), fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        } else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    // 检验用户名
    @ResponseBody
    @RequestMapping(value = "/checkUser",method = RequestMethod.GET)
    public Msg checkUser(@RequestParam("empName") String empName) {
        // 拿到用户名进行格式验证
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regx)) {
            return Msg.fail().add("va_msg","用户名必须是2-5位中文或6-16位英文和数字的组合");
        }
        boolean b = employeeService.checkUser(empName);
        return b ? Msg.success() : Msg.fail().add("va_msg","用户名不可用！");
    }



    /**
     * 查询员工数据
     * @return: java.lang.String
     */
   /* @RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model) {
        // 使用分页插件
        PageHelper.startPage(pn,5);
        List<Employee> emps = employeeService.getAll();
        // 使用pageInfo包装查询之后的结果 第二个参数是传入连续显示5页
        PageInfo pageInfo = new PageInfo(emps,5);
        model.addAttribute("pageInfo",pageInfo);
        return "list";
    }*/
}

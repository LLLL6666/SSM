package com.study.service;

import com.study.bean.Employee;
import com.study.bean.EmployeeExample;
import com.study.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @description:
 * @Author:
 * @date: 2021/6/15 - 9:45
 */
@Service
public class EmployeeService {
    @Autowired
    EmployeeMapper employeeMapper;

    /**
     * 有选择的根据主键修改数据信息
     * @param employee
     * @return: void
     */
    public void updateEmp(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    /**
     * 查询全部员工信息
     * @param
     * @return: java.util.List<com.study.bean.Employee>
     */
    public List<Employee> getAll() {
        List<Employee> employees = employeeMapper.selectByExampleWithDept(null);
        return employees;
    }

    // 员工保存方法
    public void saveEmp(Employee employee) {
        employeeMapper.insertSelective(employee);
    }

    // 检验用户名是否可用 true 代表可用
    public boolean checkUser(String empName) {
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(employeeExample);
        return count == 0;
    }

    // 根据员工id查询员工信息
    public Employee getEmp(Integer id) {
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }

    public void deleteEmp(Integer id) {
        employeeMapper.deleteByPrimaryKey(id);
    }

    // 批量删除方法
    public void deleteEmpList(List<Integer> del_ids) {
        EmployeeExample employeeExample = new EmployeeExample();
        // criteria 增加查询条件
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpIdIn(del_ids);
        // delect xxx where empId in [];
        employeeMapper.deleteByExample(employeeExample);
    }
}

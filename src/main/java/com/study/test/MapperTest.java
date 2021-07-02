package com.study.test;

import com.study.bean.Department;
import com.study.bean.Employee;
import com.study.dao.DepartmentMapper;
import com.study.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;
import java.util.UUID;

/**
 * 测试dao层的操作
 * 使用spring的测试单元，可以自动导入所需要的组件
 * 1、导入SpringTest模块
 * 2、@ContextConfiguration()指定配置文件的位置
 * 3、@RunWith()指定使用哪个单元测试的模块 这是spring4的
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    // 注入IOC容器中可以批量操作的SQLSession对象
    @Autowired
    SqlSession sqlSession;

    @Test
    public void test2() {
        // departmentMapper.insertSelective(new Department(null,"测试部"));
        // departmentMapper.insertSelective(new Department(null,"开发部"));
        // employeeMapper.insertSelective(new Employee(null,"张三","M","张三@qq.com",1));
        // 批量完成员工插入工作
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 1; i < 1000; i++) {
            String uid = UUID.randomUUID().toString().substring(0, 5);
            mapper.insertSelective(new Employee(null,uid+i,"M",uid+"@qq.com",1));
        }
        System.out.println("插入完成");

    }

    @Test
    public void test01() {
        List<Employee> employees = employeeMapper.selectByExample(null);
        for (Employee employee : employees) {
            System.out.println(employee);
        }
    }




    /**
     * 测试DepartMapper的
     */
/*   @Test
    public void test1() {
        // 获取SpringIOC容器
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        // 获取dao映射文件
        EmployeeMapper employeeMapper = context.getBean(EmployeeMapper.class);
        System.out.println(employeeMapper);
        // System.out.println(employee.getEmpId() + employee.getEmpName() + employee.getDepartment().getDeptName());
    }*/
}

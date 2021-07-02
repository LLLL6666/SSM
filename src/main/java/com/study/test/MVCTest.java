package com.study.test;

import com.github.pagehelper.PageInfo;
import com.study.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * @description: 使用spring测试模块提供的测试请求功能
 * @Author:
 * @date: 2021/6/15 - 15:04
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml",
        "file:D:\\IntelliJIDEA\\WorkSpace\\SSM\\CRUD\\src\\main\\webapp\\WEB-INF\\dispatcher-servlet.xml"})
public class MVCTest {
    // 虚拟MVC请求,获取处理结果
    MockMvc mockMvc;

    // 传入springmvc的ioc容器
    @Autowired
    WebApplicationContext webApplicationContext;

    @Before
    public void initMockMvc() {
        WebApplicationContext context;
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
    }

    @Test
    public void teatPage() throws Exception {
        // 模拟发送请求,获取返回值
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "1"))
                .andReturn();
        // 请求成功后，获取请求域中pageInfo
        PageInfo pageInfo = (PageInfo) result.getRequest().getAttribute("pageInfo");
        System.out.println("当前页码" + pageInfo.getPageNum());
        System.out.println("总页码" + pageInfo.getPages());
        System.out.println("总记录数" + pageInfo.getTotal());
        System.out.println("连续显示的页数");
        int[] navigatepageNums = pageInfo.getNavigatepageNums();
        for (int i: navigatepageNums) {
            System.out.println(i);
        }
        // 获取员工数据
        List<Employee> list = pageInfo.getList();
        for (Employee employee : list) {
            System.out.println(employee);
        }
    }
}

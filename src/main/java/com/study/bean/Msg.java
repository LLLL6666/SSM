package com.study.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * 通用的返回的类
 * @date: 2021/6/16 - 17:22
 */
public class Msg {
    // 状态码 100成功 200失败
    private int code;
    // 提示信息
    private String msg;
    // 保存用户要返回给浏览器的数据
    private Map<String, Object> extend = new HashMap<>();

    // 成功的方法返回
    public static Msg success() {
        Msg result = new Msg();
        result.setCode(100);
        result.setMsg("处理成功!");
        return result;
    }

    // 失败的方法返回
    public static Msg fail() {
        Msg result = new Msg();
        result.setCode(200);
        result.setMsg("处理失败!");
        return result;
    }

    public Msg add(String key, Object value) {
        // 获取当前msg对象的map集合，将分页信息存入到里面，如何返回这个msg对象
        this.getExtend().put(key,value);
        return this;
    }


    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }

}

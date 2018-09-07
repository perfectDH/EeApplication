package com.dh.View;

import com.dh.Services.UserServices;
import com.dh.javaBean.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;

@Controller
public class MainLogin {
    //注入服务层
    @Autowired
    private UserServices userServices;

    //转到login
    @RequestMapping("/index.action")
    public String test() {
        return "login";
    }

    //转到register
    @RequestMapping("/registerIndex.action")
    public String registerIndex() {
        return "Register";
    }

    //转发到主界面
    @RequestMapping("/main.action")
    public String forMain(){
        return "index";
    }

    //用户注册方法
    @RequestMapping("/login.action")
    public String login(String loginName, String password, HttpSession session) {
        //将页面上的数据传送数据库保存,根据返回的值判定是否注册成功
        User user = userServices.login(loginName, password);
        System.out.println(loginName);
        session.setAttribute("User", user);
        return "index";
    }

    @RequestMapping("/register.action")
    public String register(User user) {
        boolean flag = userServices.register(user);
        //根据返回值做相应的操作
        if (!flag) {
            return "Register";
        }
        return "login";
    }


}

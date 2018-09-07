package com.dh.View;

import com.dh.Services.UserServices;
import com.dh.javaBean.Addr;
import com.dh.javaBean.User;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.List;

//用户信息展示的控制类
@Controller
public class MenberController {
    @Autowired
    private UserServices userServices;

    @RequestMapping("/member.action")
    public ModelAndView showAdders() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("member");
        return mv;
    }

    //修改用户信息,ajax请求
    @ResponseBody
    @RequestMapping("/changeInfo.action")
    public String updateUserAddress(String message, String idNo, String mobile, String email) {

        //根据用户的id来修改用户信息
        int flag = userServices.updateUserAddress(message, Integer.parseInt(idNo), Integer.parseInt(mobile), email);
        if (flag == 0) {
            return "error";
        }
        return "success";
    }

    //展示用户的地址信息,从session中取出用户的id，根据id查询该用户的收货地址
    @RequestMapping("/showAddress.action")
    public String showAddress(HttpSession session, HttpServletRequest request) {
        User user = (User) session.getAttribute("User");
        Integer uid = user.getUserId();
        List<Addr> addr = userServices.findUserAddrbyId(uid);
        System.out.println(addr);
        request.setAttribute("addrList", addr);
        return "address";
    }

    //用户点击下拉框时查询数据库中省份信息m,ajax请求
    @ResponseBody
    @RequestMapping("/loadCity.action")
    public String loadCity(Integer pid) {

        return "";
    }

    ;


}

package com.dh.Services.Iml;

import com.dh.Dao.UserDao;
import com.dh.Services.UserServices;
import com.dh.javaBean.Addr;
import com.dh.javaBean.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;


@Service
public class UserServicesIml implements UserServices {
    @Autowired
    private UserDao userDao;

    @Override
    public boolean register(User user) {
       /* 注册前查询用户是否已经存在*/
       User u=userDao.login(user.getName(),user.getPwd());
       if(u!=null){
           return false;
       }
        //获取系统的当前时间
        user.setCreateTime(new Date());
        userDao.register(user);
        return true;
    }

    //用户登录
    @Override
    public User login(String loginName, String password) {

        return userDao.login(loginName, password);
    }

    @Override
    public int updateUserAddress(String message, Integer idNo, Integer mobile, String email) {
        return userDao.updateUserAddress(message, idNo, mobile, email);
    }
//根据用户id查询用户的地址信息
    @Override
    public List<Addr> findUserAddrbyId(Integer uid) {

        return userDao.findUserAddrbyId(uid);
    }
}

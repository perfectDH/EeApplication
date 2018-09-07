package com.dh.Services;

import com.dh.javaBean.Addr;
import com.dh.javaBean.User;

import java.util.List;

public interface UserServices {
    boolean register(User user);

    User login(String loginName, String password);

    int updateUserAddress(String message,Integer idNo, Integer mobile, String email);

    List<Addr> findUserAddrbyId(Integer uid);
}

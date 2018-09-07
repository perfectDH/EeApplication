package com.dh.Dao;

import com.dh.javaBean.Addr;
import com.dh.javaBean.User;

import java.util.List;

public interface UserDao {
    boolean register(User user);

    User login(String loginName, String password);

    int updateUserAddress(String message,Integer idNo, Integer mobile, String email);

    List<Addr> findUserAddrbyId(Integer uid);
}

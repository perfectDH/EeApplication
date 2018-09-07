package com.dh.Utils;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

public class DBUtils {
    private static String url;
    private static String username;
    private static String password;

    //静态代码块
    static {
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
        //读取配置文件
        InputStream is = DBUtils.class.getResourceAsStream("/db.properties");
        Properties pt = new Properties();
        try {
            //加载文件
            pt.load(is);
            //获取对应字段的内容
            url = pt.getProperty("mysql.url");
            username = pt.getProperty("mysql.username");
            password = pt.getProperty("mysql.password");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static Connection getCinn() throws SQLException {
        //连接对象
        return DriverManager.getConnection(url, username, password);
    }

    //关闭对象
    public static void Dbclose(ResultSet rs, PreparedStatement ps, Connection c) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException s) {
                s.printStackTrace();
            }
        }
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException s) {
                s.printStackTrace();
            }
        }
        if (c != null) {
            try {
                c.close();
            } catch (SQLException s) {
                s.printStackTrace();
            }
        }

    }
}
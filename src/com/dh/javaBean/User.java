package com.dh.javaBean;

import java.util.Date;

public class User {
    private int userId;
    private String name;
    private String pwd;
    private String email;
    private String mobile;
    private String idNo;
    private String inviteName;
    private int inviteId;
    private Date createTime;
    private Date updateTime;

    public User() {
    }

    public User(int userId, String name, String pwd, String email, String mobile, String idNo, String inviteName, int inviteId, Date createTime, Date updateTime) {
        this.userId = userId;
        this.name = name;
        this.pwd = pwd;
        this.email = email;
        this.mobile = mobile;
        this.idNo = idNo;
        this.inviteName = inviteName;
        this.inviteId = inviteId;
        this.createTime = createTime;
        this.updateTime = updateTime;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getIdNo() {
        return idNo;
    }

    public void setIdNo(String idNo) {
        this.idNo = idNo;
    }

    public String getInviteName() {
        return inviteName;
    }

    public void setInviteName(String inviteName) {
        this.inviteName = inviteName;
    }

    public int getInviteId() {
        return inviteId;
    }

    public void setInviteId(int inviteId) {
        this.inviteId = inviteId;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", name='" + name + '\'' +
                ", pwd='" + pwd + '\'' +
                ", email='" + email + '\'' +
                ", mobile='" + mobile + '\'' +
                ", idNo='" + idNo + '\'' +
                ", inviteName='" + inviteName + '\'' +
                ", inviteId=" + inviteId +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                '}';
    }
}

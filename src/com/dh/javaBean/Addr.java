package com.dh.javaBean;

public class Addr {
    private int addrId;
    private int userId;
    private String receiveName;
    private String receivePhone;
    private int provinceId;
    private int cityId;
    private int areaId;
    private String provinceName;
    private String cityName;
    private String areaName;
    private String addr;
    private String postCode;

    public Addr() {
    }

    public Addr(int addrId, int userId, String receiveName, String receivePhone, int provinceId, int cityId, int areaId, String provinceName, String cityName, String areaName, String addr, String postCode) {
        this.addrId = addrId;
        this.userId = userId;
        this.receiveName = receiveName;
        this.receivePhone = receivePhone;
        this.provinceId = provinceId;
        this.cityId = cityId;
        this.areaId = areaId;
        this.provinceName = provinceName;
        this.cityName = cityName;
        this.areaName = areaName;
        this.addr = addr;
        this.postCode = postCode;
    }

    public int getAddrId() {
        return addrId;
    }

    public void setAddrId(int addrId) {
        this.addrId = addrId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getReceiveName() {
        return receiveName;
    }

    public void setReceiveName(String receiveName) {
        this.receiveName = receiveName;
    }

    public String getReceivePhone() {
        return receivePhone;
    }

    public void setReceivePhone(String receivePhone) {
        this.receivePhone = receivePhone;
    }

    public int getProvinceId() {
        return provinceId;
    }

    public void setProvinceId(int provinceId) {
        this.provinceId = provinceId;
    }

    public int getCityId() {
        return cityId;
    }

    public void setCityId(int cityId) {
        this.cityId = cityId;
    }

    public int getAreaId() {
        return areaId;
    }

    public void setAreaId(int areaId) {
        this.areaId = areaId;
    }

    public String getProvinceName() {
        return provinceName;
    }

    public void setProvinceName(String provinceName) {
        this.provinceName = provinceName;
    }

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public String getAreaName() {
        return areaName;
    }

    public void setAreaName(String areaName) {
        this.areaName = areaName;
    }

    public String getAddr() {
        return addr;
    }

    public void setAddr(String addr) {
        this.addr = addr;
    }

    public String getPostCode() {
        return postCode;
    }

    public void setPostCode(String postCode) {
        this.postCode = postCode;
    }

    @Override
    public String toString() {
        return "Addr{" +
                "addrId=" + addrId +
                ", userId=" + userId +
                ", receiveName='" + receiveName + '\'' +
                ", receivePhone='" + receivePhone + '\'' +
                ", provinceId=" + provinceId +
                ", cityId=" + cityId +
                ", areaId=" + areaId +
                ", provinceName='" + provinceName + '\'' +
                ", cityName='" + cityName + '\'' +
                ", areaName='" + areaName + '\'' +
                ", addr='" + addr + '\'' +
                ", postCode='" + postCode + '\'' +
                '}';
    }
}

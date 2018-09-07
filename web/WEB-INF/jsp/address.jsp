<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link type="text/css" rel="stylesheet" href="css/style.css"/>
    <!--[if IE 6]>
    <script src="js/iepng.js" type="text/javascript"></script>
    <script type="text/javascript">
        EvPNG.fix('div, ul, img, li, input, a');
    </script>
    <![endif]-->


    <style type="text/css">
        .modify_info {
            display: none;
        }

        .addrList {
            margin-left: 50px;
            margin-top: 20px;
        }

        .addrList:hover {
            background-color: lightgreen;
        }

        .selected {
            background-color: lightgreen;
        }
    </style>
    <script type="text/javascript" src="js/jquery-1.8.2.min.js"></script>
    <script type="text/javascript" src="js/jquery-1.11.1.min_044d0927.js"></script>
    <script type="text/javascript" src="js/menu.js"></script>

    <script type="text/javascript" src="js/select.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#allAddr").on("click", "div.addrList", function () {
                //判断当前div是否有背景色（是否被选中），
                var selected = $(this).hasClass("selected");
                //如果已经被选中，则取消
                if (selected) {
                    $(this).removeClass("selected");
                } else {
                    //如果没有选中，则先取消其他被选中的div，自己设置成选中状态
                    $(".selected").removeClass("selected");
                    $(this).addClass("selected");
                }
            });

            $("#province").change(function () {
                var vv = $(this).val();
                //如果当前选项是“请选择”，直接清空后继下拉
                if (vv == "0") {
                    $("#city option:gt(0)").remove();
                    $("#area option:gt(0)").remove();
                    return;
                }

                $.ajax({
                    url: "loadCity.action",
                    type: "post",
                    data: {
                        pid: $(this).val()
                    },
                    dataType: "json",
                    success: function (data) {
                        //删除所有的option选项，保留第一个
                        $("#city option:gt(0)").remove();
                        $("#area option:gt(0)").remove();
                        $.each(data, function (idx, item) {
                            var opt = $("<option value='" + item.id + "'>" + item.name + "</option>")
                            $("#city").append(opt);
                        });
                    }
                });
            });

            $("#city").change(function () {
                var vv = $(this).val();
                //如果当前选项是“请选择”，直接清空后继下拉
                if (vv == "0") {
                    $("#area option:gt(0)").remove();
                    return;
                }

                $.ajax({
                    url: "loadArea.action",
                    type: "post",
                    data: {
                        cid: $(this).val()
                    },
                    dataType: "json",
                    success: function (data) {
                        //删除所有的option选项，保留第一个
                        $("#area option:gt(0)").remove();
                        $.each(data, function (idx, item) {
                            var opt = $("<option value='" + item.id + "'>" + item.name + "</option>")
                            $("#area").append(opt);
                        });
                    }
                });
            });

            $("#btnSaveAddr").click(function () {
                var name = $("#receiveName").val().trim();
                var phone = $("#receivePhone").val().trim();
                var province = $("#province").val();
                var city = $("#city").val();
                var area = $("#area").val();
                var address = $("#address").val().trim();
                if (name == "" || phone == "" || address == "" || province == "0" || city == "0" || area == "0") {
                    var msg = "请输入必要信息";
                    $("#msg").text(msg);
                    return;
                }

                $("#msg").text("");
                //提交后台保存
                $.ajax({
                    url: "saveAddr.action",
                    type: "post",
                    data: {
                        receiveName: name,
                        receivePhone: phone,
                        provinceId: province,
                        cityId: city,
                        areaId: area,
                        addr: address,
                        addrId: $("#addrId").val()
                    },
                    dataType: "text",
                    success: function (data) {
                        if (data == 1) {
                            $("#msg").text("新增失败");
                        } else {
                            $("#addAddr").slideUp();
                            flushAllAddress();
                            clearAddr();
                        }
                    }
                });
            });
        });

        function showAddAddr() {
            $("#addrId").val("0");
            $("#addAddr").slideDown();
        }

        function deleteAddr() {
            //没有选中的地址，直接返回
            if ($("div.selected").length == 0) {
                return;
            }

            $.ajax({
                url: "deleteAddr.action",
                type: "post",
                data: {
                    addrId: $("div.selected").children("input").val()
                },
                dataType: "text",
                success: function (data) {
                    if (data == 1) {
                        $("#msg").text("删除失败");
                    } else {
                        flushAllAddress();
                    }
                }
            });
        }

        function modifyAddr() {
            //没有选中的地址，直接返回
            if ($("div.selected").length == 0) {
                return;
            }

            //根据选中的地址id去后台获取所有相关信息
            $.ajax({
                url: "queryAddrInfo.action",
                type: "post",
                data: {
                    addrId: $("div.selected").children("input").val()
                },
                dataType: "json",
                success: function (data) {
                    showAddAddr();
                    $("#addrId").val(data.addrId);
                    $("#receiveName").val(data.receiveName);
                    $("#receivePhone").val(data.receivePhone);
                    $("#address").val(data.addr);
                    $("#province").val(data.provinceId);
                    var opt = $("<option value='" + data.cityId + "' selected>" + data.cityName + "</option>");
                    $("#city").append(opt);
                    opt = $("<option value='" + data.areaId + "' selected>" + data.areaName + "</option>");
                    $("#area").append(opt);
                }
            });


        }

        function clearAddr() {
            $("#receiveName").val("");
            $("#receivePhone").val("");
            $("#province").val("0");
            //手工触发province的change事件
            $("#province").trigger("change");
            $("#address").val("");
        }

        //清空页面上的地址信息，从后端查询所有地址，显示到页面上
        function flushAllAddress() {
            $(".addrList").remove();
            $.ajax({
                url: "queryAllAddr.action",
                type: "post",
                dataType: "json",
                success: function (json) {
                    $.each(json, function (idx, item) {
                        var tmp = "<div class=\"addrList\">" +
                            "<input type=\"hidden\" value=\"" + item.addrId + "\"/>" +
                            "<div>" +
                            "	姓名：<span>" + item.receiveName + "</span>" +
                            "	电话：<span>" + item.receivePhone + "</span>" +
                            "	</div>" +
                            "<div>" +
                            "	地址：" +
                            "	<span>" +
                            item.provinceName + item.cityName + item.areaName + item.addr +
                            "	</span>" +
                            "</div>" +
                            "</div>";
                        $("#allAddr").append(tmp);
                    });
                }
            });
        }
    </script>

    <title>购物街</title>
</head>
<body>
<!--Begin Header Begin-->
<div class="soubg">
    <div class="sou">
        <!--Begin 所在收货地区 Begin-->
        <span class="s_city_b">
        	<span class="fl">送货至：</span>
            <span class="s_city">
            	<span>四川</span>
                <div class="s_city_bg">
                	<div class="s_city_t"></div>
                    <div class="s_city_c">
                    	<h2>请选择所在的收货地区</h2>
                        <table border="0" class="c_tab" style="width:235px; margin-top:10px;" cellspacing="0"
                               cellpadding="0">
                          <tr>
                            <th>A</th>
                            <td class="c_h"><span>安徽</span><span>澳门</span></td>
                          </tr>
                          <tr>
                            <th>B</th>
                            <td class="c_h"><span>北京</span></td>
                          </tr>
                          <tr>
                            <th>C</th>
                            <td class="c_h"><span>重庆</span></td>
                          </tr>
                          <tr>
                            <th>F</th>
                            <td class="c_h"><span>福建</span></td>
                          </tr>
                          <tr>
                            <th>G</th>
                            <td class="c_h"><span>广东</span><span>广西</span><span>贵州</span><span>甘肃</span></td>
                          </tr>
                          <tr>
                            <th>H</th>
                            <td class="c_h"><span>河北</span><span>河南</span><span>黑龙江</span><span>海南</span><span>湖北</span><span>湖南</span></td>
                          </tr>
                          <tr>
                            <th>J</th>
                            <td class="c_h"><span>江苏</span><span>吉林</span><span>江西</span></td>
                          </tr>
                          <tr>
                            <th>L</th>
                            <td class="c_h"><span>辽宁</span></td>
                          </tr>
                          <tr>
                            <th>N</th>
                            <td class="c_h"><span>内蒙古</span><span>宁夏</span></td>
                          </tr>
                          <tr>
                            <th>Q</th>
                            <td class="c_h"><span>青海</span></td>
                          </tr>
                          <tr>
                            <th>S</th>
                            <td class="c_h"><span>上海</span><span>山东</span><span>山西</span><span class="c_check">四川</span><span>陕西</span></td>
                          </tr>
                          <tr>
                            <th>T</th>
                            <td class="c_h"><span>台湾</span><span>天津</span></td>
                          </tr>
                          <tr>
                            <th>X</th>
                            <td class="c_h"><span>西藏</span><span>香港</span><span>新疆</span></td>
                          </tr>
                          <tr>
                            <th>Y</th>
                            <td class="c_h"><span>云南</span></td>
                          </tr>
                          <tr>
                            <th>Z</th>
                            <td class="c_h"><span>浙江</span></td>
                          </tr>
                        </table>
                    </div>
                </div>
            </span>
        </span>
        <!--End 所在收货地区 End-->
        <span class="fr">
        <c:if test="${empty sessionScope.User}">
    <span class="fl">
          <a href="main.action">首页</a>
        你好，请<a href="index.action">登录</a>&nbsp; <a href="Regist.html" style="color:#ff4e00;">免费注册</a>&nbsp;|&nbsp;<a
            href="#">我的订单</a>&nbsp;|</span>
        </c:if>
        <c:if test="${not empty sessionScope.User}">
        		<span class="fl">
                    <a href="main.action">首页</a>
        			<a href="member.action">${sessionScope.User.name}</a>
        			<a href="#">退出</a>
        		</span>
        </c:if>
        <span class="ss">
            	<div class="ss_list">
                	<a href="#">收藏夹</a>
                    <div class="ss_list_bg">
                    	<div class="s_city_t"></div>
                        <div class="ss_list_c">
                        	<ul>
                            	<li><a href="#">我的收藏夹</a></li>
                                <li><a href="#">我的收藏夹</a></li>
                            </ul>
                        </div>
                    </div>     
                </div>
                <div class="ss_list">
                	<a href="#">客户服务</a>
                    <div class="ss_list_bg">
                    	<div class="s_city_t"></div>
                        <div class="ss_list_c">
                        	<ul>
                            	<li><a href="#">客户服务</a></li>
                                <li><a href="#">客户服务</a></li>
                                <li><a href="#">客户服务</a></li>
                            </ul>
                        </div>
                    </div>    
                </div>
                <div class="ss_list">
                	<a href="#">网站导航</a>
                    <div class="ss_list_bg">
                    	<div class="s_city_t"></div>
                        <div class="ss_list_c">
                        	<ul>
                            	<li><a href="#">网站导航</a></li>
                                <li><a href="#">网站导航</a></li>
                            </ul>
                        </div>
                    </div>    
                </div>
            </span>
        <span class="fl">|&nbsp;关注我们：</span>
        <span class="s_sh"><a href="#" class="sh1">新浪</a><a href="#" class="sh2">微信</a></span>
        <span class="fr">|&nbsp;<a href="#">手机版&nbsp;<img src="images/s_tel.png" align="absmiddle"/></a></span>
        </span>
    </div>
</div>
<div class="m_top_bg">
    <div class="top">
        <div class="m_logo"><a href="Index.html"><img src="images/logo1.png"/></a></div>
        <div class="m_search">
            <form>
                <input type="text" value="" class="m_ipt"/>
                <input type="submit" value="搜索" class="m_btn"/>
            </form>
            <span class="fl"><a href="#">咖啡</a><a href="#">iphone 6S</a><a href="#">新鲜美食</a><a href="#">蛋糕</a><a
                    href="#">日用品</a><a href="#">连衣裙</a></span>
        </div>
        <div class="i_car">
            <div class="car_t">购物车 [ <span>3</span> ]</div>
            <div class="car_bg">
                <!--Begin 购物车未登录 Begin-->
                <div class="un_login">还未登录！<a href="Login.html" style="color:#ff4e00;">马上登录</a> 查看购物车！</div>
                <!--End 购物车未登录 End-->
                <!--Begin 购物车已登录 Begin-->
                <ul class="cars">
                    <li>
                        <div class="img"><a href="#"><img src="images/car1.jpg" width="58" height="58"/></a></div>
                        <div class="name"><a href="#">法颂浪漫梦境50ML 香水女士持久清新淡香 送2ML小样3只</a></div>
                        <div class="price"><font color="#ff4e00">￥399</font> X1</div>
                    </li>
                    <li>
                        <div class="img"><a href="#"><img src="images/car2.jpg" width="58" height="58"/></a></div>
                        <div class="name"><a href="#">香奈儿（Chanel）邂逅活力淡香水50ml</a></div>
                        <div class="price"><font color="#ff4e00">￥399</font> X1</div>
                    </li>
                    <li>
                        <div class="img"><a href="#"><img src="images/car2.jpg" width="58" height="58"/></a></div>
                        <div class="name"><a href="#">香奈儿（Chanel）邂逅活力淡香水50ml</a></div>
                        <div class="price"><font color="#ff4e00">￥399</font> X1</div>
                    </li>
                </ul>
                <div class="price_sum">共计&nbsp; <font color="#ff4e00">￥</font><span>1058</span></div>
                <div class="price_a"><a href="#">去购物车结算</a></div>
                <!--End 购物车已登录 End-->
            </div>
        </div>
    </div>
</div>
<!--End Header End-->
<div class="i_bg bg_color">
    <!--Begin 用户中心 Begin -->
    <div class="m_content">
        <div class="m_left">
            <div class="left_n">管理中心</div>
            <div class="left_m">
                <div class="left_m_t t_bg1">订单中心</div>
                <ul>
                    <li><a href="Member_Order.html">我的订单</a></li>
                    <li><a href="Member_Address.html">收货地址</a></li>
                    <li><a href="#">缺货登记</a></li>
                    <li><a href="#">跟踪订单</a></li>
                </ul>
            </div>
            <div class="left_m">
                <div class="left_m_t t_bg2">会员中心</div>
                <ul>
                    <li><a href="Member_User.html">用户信息</a></li>
                    <li><a href="Member_Collect.html">我的收藏</a></li>
                    <li><a href="Member_Msg.html">我的留言</a></li>
                    <li><a href="Member_Links.html">推广链接</a></li>
                    <li><a href="#">我的评论</a></li>
                </ul>
            </div>
            <div class="left_m">
                <div class="left_m_t t_bg3">账户中心</div>
                <ul>
                    <li><a href="Member_Safe.html">账户安全</a></li>
                    <li><a href="Member_Packet.html">我的红包</a></li>
                    <li><a href="Member_Money.html">资金管理</a></li>
                </ul>
            </div>
            <div class="left_m">
                <div class="left_m_t t_bg4">分销中心</div>
                <ul>
                    <li><a href="Member_Member.html">我的会员</a></li>
                    <li><a href="Member_Results.html">我的业绩</a></li>
                    <li><a href="Member_Commission.html">我的佣金</a></li>
                    <li><a href="Member_Cash.html">申请提现</a></li>
                </ul>
            </div>
        </div>
        <div class="m_right" id="allAddr">
            <div class="mem_t">地址信息&nbsp;
                <a href="javascript:showAddAddr();">+</a>
                &nbsp;
                <a href="javascript:deleteAddr();">-</a>
                &nbsp;
                <a href="javascript:modifyAddr();">m</a>
                &nbsp;
                <span id="msg"></span>
            </div>
            <div style="display:none;" id="addAddr">
                <input type="hidden" value="0" id="addrId"/>
                <div>
                    收件人姓名：<input type="text" id="receiveName"/>
                    收件人电话：<input type="text" id="receivePhone"/>
                </div>
                <div>
                    <select id="province">
                        <option value="0">---请选择---</option>
                        <c:forEach items="${plist}" var="vo">
                            <option value="${vo.id}">${vo.name}</option>
                        </c:forEach>
                    </select>
                    <select id="city">
                        <option value="0">---请选择---</option>
                    </select>
                    <select id="area">
                        <option value="0">---请选择---</option>
                    </select>
                    <input type="text" id="address"/>
                    <input type="button" value="保存" id="btnSaveAddr"/>
                </div>
            </div>

            <c:forEach items="${addrList}" var="addr">
                <div class="addrList">
                    <input type="hidden" value="${addr.addrId}"/>
                    <div>
                        姓名：<span>${addr.receiveName}</span>
                        电话：<span>${addr.receivePhone}</span>
                    </div>
                    <div>
                        地址：
                        <span>
           					<span>${addr.provinceName}</span>
           					<span>${addr.cityName}</span>
           					<span>${addr.areaName}</span>
           					<span>${addr.addr}</span>
           				</span>
                    </div>
                </div>
            </c:forEach>


        </div>
    </div>
    <!--End 用户中心 End-->
    <!--Begin Footer Begin -->
    <div class="b_btm_bg b_btm_c">
        <div class="b_btm">
            <table border="0" style="width:210px; height:62px; float:left; margin-left:75px; margin-top:30px;"
                   cellspacing="0" cellpadding="0">
                <tr>
                    <td width="72"><img src="images/b1.png" width="62" height="62"/></td>
                    <td><h2>正品保障</h2>正品行货 放心购买</td>
                </tr>
            </table>
            <table border="0" style="width:210px; height:62px; float:left; margin-left:75px; margin-top:30px;"
                   cellspacing="0" cellpadding="0">
                <tr>
                    <td width="72"><img src="images/b2.png" width="62" height="62"/></td>
                    <td><h2>满38包邮</h2>满38包邮 免运费</td>
                </tr>
            </table>
            <table border="0" style="width:210px; height:62px; float:left; margin-left:75px; margin-top:30px;"
                   cellspacing="0" cellpadding="0">
                <tr>
                    <td width="72"><img src="images/b3.png" width="62" height="62"/></td>
                    <td><h2>天天低价</h2>天天低价 畅选无忧</td>
                </tr>
            </table>
            <table border="0" style="width:210px; height:62px; float:left; margin-left:75px; margin-top:30px;"
                   cellspacing="0" cellpadding="0">
                <tr>
                    <td width="72"><img src="images/b4.png" width="62" height="62"/></td>
                    <td><h2>准时送达</h2>收货时间由你做主</td>
                </tr>
            </table>
        </div>
    </div>
    <div class="b_nav">
        <dl>
            <dt><a href="#">新手上路</a></dt>
            <dd><a href="#">售后流程</a></dd>
            <dd><a href="#">购物流程</a></dd>
            <dd><a href="#">订购方式</a></dd>
            <dd><a href="#">隐私声明</a></dd>
            <dd><a href="#">推荐分享说明</a></dd>
        </dl>
        <dl>
            <dt><a href="#">配送与支付</a></dt>
            <dd><a href="#">货到付款区域</a></dd>
            <dd><a href="#">配送支付查询</a></dd>
            <dd><a href="#">支付方式说明</a></dd>
        </dl>
        <dl>
            <dt><a href="#">会员中心</a></dt>
            <dd><a href="#">资金管理</a></dd>
            <dd><a href="#">我的收藏</a></dd>
            <dd><a href="#">我的订单</a></dd>
        </dl>
        <dl>
            <dt><a href="#">服务保证</a></dt>
            <dd><a href="#">退换货原则</a></dd>
            <dd><a href="#">售后服务保证</a></dd>
            <dd><a href="#">产品质量保证</a></dd>
        </dl>
        <dl>
            <dt><a href="#">联系我们</a></dt>
            <dd><a href="#">网站故障报告</a></dd>
            <dd><a href="#">购物咨询</a></dd>
            <dd><a href="#">投诉与建议</a></dd>
        </dl>
        <div class="b_tel_bg">
            <a href="#" class="b_sh1">新浪微博</a>
            <a href="#" class="b_sh2">腾讯微博</a>
            <p>
                服务热线：<br/>
                <span>400-123-4567</span>
            </p>
        </div>
        <div class="b_er">
            <div class="b_er_c"><img src="images/er.gif" width="118" height="118"/></div>
            <img src="images/ss.png"/>
        </div>
    </div>
    <div class="btmbg">
        <div class="btm">
            备案/许可证编号：京ICP备070360号 Copyright © 2016-2019 购物街 All Rights Reserved. 复制必究 , Technical Support: ICT Group
            <br/>
            <img src="images/b_1.gif" width="98" height="33"/><img src="images/b_2.gif" width="98" height="33"/><img
                src="images/b_3.gif" width="98" height="33"/><img src="images/b_4.gif" width="98" height="33"/><img
                src="images/b_5.gif" width="98" height="33"/><img src="images/b_6.gif" width="98" height="33"/>
        </div>
    </div>
    <!--End Footer End -->
</div>

</body>


<!--[if IE 6]>
<script src="//letskillie6.googlecode.com/svn/trunk/2/zh_CN.js"></script>
<![endif]-->
</html>

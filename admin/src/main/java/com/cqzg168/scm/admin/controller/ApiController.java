package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.service.ThirdDeliveryService;
import com.cqzg168.scm.service.YunTongApiService;
import com.cqzg168.scm.utils.RSAUtils;
import com.cqzg168.scm.utils.Utils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.remoting.jaxws.JaxWsPortProxyFactoryBean;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Administrator on 2017/6/7 0007.
 */
@RequestMapping("/api")
@Controller
public class ApiController extends BaseController {
    @Autowired
    private ThirdDeliveryService thirdDeliveryService;
    @Autowired
    private YunTongApiService yunTongApiService;

    /**
     * 修改订单状态(华龙百家 未使用)
     *
     * @param orderSid 订单号
     * @param key      第三方标识
     * @param sign     加密串
     * @return
     */
    @RequestMapping(value = "/delivery", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String updateOrdersStatus(@RequestParam(value = "orderSid") String orderSid, @RequestParam(value = "key") String key, @RequestParam(value = "sign") String sign) {


        Map<String, Object> resultMap = thirdDeliveryService.updateOrdersStatus(orderSid, key, sign);
        JSONObject json = new JSONObject();
        try {

            json.putOpt("result", resultMap.get("result"));
            json.putOpt("msg", resultMap.get("msg"));


            return json.toString();
        } catch (JSONException e) {
            e.printStackTrace();
            return "error";
        }


    }

    /**
     * 更新商品信息（运通）
     *
     * @param key
     * @param sign
     * @return
     */
    @RequestMapping(value = "/updateGoddsInfo", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String updateGoddsInfo(@RequestParam(value = "key") String key, @RequestParam(value = "data") String data, @RequestParam(value = "sign") String sign) {

        yunTongApiService.updateGoods(data, key, sign);
        return "aaa";
    }

    /**
     * 测试使用
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/test", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String test() {
//        thirdDeliveryService.testRest();
        //测试华龙百家
//        return thirdDeliveryService.testRest();
        //测试运通
        return yunTongApiService.testRest();
    }


}

package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.service.OrdersLogService;
import com.cqzg168.scm.service.OrdersService;
import com.cqzg168.scm.service.ThirdDeliveryService;
import com.cqzg168.scm.utils.RSAUtils;
import com.cqzg168.scm.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.*;

/**
 * Created by Administrator on 2017/6/7 0007.
 */
@Service
@Transactional
public class ThirdDeliveryServiceImpl implements ThirdDeliveryService {
    @Value("${delivery_public_key}")
    private String deliveryPublicKey;
    @Value("${delivery_private_key}")
    private String deliveryPrivateKey;
    @Value("${delivery_url}")
    private String deliveryUrl;
    @Autowired
    OrdersService ordersService;
    @Autowired
    OrdersLogService ordersLogService;


    @Override
    public Map<String,Object> updateOrdersStatus(String orderSid, String key, String sign) {
        Map<String,Object> map =new HashMap<>();
        boolean flag = verifySign(orderSid, key, sign);
        if (flag) {
            Orders orders=ordersService.findOne(Long.parseLong(orderSid));
            if(!Utils.isNull(orders)){
                try{
                    Integer srcStatus=orders.getStatus();
                    orders.setStatus(3);
                    ordersService.save(orders);
                    ordersLogService.saveOrdersLog(-1l,orders.getSid(),srcStatus,orders.getStatus(),"第三方供应商发货");
                    map.put("result",true);
                    map.put("msg","调用成功");
                    return  map;
                }catch(Exception e){
                    map.put("result",false);
                    map.put("msg","修改订单状态失败");
                    return map;
                }
            }else{
                map.put("result",false);
                map.put("msg","订单号"+orderSid+"不存在");
                return  map;
            }


        } else {
            map.put("result",false);
            map.put("msg","sign校验失败");
            return map;
        }

    }

    /**
     * 测试模拟调用接口
     */
    @Override
    public String testRest() {
        MultiValueMap<String, String> paramMap = createParams();
        RestTemplate restTemplate = new RestTemplate();
        String result=restTemplate.postForObject(deliveryUrl, paramMap, String.class);
        return result;
    }

    /**
     * 校验传递的sign
     *
     * @param orderSid
     * @param key
     * @return
     */
    private boolean verifySign(String orderSid, String key, String sign) {
        List<String> list = new ArrayList<>();
        list.add("orderSid");
        list.add("key");

        Collections.sort(list);

        //生成回调数据map
        MultiValueMap<String, String> paramMap = new LinkedMultiValueMap<>();
        paramMap.add("orderSid", orderSid);
        paramMap.add("key", key);


        //规则拼装键值对
        StringBuffer singSource = new StringBuffer();
        for (String str : list) {
            singSource.append("&" + str + "=" + paramMap.getFirst(str));
        }
        //先MD5加密
        String strSource = singSource.toString().substring(1);
        strSource = Utils.getMD5String(strSource);
        String mdrStr = RSAUtils.urlDecryptByPrivate(sign, deliveryPrivateKey);
        System.out.println("原始sign      ："+strSource);
        System.out.println("verifySign解密："+mdrStr);
        if (strSource.equals(mdrStr)) {
            return true;
        } else {
            return false;
        }


    }

    /**
     * 测试模拟生成数据
     *
     * @return
     */
    private MultiValueMap<String, String> createParams() {
        List<String> list = new ArrayList<>();
        list.add("orderSid");
        list.add("key");

        Collections.sort(list);

        //生成回调数据map
        MultiValueMap<String, String> paramMap = new LinkedMultiValueMap<>();
        paramMap.add("orderSid", "10000000216");
        paramMap.add("key", "HLBJ");
        //规则拼装键值对
        StringBuffer singSource = new StringBuffer();
        for (String str : list) {
            singSource.append("&" + str + "=" + paramMap.getFirst(str));
        }
        //先MD5加密然后RSA加密生成签名
        String strSource = singSource.toString().substring(1);
        strSource = Utils.getMD5String(strSource);

        String sign = RSAUtils.urlEncryptByPublic(strSource, deliveryPublicKey);

        paramMap.add("sign", sign);
        return paramMap;
    }


}

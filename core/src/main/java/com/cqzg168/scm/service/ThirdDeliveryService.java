package com.cqzg168.scm.service;

import java.util.Map;

/**
 * Created by Administrator on 2017/6/7 0007.
 */
public interface ThirdDeliveryService {

    Map<String,Object> updateOrdersStatus(String orderSid, String key, String sign);

    String testRest();

}

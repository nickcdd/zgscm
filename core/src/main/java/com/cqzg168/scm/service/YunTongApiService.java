package com.cqzg168.scm.service;

import java.util.Map;

/**
 * Created by Administrator on 2017/6/15 0015.
 */
public interface YunTongApiService {
    Map<String,Object> updateGoods(String data, String key, String sign);

    String testRest();
}

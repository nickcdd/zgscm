package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.Orders;
import org.json.JSONObject;
import org.springframework.util.MultiValueMap;

/**
 * Created by admin on 2017/6/6.
 */
public interface LongbaiApiService {


    /**
     * api调用结果
     * @return
     */
    String result(Orders orders);
}

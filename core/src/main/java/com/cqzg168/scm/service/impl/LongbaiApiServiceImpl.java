package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Goods;
import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.OrdersRequestRecord;
import com.cqzg168.scm.domain.Supplier;
import com.cqzg168.scm.repository.AreaRepository;
import com.cqzg168.scm.service.AreaService;
import com.cqzg168.scm.service.LongbaiApiService;
import com.cqzg168.scm.service.OrdersRequestRecordService;
import com.cqzg168.scm.service.SupplierService;
import com.cqzg168.scm.utils.Utils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.*;

/**
 * Created by admin on 2017/6/6.
 */
@Service
@Transactional
public class LongbaiApiServiceImpl implements LongbaiApiService {
    @Autowired
    private SupplierService supplierService;
    @Autowired
    private OrdersRequestRecordService ordersRequestRecordService;

    @Value("${long_bai_api_key}")
    private String key;
    @Value("${long_bai_api_secrety}")
    private String secret;
    @Value("${long_bai_api_signType}")
    private String signType;
    @Value("${long_bai_api_url}")
    private String longBaiApiUrl;


    public String createSign(String data) {
        List<String> list = new ArrayList<>();
        list.add("data");
        list.add("secret");
        Collections.sort(list);
        Map<String, Object> map = new HashMap<>();
        map.put("data", data);
        map.put("secret", secret);
        StringBuffer stringBuffer = new StringBuffer();
        for (String mapKey : list) {
            stringBuffer.append("&" + mapKey + "=" + map.get(mapKey));
        }
        String signTemp = stringBuffer.toString();
        signTemp = signTemp.substring(1);
        String sign = Utils.getMD5String(signTemp).toUpperCase();
        return sign;
    }

    public JSONObject paramData(Orders orders) {
        JSONObject dataJson = new JSONObject();
        JSONArray goodsArrar = new JSONArray();
        try {
            dataJson.put("createTime", orders.getCreateTime().getTime());
            dataJson.put("orderId", orders.getSid());
            dataJson.put("shippingAddress", orders.getProvince() + orders.getCity() + orders.getArea() + orders.getAddress());
            dataJson.put("shippingMobile", orders.getShopKeeper().getTelephone());
            dataJson.put("shippingPerson", orders.getShopKeeper().getRealName());
            dataJson.put("signCreatTime", System.currentTimeMillis());
            for (int i = 0; i < orders.getOrdersGoodsList().size(); i++) {
                Goods goods = orders.getOrdersGoodsList().get(i).getGoods();
                JSONObject goodsJson = new JSONObject();
                goodsJson.put("goodsInfoId", goods.getSid());
                //商品数量
                Integer count = orders.getOrdersGoodsList().get(i).getGoodsCount();
                goodsJson.put("goodsInfoNum", count);
                goodsArrar.put(goodsJson);
            }
            dataJson.put("goods", goodsArrar);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return dataJson;
    }

    @Override
    public String result(Orders orders) {
        MultiValueMap<String, Object> paramMap = new LinkedMultiValueMap<>();
        String data = paramData(orders).toString();
        paramMap.add("data", data);
        paramMap.add("key", key);
        paramMap.add("signType", signType);
        paramMap.add("sign", createSign(data));
        RestTemplate restTemplate = new RestTemplate();
        String result = "";
        if (orders.getChildrenOrders() != null && orders.getChildrenOrders().size() > 0) {
            for (Orders chlidrenOrders : orders.getChildrenOrders()) {
                Supplier supplier = supplierService.findOne(chlidrenOrders.getSupplierSid());
                if(supplier != null){
                    String supplierApi = supplier.getApi();
                    if ("lbapi".equals(supplierApi)) {
                        result = restTemplate.postForObject(longBaiApiUrl, paramMap, String.class);
                        saveOrdersRequestRecord(supplier.getSid(), result);
                    }
                }
            }
        } else {
            Supplier supplier = supplierService.findOne(orders.getSupplierSid());
            if(supplier != null){
                String supplierApi = supplier.getApi();
                if ("lbapi".equals(supplierApi)) {
                    result = restTemplate.postForObject(longBaiApiUrl, paramMap, String.class);
                    saveOrdersRequestRecord(supplier.getSid(), result);
                }
            }
        }
        return result;
    }

    /**
     * 保存订单请求记录
     *
     * @param sid
     * @param reseult
     */
    public void saveOrdersRequestRecord(Long sid, String reseult) {
        try {
            JSONObject jsonObject = new JSONObject(reseult);
            String resultMsg = jsonObject.getString("msg");
            OrdersRequestRecord ordersRequestRecord = new OrdersRequestRecord();
            ordersRequestRecord.setSupplierSid(sid);
            ordersRequestRecord.setResult(resultMsg);
            ordersRequestRecordService.save(ordersRequestRecord);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.service.YunTongApiService;
import com.cqzg168.scm.utils.RSAUtils;
import com.cqzg168.scm.utils.Utils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.*;

/**
 * Created by Administrator on 2017/6/15 0015.
 */
@Service
@Transactional
public class YunTongApiServiceImpl implements YunTongApiService {
    @Value("${yuntong_public_key}")
    private String yuntongPublicKey;
    @Value("${yuntong_private_key}")
    private String yuntongPrivateKey;
    @Value("${yuntong_url}")
    private String yuntongUrl;

    @Override
    public Map<String, Object> updateGoods(String data, String key, String sign) {
        boolean flag = verifySign(data, key, sign);
        if(flag){
            System.out.println("成功");
        }else{
            System.out.println("失败");
        }
        return null;
    }

    /**
     * 测试模拟调用接口
     */
    @Override
    public String testRest() {
        MultiValueMap<String, String> paramMap = createParams();
        RestTemplate restTemplate = new RestTemplate();
//        testsign();
        String result=restTemplate.postForObject(yuntongUrl, paramMap, String.class);
       
        return result;
    }

    /**
     * 校验传递的sign
     *
     * @param
     * @param key
     * @return
     */
    private boolean verifySign(String data, String key, String sign) {
        List<String> list = new ArrayList<>();
        list.add("data");
        list.add("key");

        Collections.sort(list);

        //生成回调数据map
        MultiValueMap<String, String> paramMap = new LinkedMultiValueMap<>();
        paramMap.add("data", data);
        paramMap.add("key", key);


        //规则拼装键值对
        StringBuffer singSource = new StringBuffer();
        for (String str : list) {
            singSource.append("&" + str + "=" + paramMap.getFirst(str));
        }
        //先MD5加密
        String strSource = singSource.toString().substring(1);
        strSource = Utils.getMD5String(strSource);
        String mdrStr = RSAUtils.urlDecryptByPrivate(sign, yuntongPrivateKey);

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
        list.add("data");
        list.add("key");

        Collections.sort(list);

        //生成回调数据map
        MultiValueMap<String, String> paramMap = new LinkedMultiValueMap<>();
        JSONObject jsonObject = new JSONObject();
        JSONArray goodsArrar = new JSONArray();


        for(int i=0;i<3;i++){

            HashMap<String,Object> map=new HashMap<>();
            map.put("sid",new Long((long)i));
            map.put("cname","测试"+i);
            JSONObject json = new JSONObject(map);
            goodsArrar.put(json);
        }
        try {
            jsonObject.put("goods", goodsArrar.toString());
            System.out.println(jsonObject.toString());
        }catch (JSONException e) {
            e.printStackTrace();
        }
        paramMap.add("data",jsonObject.toString());
        paramMap.add("key", "YUNTONG");
        //规则拼装键值对
        StringBuffer singSource = new StringBuffer();
        for (String str : list) {
            singSource.append("&" + str + "=" + paramMap.getFirst(str));
        }
        //先MD5加密然后RSA加密生成签名
        String strSource = singSource.toString().substring(1);
        strSource = Utils.getMD5String(strSource);

        String sign = RSAUtils.urlEncryptByPublic(strSource, yuntongPublicKey);

        paramMap.add("sign", sign);
        return paramMap;
    }
}

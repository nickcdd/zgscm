package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.service.SMSService;
import com.cqzg168.scm.utils.RSAUtils;
import com.cqzg168.scm.utils.Utils;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.awt.*;
import java.util.*;
import java.util.List;

/**
 * Created by admin on 2017/5/12.
 */
@Service
@Transactional
public class SMSServiceImpl implements SMSService {
    @Value("${public_key}")
    private String publicKey;
    @Value("${sms_url}")
    private String smsUrl;
    @Value("${sms_login_body}")
    private String smsLoginBody;
    @Value("${sms_gathering_body}")
    private String smsGatheringBody;

    RestTemplate restTemplate = new RestTemplate();

    @Override
    public String loginSmsValidate(String telephone,String random) {
        MultiValueMap<String, String> paramMap = createSmsParame(smsLoginBody + random, telephone);
        String resultJSON = restTemplate.postForObject(smsUrl, paramMap, String.class);
        String result = "error";
        try {
            JSONObject jsonObject = new JSONObject(resultJSON);
            if("true".equals(jsonObject.getString("result"))){
                result = "success";
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public String gatheringSmsPush(String telephone, Double amount) {
        String body = smsGatheringBody + amount + "元";
        MultiValueMap<String, String> paramMap = createSmsParame(body, telephone);
        return restTemplate.postForObject(smsUrl, paramMap, String.class);
    }

    /**
     * 生成短信推送参数
     *
     * @param smsBody
     * @param telephone
     * @return
     */
    private MultiValueMap<String, String> createSmsParame(String smsBody, String telephone) {
        List<String> list = new ArrayList<>();
        list.add("sendTime");
        list.add("mobile");
        list.add("content");
        Collections.sort(list);

        //生成回调数据map
        MultiValueMap<String, String> paramMap = new LinkedMultiValueMap<>();
        paramMap.add("sendTime", (System.currentTimeMillis() / 1000) + "");
        paramMap.add("mobile", telephone);
        paramMap.add("content", smsBody);
        //规则拼装键值对
        StringBuffer singSource = new StringBuffer();
        for (String str : list) {
            singSource.append("&" + str + "=" + paramMap.getFirst(str));
        }
        //先MD5加密然后RSA加密生成签名
        String strSource = singSource.toString().substring(1);
        strSource = Utils.getMD5String(strSource);
        String sign = RSAUtils.encryptByPublic(strSource, publicKey);
        paramMap.add("key", sign);
        return paramMap;
    }
}

package com.cqzg168.scm.service;

import org.springframework.util.MultiValueMap;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * Created by admin on 2017/5/12.
 */
public interface SMSService {
    /**
     * 登录短信验证
     *
     * @param telephone
     * @return
     */
    String loginSmsValidate(String telephone, String random);

    /**
     * 发送收款短信通知
     *
     * @param telephone
     * @return
     */
    String gatheringSmsPush(String telephone, Double amount);

}

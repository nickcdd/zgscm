package com.cqzg168.scm.utils;

import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.domain.Sort.Order;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 系统常量 Created by jackytsu on 2017/3/14.
 */
public class Constant {

    public final static String TABLE_PREFIX = "scm_";

    public final static SimpleDateFormat SF_FULL_DATE_TIME = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    public final static SimpleDateFormat SF_DATE           = new SimpleDateFormat("yyyy-MM-dd");
    public final static SimpleDateFormat SF_DATE_DOT       = new SimpleDateFormat("yyyy.MM.dd");

    public final static DateTimeFormatter DTF_FULL_DATE_TIME = DateTimeFormat.forPattern(Constant.STR_FULL_DATE_TIME);
    public final static DateTimeFormatter DTF_DATE           = DateTimeFormat.forPattern(Constant.STR_DATE);

    public final static String              STR_FULL_DATE_TIME = "yyyy-MM-dd HH:mm:ss";
    public final static String              STR_DATE_TIME_HOUR = "yyyy-MM-dd HH:mm";
    public final static String              STR_DATE           = "yyyy-MM-dd";
    public final static Map<String, String> BANK_NAME_MAP      = bankName();

    /**
     * 银行名称映射
     *
     * @return
     */
    private static Map<String, String> bankName() {
        Map<String, String> map = new HashMap<>();
        map.put("ABC", "中国农业银行");
        map.put("BJBANK", "北京银行");
        map.put("BOC", "中国银行");
        map.put("CCB", "中国建设银行");
        map.put("CCQTGB", "重庆三峡银行");
        map.put("CDCB", "成都银行");
        map.put("CIB", "兴业银行");
        map.put("CITIC", "中信银行");
        map.put("CMB", "招商银行");
        map.put("CMBC", "中国民生银行");
        map.put("COMM", "交通银行");
        map.put("CQBANK", "重庆银行");
        map.put("CRCBANK", "重庆农村商业银行");
        map.put("GDB", "广发银行ICGB");
        map.put("HXBANK", "华夏银行");
        map.put("ICBC", "中国工商银行");
        map.put("PINGAN", "平安银行");
        map.put("PSBC", "中国邮政储蓄银行");
        map.put("SPDB", "浦发银行");
        return map;
    }

    /**
     * 排序规则
     */
    public final static List<Order> orders = new ArrayList<Order>() {
        private static final long serialVersionUID = -11116779924094735L;

        {
            add(new Order(Direction.ASC, "sort"));
            add(new Order(Direction.DESC, "createTime"));
        }
    };

    /**
     * 默认每页显示记录数
     */
    public final static String DEFAULT_PAGE_SIZE = "10";

    /**
     * Session 对象 KEY
     * <p>
     * Created by jackytsu on 2017/3/14.
     */
    public final class SessionKey {
        /**
         * 当前登录用户
         */
        public static final String CURRENT_USER = "com.cqzg168.scm.session.user";
        /**
         * 图形验证码
         */
        public static final String CAPTCHA      = "com.cqzg168.scm.session.captcha";
        /**
         * 防止表单重复提交的令牌
         */
        public static final String FORM_TOKEN   = "com.cqzg168.scm.session.form_token";
    }

    /**
     * Request 对象 KEY
     */
    public final class RequestKey {
        public static final String DISABLE_DECORATE = "com.cqzg168.scm.request.disable_decorate";
    }
}

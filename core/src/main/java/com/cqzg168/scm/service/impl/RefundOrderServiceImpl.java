package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.service.RefundOrderService;
import com.cqzg168.scm.service.ShopKeeperService;
import com.cqzg168.scm.utils.DateUtil;
import com.cqzg168.scm.utils.RSAUtils;
import com.cqzg168.scm.utils.Utils;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.util.*;

/**
 * Created by Administrator on 2017/6/21 0021.
 */
@Service
@Transactional
public class RefundOrderServiceImpl implements RefundOrderService {
    @Value("${public_key}")
    private String publicKey;
    @Value("${refund_url}")
    private String refundUrl;
//    @Value("${minsheng_refund_url}")
//    private  String minshengRefundUrl;
    @Autowired
    private ShopKeeperService shopKeeperService;

    @Override
    public Map<String,Object> refundToWeChatOrAlipay(Long ordersSid, BigDecimal amount) {
        System.out.println("退款金额"+amount+" "+ordersSid);
        String resultStr=refundOrders(ordersSid,amount);
        System.out.println("返回结果"+resultStr);
        Map<String,Object> map=new HashMap<>();
        String msg="";
        boolean flag=true;
        try {
            JSONObject jsonObject = new JSONObject(resultStr);
            String result=jsonObject.getString("result");
            if("true".equals(result)){
                flag= true;
                msg=",已退款"+amount.toString()+"元";
            }else{
                flag= false;
            }

        } catch (JSONException e) {

            e.printStackTrace();
            flag= true;
        }finally{
            map.put("flag",flag);
            map.put("msg",msg);
            return map;

        }

    }

    @Override
    public Map<String,Object> refundToCredit(Long ordersSid, BigDecimal amount, ShopKeeper shopKeeper) {
        Map<String,Object> map=new HashMap<>();
        boolean flag=true;
        shopKeeper.setCredit(shopKeeper.getCredit().add(amount));
        try{
            if(!Utils.isNull(shopKeeper.getSid())){
                shopKeeperService.save(shopKeeper);
                flag= true;
            }else{
             flag=  false;
            }

        }catch (Exception e){
            e.printStackTrace();
            flag=  false;
        }finally{
            map.put("flag",flag);

    }
        return map;
    }

//    @Override
//    public Map<String,Object> refundToBankCard(String billNo, BigDecimal amount)  {
//        Map<String,Object> map=new HashMap<>();
//        boolean flag=true;
//        String msg="";
//        String resultStr=minshengRefundOrders(billNo,amount);
//        System.out.println("民生付返回值"+resultStr);
//        resultStr=resultStr.substring(1,resultStr.length());
//        System.out.println("截取后返回值"+resultStr);
//        try {
//            JSONObject jsonObject = new JSONObject(resultStr);
//            JSONObject message =new JSONObject( jsonObject.getString("Message"));
////            JSONObject errorStr =new JSONObject( message.getString("Error"));
////            System.out.println("erroer"+errorStr.toString());
//
//            //        String result=jsonObject.getString("result");
//            if (message.isNull("Error")) {
//                JSONObject refundReq =new JSONObject( jsonObject.getString("RefundReq"));
//                String status = refundReq.getString("status");
//                if ("00".equals(status)) {
//                    flag= true;
//                    msg="，民生付退款订单："+refundReq.getString("orderId");
//                }else if("99".equals(status)){
//                    flag= true;
//                    msg="，交易结果未知，民生付退款订单："+refundReq.getString("orderId");
//                }
//                else {
//                    System.out.println("aaaaaaaaaaaaaaaaaaa");
//                    flag= false;
//                }
//            } else {
//                System.out.println("bbbbbbbbb");
//                flag= false;
//            }
//
//        }catch (JSONException e){
//            e.printStackTrace();
//            flag= true;
//        }finally {
//            map.put("flag",flag);
//            map.put("msg",msg);
//        }
//       return map;
//    }

    public String refundOrders( Long ordersSid, BigDecimal amount) {
        RestTemplate restTemplate = new RestTemplate();
        MultiValueMap<String, String> paramMap = refundParam( ordersSid, amount);

        return restTemplate.postForObject(refundUrl, paramMap, String.class);
    }

    /**
     * 生成退款请求参数
     *
     * @param
     * @param
     * @param
     * @return
     */
    public MultiValueMap<String, String> refundParam( Long ordersSid, BigDecimal amount) {
        List<String> list = new ArrayList<>();
        list.add("orderid");
        list.add("apply_date");
        list.add("money");
        list.add("source");
        Collections.sort(list);
        //生成回调数据map
        MultiValueMap<String, String> resultMap = new LinkedMultiValueMap<>();
        resultMap.add("orderid", ordersSid.toString());

        String date=DateUtil.dateToString(new Date(),"yyyy-MM-dd HH:mm:ss");
        resultMap.add("apply_date", date);
        amount=amount.setScale(2, BigDecimal.ROUND_HALF_UP);
        resultMap.add("money", amount.toString());
        resultMap.add("source", "集采平台");
        //规则拼装键值对
        StringBuffer singSource = new StringBuffer();
        for (String str : list) {
            singSource.append("&" + str + "=" + resultMap.getFirst(str));
        }

        //先MD5加密然后RSA加密生成签名
        String strSource = singSource.toString().substring(1);
        System.out.println("生成支付参数"+strSource);
        strSource = Utils.getMD5String(strSource);
        String sign = RSAUtils.encryptByPublic(strSource, publicKey);
        resultMap.add("key", sign);
        return resultMap;
    }

//    /**
//     * 调用民生付退款接口
//     * @param orgOrderId
//     * @param amount
//     * @return
//     */
//    public String minshengRefundOrders( String orgOrderId, BigDecimal amount) {
//        RestTemplate restTemplate = new RestTemplate();
//        MultiValueMap<String, String> paramMap = minshengRefundParam( orgOrderId, amount);
//
//        return restTemplate.postForObject(minshengRefundUrl, paramMap, String.class);
//    }
//
//    /**
//     * 生成民生付退款请求参数
//     *
//     * @param
//     * @param
//     * @param
//     * @return
//     */
//    public MultiValueMap<String, String> minshengRefundParam( String orgOrderId, BigDecimal amount) {
//        List<String> list = new ArrayList<>();
//        list.add("orgOrderId");
//        list.add("addtime");
//        list.add("money");
//        list.add("remark");
//        Collections.sort(list);
//        //生成回调数据map
//        MultiValueMap<String, String> resultMap = new LinkedMultiValueMap<>();
//        resultMap.add("orgOrderId", orgOrderId);
//
//        String date=DateUtil.dateToString(new Date(),"yyyy-MM-dd HH:mm:ss");
//        resultMap.add("addtime", date);
//        amount=amount.setScale(2, BigDecimal.ROUND_HALF_UP);
//        resultMap.add("money", amount.toString());
//        resultMap.add("remark", "集采平台");
//        //规则拼装键值对
//        StringBuffer singSource = new StringBuffer();
//        for (String str : list) {
//            singSource.append("&" + str + "=" + resultMap.getFirst(str));
//        }
//
//        //先MD5加密然后RSA加密生成签名
//        String strSource = singSource.toString().substring(1);
//        System.out.println("民生付参数"+strSource);
//        strSource = Utils.getMD5String(strSource);
//        String sign = RSAUtils.encryptByPublic(strSource, publicKey);
//        resultMap.add("key", sign);
//        return resultMap;
//    }
}

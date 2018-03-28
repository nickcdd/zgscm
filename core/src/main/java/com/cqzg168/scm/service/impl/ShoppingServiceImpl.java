package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Inventory;
import com.cqzg168.scm.domain.ReceivingAddress;
import com.cqzg168.scm.domain.ShoppingCart;
import com.cqzg168.scm.service.*;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by admin on 2017/7/4.
 */
@Service
@Transactional
public class ShoppingServiceImpl implements ShoppingService {
    @Autowired
    private GoodsService            goodsService;
    @Autowired
    private ShoppingCartService     shoppingCartService;
    @Autowired
    private ReceivingAddressService receivingAddressService;
    @Value("${orders_total_pirce_estimate}")
    private String                  ordersTotalPirceEstimate;
    @Value("${orders_total_pirce_estimate_special}")
    private String                  ordersTotalPirceEstimateSpecial;
    @Autowired
    private InventoryService        inventoryService;

    private final List<String> setCitys = setCitys();

    private List<String> setCitys() {
        List<String> list = new ArrayList<>();
        list.add("南岸区");
        list.add("渝北区");
        list.add("大渡口区");
        list.add("北碚区");
        list.add("沙坪坝区");
        list.add("江北区");
        list.add("九龙坡区");
        list.add("渝中区");
        list.add("巴南区");
        return list;
    }

    /**
     * 判断库存是否足够
     *
     * @param shoppingCartSid
     * @return
     */
    @Override
    public String inventoryIsSufficient(String[] shoppingCartSid) {
        List<ShoppingCart>  shoppingCarts      = new ArrayList<>();
        Map<String, String> jsonObject         = new HashMap<>();
        Session             session            = SecurityUtils.getSubject().getSession();
        ShoppingCart        shoppingCartBuyNow = (ShoppingCart) session.getAttribute("buy_now");
        if (!Utils.isNull(shoppingCartSid) && shoppingCartSid.length > 0) {
            for (int i = 0; i < shoppingCartSid.length; i++) {
                ShoppingCart shoppingCart    = shoppingCartService.findOne(Long.parseLong(shoppingCartSid[i]));
                Long         resultInventory = inventoryService.getGoodsInventory(shoppingCart.getGoodsSpecification().getGoodsBm(), shoppingCart.getGoodsSpecification().getSid());
                if (shoppingCart.getGoodsAmount() > resultInventory) {
                    String goodsName = shoppingCart.getGoods().getCname() + " " + shoppingCart.getGoodsSpecification().getCname();
                    return goodsName;
                }
            }
        } else if (shoppingCartBuyNow != null) {
            Long resultInventory = inventoryService.getGoodsInventory(shoppingCartBuyNow.getGoodsSpecification().getGoodsBm(), shoppingCartBuyNow.getGoodsSpecification().getSid());
            if (shoppingCartBuyNow.getGoodsAmount() > resultInventory) {
                String goodsName = shoppingCartBuyNow.getGoods().getCname() + " " + shoppingCartBuyNow.getGoodsSpecification().getCname();
                return goodsName;
            }
        }
        return "success";
    }

    /**
     * 判断平台订单总金额是否大于1000
     *
     * @param shoppingCartSid
     * @return
     */
    @Override
    public Integer orderTotalPirceEstimate(String[] shoppingCartSid, Long addressSid) {
        List<ShoppingCart>  shoppingCarts      = new ArrayList<>();
        Integer status = 0;
        Session             session            = SecurityUtils.getSubject().getSession();
        int                 sum                = 0;
        Map<Integer, String> map = new HashMap<>();
        ShoppingCart        shoppingCartBuyNow = (ShoppingCart) session.getAttribute("buy_now");
        if (!Utils.isNull(shoppingCartSid) && shoppingCartSid.length > 0) {
            for (int i = 0; i < shoppingCartSid.length; i++) {
                ShoppingCart shoppingCart = shoppingCartService.findOne(Long.parseLong(shoppingCartSid[i]));
                if (shoppingCart.getGoods().getSupplier().getSid() == -1) {
                    shoppingCarts.add(shoppingCart);
                } else {
                    sum++;
                }
            }
        } else if (shoppingCartBuyNow != null) {
            if (shoppingCartBuyNow.getGoods().getSupplier().getSid() == -1) {
                shoppingCarts.add(shoppingCartBuyNow);
            } else {
                sum++;
            }
        }
        if(shoppingCarts.size() == 0){
            return status;
        }
        BigDecimal       totalPrice       = shoppingCartService.totalPrice(shoppingCarts);
        ReceivingAddress receivingAddress = receivingAddressService.findOne(addressSid);
        if (setCitys.contains(receivingAddress.getArea())) {
            if (totalPrice.compareTo(new BigDecimal(ordersTotalPirceEstimate)) != 1) {
                if(sum > 0){
                   //主城九区以内的地区，金额不满足要求。有其它非平台商品。
                    status = 1;
                }else {
                    //主城九区以内的地区，金额不满足要求。没有其它非平台商品。
                    status = 2;
                }
            }
        } else {
            if (totalPrice.compareTo(new BigDecimal(ordersTotalPirceEstimateSpecial)) != 1) {
                if(sum > 0){
                    //主城九区以外的地区，金额不满足要求。有其它非平台商品。
                    status = 3;
                }else {
                    //主城九区以外的地区，金额不满足要求。没有其它非平台商品。
                    status = 4;
                }
            }
        }
        return status;
    }
}

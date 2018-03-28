package com.cqzg168.scm.shopkeeper.controller;

import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.service.GoodsService;
import com.cqzg168.scm.service.GoodsSpecificationService;
import com.cqzg168.scm.service.InventoryService;
import com.cqzg168.scm.service.ShoppingCartService;
import com.cqzg168.scm.utils.Constant;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by admin on 2017/5/17.
 */
@RequestMapping("/shoppingCart")
@Controller
public class ShoppingCartController extends BaseController {

    @Autowired
    private ShoppingCartService       shoppingCartService;
    @Autowired
    private GoodsService              goodsService;
    @Autowired
    private GoodsSpecificationService goodsSpecificationService;
    @Autowired
    private InventoryService inventoryService;

    /**
     * 购物车列表
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/index")
    public String index(Device device, Model model) {
        Session    session    = SecurityUtils.getSubject().getSession();
        ShopKeeper shopKeeper = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        //根据商户查询购物车列表
        List<ShoppingCart> shoppingCarts = shoppingCartService.findShoppingCartByShopKeeperSid(shopKeeper.getSid());
        model.addAttribute("shoppingCarts", shoppingCarts);
        BigDecimal totalPrice       = shoppingCartService.totalPrice(shoppingCarts);
        Double     resultTotalPrice = totalPrice.doubleValue();
        model.addAttribute("totalPrice", resultTotalPrice);
        if (device.isNormal()) {
            return "shoppingCart/index";
        } else {
            return "shoppingCart/index_mobile";
        }

    }

    /**
     * 添加商品到购物车
     *
     * @param goodsSid
     * @param specificationSid
     * @param goodsAmount
     * @param model
     * @return
     */
    @RequestMapping(value = "/add")
    public String addShoppingCart(Long goodsSid, Long specificationSid, Integer goodsAmount, Model model) {
        Session            session            = SecurityUtils.getSubject().getSession();
        ShopKeeper         shopKeeper         = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        Goods              goods              = goodsService.findOne(goodsSid);
        GoodsSpecification goodsSpecification = goodsSpecificationService.findOne(specificationSid);
        //商品存入购物车
        ShoppingCart shoppingCartTraget = shoppingCartService.findOneByGoodsAndAndGoodsSpecificationAndShopKeeperSid(goods, goodsSpecification, shopKeeper.getSid());
        if (shoppingCartTraget != null) {
            if (shoppingCartTraget.getGoodsSpecification().getSid() == specificationSid) {
                shoppingCartTraget.setGoodsAmount(shoppingCartTraget.getGoodsAmount() + goodsAmount);
            }
        } else {
            ShoppingCart shoppingCart = new ShoppingCart();
            shoppingCart.setShopKeeperSid(shopKeeper.getSid());
            shoppingCart.setGoods(goods);
            shoppingCart.setGoodsSpecification(goodsSpecification);
            shoppingCart.setGoodsAmount(goodsAmount);
            shoppingCartService.save(shoppingCart);
        }
        //根据商户查询购物车列表
        List<ShoppingCart> shoppingCarts = shoppingCartService.findShoppingCartByShopKeeperSid(shopKeeper.getSid());
        model.addAttribute("shoppingCarts", shoppingCarts);
        return "redirect:/shoppingCart/index";
    }

    /**
     * 删除购物车商品
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/remove")
    public String remove(Long sid, Model model) {
        Session    session    = SecurityUtils.getSubject().getSession();
        ShopKeeper shopKeeper = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        shoppingCartService.remove(sid);
        List<ShoppingCart> shoppingCarts = shoppingCartService.findShoppingCartByShopKeeperSid(shopKeeper.getSid());
        model.addAttribute("shoppingCarts", shoppingCarts);
        return "redirect:/shoppingCart/index";
    }

    /**
     * 更新购物车商品数据
     *
     * @return
     */
    @RequestMapping(value = "/update")
    @ResponseBody
    public AjaxResult update(Long sid, Integer amount) {
        ShoppingCart shoppingCart = shoppingCartService.findOne(sid);
        shoppingCart.setGoodsAmount(amount);
        shoppingCartService.save(shoppingCart);

        return AjaxResult.ajaxSuccessResult("更新商品数量", shoppingCart.toMap());
    }

    /**
     * 更新立即购买Session中购物车商品数据
     *
     * @return
     */
    @RequestMapping(value = "/updateSession")
    @ResponseBody
    public AjaxResult updateSession(Integer amount) {
        Session      session            = SecurityUtils.getSubject().getSession();
        ShoppingCart shoppingCartBuyNow = (ShoppingCart) session.getAttribute("buy_now");
        shoppingCartBuyNow.setGoodsAmount(amount);
        session.setAttribute("buy_now", shoppingCartBuyNow);
        ShoppingCart shoppingCart = new ShoppingCart();
        shoppingCart.setGoodsAmount(shoppingCartBuyNow.getGoodsAmount());
        return AjaxResult.ajaxSuccessResult("更新商品数量", shoppingCart);
    }

    /**
     * 获取商品库存
     * @param specificationSid
     * @return
     */
    @ResponseBody
    @RequestMapping("/getInvertory")
    public AjaxResult getInvertory(Long specificationSid){
        GoodsSpecification goodsSpecification = goodsSpecificationService.findOne(specificationSid);
        Long resultInventory = inventoryService.getGoodsInventory(goodsSpecification.getGoodsBm(),specificationSid);
        return AjaxResult.ajaxSuccessResult("",resultInventory);
    }
}

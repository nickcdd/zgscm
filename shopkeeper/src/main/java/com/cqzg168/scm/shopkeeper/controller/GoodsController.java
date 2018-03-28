package com.cqzg168.scm.shopkeeper.controller;

import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.dto.GoodsDto;
import com.cqzg168.scm.dto.GoodsSpecificationDto;
import com.cqzg168.scm.service.*;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by admin on 2017/5/17.
 */
@RequestMapping("/goods")
@Controller
public class GoodsController extends BaseController {

    @Autowired
    private GoodsService              goodsService;
    @Autowired
    private GoodsCategoryService      goodsCategoryService;
    @Autowired
    private GoodsSpecificationService goodsSpecificationService;
    @Autowired
    private ShoppingCartService       shoppingCartService;
    @Autowired
    private SupplierService supplierService;
    @Autowired
    private InventoryService inventoryService;

    @RequestMapping(value = "/index")
    public String index(Device device, String cname, String bigCategory, String smallCategory, @RequestParam(defaultValue = "12") int size, @RequestParam(defaultValue = "0") int page, Model model) {
        Session     session    = SecurityUtils.getSubject().getSession();
        ShopKeeper  shopKeeper = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        PageRequest pageable   = new PageRequest(page, size, new Sort(Sort.Direction.DESC, "createTime"));
        Page<Goods> goods      = goodsService.findAllGoodsPage(cname, bigCategory, smallCategory, 1, pageable);
        model.addAttribute("pageInfo", new PageInfo(goods));

        if (!Utils.isEmpty(cname)) {
            model.addAttribute("cname", cname);
        }
        if (!Utils.isEmpty(smallCategory)) {
            model.addAttribute("smallCategory", smallCategory);
        }
        if (!Utils.isEmpty(bigCategory)) {
            model.addAttribute("bigCategory", bigCategory);
        }
        if (device.isNormal()) {
            model.addAttribute("goods", goods.getContent());
            return "goods/index";
        } else {
            List<ShoppingCart> shopKeeperCards = shoppingCartService.findShoppingCartByShopKeeperSid(shopKeeper.getSid());
            Integer            totalCount      = 0;
            for (ShoppingCart shoppingCart : shopKeeperCards) {
                totalCount = totalCount + shoppingCart.getGoodsAmount();
            }
            BigDecimal          totalPrice      = shoppingCartService.totalPrice(shopKeeperCards);
            List<GoodsCategory> goodsCategories = goodsCategoryService.findByParentSid(1L);
            model.addAttribute("goodsCategories", goodsCategories);
            model.addAttribute("goods", goods);
            model.addAttribute("totalCount", totalCount);
            model.addAttribute("totalPrice", totalPrice);
            return "goods/index_mobile";
        }
    }

    @RequestMapping(value = "/shopIndex")
    public String shopIndex(String cname, Long supplierSid, @RequestParam(defaultValue = "12") int size, @RequestParam(defaultValue = "0") int page, Model model) {
        PageRequest pageable = new PageRequest(page, size, new Sort(Sort.Direction.DESC, "createTime"));
        Page<Goods> goods    = goodsService.findBySuppliergoodsPage(cname, supplierSid, 1, pageable);
        model.addAttribute("pageInfo", new PageInfo(goods));
        model.addAttribute("goods", goods.getContent());
        if (!Utils.isEmpty(cname)) {
            model.addAttribute("cname", cname);
        }
        Supplier supplier = supplierService.findOne(supplierSid);
        model.addAttribute("supplierName", supplier.getCname());
        return "goods/shop_index";

    }

    /**
     * 手机端分页查询
     *
     * @param cname
     * @param categorySid
     * @param size
     * @param page
     * @param model
     * @return
     */
    @RequestMapping(value = "/page")
    public String page(String cname, Long categorySid, @RequestParam(defaultValue = "12") int size, @RequestParam(defaultValue = "0") int page, Model model) {
        Session     session    = SecurityUtils.getSubject().getSession();
        ShopKeeper  shopKeeper = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        PageRequest pageable   = new PageRequest(page, size, new Sort(Sort.Direction.DESC, "updateTime"));
        Page<Goods> goods      = goodsService.findBycategorySid(cname, categorySid, 1, pageable);
        model.addAttribute("pageInfo", new PageInfo(goods));
        if (!Utils.isEmpty(cname)) {
            model.addAttribute("cname", cname);
        }
        model.addAttribute("goods", goods);
        List<ShoppingCart> shopKeeperCards = shoppingCartService.findShoppingCartByShopKeeperSid(shopKeeper.getSid());
        model.addAttribute("shopKeeperCards", shopKeeperCards);
        model.addAttribute("categorySid", categorySid);
        return "goods/index_fragment";
    }

    /**
     * 查询库存 、库存足够保存到购物车
     *
     * @param pecificationsSid
     * @return
     */
    @RequestMapping(value = "/queryInventory")
    @ResponseBody
    public AjaxResult queryInventory(Long pecificationsSid, Integer goodsAmount, String addFlag, Long goodsCountTemp) {
        Map<String, Object> map                = new HashMap<>();
        Session             session            = SecurityUtils.getSubject().getSession();
        ShopKeeper          shopKeeper         = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        GoodsSpecification  goodsSpecification = goodsSpecificationService.findOne(pecificationsSid);
        Long                resultInventory    = 0L;
        if (addFlag != null && "addflag".equals(addFlag)) {
            resultInventory = inventoryService.getGoodsInventory(goodsSpecification.getGoodsBm(), goodsSpecification.getSid());
            if (goodsCountTemp < resultInventory) {
                //商品存入购物车
                Goods        goods              = goodsService.findOne(goodsSpecification.getGoodsSid());
                ShoppingCart shoppingCartTraget = shoppingCartService.findOneByGoodsAndAndGoodsSpecificationAndShopKeeperSid(goods, goodsSpecification, shopKeeper.getSid());
                if (shoppingCartTraget != null) {
                    if (shoppingCartTraget.getGoodsSpecification().getSid() == pecificationsSid) {
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
            }
        } else if (addFlag != null && "subtractflag".equals(addFlag)) {
            Goods        goods              = goodsService.findOne(goodsSpecification.getGoodsSid());
            ShoppingCart shoppingCartTraget = shoppingCartService.findOneByGoodsAndAndGoodsSpecificationAndShopKeeperSid(goods, goodsSpecification, shopKeeper.getSid());
            if (shoppingCartTraget.getGoodsAmount() <= goodsAmount) {
                shoppingCartService.remove(shoppingCartTraget.getSid());
            } else {
                shoppingCartTraget.setGoodsAmount(shoppingCartTraget.getGoodsAmount() - goodsAmount);
                shoppingCartService.save(shoppingCartTraget);
            }
        }
        List<ShoppingCart> shopKeeperCards = shoppingCartService.findShoppingCartByShopKeeperSid(shopKeeper.getSid());
        Integer            totalCount      = 0;
        for (ShoppingCart shoppingCart : shopKeeperCards) {
            totalCount = totalCount + shoppingCart.getGoodsAmount();
        }
        BigDecimal totalPrice = shoppingCartService.totalPrice(shopKeeperCards);
        map.put("inventory", resultInventory);
        map.put("totalPrice", totalPrice.toString());
        map.put("totalCount", totalCount);

        return AjaxResult.ajaxSuccessResult("goodsCategories", map);
    }

    /**
     * 加载商品规格
     *
     * @param goodsSid
     * @return
     */
    @RequestMapping(value = "/querySpecification")
    @ResponseBody
    public AjaxResult querySpecification(Long goodsSid) {
        Session session = SecurityUtils.getSubject().getSession();
        //删除上一次购买多规格商品未确定的session
        session.removeAttribute("saveModalSpecificationAndCount");
        ShopKeeper          shopKeeper          = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        Map<String, Object> map                 = new HashMap<>();
        List<ShoppingCart>  tempShopKeeperCards = shoppingCartService.findShoppingCartByShopKeeperSid(shopKeeper.getSid());
        Goods               goods               = goodsService.findOne(goodsSid);
        map.put("goods", goods);
        map.put("shopKeeperCards", tempShopKeeperCards);
        return AjaxResult.ajaxSuccessResult("", map);
    }

    /**
     * 改变不同规格商品的价格
     *
     * @param speicificationSid
     * @return
     */
    @RequestMapping(value = "/changeGooodsPrice")
    @ResponseBody
    public AjaxResult changeGooodsPrice(Long speicificationSid) {
        Session             session             = SecurityUtils.getSubject().getSession();
        ShopKeeper          shopKeeper          = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        Map<String, Object> map                 = new HashMap<>();
        List<ShoppingCart>  tempShopKeeperCards = shoppingCartService.findShoppingCartByShopKeeperSid(shopKeeper.getSid());
        GoodsSpecification  goodsSpecification  = goodsSpecificationService.findOne(speicificationSid);
        map.put("goodsSpecification", goodsSpecification);
        map.put("shopKeeperCards", tempShopKeeperCards);
        return AjaxResult.ajaxSuccessResult("", map);
    }

    /**
     * 多个规格的商品  加减商品时候
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/sessionSpecificationCount")
    @ResponseBody
    public AjaxResult sessionSpecificationCount(Long specificationSid, Integer count) {
        Session            session = SecurityUtils.getSubject().getSession();
        Map<Long, Integer> map     = (Map<Long, Integer>) session.getAttribute("saveModalSpecificationAndCount");
        if (map == null) {
            map = new HashMap<>();
        }
        map.put(specificationSid, count);
        session.setAttribute("saveModalSpecificationAndCount", map);
        return AjaxResult.ajaxSuccessResult("", "");
    }

    /**
     * 多个商品最后提交 库存检查
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/submitInventoryExamine")
    @ResponseBody
    public AjaxResult submitInventoryExamine() {
        Session            session    = SecurityUtils.getSubject().getSession();
        ShopKeeper         shopKeeper = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        Map<Long, Integer> map        = (Map<Long, Integer>) session.getAttribute("saveModalSpecificationAndCount");
        if (map != null) {
            for (Map.Entry<Long, Integer> entry : map.entrySet()) {
                GoodsSpecification goodsSpecification = goodsSpecificationService.findOne(entry.getKey());
                Long               resultInventory    = inventoryService.getGoodsInventory(goodsSpecification.getGoodsBm(), goodsSpecification.getSid());
                if (entry.getValue() > resultInventory) {
                    return AjaxResult.ajaxSuccessResult("false", "规格：" + goodsSpecification.getCname() + " 库存为" + resultInventory + "，请重新选择数量购买。");
                }
            }
        } else {
            map = new HashMap<>();
        }
        for (Map.Entry<Long, Integer> entry : map.entrySet()) {
            GoodsSpecification goodsSpecification = goodsSpecificationService.findOne(entry.getKey());
            //商品存入购物车
            Goods        goods              = goodsService.findOne(goodsSpecification.getGoodsSid());
            ShoppingCart shoppingCartTraget = shoppingCartService.findOneByGoodsAndAndGoodsSpecificationAndShopKeeperSid(goods, goodsSpecification, shopKeeper.getSid());
            if (shoppingCartTraget != null) {
                if (shoppingCartTraget.getGoodsSpecification().getSid() == entry.getKey()) {
                    shoppingCartTraget.setGoodsAmount(entry.getValue());
                }
            } else {
                ShoppingCart shoppingCart = new ShoppingCart();
                shoppingCart.setShopKeeperSid(shopKeeper.getSid());
                shoppingCart.setGoods(goods);
                shoppingCart.setGoodsSpecification(goodsSpecification);
                shoppingCart.setGoodsAmount(entry.getValue());
                shoppingCartService.save(shoppingCart);
            }
        }
        List<ShoppingCart> shopKeeperCards = shoppingCartService.findShoppingCartByShopKeeperSid(shopKeeper.getSid());
        Integer            totalCount      = 0;
        for (ShoppingCart shoppingCart : shopKeeperCards) {
            totalCount = totalCount + shoppingCart.getGoodsAmount();
        }
        BigDecimal          totalPrice = shoppingCartService.totalPrice(shopKeeperCards);
        Map<String, Object> mapResult  = new HashMap<>();
        mapResult.put("totalPrice", totalPrice.toString());
        mapResult.put("totalCount", totalCount);
        return AjaxResult.ajaxSuccessResult("true", mapResult);
    }

    /**
     * 加载子类  商品分类
     *
     * @param parentSid
     * @return
     */
    @RequestMapping(value = "/getChildrenGoodsCategorys")
    @ResponseBody
    public AjaxResult getChildrenGoodsCategorys(Long parentSid) {
        List<GoodsCategory> goodsCategories = goodsCategoryService.findByParentSid(parentSid);
        return AjaxResult.ajaxSuccessResult("goodsCategories", goodsCategories);
    }

    @RequestMapping(value = "/detail")
    public String detail(Long sid, Model model) {

        Goods                       goods                      = goodsService.findOne(sid);
        GoodsDto                    goodsDto                   = new GoodsDto(goods);
        List<GoodsSpecificationDto> tempGoodsSpecificationDtos = new ArrayList<>();
        if (goodsDto.getGoodsSpecifications() != null && goodsDto.getGoodsSpecifications().size() > 0) {
            for (int i = 0; i < goodsDto.getGoodsSpecifications().size(); i++) {
                if (goodsDto.getGoodsSpecifications().get(i).getStatus() == 1) {
                    //获得应显示库存
                    Long resultInventory = inventoryService.getGoodsInventory(goodsDto.getGoodsSpecifications().get(i).getGoodsBm(), goodsDto.getGoodsSpecifications().get(i).getSid());
                    //数据存入dto
                    GoodsSpecificationDto goodsSpecificationDto = new GoodsSpecificationDto(goodsDto.getGoodsSpecifications().get(i));
                    //= (GoodsSpecificationDto);
                    goodsSpecificationDto.setInventory(resultInventory);
                    tempGoodsSpecificationDtos.add(goodsSpecificationDto);
                }
            }
            goodsDto.setGoodsSpecificationDtos(tempGoodsSpecificationDtos);
        }
        model.addAttribute("goods", goodsDto);
        return "goods/detail";
    }

    /**
     * 商品分类加载
     *
     * @param parentSid
     * @return
     */
    @RequestMapping(value = "/category")
    @ResponseBody
    public AjaxResult category(Long parentSid) {
        List<GoodsCategory> goodsCategories = goodsCategoryService.findByParentSid(parentSid);
        return AjaxResult.ajaxSuccessResult("商品分类", goodsCategories);
    }

    /**
     * 更新商品价格根据不同的规格
     *
     * @param pecificationsSid
     * @return
     */
    @RequestMapping(value = "/updatePrice")
    @ResponseBody
    public AjaxResult updatePrice(Long pecificationsSid) {
        GoodsSpecification    goodsSpecification    = goodsSpecificationService.findOne(pecificationsSid);
        Long                  resultInventory       = inventoryService.getGoodsInventory(goodsSpecification.getGoodsBm(), goodsSpecification.getSid());
        GoodsSpecificationDto goodsSpecificationDto = new GoodsSpecificationDto(goodsSpecification);
        goodsSpecificationDto.setInventory(resultInventory);
        return AjaxResult.ajaxSuccessResult("商品", goodsSpecificationDto);
    }

}

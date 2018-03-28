package com.cqzg168.scm.supplier.controller;

import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.service.GoodsService;
import com.cqzg168.scm.service.GoodsSpecificationService;
import com.cqzg168.scm.service.InventoryService;
import com.cqzg168.scm.service.StorageService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.session.Session;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Created by Administrator on 2017/7/28 0028.
 */
@Controller
@RequestMapping("/inventory")
public class InventoryController {
    @Autowired
    InventoryService          inventoryService;
    @Autowired
    StorageService            storageService;
    @Autowired
    GoodsService              goodsService;
    @Autowired
    GoodsSpecificationService goodsSpecificationService;

    /**
     * 库存列表页
     *
     * @return
     */
    @RequestMapping("/index")
    public String index(@RequestParam(required = false) String goodsName, @RequestParam(required = false) String storageSid, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {
        Session                session         = (Session) SecurityUtils.getSubject().getSession();
        Supplier        supplier        = (Supplier) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        Page<Inventory> inventoriesPage = inventoryService.findEnventoryByPage(supplier.getSid(),goodsName, storageSid, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "goods.cname")));

        model.addAttribute("inventorys", inventoriesPage.getContent());
        model.addAttribute("pageInfo", new PageInfo(inventoriesPage));
        if (Utils.isEmpty(storageSid)) {
            model.addAttribute("checkStorageSid", "");
        } else {
            model.addAttribute("checkStorageSid", storageSid);
        }
        if (Utils.isEmpty(goodsName)) {
            model.addAttribute("goodsName", "");
        } else {
            model.addAttribute("goodsName", goodsName);
        }

        return "/inventory/index";
    }

    @ResponseBody
    @RequestMapping("/getAllStorages")
    public AjaxResult getAllStorages() {
        //        List<Supplier> areaList = supplierService.findAllSupplier();
        List<Storage> storagesList = storageService.findAllByStatus(1);

        if (!Utils.isNull(storagesList)) {
            return AjaxResult.ajaxSuccessResult("操作成功", storagesList);
        }

        return AjaxResult.ajaxFailResult("未找到指定管理员", null);
    }

    /**
     * 跳转到新增界面
     *
     * @return
     */
    @RequestMapping("/add")
    public String add(String redirectGoodsName,String redirectStorageSid,int redirectPage, int redirectSize,Model model) {
        model.addAttribute("redirectStorageSid", redirectStorageSid);
        model.addAttribute("redirectGoodsName", redirectGoodsName);
        model.addAttribute("redirectPage", redirectPage);
        model.addAttribute("redirectSize", redirectSize);
        return "/inventory/add";
    }

    /**
     * 查询商品
     *
     * @param name
     * @return
     */
    @ResponseBody
    @RequestMapping("/getGoodsByName")
    public AjaxResult getGoodsByName(String name) {
        Session                session         = (Session) SecurityUtils.getSubject().getSession();
        Supplier        supplier        = (Supplier) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        List<Goods> goodsList = goodsService.findByLikeGoodsName(name,supplier.getSid());

        if (!Utils.isNull(goodsList)) {
            return AjaxResult.ajaxSuccessResult("操作成功", goodsList);
        }

        return AjaxResult.ajaxFailResult("未找到指定管理员", null);
    }

    /**
     * 查询商品规格
     *
     * @param goodsSid
     * @return
     */
    @ResponseBody
    @RequestMapping("/getGoodsSpecificationByGoodsSid")
    public AjaxResult getGoodsSpecificationByGoodsSid(String goodsSid) {
        //        List<Supplier> areaList = supplierService.findAllSupplier();

        List<GoodsSpecification> goodsList = goodsSpecificationService.findByGoodsSid(Long.parseLong(goodsSid));

        if (!Utils.isNull(goodsList)) {
            return AjaxResult.ajaxSuccessResult("操作成功", goodsList);
        }

        return AjaxResult.ajaxFailResult("未找到指定管理员", null);
    }

    /**
     * 保存供应商信息
     *
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping(value ="/save",produces = "application/json;charset=UTF-8")
    public String save(String sid, String goodsSid, String specificationSid, String storageSid, Integer amount) throws JSONException {
        JSONObject jsonObject = new JSONObject();
        boolean    flag       = false;
        String     msg        = "";
        try {
            Inventory inventory=null;
            if(!Utils.isNull(sid)){


             inventory = inventoryService.findOne(Long.parseLong(sid));
            }

            if (!Utils.isNull(inventory)) {
                //修改
                if (!Utils.isNull(amount)) {
                    inventory.setAmount(amount);
                    inventoryService.save(inventory);
                }
                flag = true;
                msg = "修改库存成功";
            } else {
                //新增Inventory addInventory=new Inventory();

                Goods              goods              = goodsService.findOne(Long.parseLong(goodsSid));
                GoodsSpecification goodsSpecification = goodsSpecificationService.findOne(Long.parseLong(specificationSid));
                Storage            storage            = storageService.findOne(Long.parseLong(storageSid));
                if (!Utils.isNull(goods) && !Utils.isNull(goodsSpecification) && !Utils.isNull(storage)) {
                    List<Inventory> list=inventoryService.checkInventory(Long.parseLong(goodsSid),Long.parseLong(specificationSid),Long.parseLong(storageSid));
                    if(list.size()>0){
                        flag = false;
                        msg = "库存已存在，请勿重复添加";
                    }else {
                        Inventory addInventory = new Inventory();
                        addInventory.setGoods(goods);
                        addInventory.setAmount(amount);
                        addInventory.setGoodsSpecification(goodsSpecification);
                        addInventory.setStorage(storage);
                        inventoryService.save(addInventory);
                        flag = true;
                        msg = "新增成功";
                    }
                } else {
                    flag = false;
                    msg = "填写内容有误，保存失败";
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            flag = false;
            msg = "保存失败,请联系管理员";
        }
        jsonObject.put("flag", flag);
        jsonObject.put("msg", msg);
        return jsonObject.toString();

    }
    /**
     * 跳转到编辑界面
     *
     * @return
     */
    @RequestMapping("/edit")
    public String edit(Long sid,String redirectGoodsName,String redirectStorageSid,int redirectPage, int redirectSize,Model model) {

        Inventory inventory=inventoryService.findOne(sid);

        model.addAttribute("inventory", inventory);
        model.addAttribute("redirectStorageSid", redirectStorageSid);
        model.addAttribute("redirectGoodsName", redirectGoodsName);
        model.addAttribute("redirectPage", redirectPage);
        model.addAttribute("redirectSize", redirectSize);
        return "/inventory/edit";
    }
}

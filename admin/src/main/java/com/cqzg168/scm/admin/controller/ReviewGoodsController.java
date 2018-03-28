package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.admin.shiro.realm.WebAuthorizing;
import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.service.GoodsCategoryService;
import com.cqzg168.scm.service.GoodsLogService;
import com.cqzg168.scm.service.GoodsService;
import com.cqzg168.scm.service.GoodsSpecificationService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by Administrator on 2017/8/4 0004.
 */
@RequestMapping("/reviewGoods")
@Controller
public class ReviewGoodsController extends BaseController {
    @Autowired
    GoodsService         goodsService;
    @Autowired
    GoodsCategoryService goodsCategoryService;
    @Autowired
    GoodsLogService      goodsLogService;

    /**
     * 商品价格审核分页查询
     *
     * @param q
     * @param searchBigCatecory
     * @param searchSmallCatecory
     * @param price
     * @param status
     * @param page
     * @param size
     * @param model
     * @return
     */
    @RequiresPermissions("goods:reviewGoods")
    @RequestMapping("/index")
    public String index(@RequestParam(required = false) String q, @RequestParam(required = false) String searchBigCatecory, @RequestParam(required = false) String searchSmallCatecory, @RequestParam(required = false) String price, @RequestParam(required = true, defaultValue = "2") Integer status, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {
        Page<Goods>   goodsPage     = goodsService.findGoodsByPage(null, q, searchBigCatecory, searchSmallCatecory, price, null, null, status, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "cname")));
        GoodsCategory bigCategory   = new GoodsCategory();
        GoodsCategory smallCategory = new GoodsCategory();
        if (goodsPage.getContent().size() == 0 && page != 0) {
            goodsPage = goodsService.findGoodsByPage(null, q, searchBigCatecory, searchSmallCatecory, price, null, null, status, new PageRequest(page - 1, size, new Sort(Sort.Direction.ASC, "cname")));
        }
        model.addAttribute("goods", goodsPage.getContent());
        model.addAttribute("pageInfo", new PageInfo(goodsPage));
        if (Utils.isEmpty(q)) {
            model.addAttribute("q", "");
        } else {
            model.addAttribute("q", q);
        }
        if (Utils.isEmpty(searchBigCatecory)) {
            model.addAttribute("searchBigCatecory", "");
        } else {
            bigCategory = goodsCategoryService.findOne(Long.parseLong(searchBigCatecory));
            if (!Utils.isNull(bigCategory)) {
                model.addAttribute("searchBigCatecory", bigCategory.getSid() + "," + bigCategory.getCname());
            } else {
                model.addAttribute("searchBigCatecory", "");
            }

        }
        if (Utils.isEmpty(searchSmallCatecory)) {
            model.addAttribute("searchSmallCatecory", "");
        } else {
            smallCategory = goodsCategoryService.findOne(Long.parseLong(searchSmallCatecory));
            if (!Utils.isNull(smallCategory)) {
                model.addAttribute("searchSmallCatecory", smallCategory.getSid() + "," + smallCategory.getCname());
            } else {
                model.addAttribute("searchSmallCatecory", "");
            }
        }
        if (Utils.isEmpty(price)) {
            model.addAttribute("price", "");
        } else {
            model.addAttribute("price", price);
        }
        return "/reviewGoods/index";
    }

    /**
     * 保存价格审核信息
     *
     * @param goods
     * @param reviewStatus
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/save")
    @RequiresPermissions("goods:reviewGoods")
    public String save(Goods goods, int reviewStatus, final RedirectAttributes redirectAttributes, Long redirectBigCategory, Long redirectSmallCategory, String redirectQ, int redirectPage, int redirectSize, String reason) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        try {
            if (goods.getSid() != null && goods.getSid() > 0) {

                Goods   srcGoods  = goodsService.findOne(goods.getSid());
                Integer srcStatus = srcGoods.getStatus();
                srcGoods.setStatus(reviewStatus);

                Goods saveGoods = goodsService.save(srcGoods);
                if (reviewStatus == 4) {
                    goodsLogService.writeGoodsLog(manager.getSid(), saveGoods.getSid(), srcStatus, saveGoods.getStatus(), manager.getCname() + " 价格信息审核未通过，原因：" + reason);
                } else if (reviewStatus == 3) {
                    goodsLogService.writeGoodsLog(manager.getSid(), saveGoods.getSid(), srcStatus, saveGoods.getStatus(), manager.getCname() + ": 价格信息审核通过");
                }
                WebAuthorizing.refreshSessionPermission();
            } else {

            }

            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
        } finally {
            redirectAttributes.addAttribute("searchBigCatecory", redirectBigCategory);
            redirectAttributes.addAttribute("searchSmallCatecory", redirectSmallCategory);
            redirectAttributes.addAttribute("q", redirectQ);
            redirectAttributes.addAttribute("status", 2);
            redirectAttributes.addAttribute("page", redirectPage);
            redirectAttributes.addAttribute("size", redirectSize);
        }

        return "redirect:/reviewGoods/index";
    }

    /**
     * 商品基本详情
     *
     * @param sid
     * @return
     */
    @ResponseBody
    @RequestMapping("/detail")
    public AjaxResult detail(Long sid) {

        Goods goods = goodsService.findBySid(sid);

        if (!Utils.isNull(goods)) {

            return AjaxResult.ajaxSuccessResult("操作成功", goods.toMapWithExclude(null));
        }

        return AjaxResult.ajaxFailResult("未找到指定管理员", null);
    }

    /**
     * 单个操作
     *
     * @param sid
     * @param status
     * @return
     */
    @ResponseBody
    @RequestMapping("/commitReview")
    public AjaxResult commitReview(Long sid, Integer status, String reason) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);

        try {
            Goods   srcGoods  = goodsService.findOne(sid);
            Integer srcStatus = srcGoods.getStatus();
            srcGoods.setStatus(status);
            Goods  saveGoods = goodsService.save(srcGoods);
            String note      = "";
            if (status == 2) {
                note = manager.getCname() + ": 提交商品审核";
            } else if (status == 4) {
                note = manager.getCname() + ": 基本信息审核未通过 原因：" + reason;
            } else if (status == 3) {
                note = manager.getCname() + ": 基本信息审核通过";
            } else if (status == 0) {
                note = manager.getCname() + " :下架商品";
            } else if (status == 1) {
                note = manager.getCname() + ": 上架商品";
            }

            goodsLogService.writeGoodsLog(manager.getSid(), saveGoods.getSid(), srcStatus, saveGoods.getStatus(), note);
        } catch (Exception e) {
            AjaxResult.ajaxFailResult("", "提交审核申请失败");
        }
        return AjaxResult.ajaxSuccessResult("执行成功", "");
    }

    /**
     * 批量操作
     *
     * @param goodsSids
     * @param status
     * @return
     */
    @ResponseBody
    @RequestMapping("/batchCommitReview")
    public AjaxResult batchCommitReview(Long[] goodsSids, Integer status, String reason) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);

        try {

            if (!Utils.isNull(status)) {
                String note = "";
                if (status == 2) {
                    note = manager.getCname() + ": 提交商品审核";
                } else if (status == 4) {
                    note = manager.getCname() + ": 基本信息审核未通过 原因：" + reason;
                } else if (status == 3) {
                    note = manager.getCname() + ": 基本信息审核通过";
                } else if (status == 0) {
                    note = manager.getCname() + " :下架商品";
                } else if (status == 1) {
                    note = manager.getCname() + ": 上架商品";
                }
                if (!Utils.isEmpty(goodsSids)) {
                    List<Long> goodsList = Arrays.asList(goodsSids);
                    goodsService.batchUpdateStatus(manager.getSid(), goodsList, status, note);
                }
            }

        } catch (Exception e) {
            AjaxResult.ajaxFailResult("", "批量执行失败");
        }
        return AjaxResult.ajaxSuccessResult("执行成功", "");
    }

    @ResponseBody
    @RequestMapping("/getGoodsCategorys")
    public AjaxResult getGoodsCategorys(Long parentSid, Integer status) {
        List<GoodsCategory> goodsCategoryList = new ArrayList<>();
        if (!Utils.isNull(status)) {
            goodsCategoryList = goodsCategoryService.findByParentSidAndStatus(parentSid, status);
        } else {
            goodsCategoryList = goodsCategoryService.findByParentSid(parentSid);
        }
        if (!Utils.isNull(goodsCategoryList)) {
            return AjaxResult.ajaxSuccessResult("操作成功", goodsCategoryList);
        }

        return AjaxResult.ajaxFailResult("未找到指定管理员", null);
    }
}

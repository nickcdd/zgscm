package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.admin.shiro.realm.WebAuthorizing;
import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.dto.GoodsDto;
import com.cqzg168.scm.service.*;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.crypto.hash.Hash;
import org.apache.shiro.session.Session;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

/**
 * Created by think on 2017/5/7.
 */
@Controller
@RequestMapping("/goods")
public class GoodsController extends BaseController {
    @Autowired
    GoodsService goodsService;
    @Autowired
    GoodsCategoryService goodsCategoryService;
    @Autowired
    SupplierService supplierService;
    @Autowired
    GoodsFileService goodsFileService;
    @Autowired
    GoodsSpecificationService goodsSpecificationService;
    @Autowired
    GoodsLogService goodsLogService;
    @Autowired
    UploadGoodsExcelService uploadGoodsExcelService;


    /**
     * 查询商品基本列表分页查询
     *
     * @param q
     * @param status
     * @param page
     * @param size
     * @param model
     * @return
     */
    @RequiresPermissions("goods:managerBaseInfo")
    @RequestMapping("/baseInfo/index")
    public String index(@RequestParam(required = false) String q, @RequestParam(required = false) String searchBigCatecory, @RequestParam(required = false) String searchSmallCatecory, @RequestParam(required = false) String price, @RequestParam(required = false) Integer status, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {
        List<Integer> defaultStatus = new ArrayList<>();
        defaultStatus.add(0);
        defaultStatus.add(3);
        Page<Goods> goodsPage = goodsService.findGoodsByPage(null,q, searchBigCatecory, searchSmallCatecory, price, null, defaultStatus, status, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "cname")));
        GoodsCategory bigCategory = new GoodsCategory();
        GoodsCategory smallCategory = new GoodsCategory();
        if (goodsPage.getContent().size() == 0 && page != 0) {
            goodsPage = goodsService.findGoodsByPage(null,q, searchBigCatecory, searchSmallCatecory, price, null, defaultStatus, status, new PageRequest(page - 1, size, new Sort(Sort.Direction.ASC, "cname")));
        }
        model.addAttribute("goods", goodsPage.getContent());
        model.addAttribute("pageInfo", new PageInfo(goodsPage));
        if (Utils.isEmpty(q)) {
            model.addAttribute("q", "");
        } else {
            model.addAttribute("q", q);
        }
        model.addAttribute("status", status);
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
        return "/goods/baseInfo/index";
    }

    /**
     * 商品基本信息审核分页查询
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
    @RequiresPermissions("goods:reviewBasiInfo")
    @RequestMapping("/reviewBaseInfo/index")
    public String reviewBaseInfoIndex(@RequestParam(required = false) String q, @RequestParam(required = false) String searchBigCatecory, @RequestParam(required = false) String searchSmallCatecory, @RequestParam(required = false) String price, @RequestParam(required = true, defaultValue = "2") Integer status, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {
        Page<Goods> goodsPage = goodsService.findGoodsByPage(null,q, searchBigCatecory, searchSmallCatecory, price, null, null, status, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "cname")));
        GoodsCategory bigCategory = new GoodsCategory();
        GoodsCategory smallCategory = new GoodsCategory();

        if (goodsPage.getContent().size() == 0 && page != 0) {
            goodsPage = goodsService.findGoodsByPage(null,q, searchBigCatecory, searchSmallCatecory, price, null, null, status, new PageRequest(page - 1, size, new Sort(Sort.Direction.ASC, "cname")));
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
        return "/goods/reviewBaseInfo/index";
    }

    /**
     * 供应商管理分页查询商品
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
    @RequiresPermissions("goods:managerSupplier")
    @RequestMapping("/goodsSupplier/index")
    public String goodsSupplierIndex(@RequestParam(required = false) String q, @RequestParam(required = false) String searchBigCatecory, @RequestParam(required = false) String searchSmallCatecory, @RequestParam(required = false) String price, @RequestParam(required = false) Integer status, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {
        List<Integer> defaultStatus = new ArrayList<>();
        defaultStatus.add(1);
        defaultStatus.add(4);
        defaultStatus.add(7);
        Page<Goods> goodsPage = goodsService.findGoodsByPage(null,q, searchBigCatecory, searchSmallCatecory, price, 0, defaultStatus, status, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "cname")));
        if (goodsPage.getContent().size() == 0 && page != 0) {
            goodsPage = goodsService.findGoodsByPage(null,q, searchBigCatecory, searchSmallCatecory, price, 0, defaultStatus, status, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "cname")));
        }
        GoodsCategory bigCategory = new GoodsCategory();
        GoodsCategory smallCategory = new GoodsCategory();
        if (goodsPage.getContent().size() == 0 && page != 0) {
            goodsPage = goodsService.findGoodsByPage(null,q, searchBigCatecory, searchSmallCatecory, price, 0, defaultStatus, status, new PageRequest(page - 1, size, new Sort(Sort.Direction.ASC, "cname")));
        }
        model.addAttribute("goods", goodsPage.getContent());
        model.addAttribute("pageInfo", new PageInfo(goodsPage));
        if (Utils.isEmpty(q)) {
            model.addAttribute("q", "");
        } else {
            model.addAttribute("q", q);
        }
        model.addAttribute("status", status);
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
        return "/goods/goodsSupplier/index";
    }

    /**
     * 商品价格管理分页查询
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
    @RequiresPermissions("goods:managerPrice")
    @RequestMapping("/goodsPrice/index")
    public String goodsPriceIndex(@RequestParam(required = false) String q, @RequestParam(required = false) String searchBigCatecory, @RequestParam(required = false) String searchSmallCatecory, @RequestParam(required = false) String price, @RequestParam(required = false) Integer status, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {
        List<Integer> defaultStatus = new ArrayList<>();
        defaultStatus.add(0);
        defaultStatus.add(4);
        defaultStatus.add(6);
        Page<Goods> goodsPage = goodsService.findGoodsByPage(null,q, searchBigCatecory, searchSmallCatecory, price, null, defaultStatus, status, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "cname")));
        GoodsCategory bigCategory = new GoodsCategory();
        GoodsCategory smallCategory = new GoodsCategory();
        if (goodsPage.getContent().size() == 0 && page != 0) {
            goodsPage = goodsService.findGoodsByPage(null,q, searchBigCatecory, searchSmallCatecory, price, null, defaultStatus, status, new PageRequest(page - 1, size, new Sort(Sort.Direction.ASC, "cname")));
        }
        model.addAttribute("goods", goodsPage.getContent());
        model.addAttribute("pageInfo", new PageInfo(goodsPage));
        if (Utils.isEmpty(q)) {
            model.addAttribute("q", "");
        } else {
            model.addAttribute("q", q);
        }
        model.addAttribute("status", status);
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
        return "/goods/goodsPrice/index";
    }

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
    @RequiresPermissions("goods:reviewPrice")
    @RequestMapping("/reviewPrice/index")
    public String reviewPriceIndex(@RequestParam(required = false) String q, @RequestParam(required = false) String searchBigCatecory, @RequestParam(required = false) String searchSmallCatecory, @RequestParam(required = false) String price, @RequestParam(required = true, defaultValue = "5") Integer status, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {
        Page<Goods> goodsPage = goodsService.findGoodsByPage(null,q, searchBigCatecory, searchSmallCatecory, price, null, null, status, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "cname")));
        GoodsCategory bigCategory = new GoodsCategory();
        GoodsCategory smallCategory = new GoodsCategory();
        if (goodsPage.getContent().size() == 0 && page != 0) {
            goodsPage = goodsService.findGoodsByPage(null,q, searchBigCatecory, searchSmallCatecory, price, null, null, status, new PageRequest(page - 1, size, new Sort(Sort.Direction.ASC, "cname")));
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
        return "/goods/reviewPrice/index";
    }

    /**
     * 商品上下架管理分页查询
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
    @RequiresPermissions("goods:managerGoods")
    @RequestMapping("/publishGoods/index")
    public String publishGoodsIndex(@RequestParam(required = false) String q, @RequestParam(required = false) String searchBigCatecory, @RequestParam(required = false) String searchSmallCatecory, @RequestParam(required = false) String price, @RequestParam(required = false) Integer status, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {
        List<Integer> defaultStatus = new ArrayList<>();
        defaultStatus.add(0);
        defaultStatus.add(1);
        defaultStatus.add(7);
        Page<Goods> goodsPage = goodsService.findGoodsByPage(null,q, searchBigCatecory, searchSmallCatecory, price, null, defaultStatus, status, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "cname")));

        GoodsCategory bigCategory = new GoodsCategory();
        GoodsCategory smallCategory = new GoodsCategory();
        if (goodsPage.getContent().size() == 0 && page != 0) {
            goodsPage = goodsService.findGoodsByPage(null,q, searchBigCatecory, searchSmallCatecory, price, null, defaultStatus, status, new PageRequest(page - 1, size, new Sort(Sort.Direction.ASC, "cname")));
        }
        model.addAttribute("goods", goodsPage.getContent());
        model.addAttribute("pageInfo", new PageInfo(goodsPage));
        if (Utils.isEmpty(q)) {
            model.addAttribute("q", "");
        } else {
            model.addAttribute("q", q);
        }
        model.addAttribute("status", status);
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
        return "/goods/publishGoods/index";
    }

    /**
     * 商品基本详情
     *
     * @param sid
     * @return
     */
    @ResponseBody
    @RequestMapping("/detail")
    @RequiresPermissions("goods:managerBaseInfo")
    public AjaxResult detail(Long sid) {

        Goods goods = goodsService.findOne(sid);

        System.out.println(goods.getCname());
//        if (!Utils.isNull(goods)) {
////            for(GoodsSpecification goodsSpecification:goods.getGoodsSpecifications()){
////                goodsSpecification.setInventoryList(null);
////            }
//            goods.setGoodsSpecifications(null);
////            System.out.println(goods.getGoodsSpecifications().);
//
//            return AjaxResult.ajaxSuccessResult("操作成功", goods.toMapWithExclude(null));
//        }

        return AjaxResult.ajaxFailResult("未找到指定管理员", null);
    }

    /**
     * c查询商品日志
     *
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/findLogs")
    @RequiresPermissions("goods:managerBaseInfo")
    public AjaxResult findLogs(Long goodsSid) {

        Goods goods = goodsService.findOne(goodsSid);


        if (!Utils.isNull(goods)) {

            return AjaxResult.ajaxSuccessResult("操作成功", goods.toMapWithExclude(null));
        }

        return AjaxResult.ajaxFailResult("未找到指定管理员", null);
    }

    /**
     * 保存商品基本信息
     *
     * @param goods
     * @param bigCatecory
     * @param smallCatecory
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/baseInfo/save")
    @RequiresPermissions("goods:managerBaseInfo")
    public String save(Goods goods, Long bigCatecory, Long smallCatecory, MultipartFile myavatar, final RedirectAttributes redirectAttributes, Long redirectBigCategory, Long redirectSmallCategory, String redirectQ, int redirectPage, int redirectSize, Integer redirectStatus, Integer reviewStatus) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);

        try {

            if (goods.getSid() != null && goods.getSid() > 0) {
                Goods srcGoods = goodsService.findOne(goods.getSid());
                if (myavatar != null && myavatar.getOriginalFilename() != null && myavatar.getOriginalFilename().length() > 0) {
                    if (srcGoods.getGoodsFiles() != null) {
                        if (srcGoods.getGoodsFiles().size() == 0) {

                            String imgUrl = goodsFileService.uploadGoodsFile(myavatar);
                            GoodsFile goodsFile = new GoodsFile();
                            goodsFile.setUrl("/attachment/" + imgUrl);
                            goodsFile.setType(1);
                            goodsFile.setGoodsSid(goods.getSid());
                            goodsFileService.save(goodsFile);


                        } else {

                            String[] urlArray = srcGoods.getGoodsFiles().get(0).getUrl().split("/");
                            if (goodsFileService.deleteImg(urlArray[urlArray.length - 1])) {
                                String imgUrl = goodsFileService.uploadGoodsFile(myavatar);
                                srcGoods.getGoodsFiles().get(0).setUrl("/attachment/" + imgUrl);
                            }
                        }
                    }

                }
                GoodsCategory bigGoodsCategory = goodsCategoryService.findOne(bigCatecory);
                GoodsCategory smallGoodsCategory = goodsCategoryService.findOne(smallCatecory);
                srcGoods.setCname(goods.getCname());
                srcGoods.setGoodsBarcode(goods.getGoodsBarcode());
                srcGoods.setUnifiedCode(goods.getUnifiedCode());
                srcGoods.setGoodsCategoryOne(bigGoodsCategory);
                srcGoods.setGoodsCategoryTwo(smallGoodsCategory);
                if (goods.getFreeGoods() == 1) {
                    //是平台商品，需要移除供应商

//                    srcGoods.setSupplierList(null);
                    srcGoods.setSupplier(null);
                }
                srcGoods.setFreeGoods(goods.getFreeGoods());
                //判断是否提交审核
                Integer srcStatus = null;
                if (!Utils.isNull(reviewStatus)) {
                    srcStatus = srcGoods.getStatus();
                    srcGoods.setStatus(reviewStatus);
                }
                goodsService.save(srcGoods);
                //日志
                if (!Utils.isNull(reviewStatus)) {
                    goodsLogService.writeGoodsLog(manager.getSid(), goods.getSid(), srcStatus, reviewStatus, manager.getCname() + ": 提交商品基本信息审核");
                } else {
                    goodsLogService.writeGoodsLog(manager.getSid(), goods.getSid(), srcGoods.getStatus(), srcGoods.getStatus(), manager.getCname() + ": 修改商品基本信息");
                }
                WebAuthorizing.refreshSessionPermission();
            } else {

                GoodsCategory bigGoodsCategory = goodsCategoryService.findOne(bigCatecory);
                GoodsCategory smallGoodsCategory = goodsCategoryService.findOne(smallCatecory);
                goods.setGoodsCategoryOne(bigGoodsCategory);
                goods.setGoodsCategoryTwo(smallGoodsCategory);
                goods.setStatus(0);
                if (myavatar != null && myavatar.getOriginalFilename() != null && myavatar.getOriginalFilename().length() > 0) {
                    String imgUrl = goodsFileService.uploadGoodsFile(myavatar);
                    GoodsFile goodsFile = new GoodsFile();
                    goodsFile.setUrl("/attachment/" + imgUrl);
                    goodsFile.setType(1);

                    Goods saveGoods = goodsService.save(goods);

                    goodsFile.setGoodsSid(saveGoods.getSid());
                    goodsFileService.save(goodsFile);
                    goodsLogService.writeGoodsLog(manager.getSid(), saveGoods.getSid(), 0, 0, manager.getCname() + ": 新增商品基本信息（有添加图片）");
                } else {
                    Goods saveGoods = goodsService.save(goods);
                    goodsLogService.writeGoodsLog(manager.getSid(), saveGoods.getSid(), 0, 0, manager.getCname() + ": 新增商品基本信息（没有添加图片）");
                }
//                goodsLogService.writeGoodsLog(manager.getSid(),0,0,"新增商品基本信息");
            }

            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
        } finally {
            redirectAttributes.addAttribute("searchBigCatecory", redirectBigCategory);
            redirectAttributes.addAttribute("searchSmallCatecory", redirectSmallCategory);
            redirectAttributes.addAttribute("q", redirectQ);
            redirectAttributes.addAttribute("status", redirectStatus);
            redirectAttributes.addAttribute("page", redirectPage);
            redirectAttributes.addAttribute("size", redirectSize);
        }

        return "redirect:/goods/baseInfo/index";
    }

    /**
     * 保存商品基本信息审核
     *
     * @param goods
     * @param reviewStatus
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/reviewBaseInfo/save")
    @RequiresPermissions("goods:reviewBasiInfo")
    public String saveReviewBaseInfo(Goods goods, int reviewStatus, final RedirectAttributes redirectAttributes, Long redirectBigCategory, Long redirectSmallCategory, String redirectQ, int redirectPage, int redirectSize, String reason) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        try {
            if (goods.getSid() != null && goods.getSid() > 0) {

                Goods srcGoods = goodsService.findOne(goods.getSid());
                Integer srcStatus = srcGoods.getStatus();
                srcGoods.setStatus(reviewStatus);
                Goods saveGoods = goodsService.save(srcGoods);
                if (reviewStatus == 3) {
                    goodsLogService.writeGoodsLog(manager.getSid(), saveGoods.getSid(), srcStatus, saveGoods.getStatus(), manager.getCname() + ": 基本信息审核未通过 原因：" + reason);
                } else if (reviewStatus == 4) {
                    goodsLogService.writeGoodsLog(manager.getSid(), saveGoods.getSid(), srcStatus, saveGoods.getStatus(), manager.getCname() + ": 基本信息审核通过");
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

        return "redirect:/goods/reviewBaseInfo/index";
    }

    @RequestMapping("/goodsPrice/save")
    @RequiresPermissions("goods:managerPrice")
    public String saveGoodsPrice(Goods goods, String goodsSpecificationStr, final RedirectAttributes redirectAttributes, Long redirectBigCategory, Long redirectSmallCategory, String redirectQ, int redirectPage, int redirectSize, Integer redirectStatus, Integer reviewStatus) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
//        System.out.println(">>>>>>>>>>>"+goods.getSid()+">>>>>>>"+goodsSpecificationStr);
        try {
            if (goods.getSid() != null && !Utils.isEmpty(goodsSpecificationStr)) {
                Goods srcGoods = goodsService.findOne(goods.getSid());
                if (!Utils.isNull(srcGoods)) {
                    goodsSpecificationService.saveOrUpdate(goods.getSid(), goodsSpecificationStr);

                    Integer srcStatus = srcGoods.getStatus();
                    if (!Utils.isNull(reviewStatus)) {
                        srcGoods.setStatus(reviewStatus);
                        goodsService.save(srcGoods);
                        goodsLogService.writeGoodsLog(manager.getSid(), goods.getSid(), srcStatus, reviewStatus, manager.getCname() + ": 修改商品价格并提交审核");
                    } else {
                        goodsLogService.writeGoodsLog(manager.getSid(), goods.getSid(), srcStatus, srcStatus, manager.getCname() + ": 修改商品价格");
                    }
                    redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
                } else {
                    //没有找到goods
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
        } finally {
            redirectAttributes.addAttribute("searchBigCatecory", redirectBigCategory);
            redirectAttributes.addAttribute("searchSmallCatecory", redirectSmallCategory);
            redirectAttributes.addAttribute("q", redirectQ);
            redirectAttributes.addAttribute("status", redirectStatus);
            redirectAttributes.addAttribute("page", redirectPage);
            redirectAttributes.addAttribute("size", redirectSize);
        }


        return "redirect:/goods/goodsPrice/index";
    }

    /**
     * 保存商品供应商
     *
     * @param goods
     * @param allSuppliers
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/goodsSupplier/save")
    @RequiresPermissions("goods:managerSupplier")
    public String saveGoodsSupplier(Goods goods, Long[] allSuppliers, final RedirectAttributes redirectAttributes, Long redirectBigCategory, Long redirectSmallCategory, String redirectQ, int redirectPage, int redirectSize, Integer redirectStatus) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        try {

            if (goods.getSid() != null && goods.getSid() > 0) {

                Goods srcGoods = goodsService.findOne(goods.getSid());
                if (allSuppliers != null) {
                    if (allSuppliers.length > 0) {
                        List<Long> supplierSid = new ArrayList<>();
                        for (int i = 0; i < allSuppliers.length; i++) {
                            supplierSid.add(allSuppliers[i]);
                        }

                        List<Supplier> suppliers = supplierService.findBySids(supplierSid);
//                        srcGoods.setSupplierList(suppliers);
                        srcGoods.setSupplier(suppliers.get(0));
                    }
                } else {
//                    srcGoods.setSupplierList(null);
                    srcGoods.setSupplier(null);
                }
                Goods saveGoods = goodsService.save(srcGoods);
                goodsLogService.writeGoodsLog(manager.getSid(), saveGoods.getSid(), saveGoods.getStatus(), saveGoods.getStatus(), manager.getCname() + ": 修改商品供应商");
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
            redirectAttributes.addAttribute("status", redirectStatus);
            redirectAttributes.addAttribute("page", redirectPage);
            redirectAttributes.addAttribute("size", redirectSize);
        }

        return "redirect:/goods/goodsSupplier/index";
    }

    /**
     * 保存价格审核信息
     *
     * @param goods
     * @param reviewStatus
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/reviewPrice/save")
    @RequiresPermissions("goods:reviewPrice")
    public String saveReviewPrice(Goods goods, int reviewStatus, final RedirectAttributes redirectAttributes, Long redirectBigCategory, Long redirectSmallCategory, String redirectQ, int redirectPage, int redirectSize, String reason) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        try {
            if (goods.getSid() != null && goods.getSid() > 0) {

                Goods srcGoods = goodsService.findOne(goods.getSid());
                Integer srcStatus = srcGoods.getStatus();
                srcGoods.setStatus(reviewStatus);

                Goods saveGoods = goodsService.save(srcGoods);
                if (reviewStatus == 6) {
                    goodsLogService.writeGoodsLog(manager.getSid(), saveGoods.getSid(), srcStatus, saveGoods.getStatus(), manager.getCname() + " 价格信息审核未通过，原因：" + reason);
                } else if (reviewStatus == 7) {
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
            redirectAttributes.addAttribute("status", 5);
            redirectAttributes.addAttribute("page", redirectPage);
            redirectAttributes.addAttribute("size", redirectSize);
        }

        return "redirect:/goods/reviewPrice/index";
    }

    /**
     * 商品上下架
     *
     * @param goods
     * @param reviewStatus
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/publishGoods/save")
    @RequiresPermissions("goods:reviewPrice")
    public String savePublishGoods(Goods goods, int reviewStatus, final RedirectAttributes redirectAttributes, Long redirectBigCategory, Long redirectSmallCategory, String redirectQ, int redirectPage, int redirectSize, Integer redirectStatus) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        try {
            if (goods.getSid() != null && goods.getSid() > 0) {

                Goods srcGoods = goodsService.findOne(goods.getSid());
                Integer srcStatus = srcGoods.getStatus();
                srcGoods.setStatus(reviewStatus);

                Goods saveGoods = goodsService.save(srcGoods);
                String note = "";
                if (reviewStatus == 0) {
                    note = manager.getCname() + ": 下架商品";
                } else if (reviewStatus == 1) {
                    note = manager.getCname() + ": 上架商品";
                }
                goodsLogService.writeGoodsLog(manager.getSid(), saveGoods.getSid(), srcStatus, saveGoods.getStatus(), note);
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
            redirectAttributes.addAttribute("status", redirectStatus);
            redirectAttributes.addAttribute("page", redirectPage);
            redirectAttributes.addAttribute("size", redirectSize);
        }

        return "redirect:/goods/publishGoods/index";
    }


    @RequiresPermissions("goods:managerCategory")
    @RequestMapping("/goodsCategory/index")
    public String goodsCategoryIndex(@RequestParam(required = false) String q, @RequestParam(required = true, defaultValue = "1") int status, @RequestParam(required = false) String startDate, @RequestParam(required = false) String endDate, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int pageSize, Model model) {

        return "/goods/goodsCategory/index";
    }

    /**
     * 提交审核
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
            Goods srcGoods = goodsService.findOne(sid);
            Integer srcStatus = srcGoods.getStatus();
            srcGoods.setStatus(status);
            Goods saveGoods = goodsService.save(srcGoods);
            String note = "";
            if (status == 2) {
                note = manager.getCname() + ": 提交商品基本信息审核";
            } else if (status == 5) {
                note = manager.getCname() + ": 提交商品价格信息审核";
            } else if (status == 3) {
                note = manager.getCname() + ": 基本信息审核未通过 原因：" + reason;
            } else if (status == 4) {
                note = manager.getCname() + ": 基本信息审核通过";
            } else if (status == 6) {
                note = manager.getCname() + " 价格信息审核未通过，原因：" + reason;
            } else if (status == 7) {
                note = manager.getCname() + ": 价格信息审核通过";
            }

            goodsLogService.writeGoodsLog(manager.getSid(), saveGoods.getSid(), srcStatus, saveGoods.getStatus(), note);
        } catch (Exception e) {
            AjaxResult.ajaxFailResult("", "提交审核申请失败");
        }
        return AjaxResult.ajaxSuccessResult("执行成功", "");
    }

    /**
     * 批量提交审核
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
                    note = manager.getCname() + ": 提交商品基本信息审核";
                } else if (status == 5) {
                    note = manager.getCname() + ": 提交商品价格信息审核";
                } else if (status == 3) {
                    note = manager.getCname() + ": 基本信息审核未通过 原因：" + reason;
                } else if (status == 4) {
                    note = manager.getCname() + ": 基本信息审核通过";
                } else if (status == 6) {
                    note = manager.getCname() + " 价格信息审核未通过，原因：" + reason;
                } else if (status == 7) {
                    note = manager.getCname() + ": 价格信息审核通过";
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

    /**
     * 查询商品类别
     *
     * @param sid
     * @return
     */
    @ResponseBody
    @RequestMapping("/showGoodsCategory")
    public AjaxResult showGoodsCategory(Long sid) {

        List<GoodsCategory> list = goodsCategoryService.findGoodsCategory(null, sid, null);


        return AjaxResult.ajaxSuccessResult("查询成功", list);
    }

    /**
     * 查找某个商品类别
     *
     * @param sid
     * @return
     */
    @ResponseBody
    @RequestMapping("/goodsCategory/detail")
    @RequiresPermissions("goods:managerCategory")
    public AjaxResult detailGoodsCategory(Long sid) {
        GoodsCategory goodsGategory = goodsCategoryService.findOne(sid);
        if (!Utils.isNull(goodsGategory)) {

            return AjaxResult.ajaxSuccessResult("操作成功", goodsGategory.toMapWithExclude(null));
        }

        return AjaxResult.ajaxFailResult("未找到指定商品类别", null);

    }

    /**
     * 查询类别名称是否重复
     *
     * @param cname
     * @return
     */
    @ResponseBody
    @RequestMapping("/goodsCategory/findCategoryByCname")
    @RequiresPermissions("goods:managerCategory")
    public AjaxResult findCategoryByCname(String cname, Long sid) {

        List<GoodsCategory> list = goodsCategoryService.findByCname(cname);
//        System.out.println("sid"+sid+"   "+list.size());
//        if (list.size()==1) {
//            if(!Utils.isNull(sid)){
//                if(sid!=list.get(0).getSid()){
//                    return AjaxResult.ajaxFailResult("", null);
//                }else{
//                    return AjaxResult.ajaxSuccessResult("名称不存在", null);
//                }
//            }else{
//                return AjaxResult.ajaxFailResult("", null);
//            }
//
//        }else if(list.size()>1){
//            return AjaxResult.ajaxFailResult("", null);
//        }else {
//
//            return AjaxResult.ajaxSuccessResult("名称不存在", null);
//
//        }
        if (list.size() == 1) {
            if (!Utils.isNull(sid)) {
                if (!sid.equals(list.get(0).getSid())) {

                    return AjaxResult.ajaxFailResult("", null);
                } else {

                    return AjaxResult.ajaxSuccessResult("名称不存在", null);
                }
            } else {

                return AjaxResult.ajaxFailResult("", null);
            }
        } else if (list.size() == 0) {

            return AjaxResult.ajaxSuccessResult("名称不存在", null);
        } else {

            return AjaxResult.ajaxFailResult("", null);
        }

    }


    /**
     * 商品类别保存
     *
     * @param goodsGategory
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/goodsCategory/save")
    @RequiresPermissions("goods:managerCategory")
    public String save(GoodsCategory goodsGategory, final RedirectAttributes redirectAttributes) {
        try {
            if (goodsGategory.getSid() != null && goodsGategory.getSid() > 0) {
                GoodsCategory srcGoodsCategory = goodsCategoryService.findOne(goodsGategory.getSid());
                srcGoodsCategory.setCname(goodsGategory.getCname());
                //大类和根节点不允许修改父节点
                if (srcGoodsCategory.getParentSid() != 1 && srcGoodsCategory.getParentSid() != -1) {

                    srcGoodsCategory.setParentSid(goodsGategory.getParentSid());
                }
                srcGoodsCategory.setNote(goodsGategory.getNote());
                srcGoodsCategory.setStatus(goodsGategory.getStatus());
                goodsCategoryService.save(srcGoodsCategory);
                WebAuthorizing.refreshSessionPermission();
            } else {
                goodsGategory.setSort(0);
                goodsCategoryService.save(goodsGategory);
            }

            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
        }

        return "redirect:/goods/goodsCategory/index";
    }

    @ResponseBody
    @RequestMapping("/getBigGoodsCategory")
    public AjaxResult getBigGoodsCategory(Long sid) {
        List<GoodsCategory> areaList = goodsCategoryService.findGoodsCategory(null, sid, 1);

        if (!Utils.isNull(areaList)) {
            return AjaxResult.ajaxSuccessResult("操作成功", areaList);
        }

        return AjaxResult.ajaxFailResult("未找到指定管理员", null);
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

    @ResponseBody
    @RequestMapping(value = "/uploadFile", produces = "application/json;charset=UTF-8")
    public String uploadFile(@RequestParam(value = "excelFile", required = false) MultipartFile excelFile) throws JSONException, IOException {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        JSONObject json = new JSONObject();
        if (excelFile != null && excelFile.getOriginalFilename() != null && excelFile.getOriginalFilename().length() > 0) {
            HashMap<String, Object> map = uploadGoodsExcelService.uploadExcelFile(excelFile, manager);
            json.put("flag", map.get("flag"));
            json.put("msg", map.get("msg"));
            if (map.containsKey("errorList")) {
                List<GoodsDto> list = (List<GoodsDto>) map.get("errorList");
                if (list.size() > 0) {
                    String fileName = manager.getUsername() + "_" + "result" + System.currentTimeMillis() + ".xlsx";
//                    String path=uploadPath+"/resultExcel/"+fileName;
                    String relativePath = "/attachment/resultExcel/" + fileName;
                    boolean flag = uploadGoodsExcelService.createExcelAndSaveFile(list, fileName);
                    System.out.println("返回结果" + flag);
                    if (flag) {
                        json.put("downloadUrl", relativePath);
                    }

                }

            }

            return json.toString();
        } else {
            json.put("flag", false);
            json.put("msg", "上传失败，文件为空");

            return json.toString();
        }
    }
}

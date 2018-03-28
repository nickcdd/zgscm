package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.admin.shiro.realm.WebAuthorizing;
import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.dto.GoodsDto;
import com.cqzg168.scm.service.*;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

/**
 * Created by Administrator on 2017/8/3 0003.
 */
@Controller
@RequestMapping("/selfSupportGoods")
public class SelfSupportGoodsController extends  BaseController {
    @Autowired
    GoodsService              goodsService;
    @Autowired
    GoodsCategoryService      goodsCategoryService;
    @Autowired
    GoodsFileService          goodsFileService;
    @Autowired
    GoodsLogService           goodsLogService;
    @Autowired
    GoodsSpecificationService goodsSpecificationService;
    @Autowired
    SupplierService supplierService;
    @Autowired
    UploadGoodsExcelService uploadGoodsExcelService;
    @RequiresPermissions("selfSupport:goodsManager")
    @RequestMapping("/goodsInfo/index")
    public String index(@RequestParam(required = false) String q, @RequestParam(required = false) String searchBigCatecory, @RequestParam(required = false) String searchSmallCatecory, @RequestParam(required = false) String price, @RequestParam(required = false) Integer status, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {

        List<Integer> defaultStatus = new ArrayList<>();
        defaultStatus.add(0);
//        defaultStatus.add(1);
//        defaultStatus.add(2);
//        defaultStatus.add(3);
        defaultStatus.add(4);
//        defaultStatus.add(5);
        Page<Goods>   goodsPage     = goodsService.findGoodsByPage(-1l,q, searchBigCatecory, searchSmallCatecory, price, null, defaultStatus, status, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "cname")));
        GoodsCategory bigCategory   = new GoodsCategory();
        GoodsCategory smallCategory = new GoodsCategory();
        if (goodsPage.getContent().size() == 0 && page != 0) {
            goodsPage = goodsService.findGoodsByPage(-1l,q, searchBigCatecory, searchSmallCatecory, price, null, defaultStatus, status, new PageRequest(page - 1, size, new Sort(Sort.Direction.ASC, "cname")));
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
        return "/selfSupportGoods/goodsInfo/index";
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
    @RequiresPermissions("selfSupport:goodsManager")
    @RequestMapping("/goodsInfo/save")
    public String save(String goodsSpecificationStr, Goods goods, Long bigCatecory, Long smallCatecory, MultipartFile myavatar, final RedirectAttributes redirectAttributes, Long redirectBigCategory, Long redirectSmallCategory, String redirectQ, int redirectPage, int redirectSize, Integer redirectStatus, Integer reviewStatus) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Manager manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        Supplier supplier=supplierService.findOne(-1l);
        try {

            if (goods.getSid() != null && goods.getSid() > 0) {
                Goods srcGoods = goodsService.findOne(goods.getSid());
                if (myavatar != null && myavatar.getOriginalFilename() != null && myavatar.getOriginalFilename().length() > 0) {
                    if (srcGoods.getGoodsFiles() != null) {
                        if (srcGoods.getGoodsFiles().size() == 0) {

                            String    imgUrl    = goodsFileService.uploadGoodsFile(myavatar);
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
                //                if (goods.getFreeGoods() == 1) {
                //                    //是平台商品，需要移除供应商
                //
                //                    //                    srcGoods.setSupplierList(null);
                //                    srcGoods.setSupplier(null);
                //                }

                //判断是否提交审核
                Integer srcStatus = null;
                if (!Utils.isNull(reviewStatus)) {
                    srcStatus = srcGoods.getStatus();
                    srcGoods.setStatus(reviewStatus);
                }
                goodsService.save(srcGoods);
                if(!Utils.isEmpty(goodsSpecificationStr)){
                    goodsSpecificationService.saveOrUpdate(goods.getSid(), goodsSpecificationStr);
                }
                //日志
                if (!Utils.isNull(reviewStatus)) {
                    if(reviewStatus==0){
                        goodsLogService.writeGoodsLog(manager.getSid(), goods.getSid(), srcStatus, reviewStatus, manager.getCname() + ": 修改并下架商品");
                    }else if(reviewStatus==1){
                        goodsLogService.writeGoodsLog(manager.getSid(), goods.getSid(), srcStatus, reviewStatus, manager.getCname() + ": 修改并上架商品");
                    }else if(reviewStatus==2){
                        goodsLogService.writeGoodsLog(manager.getSid(), goods.getSid(), srcStatus, reviewStatus, manager.getCname() + ": 修改并提交商品审核");
                    }
//                    goodsLogService.writeGoodsLog(supplier.getSid(), goods.getSid(), srcStatus, reviewStatus, supplier.getCname() + ": 提交新增商品信息审核");
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
                goods.setFreeGoods(1);
                goods.setSupplier(supplier);
                Goods saveGoods=null;
                if (myavatar != null && myavatar.getOriginalFilename() != null && myavatar.getOriginalFilename().length() > 0) {
                    String imgUrl = goodsFileService.uploadGoodsFile(myavatar);
                    GoodsFile goodsFile = new GoodsFile();
                    goodsFile.setUrl("/attachment/" + imgUrl);
                    goodsFile.setType(1);

                    saveGoods = goodsService.save(goods);

                    goodsFile.setGoodsSid(saveGoods.getSid());
                    goodsFileService.save(goodsFile);
                    goodsLogService.writeGoodsLog(manager.getSid(), saveGoods.getSid(), 0, 0, manager.getCname() + ": 新增商品基本信息（有添加图片）");
                } else {

                    saveGoods = goodsService.save(goods);
                    goodsLogService.writeGoodsLog(manager.getSid(), saveGoods.getSid(), 0, 0, manager.getCname() + ": 新增商品基本信息（没有添加图片）");
                }
                if(!Utils.isEmpty(goodsSpecificationStr)){
                    goodsSpecificationService.saveOrUpdate(saveGoods.getSid(), goodsSpecificationStr);
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

        return "redirect:/selfSupportGoods/goodsInfo/index";
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
    @RequiresPermissions("selfSupport:publishManager")
    @RequestMapping("/publishGoods/index")
    public String publishGoodsIndex(@RequestParam(required = false) String q, @RequestParam(required = false) String searchBigCatecory, @RequestParam(required = false) String searchSmallCatecory, @RequestParam(required = false) String price, @RequestParam(required = false) Integer status, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {
        List<Integer> defaultStatus = new ArrayList<>();
        defaultStatus.add(3);
        defaultStatus.add(1);

        Page<Goods> goodsPage = goodsService.findGoodsByPage(-1l,q, searchBigCatecory, searchSmallCatecory, price, null, defaultStatus, status, new PageRequest(page, size, new Sort(Sort.Direction.ASC, "cname")));

        GoodsCategory bigCategory = new GoodsCategory();
        GoodsCategory smallCategory = new GoodsCategory();
        if (goodsPage.getContent().size() == 0 && page != 0) {
            goodsPage = goodsService.findGoodsByPage(-1l,q, searchBigCatecory, searchSmallCatecory, price, null, defaultStatus, status, new PageRequest(page - 1, size, new Sort(Sort.Direction.ASC, "cname")));
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
        return "/selfSupportGoods/publishGoods/index";
    }
    /**
     * 商品上下架
     *
     * @param goods
     * @param reviewStatus
     * @param redirectAttributes
     * @return
     */
    @RequiresPermissions("selfSupport:publishManager")
    @RequestMapping("/publishGoods/save")
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

        return "redirect:/selfSupportGoods/publishGoods/index";
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
            Goods srcGoods = goodsService.findOne(sid);
            Integer srcStatus = srcGoods.getStatus();
            srcGoods.setStatus(status);
            Goods saveGoods = goodsService.save(srcGoods);
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

    @ResponseBody
    @RequestMapping(value = "/uploadFile", produces = "application/json;charset=UTF-8")
    public String uploadFile(@RequestParam(value = "excelFile", required = false) MultipartFile excelFile) throws JSONException, IOException {
        Session    session = (Session) SecurityUtils.getSubject().getSession();
        Manager    manager = (Manager) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        JSONObject json    = new JSONObject();
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

    /**
     * 校验商品编码是否重复
     * @param
     * @return
     * @throws JSONException
     * @throws IOException
     */
    @ResponseBody
    @RequestMapping(value = "/checkGoodsBm", produces = "application/json;charset=UTF-8")
    public String checkGoodsBm(Long specificationSid,String goodsBm) throws JSONException{

        JSONObject json    = new JSONObject();
        boolean flag=false;
        List<GoodsSpecification> list=goodsSpecificationService.findByGoodsBm(goodsBm);
        if(list.size()==0){
            flag=true;
        }else if(list.size()==1){
            if(list.get(0).getSid().equals(specificationSid)){
                flag=true;
            }else{
                flag=false;
            }
        }else{
            flag=false;
        }
        json.put("success",flag);
        return json.toString();

    }
}

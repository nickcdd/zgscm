package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.admin.shiro.realm.WebAuthorizing;
import com.cqzg168.scm.domain.*;

import com.cqzg168.scm.service.*;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
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


import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

/**
 * Created by Administrator on 2017/5/3 0003.
 */

@Controller
@RequestMapping("/shopKeeper")
public class ShopKeeperController extends BaseController {
    @Autowired
    private ShopKeeperService shopKeeperService;
    @Autowired
    private AreaService areaService;
    @Autowired
    private ResellerService resellerService;
    //上传图片路径
    @Value("${upload_path}")
    private String uploadPath;
    @Autowired
    UploadShopKeeperService uploadShopKeeperService;
    @Autowired
    CxfUtilsService cxfUtilsService;

    /**
     * 商户列表页
     *
     * @return
     */
    @RequiresPermissions("shopKeeper:index")
    @RequestMapping("/index")
    public String index(@RequestParam(required = false) String q, @RequestParam(required = false) String searchProvince, @RequestParam(required = false) String searchCity, @RequestParam(required = false) String searchArea, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {
        //导入
        //        uploadShopKeeperService.test();

        Area provice = new Area();
        Area city = new Area();
        Area area = new Area();
        if (!Utils.isEmpty(searchProvince)) {
            provice = areaService.findOne(Long.parseLong(searchProvince));

            if (!Utils.isNull(provice)) {
                model.addAttribute("searchProvince", provice.getSid() + "," + provice.getCname());
            } else {
                model.addAttribute("searchProvince", "");
            }

        } else {
            model.addAttribute("searchProvince", "");


        }
        if (!Utils.isEmpty(searchCity)) {
            city = areaService.findOne(Long.parseLong(searchCity));
            if (!Utils.isNull(city)) {
                model.addAttribute("searchCity", city.getSid() + "," + city.getCname());
            } else {
                model.addAttribute("searchCity", "");
            }
        } else {
            model.addAttribute("searchCity", "");
        }
        if (!Utils.isEmpty(searchArea)) {
            area = areaService.findOne(Long.parseLong(searchArea));
            if (!Utils.isNull(area)) {
                model.addAttribute("searchArea", area.getSid() + "," + area.getCname());
            } else {
                model.addAttribute("searchArea", "");
            }
        } else {
            model.addAttribute("searchArea", "");
        }

        Page<ShopKeeper> shopKeeperPage = shopKeeperService.findByPage(q, provice.getCname(), city.getCname(), area.getCname(), new PageRequest(page, size, new Sort(Sort.Direction.ASC, "cname")));

        model.addAttribute("shopKeepers", shopKeeperPage.getContent());
        model.addAttribute("pageInfo", new PageInfo(shopKeeperPage));
        if (Utils.isEmpty(q)) {
            model.addAttribute("q", "");
        } else {
            model.addAttribute("q", q);
        }


        return "/shopKeeper/index";
    }

    /**
     * 商户详情
     *
     * @param sid
     * @return
     */
    @ResponseBody
    @RequestMapping("/detail")
    @RequiresPermissions("shopKeeper:index")
    public AjaxResult detail(Long sid) {

        ShopKeeper shopKeeper = shopKeeperService.findOne(sid);


        if (!Utils.isNull(shopKeeper)) {
            Area provice = areaService.findProviceByCnameAndType(shopKeeper.getProvince(), 1);
            Area city = areaService.findAreaByParentIdAndTypeAndCname(provice.getSid(), shopKeeper.getCity(), 2);
            Area area = areaService.findAreaByParentIdAndTypeAndCname(city.getSid(), shopKeeper.getArea(), 3);
            shopKeeper.setProvince(provice.getSid() + "," + provice.getCname());
            shopKeeper.setCity(city.getSid() + "," + city.getCname());
            shopKeeper.setArea(area.getSid() + "," + area.getCname());
            return AjaxResult.ajaxSuccessResult("操作成功", shopKeeper.toMapWithExclude(new String[]{"password"}));
        }

        return AjaxResult.ajaxFailResult("未找到指定商户", null);
    }

    /**
     * 商户分销商信息
     *
     * @param
     * @return
     */
    @RequestMapping("/resellerInfo")
    @RequiresPermissions("shopKeeper:index")
    public String resellerInfo(Long shopKeeperSid, Model model, final RedirectAttributes redirectAttributes, Long resellerProvince, Long resellerCity, Long resellerArea, String resellerQ, Integer resellerPage, Integer resellerSize) {

        ShopKeeper shopKeeper = shopKeeperService.findOne(shopKeeperSid);
        if (!Utils.isNull(shopKeeper)) {
            if (!Utils.isNull(shopKeeper.getResellerSid())) {
                Reseller reseller = resellerService.findOne(shopKeeper.getResellerSid());
                if (!Utils.isNull(reseller)) {
                    model.addAttribute("resellerSid", reseller.getSid());
                } else {
                    model.addAttribute("resellerSid", -1);
                }
            } else {
                model.addAttribute("resellerSid", -1);
            }
            List<Reseller> resellerList = resellerService.findAllByStatus(1);
            model.addAttribute("resellerList", resellerList);
        } else {
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "没有找到该商户");
        }


        model.addAttribute("shopKeeperSid", shopKeeperSid);
        model.addAttribute("resellerProvince", resellerProvince);
        model.addAttribute("resellerCity", resellerCity);
        model.addAttribute("resellerArea", resellerArea);
        model.addAttribute("resellerQ", resellerQ);
        model.addAttribute("resellerPage", resellerPage);
        model.addAttribute("resellerSize", resellerSize);

        return "/shopKeeper/resellerInfo";
    }

    /**
     * 保存分销商
     *
     * @param
     * @return
     */

    @RequestMapping("/saveReseller")
    @RequiresPermissions("shopKeeper:editReseller")
    public String saveReseller(boolean flag, final RedirectAttributes redirectAttributes, Long shopKeeperSid, Long resellerSid, Long resellerProvince, Long resellerCity, Long resellerArea, String resellerQ, Integer resellerPage, Integer resellerSize) {
        if (flag) {
            ShopKeeper shopKeeper = shopKeeperService.findOne(shopKeeperSid);


            if (!Utils.isNull(shopKeeper)) {
                if (resellerSid == -1) {
                    shopKeeper.setResellerSid(null);
                } else {
                    shopKeeper.setResellerSid(resellerSid);
                }
                shopKeeperService.save(shopKeeper);
                redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
            } else {
                redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "分销商保存失败");
            }
        }
        redirectAttributes.addAttribute("searchProvince", resellerProvince);
        redirectAttributes.addAttribute("searchCity", resellerCity);
        redirectAttributes.addAttribute("searchArea", resellerArea);
        redirectAttributes.addAttribute("q", resellerQ);
        redirectAttributes.addAttribute("page", resellerPage);
        redirectAttributes.addAttribute("size", resellerSize);

        return "redirect:/shopKeeper/index";
    }

    /**
     * 保存商户信息
     *
     * @param shopKeeper
     * @return
     */
    @RequestMapping("/save")
    @RequiresPermissions("shopKeeper:save")
    public String save(ShopKeeper shopKeeper, final RedirectAttributes redirectAttributes, MultipartFile myavatar, Long redirectProvince, Long redirectCity, Long redirectArea, String redirectQ, int redirectPage, int redirectSize) {


        try {
            if (shopKeeper.getSid() != null && shopKeeper.getSid() > 0) {
                ShopKeeper srcShopKeeper = shopKeeperService.findOne(shopKeeper.getSid());
                if (myavatar != null && myavatar.getOriginalFilename() != null && myavatar.getOriginalFilename().length() > 0) {
                    String avatarUrl = shopKeeperService.uploadAvatar(myavatar);
                    if (Utils.isEmpty(srcShopKeeper.getAvatar())) {
                        srcShopKeeper.setAvatar("/attachment/" + avatarUrl);
                    } else {
                        String[] urlArray = srcShopKeeper.getAvatar().split("/");
                        if (shopKeeperService.deleteAvatar(urlArray[urlArray.length - 1])) {
                            srcShopKeeper.setAvatar("/attachment/" + avatarUrl);
                        }
                    }

                }
                //                srcShopKeeper.setLevel(shopKeeper.getLevel());
                srcShopKeeper.setCname(shopKeeper.getCname());
                srcShopKeeper.setAddress(shopKeeper.getAddress());
                srcShopKeeper.setTelephone(shopKeeper.getTelephone());
                srcShopKeeper.setNote(shopKeeper.getNote());
                srcShopKeeper.setProvince(areaService.findOne(Long.parseLong(shopKeeper.getProvince())).getCname());
                srcShopKeeper.setCity(areaService.findOne(Long.parseLong(shopKeeper.getCity())).getCname());
                srcShopKeeper.setArea(areaService.findOne(Long.parseLong(shopKeeper.getArea())).getCname());
                shopKeeperService.save(srcShopKeeper);
                WebAuthorizing.refreshSessionPermission();
                redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
            } else {


                if (Utils.isEmpty(shopKeeper.getPassword())) {
                    redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "密码不能为空");

                } else {
                    //上传图片
                    if (myavatar != null && myavatar.getOriginalFilename() != null && myavatar.getOriginalFilename().length() > 0) {
                        String avatarUrl = shopKeeperService.uploadAvatar(myavatar);
                        shopKeeper.setAvatar("/attachment/" + avatarUrl);
                    }
                    shopKeeper.setPassword(Utils.getMD5String(shopKeeper.getPassword()));
                    shopKeeper.setProvince(areaService.findOne(Long.parseLong(shopKeeper.getProvince())).getCname());
                    shopKeeper.setCity(areaService.findOne(Long.parseLong(shopKeeper.getCity())).getCname());
                    shopKeeper.setArea(areaService.findOne(Long.parseLong(shopKeeper.getArea())).getCname());
                    shopKeeper.setBalance(new BigDecimal("0"));
                    shopKeeper.setCredit(new BigDecimal("0"));
                    shopKeeper.setFrozenBalance(new BigDecimal("0"));
                    shopKeeper.setLevel(0);
                    shopKeeperService.save(shopKeeper);


                    redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
        } finally {
            redirectAttributes.addAttribute("searchProvince", redirectProvince);
            redirectAttributes.addAttribute("searchCity", redirectCity);
            redirectAttributes.addAttribute("searchArea", redirectArea);
            redirectAttributes.addAttribute("q", redirectQ);
            redirectAttributes.addAttribute("page", redirectPage);
            redirectAttributes.addAttribute("size", redirectSize);
        }

        return "redirect:/shopKeeper/index";


    }

    //    /**
    //     * 启用商户
    //     *
    //     * @param sid
    //     * @param redirectAttributes
    //     * @return
    //     */
    //    @RequestMapping("/enable")
    //    @RequiresPermissions("shopKeeper:save")
    //    public String enable(Long sid, final RedirectAttributes redirectAttributes) {
    //        try {
    //            shopKeeperService.enable(sid);
    //            WebAuthorizing.refreshSessionPermission();
    //            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
    //        } catch (Exception e) {
    //            e.printStackTrace();
    //            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
    //        }
    //
    //        return "redirect:/shopKeeper/index";
    //    }
    //
    //    /**
    //     * 禁用商户
    //     *
    //     * @param sid
    //     * @param redirectAttributes
    //     * @return
    //     */
    //    @RequestMapping("/disable")
    //    @RequiresPermissions("shopKeeper:save")
    //    public String disable(Long sid, final RedirectAttributes redirectAttributes) {
    //        try {
    //            shopKeeperService.disable(sid);
    //            WebAuthorizing.refreshSessionPermission();
    //            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
    //        } catch (Exception e) {
    //            e.printStackTrace();
    //            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
    //        }
    //
    //        return "redirect:/shopKeeper/index";
    //    }

    /**
     * 启用商户
     *
     * @param sid
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/enable")
    @RequiresPermissions("shopKeeper:save")
    public AjaxResult enable(Long sid) {
        try {
            shopKeeperService.enable(sid);
            WebAuthorizing.refreshSessionPermission();
            return AjaxResult.ajaxSuccessResult("启用商户成功", null);
        } catch (Exception e) {
            e.printStackTrace();
            return AjaxResult.ajaxFailResult("启用商户失败", null);
        }


    }

    /**
     * 禁用商户
     *
     * @param sid
     * @param redirectAttributes
     * @return
     */
    @ResponseBody
    @RequestMapping("/disable")
    @RequiresPermissions("shopKeeper:save")
    public AjaxResult disable(Long sid, final RedirectAttributes redirectAttributes) {
        try {
            shopKeeperService.disable(sid);
            WebAuthorizing.refreshSessionPermission();
            return AjaxResult.ajaxSuccessResult("禁用商户成功", null);
        } catch (Exception e) {
            e.printStackTrace();
            return AjaxResult.ajaxFailResult("禁用商户失败", null);
        }


    }

    /**
     * 删除分销商
     *
     * @param sid
     * @param redirectAttributes
     * @return
     */
    @ResponseBody
    @RequestMapping("/remove")
    @RequiresPermissions("shopKeeper:remove")
    public AjaxResult remove(Long sid, final RedirectAttributes redirectAttributes) {
        try {
            shopKeeperService.remove(sid);
            WebAuthorizing.refreshSessionPermission();
            return AjaxResult.ajaxSuccessResult("删除商户成功", null);
        } catch (Exception e) {
            e.printStackTrace();
            return AjaxResult.ajaxFailResult("删除商户失败", null);
        }


    }

    /**
     * 验证手机号是否重复
     *
     * @param telephone
     * @param redirectAttributes
     * @return
     */
    @ResponseBody
    @RequestMapping("/checkTelephone")
    public AjaxResult checkTelephone(String telephone, Long sid, final RedirectAttributes redirectAttributes) {

        if (shopKeeperService.findByTelephone(telephone, sid)) {
            return AjaxResult.ajaxSuccessResult("验证通过", null);
        } else {
            return AjaxResult.ajaxFailResult("验证失败", null);
        }

    }

    /**
     * 查询分销商
     *
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/findResellsers")
    public AjaxResult findResellsers(String q) {

        System.out.println(">>>>>>>>>>>>>" + q);

        return AjaxResult.ajaxFailResult("未找到指定商户", null);
    }
}

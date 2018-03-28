package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.admin.shiro.realm.WebAuthorizing;
import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.domain.Area;
import com.cqzg168.scm.domain.PageInfo;
import com.cqzg168.scm.domain.Supplier;
import com.cqzg168.scm.service.*;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.RSAUtils;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.dom4j.DocumentException;
import org.json.JSONArray;
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

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Created by think on 2017/4/27.
 */
@Controller
@RequestMapping("/supplier")
public class SupplierController extends BaseController {

    @Autowired
    private SupplierService supplierService;
    @Autowired
    private AreaService areaService;
    @Autowired
    SupplierLicenceService supplierLicenceService;
    @Autowired
    CxfUtilsService cxfUtilsService;
    //上传图片路径
    @Value("${upload_path}")
    private String uploadPath;


    /**
     * 供应商列表页
     *
     * @return
     */
    @RequiresPermissions("supplier:index")
    @RequestMapping("/index")
    public String index(@RequestParam(required = false) String q, @RequestParam(required = false) String searchProvince, @RequestParam(required = false) String searchCity, @RequestParam(required = false) String searchArea, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = Constant.DEFAULT_PAGE_SIZE) int size, Model model) {

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

        Page<Supplier> supplierPage = supplierService.findByPage(q, provice.getCname(), city.getCname(), area.getCname(), new PageRequest(page, size, new Sort(Sort.Direction.ASC, "cname")));

        model.addAttribute("suppliers", supplierPage.getContent());
        model.addAttribute("pageInfo", new PageInfo(supplierPage));
        if (Utils.isEmpty(q)) {
            model.addAttribute("q", "");
        } else {
            model.addAttribute("q", q);
        }

        return "/supplier/index";
    }

    /**
     * 供应商详情
     *
     * @param sid
     * @return
     */
    @ResponseBody
    @RequestMapping("/detail")
    @RequiresPermissions("supplier:index")
    public AjaxResult detail(Long sid) {

        Supplier supplier = supplierService.findOne(sid);


        if (!Utils.isNull(supplier)) {
            Area provice = areaService.findProviceByCnameAndType(supplier.getProvince(), 1);
            Area city = areaService.findAreaByParentIdAndTypeAndCname(provice.getSid(), supplier.getCity(), 2);
            Area area = areaService.findAreaByParentIdAndTypeAndCname(city.getSid(), supplier.getArea(), 3);
            supplier.setProvince(provice.getSid() + "," + provice.getCname());
            supplier.setCity(city.getSid() + "," + city.getCname());
            supplier.setArea(area.getSid() + "," + area.getCname());
            return AjaxResult.ajaxSuccessResult("操作成功", supplier.toMapWithExclude(new String[]{"password"}));
        }

        return AjaxResult.ajaxFailResult("未找到指定管理员", null);
    }

    /**
     * 保存供应商信息
     *
     * @param supplier
     * @return
     */
    @RequestMapping("/save")
    @RequiresPermissions("supplier:save")
    public String save(Supplier supplier, final RedirectAttributes redirectAttributes, MultipartFile myavatar, Long redirectProvince, Long redirectCity, Long redirectArea, String redirectQ, int redirectPage, int redirectSize, String updateLicenceStr, MultipartFile[] updateLicences, String addLicenceStr, MultipartFile[] addLicences) {


        try {
            //修改
            if (supplier.getSid() != null && supplier.getSid() > 0) {


                Supplier srcSupplier = supplierService.findOne(supplier.getSid());
                if (!Utils.isNull(srcSupplier)) {
                    //修改供应商证件照
                    if (!Utils.isEmpty(updateLicenceStr) && !Utils.isEmpty(updateLicences)) {
                        supplierLicenceService.updateUrls(srcSupplier.getSid(), updateLicenceStr, updateLicences);
                    }
                    //新增供应商证照
                    if (!Utils.isEmpty(addLicenceStr) && !Utils.isEmpty(addLicences)) {
                        supplierLicenceService.saveUrls(srcSupplier.getSid(), addLicenceStr, addLicences);
                    }
                    if (myavatar != null && myavatar.getOriginalFilename() != null && myavatar.getOriginalFilename().length() > 0) {
                        String avatarUrl = supplierService.uploadAvatar(myavatar);
                        if (Utils.isEmpty(srcSupplier.getAvatar())) {
                            srcSupplier.setAvatar("/attachment/" + avatarUrl);
                        } else {
                            String[] urlArray = srcSupplier.getAvatar().split("/");
                            if (supplierService.deleteAvatar(urlArray[urlArray.length - 1])) {
                                srcSupplier.setAvatar("/attachment/" + avatarUrl);
                            }
                        }
                    }
                    srcSupplier.setCname(supplier.getCname());
                    srcSupplier.setContact(supplier.getContact());
                    srcSupplier.setTelephone(supplier.getTelephone());
                    srcSupplier.setApi(supplier.getApi());
                    srcSupplier.setNote(supplier.getNote());
                    srcSupplier.setProvince(areaService.findOne(Long.parseLong(supplier.getProvince())).getCname());
                    srcSupplier.setCity(areaService.findOne(Long.parseLong(supplier.getCity())).getCname());
                    srcSupplier.setArea(areaService.findOne(Long.parseLong(supplier.getArea())).getCname());
                    srcSupplier.setAddress(supplier.getAddress());
                    supplierService.save(srcSupplier);
                    WebAuthorizing.refreshSessionPermission();
                    redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
                } else {
                    redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "供应商sid不存在" + supplier.getSid());

                }
            } else {
                if (Utils.isEmpty(supplier.getPassword())) {
                    redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "密码不能为空");

                } else {
                    //上传图片
                    if (myavatar != null && myavatar.getOriginalFilename() != null && myavatar.getOriginalFilename().length() > 0) {


                        String avatarUrl = supplierService.uploadAvatar(myavatar);
                        supplier.setAvatar("/attachment/" + avatarUrl);
                    }
                    supplier.setPassword(Utils.getMD5String(supplier.getPassword()));
                    supplier.setProvince(areaService.findOne(Long.parseLong(supplier.getProvince())).getCname());
                    supplier.setCity(areaService.findOne(Long.parseLong(supplier.getCity())).getCname());
                    supplier.setArea(areaService.findOne(Long.parseLong(supplier.getArea())).getCname());
                    Supplier srcSupplier = supplierService.save(supplier);
                    //添加证商户证照
                    if (!Utils.isEmpty(addLicenceStr) && !Utils.isEmpty(addLicences)) {

                        supplierLicenceService.saveUrls(srcSupplier.getSid(), addLicenceStr, addLicences);
                    }

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

        return "redirect:/supplier/index";


    }

    @ResponseBody
    @RequestMapping("/getArea")
    public AjaxResult getArea(Long parentSid) {
        List<Area> areaList = areaService.findByParentSid(parentSid);

        if (!Utils.isNull(areaList)) {
            return AjaxResult.ajaxSuccessResult("操作成功", areaList);
        }

        return AjaxResult.ajaxFailResult("未找到指定数据", null);
    }


    @ResponseBody
    @RequestMapping("/getAllSuppliers")
    public AjaxResult getAllSuppliers() {
//        List<Supplier> areaList = supplierService.findAllSupplier();
        List<Supplier> suppliersList = supplierService.findAllByStatus(1);

        if (!Utils.isNull(suppliersList)) {
            return AjaxResult.ajaxSuccessResult("操作成功", suppliersList);
        }

        return AjaxResult.ajaxFailResult("未找到指定管理员", null);
    }

    /**
     * 启用供应商
     *
     * @param sid
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/enable")
    @RequiresPermissions("supplier:save")
    public AjaxResult enable(Long sid) {
        try {
            supplierService.enable(sid);
            WebAuthorizing.refreshSessionPermission();
            return AjaxResult.ajaxSuccessResult("启用商户成功", null);
        } catch (Exception e) {
            e.printStackTrace();
            return AjaxResult.ajaxFailResult("启用商户失败", null);
        }


    }

    /**
     * 禁用供应商
     *
     * @param sid
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/disable")
    @RequiresPermissions("supplier:save")
    public AjaxResult disable(Long sid) {
        try {
            supplierService.disable(sid);
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
    @RequiresPermissions("supplier:remove")
    public AjaxResult remove(Long sid, final RedirectAttributes redirectAttributes) {
        try {
            supplierService.remove(sid);
            WebAuthorizing.refreshSessionPermission();
            return AjaxResult.ajaxSuccessResult("删除分销商成功", null);
        } catch (Exception e) {
            e.printStackTrace();
            return AjaxResult.ajaxFailResult("删除分销商失败", null);
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

        if (supplierService.findByTelephone(telephone, sid)) {
            return AjaxResult.ajaxSuccessResult("验证通过", null);
        } else {
            return AjaxResult.ajaxFailResult("验证失败", null);
        }

    }
}

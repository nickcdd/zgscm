package com.cqzg168.scm.supplier.controller;

import com.cqzg168.scm.annotation.AvoidDuplicateSubmit;
import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.domain.Area;
import com.cqzg168.scm.domain.Manager;
import com.cqzg168.scm.domain.Supplier;
import com.cqzg168.scm.service.AreaService;
import com.cqzg168.scm.service.ManagerService;
import com.cqzg168.scm.service.SupplierLicenceService;
import com.cqzg168.scm.service.SupplierService;
import com.cqzg168.scm.supplier.shiro.realm.WebAuthorizing;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/**
 * Created by Administrator on 2017/6/2 0002.
 */
@Controller
@RequestMapping("/personInfo")
public class PersonInfoController extends BaseController {

    @Autowired
    SupplierService supplierService;
    @Autowired
    AreaService areaService;
    @Autowired
    SupplierLicenceService supplierLicenceService;

    /**
     * 跳转修改供应商个人信息页面
     *
     * @return
     */
    @AvoidDuplicateSubmit(needSaveToken = true)
    @RequestMapping(value = "/baseInfo")
    public String baseInfo(Model model) {
//        Session session    = (Session) SecurityUtils.getSubject().getSession();
//        Supplier supplier = (Supplier) session.getAttribute(Constant.SessionKey.CURRENT_USER);
//        model.addAttribute("supplier", supplierService.findOne(supplier.getSid()));
        return "/personInfo/baseInfo";
    }

    /**
     * 供应商详情
     *
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/detail")
    public AjaxResult detail() {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Supplier sessionSupplier = (Supplier) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        Supplier supplier = supplierService.findOne(sessionSupplier.getSid());


        if (!Utils.isNull(supplier)) {
            Area provice = areaService.findProviceByCnameAndType(supplier.getProvince(), 1);
            Area city = areaService.findAreaByParentIdAndTypeAndCname(provice.getSid(), supplier.getCity(), 2);
            Area area = areaService.findAreaByParentIdAndTypeAndCname(city.getSid(), supplier.getArea(), 3);
            supplier.setProvince(provice.getSid() + "," + provice.getCname());
            supplier.setCity(city.getSid() + "," + city.getCname());
            supplier.setArea(area.getSid() + "," + area.getCname());
            return AjaxResult.ajaxSuccessResult("操作成功", supplier.toMapWithExclude(new String[]{"password"}));
        }

        return AjaxResult.ajaxFailResult("未找到指定数据", null);
    }

    /**
     * 保存供应商信息
     *
     * @param supplier
     * @return
     */
    @RequestMapping("/save")
    public String save(Supplier supplier, final RedirectAttributes redirectAttributes, MultipartFile myavatar, String updateLicenceStr, MultipartFile[] updateLicences, String addLicenceStr, MultipartFile[] addLicences) {
//        System.out.println(">>>>>>>>>>>>>>>>>>>>>"+updateLicenceStr+">>>>>>>>>>>>>>"+updateLicences.length);
        Session session = (Session) SecurityUtils.getSubject().getSession();
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
                    srcSupplier.setNote(supplier.getNote());
                    srcSupplier.setProvince(areaService.findOne(Long.parseLong(supplier.getProvince())).getCname());
                    srcSupplier.setCity(areaService.findOne(Long.parseLong(supplier.getCity())).getCname());
                    srcSupplier.setArea(areaService.findOne(Long.parseLong(supplier.getArea())).getCname());
                    srcSupplier.setAddress(supplier.getAddress());
                    supplierService.save(srcSupplier);
                    session.setAttribute(Constant.SessionKey.CURRENT_USER, srcSupplier);
                    WebAuthorizing.refreshSessionPermission();
                    redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.save.success");
                } else {
                    redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "供应商sid不存在" + supplier.getSid());

                }
            } else {
                redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "供应商sid为空");
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.save.fail");
        }

        return "redirect:/index";


    }

    /**
     * 跳转修改密码页面
     */
    @RequestMapping(value = "/password")
    public String password() {
        return "/personInfo/password";
    }


    /**
     * 验证密码是否正确
     *
     * @param
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping("/checkPassword")
    public AjaxResult checkPassword(String oldPassword) {
        Session session = (Session) SecurityUtils.getSubject().getSession();
        Supplier supplier = (Supplier) session.getAttribute(Constant.SessionKey.CURRENT_USER);

        oldPassword = Utils.getMD5String(oldPassword);
        if (supplier.getPassword().equals(oldPassword)) {
            return AjaxResult.ajaxSuccessResult("验证通过", null);
        } else {
            return AjaxResult.ajaxFailResult("验证失败", null);
        }
//        if(supplierService.findByTelephone(telephone,sid)){
//            return AjaxResult.ajaxSuccessResult("验证通过", null);
//        }else{
//            return AjaxResult.ajaxFailResult("验证失败", null);
//        }

    }

    /**
     * 修改密码
     */
    @RequestMapping(value = "/updatePassword")
    public String updatePassword(String oldPassword, String newPassword1, final RedirectAttributes redirectAttributes) {
        Session session = SecurityUtils.getSubject().getSession();
        Supplier supplier = (Supplier) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        oldPassword = Utils.getMD5String(oldPassword);
        if (!supplier.getPassword().equals(oldPassword)) {
            redirectAttributes.addFlashAttribute("ERROR_MESSAGE", "error.update.password.different");
            return "redirect:/password";
        } else {
            supplier.setPassword(Utils.getMD5String(newPassword1));
            supplierService.save(supplier);
            redirectAttributes.addFlashAttribute("INFO_MESSAGE", "info.update.password.success");
        }
        return "redirect:/logout";
    }

    @ResponseBody
    @RequestMapping("/getArea")
    public AjaxResult getArea(Long parentSid) {
        List<Area> areaList = areaService.findByParentSid(parentSid);

        if (!Utils.isNull(areaList)) {
            return AjaxResult.ajaxSuccessResult("操作成功", areaList);
        }

        return AjaxResult.ajaxFailResult("未找到指定管理员", null);
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

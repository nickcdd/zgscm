package com.cqzg168.scm.shopkeeper.controller;

import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.domain.Area;
import com.cqzg168.scm.domain.PageInfo;
import com.cqzg168.scm.domain.Supplier;
import com.cqzg168.scm.service.AreaService;
import com.cqzg168.scm.service.SupplierService;
import com.cqzg168.scm.utils.Utils;
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
 * Created by admin on 2017/8/3.
 */
@Controller
@RequestMapping("/supplier")
public class SupplierController extends BaseController {
    @Autowired
    private SupplierService supplierService;
    @Autowired
    private AreaService     areaService;
    /**
     * 供应商列表
     * @param model
     * @param province
     * @param city
     * @param area
     * @param cname
     * @param page
     * @param size
     * @return
     */
    @RequestMapping("/index")
    public String indexSupplier(Model model, String province, String city, String area, String cname, @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "10") int size) {
        PageRequest    pageable  = new PageRequest(page, size, new Sort(Sort.Direction.DESC, "createTime"));
        Page<Supplier> suppliers = supplierService.findByPage(cname, province, city, area, pageable);
        model.addAttribute("pageInfo", new PageInfo(suppliers));
        model.addAttribute("suppliers", suppliers.getContent());
        if (!Utils.isEmpty(province)) {
            model.addAttribute("province", province);
        } else {
            model.addAttribute("province", "");
        }
        if (!Utils.isEmpty(city)) {
            model.addAttribute("city", city);
        } else {
            model.addAttribute("city", "");
        }
        if (!Utils.isEmpty(area)) {
            model.addAttribute("area", area);
        } else {
            model.addAttribute("area", "");
        }
        if (!Utils.isEmpty(cname)) {
            model.addAttribute("cname", cname);
        } else {
            model.addAttribute("cname", "");
        }
        return "supplier/index";
    }

    /**
     * 查询供应商地区
     * @param parentSid
     * @return
     */
    @RequestMapping("/findAreaByPraentSid")
    @ResponseBody
    public AjaxResult findAreaByPraentSid(Long parentSid) {
        List<Area> areas = areaService.findByParentSid(parentSid);
        return AjaxResult.ajaxSuccessResult("", areas);
    }
}

package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.domain.AjaxResult;
import com.cqzg168.scm.domain.Area;
import com.cqzg168.scm.domain.PageInfo;
import com.cqzg168.scm.domain.Storage;
import com.cqzg168.scm.service.AreaService;
import com.cqzg168.scm.service.StorageService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
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
 * Created by admin on 2017/7/27.
 */
@Controller
@RequestMapping("/storage")
public class StorageController extends BaseController {
    @Autowired
    private StorageService storageService;
    @Autowired
    private AreaService    areaService;

    /**
     * 仓储列表页
     *
     * @return
     */
    @RequiresPermissions("storage:index")
    @RequestMapping("/index")
    public String index(String cname, String code, @RequestParam(required = false) String searchProvince, @RequestParam(required = false) String searchCity, @RequestParam(required = false) String searchArea, @RequestParam(defaultValue = "10") int size, @RequestParam(defaultValue = "0") int page, Model model) {
        PageRequest   pagable     = new PageRequest(page, size, new Sort(Sort.Direction.DESC, "createTime"));
        Page<Storage> storagePage = storageService.findStoragePage(cname, code, searchProvince, searchCity, searchArea, pagable);
        model.addAttribute("pageInfo", new PageInfo(storagePage));
        model.addAttribute("storagePage", storagePage.getContent());
        if (!Utils.isEmpty(searchProvince)) {
                model.addAttribute("searchProvince",searchProvince);
        }else {
            model.addAttribute("searchProvince","");
        }
        if (!Utils.isEmpty(searchCity)) {
                model.addAttribute("searchCity",searchCity);
        }else {
            model.addAttribute("searchCity","");
        }
        if (!Utils.isEmpty(searchArea)) {
                model.addAttribute("searchArea",searchArea);
        }else {
            model.addAttribute("searchArea","");
        }
        if(!Utils.isEmpty(cname)){
            model.addAttribute("cname",cname);
        }else {
            model.addAttribute("cname","");
        }
        if(!Utils.isEmpty(code)){
            model.addAttribute("code",code);
        }else {
            model.addAttribute("code","");
        }
        return "/storage/index";
    }

    /**
     * 仓储详情
     * @param sid
     * @return
     */
    @RequiresPermissions("storage:save")
    @RequestMapping("/detail")
    public String detail(Long sid, Model model){
        Storage storage = storageService.findOne(sid);
        model.addAttribute("storage",storage);
        return "/storage/detail";
    }
    /**
     * 保存仓储
     * @return
     */
    @RequiresPermissions("storage:save")
    @RequestMapping("/save")
    public String save(Storage storage){
        storageService.save(storage);
        return "redirect:/storage/index";
    }
    /**
     * 删除仓储
     * @return
     */
    @RequiresPermissions("storage:remove")
    @RequestMapping("/remove")
    public String remove(Long sid){
        storageService.remove(sid);
        return "redirect:/storage/index";
    }
    /**
     * 添加仓储
     * @return
     */
    @RequiresPermissions("storage:save")
    @RequestMapping("/add")
    public String add(){
        return "/storage/add";
    }

    @RequestMapping("/findAreaByPraentSid")
    @ResponseBody
    public AjaxResult findAreaByPraentSid(Long parentSid){
        List<Area> areas = areaService.findByParentSid(parentSid);
        return AjaxResult.ajaxSuccessResult("",areas);
    }
}

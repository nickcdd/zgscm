package com.cqzg168.scm.shopkeeper.controller;

import com.cqzg168.scm.domain.ReceivingAddress;
import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.service.ReceivingAddressService;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

import static com.cqzg168.scm.shopkeeper.util.ClassUtils.combineSydwCore;

/**
 * Created by admin on 2017/5/3.
 */
@RequestMapping("/receivingAddress")
@Controller
public class ReceivingAddressController extends BaseController {

    @Autowired
    private ReceivingAddressService receivingAddressService;

    /**
     * 进入收货地址管理
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/index")
    public String index(Device device, Model model) {
        Session                session            = SecurityUtils.getSubject().getSession();
        ShopKeeper             shopKeeper         = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        List<ReceivingAddress> receivingAddresses = receivingAddressService.findbyShopkeperAddressAll(shopKeeper.getSid());
        model.addAttribute("receivingAddresses", receivingAddresses);
        if (device.isNormal()) {
            return "/receivingAddress/index";
        } else {
            return "/receivingAddress/index_mobile";
        }
    }

    /**
     * 进入新增收货地址
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/add")
    public String add(Device device, Model model) {
        if (device.isNormal()) {
            return "/receivingAddress/add";
        } else {
            return "/receivingAddress/add_mobile";
        }
    }

    /**
     * 保存收货地址
     *
     * @param receivingAddress
     * @return
     */
    @RequestMapping(value = "/save")
    public String save(ReceivingAddress receivingAddress) {
        Session                session              = SecurityUtils.getSubject().getSession();
        ShopKeeper             shopKeeper           = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        List<ReceivingAddress> receivingAddressAlls = receivingAddressService.findbyShopkeperAddressAll(shopKeeper.getSid());
        receivingAddress.setShopKeeperSid(shopKeeper.getSid());
        if (receivingAddressAlls != null && receivingAddressAlls.size() > 0) {
            //当新增地址选择默认地址后  移除已有默认地址
            if (!Utils.isNull(receivingAddress.getIsDefault())) {
                List<ReceivingAddress> receivingAddresses = receivingAddressService.findIsDefaultAddress(1);
                if (!Utils.isNull(receivingAddresses) && receivingAddresses.size() > 0) {
                    ReceivingAddress receivingAddressTemp = receivingAddresses.get(0);
                    receivingAddressTemp.setIsDefault(0);
                    receivingAddressService.save(receivingAddressTemp);
                }
            } else {
                receivingAddress.setIsDefault(0);
            }
        } else {
            receivingAddress.setIsDefault(1);
        }
        receivingAddressService.save(receivingAddress);
        return "redirect:/receivingAddress/index";

    }

    /**
     * 删除收货地址
     *
     * @param sid
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(Long sid) {
        receivingAddressService.remove(sid);
        return "redirect:/receivingAddress/index";
    }

    /**
     * 收货地址详细
     *
     * @param sid
     * @param model
     * @return
     */
    @RequestMapping(value = "/detail")
    public String detail(Device device, Long sid, Model model) {
        ReceivingAddress receivingAddress = receivingAddressService.findOne(sid);
        model.addAttribute("receivingAddresses", receivingAddress);
        if (device.isNormal()) {
            return "/receivingAddress/detail";
        } else {
            return "/receivingAddress/detail_mobile";
        }

    }

    /**
     * 修改收货地址
     *
     * @param receivingAddress
     * @return
     */
    @RequestMapping(value = "/update")
    public String update(ReceivingAddress receivingAddress) {
        ReceivingAddress receivingAddressTarget = receivingAddressService.findOne(receivingAddress.getSid());
        //当新增地址选择默认地址后  移除已有默认地址
        if (!Utils.isNull(receivingAddress.getIsDefault())) {
            List<ReceivingAddress> receivingAddresses = receivingAddressService.findIsDefaultAddress(1);
            if (!Utils.isNull(receivingAddresses) && receivingAddresses.size() > 0) {
                ReceivingAddress receivingAddressTemp = receivingAddresses.get(0);
                receivingAddressTemp.setIsDefault(0);
                receivingAddressService.save(receivingAddressTemp);
            }
        }
        combineSydwCore(receivingAddress, receivingAddressTarget);
        receivingAddressService.save(receivingAddressTarget);
        return "redirect:/receivingAddress/index";
    }

    /**
     * 收货地址设为默认
     *
     * @param sid
     * @return
     */
    @RequestMapping(value = "/setDefault")
    public String setDefault(Long sid) {
        ReceivingAddress receivingAddress = receivingAddressService.findOne(sid);
        //当新增地址选择默认地址后  移除已有默认地址
        if (!Utils.isNull(receivingAddress.getIsDefault())) {
            List<ReceivingAddress> receivingAddresses = receivingAddressService.findIsDefaultAddress(1);
            if (!Utils.isNull(receivingAddresses) && receivingAddresses.size() > 0) {
                ReceivingAddress receivingAddressTemp = receivingAddresses.get(0);
                receivingAddressTemp.setIsDefault(0);
                receivingAddressService.save(receivingAddressTemp);
            }
        }
        receivingAddress.setIsDefault(1);
        receivingAddressService.save(receivingAddress);
        return "redirect:/receivingAddress/index";
    }

}

package com.cqzg168.scm.shopkeeper.controller;

import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.domain.ShopKeeperCard;
import com.cqzg168.scm.service.ShopKeeperCardService;
import com.cqzg168.scm.utils.Constant;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

import static com.cqzg168.scm.shopkeeper.util.ClassUtils.combineSydwCore;

/**
 * Created by admin on 2017/5/3.
 */
@RequestMapping("/shopKeeperCard")
@Controller
public class ShopKeeperCardController extends BaseController {
    @Autowired
    private ShopKeeperCardService shopKeeperCardService;

    /**
     * 进入商户银行卡管理页面
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/index")
    public String index(Model model) {
        Session              session         = SecurityUtils.getSubject().getSession();
        ShopKeeper           shopKeeper      = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        List<ShopKeeperCard> shopKeeperCards = shopKeeperCardService.showShopKeeperBankCard(shopKeeper.getSid());
        model.addAttribute("shopKeeperCards", shopKeeperCards);
        model.addAttribute("shopKeeper", shopKeeper);
        return "/shopKeeperCard/index";
    }

    /**
     * 进入添加银行卡界面
     *
     * @return
     */
    @RequestMapping(value = "/add")
    public String add(Model model, String bankCardName) {
        Session    session    = SecurityUtils.getSubject().getSession();
        ShopKeeper shopKeeper = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        model.addAttribute("shopKeeper", shopKeeper);
        model.addAttribute("bankCardName", bankCardName);
        return "/shopKeeperCard/add";
    }

    /**
     * 商户添加银行卡
     *
     * @return
     */
    @RequestMapping(value = "/save")
    public String save(ShopKeeperCard shopKeeperCard) {
        Session    session    = SecurityUtils.getSubject().getSession();
        ShopKeeper shopKeeper = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        shopKeeperCard.setShopKeeperSid(shopKeeper.getSid());
        shopKeeperCardService.save(shopKeeperCard);
        List<ShopKeeperCard> shopKeeperCards = shopKeeperCardService.showShopKeeperBankCard(shopKeeper.getSid());
        session.setAttribute("bankCards", shopKeeperCards);
        return "redirect:/shopKeeperCard/index";
    }

    /**
     * 商户删除银行卡
     *
     * @param sid 银行卡sid
     * @return
     */
    @RequestMapping(value = "/delete")
    public String delete(Long sid) {
        shopKeeperCardService.remove(sid);
        //更新银行卡session中的值
        Session              session         = SecurityUtils.getSubject().getSession();
        ShopKeeper           shopKeeper      = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        List<ShopKeeperCard> shopKeeperCards = shopKeeperCardService.showShopKeeperBankCard(shopKeeper.getSid());
        session.setAttribute("bankCards", shopKeeperCards);
        return "redirect:/shopKeeperCard/index";
    }

    /**
     * 进入商户修改银行卡
     *
     * @param sid 银行卡id
     * @return
     */
    @RequestMapping(value = "/detail")
    public String detail(Long sid, Model model) {
        Session        session        = SecurityUtils.getSubject().getSession();
        ShopKeeper     shopKeeper     = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        ShopKeeperCard shopKeeperCard = shopKeeperCardService.findOne(sid);
        model.addAttribute("shopKeeper", shopKeeper);
        model.addAttribute("shopKeeperCard", shopKeeperCard);
        return "/shopKeeperCard/detail";
    }

    /**
     * 商户修改银行卡
     *
     * @param shopKeeperCard
     * @return
     */
    @RequestMapping(value = "update")
    public String update(ShopKeeperCard shopKeeperCard) {
        ShopKeeperCard shopKeeperCardOld = shopKeeperCardService.findOne(shopKeeperCard.getSid());
        combineSydwCore(shopKeeperCard, shopKeeperCardOld);
        shopKeeperCardService.save(shopKeeperCardOld);
        //更新银行卡session中的值
        Session              session         = SecurityUtils.getSubject().getSession();
        ShopKeeper           shopKeeper      = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        List<ShopKeeperCard> shopKeeperCards = shopKeeperCardService.showShopKeeperBankCard(shopKeeper.getSid());
        session.setAttribute("bankCards", shopKeeperCards);
        return "redirect:/shopKeeperCard/index";
    }
}

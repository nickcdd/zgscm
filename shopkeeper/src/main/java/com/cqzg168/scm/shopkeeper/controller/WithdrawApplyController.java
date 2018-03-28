package com.cqzg168.scm.shopkeeper.controller;

import com.cqzg168.scm.domain.PageInfo;
import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.domain.ShopKeeperCard;
import com.cqzg168.scm.domain.WithdrawApply;
import com.cqzg168.scm.service.WithdrawApplyService;
import com.cqzg168.scm.utils.Constant;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;

import static com.cqzg168.scm.utils.Constant.BANK_NAME_MAP;

/**
 * Created by admin on 2017/5/3.
 */
@RequestMapping("/withdrawApply")
@Controller
public class WithdrawApplyController extends BaseController {

    @Autowired
    private WithdrawApplyService withdrawApplyService;

    /**
     * 提现到银行卡
     *
     * @return
     */
    @RequestMapping(value = "/save")
    public String save(ShopKeeperCard shopKeeperCard, String amount) {
        Session    session    = SecurityUtils.getSubject().getSession();
        ShopKeeper shopKeeper = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);

        WithdrawApply withdrawApply = new WithdrawApply();
        withdrawApply.setAmount(new BigDecimal(amount));
        withdrawApply.setBankName(BANK_NAME_MAP.get(shopKeeperCard.getBankName()));
        withdrawApply.setCardNo(shopKeeperCard.getCardNo());
        withdrawApply.setShopKeeperSid(shopKeeper.getSid());
        withdrawApply.setShopKeeperCname(shopKeeper.getCname());
        withdrawApplyService.save(withdrawApply);
        return "redirect:/withdrawApply/index";
    }

    /**
     * 提现申请记录
     *
     * @param page
     * @param startTime
     * @param endTime
     * @param model
     * @return
     */
    @RequestMapping(value = "/index")
    public String index(@RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "5") int size, String startTime, String endTime, @RequestParam(defaultValue = "1") int status, Model model) {
        Session             session         = SecurityUtils.getSubject().getSession();
        ShopKeeper          shopKeeper      = (ShopKeeper) session.getAttribute(Constant.SessionKey.CURRENT_USER);
        PageRequest         pagable         = new PageRequest(page, size, new Sort(Sort.Direction.DESC, "createTime"));
        Page<WithdrawApply> withdrawApplies = withdrawApplyService.findByCashRecordPage(startTime, endTime, status, shopKeeper.getSid(), pagable);
        model.addAttribute("pageInfo", new PageInfo(withdrawApplies));
        model.addAttribute("withdrawApplies", withdrawApplies.getContent());
        if (startTime == null) {
            model.addAttribute("startTime", "");
        } else {
            model.addAttribute("startTime", startTime);
        }
        if (startTime == null) {
            model.addAttribute("endTime", "");
        } else {
            model.addAttribute("endTime", endTime);
        }
        model.addAttribute("status", status);

        return "/withdrawApply/index";
    }

}

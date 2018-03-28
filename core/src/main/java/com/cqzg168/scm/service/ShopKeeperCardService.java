package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.ShopKeeperCard;

import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
public interface ShopKeeperCardService extends BaseService<ShopKeeperCard> {

    /**
     * 展示商户绑定的银行卡
     *
     * @param shopKeeperSid
     * @return
     */
    List<ShopKeeperCard> showShopKeeperBankCard(Long shopKeeperSid);
}

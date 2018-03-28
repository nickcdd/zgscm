package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.ShopKeeperCard;
import com.cqzg168.scm.repository.AreaRepository;
import com.cqzg168.scm.repository.ShopKeeperCardRepository;
import com.cqzg168.scm.service.ShopKeeperCardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class ShopKeeperCardServiceImpl extends BaseServiceImpl<ShopKeeperCard, ShopKeeperCardRepository> implements ShopKeeperCardService {
    private ShopKeeperCardRepository repository;

    @Autowired
    @Override
    public void setRepository(ShopKeeperCardRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    /**
     * 展示商户绑定的银行卡
     *
     * @param shopKeeperSid
     * @return
     */
    public List<ShopKeeperCard> showShopKeeperBankCard(Long shopKeeperSid) {
        return repository.showShopKeeperBankCard(shopKeeperSid);
    }
}

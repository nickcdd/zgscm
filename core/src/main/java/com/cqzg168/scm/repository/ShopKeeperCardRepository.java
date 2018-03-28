package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.ShopKeeperCard;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 商户银行卡数据操作接口
 * Created by think on 2017/4/27.
 */
@Repository
public interface ShopKeeperCardRepository extends BaseRepository<ShopKeeperCard> {

    /**
     * 展示商户绑定的银行卡
     *
     * @param shopKeeperSid
     * @return
     */
    @Query("select s from ShopKeeperCard s where s.shopKeeperSid = ?1 and s.status = 1")
    List<ShopKeeperCard> showShopKeeperBankCard(Long shopKeeperSid);
}

package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.ShopKeeper;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * d订单数据操作接口
 * Created by think on 2017/4/27.
 */
@Repository
public interface OrdersRepository extends BaseRepository<Orders> {

    /**
     * 查询商户冻结订单汇总金额
     *
     * @param shopKeeper
     * @return
     */
    @Query("SELECT SUM(o.payAmount) FROM Orders o WHERE o.shopKeeper = ?1 AND o.freeze = 1 AND o.type = 2")
    Long sumFreezeOrdersByShopKeeperSid(ShopKeeper shopKeeper);

    /**
     * 查询商户指定时间内冻结订单汇总金额
     *
     * @param shopKeeper
     * @param createTime
     * @return
     */
    @Query("SELECT SUM(o.payAmount) FROM Orders o WHERE o.shopKeeper = ?1 AND o.createTime < ?2 AND o.freeze = 1 AND o.type = 2")
    Long sumFreezeOrdersByShopKeeperSidAndCreateTime(ShopKeeper shopKeeper, Date createTime);

    /**
     * 更新订单是否冻结
     *
     * @param shopKeeper
     * @param createTime
     */
    @Modifying
    @Query("UPDATE Orders o SET o.freeze = 0 WHERE o.shopKeeper = ?1 AND o.createTime < ?2 AND o.freeze = 1 AND o.type = 2")
    void updateFreezeOrdersByShopKeeperSidAndCreateTime(ShopKeeper shopKeeper, Date createTime);

    /**
     * 商户当天的收款金额
     *
     * @param startTime
     * @param endTime
     * @param shopKeeper
     * @return
     */
    @Query("select sum(o.payAmount) from Orders  o where o.createTime between ?1 and ?2 and o.shopKeeper = ?3 and o.status = 1")
    BigDecimal todayOrdersTotalAmount(Date startTime, Date endTime, ShopKeeper shopKeeper);

    /**
     * 单商户 当天的下单总金额
     *
     * @param startTime
     * @param endTime
     * @param shopKeeper
     * @return
     */
    @Query("select sum(w.totalAmount) from Orders w where w.createTime between ?1 and ?2 and  w.shopKeeper = ?3 and w.status in (2,3,4)")
    BigDecimal todayOrdersAmountMoney(Date startTime, Date endTime, ShopKeeper shopKeeper);

    /**
     * 删除一段时间以后还未付款订单
     * @return
     */
    @Query("select o.sid from Orders o where o.createTime < ?1 and o.status = 1")
    List<Long> deleteByNoPaymentOrders(Date targetTime);
}

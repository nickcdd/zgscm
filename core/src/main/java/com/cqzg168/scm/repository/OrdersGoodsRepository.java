package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.Goods;
import com.cqzg168.scm.domain.Orders;
import com.cqzg168.scm.domain.OrdersGoods;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 订单商品详情数据操作接口
 * Created by think on 2017/4/27.
 */
@Repository
public interface OrdersGoodsRepository extends BaseRepository<OrdersGoods> {
    @Query("select og.orders from OrdersGoods og  where og.goodsCname like ?1")
    List<Orders> findByGoodsName(String goodsName);
    @Query("select og  from OrdersGoods  og where og.orders.sid=?1 and og.goodsSpecification.goodsBm=?2 ")
    OrdersGoods findByOdersSidAndGoodsBm(Long ordersSid,String goodsBm);
}

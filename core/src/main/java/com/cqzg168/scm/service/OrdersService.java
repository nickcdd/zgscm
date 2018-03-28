package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.util.MultiValueMap;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by think on 2017/4/27.
 */
public interface OrdersService extends BaseService<Orders> {
    /**
     * 查询单个商户订单
     *
     * @param startTime 开始时间
     * @param endTime   结束时间
     * @param orderNo   订单编号
     * @param pageable  分页对象
     * @return findOrdersByShopkeeperGathering
     */
    Page<Orders> findOrdersByShopkeeperGathering(String startTime, String endTime, Long orderNo, Long sid, Integer status, Integer type, Pageable pageable);

    /**
     * 查询单个商户订单
     *
     * @param startTime 开始时间
     * @param endTime   结束时间
     * @param orderNo   订单编号
     * @param pageable  分页对象
     * @return findOrdersByShopkeeperShopping
     */
    Page<Orders> findOrdersByShopkeeperShopping(String startTime, String endTime, Long orderNo, Long sid, Integer status, Integer type, Pageable pageable);

    /**
     * 查询所有商户采购订单
     *
     * @param startTime 开始时间
     * @param endTime   结束时间
     * @param status    订单状态
     * @param pageable  分页对象
     * @return
     */
    Page<Orders> findOrdersByShopKepperProcurementPage(Long sid, String startTime, String endTime, Integer type, Integer status, Pageable pageable);

    /**
     * 后台管理分页查询订单
     *
     * @param shopKeeperName
     * @param goodsName
     * @param startDate
     * @param endDate
     * @param status
     * @param pageable
     * @return
     */

    Page<Orders> findByPage(String shopKeeperName, String goodsName, String startDate, String endDate, Integer status, Pageable pageable);

    /**
     * 查询需要平台发货的订单
     * @param shopKeeperName
     * @param goodsName
     * @param startDate
     * @param endDate
     * @param status
     * @param pageable
     * @return
     */
    Page<Orders> findSendOrdersByPage(Long supplierSid,String shopKeeperName, String goodsName, String startDate, String endDate, Integer status, Pageable pageable);

    /**
     * 商户下单 生成订单
     *
     * @param shopKeeper
     * @param shoppingCarts
     */
    Orders saveOrders(ShopKeeper shopKeeper, List<ShoppingCart> shoppingCarts, ReceivingAddress receivingAddress, Long sid);

    /**
     * 多个商品不同的供应商分单
     *
     * @param shopKeeper
     * @param shoppingCarts
     */
    void saveOrdersBySupplier(Orders orders, ShopKeeper shopKeeper, List<ShoppingCart> shoppingCarts, ReceivingAddress receivingAddress);

    /**
     * 根据供应商查询订单
     * @param supplierSid
     * @param startDate
     * @param endDate
     * @param status
     * @param defaultStatus
     * @param pageable
     * @return
     */
    Page<Orders> findBySupplier(Long supplierSid,String startDate, String endDate, Integer status,List<Integer> defaultStatus, Pageable pageable);

    /**
     * 根据统计订单总金额和数量
     * @param list
     * @return
     */
    Map<String,Object> countOrders(List<Orders> list);

    /**
     * 确认收货子订单  修改父订单状态
     * @param parentOrderSid
     */
    void parentOrdersTakeGoods(Long parentOrderSid);

    /**
     * 单商户 当天的下单总金额
     * @param startTime
     * @param endTime
     * @param shopKeeper
     * @return
     */
    BigDecimal todayOrdersAmountMoney(Date startTime, Date endTime, ShopKeeper shopKeeper);


    /**
     * 后台管理分页查询退款订单
     *
     * @param shopKeeperName
     * @param goodsName
     * @param startDate
     * @param endDate
     * @param status
     * @param pageable
     * @return
     */

    Page<Orders> findRefundOrdersByPage(Long supplierSid,List<Integer> defaultStatus,String shopKeeperName, String goodsName, String startDate, String endDate, Integer status, Pageable pageable);

    /**
     * 处理退款申请
     * @param ordersSids
     * @param flag
     * @param manager
     * @return
     */
    boolean reviewRefundOrders(Long[] ordersSids,boolean flag,Manager manager);

    /**
     * 处理拣货操作
     * @param ordersSids
     * @param flagStatus
     * @param manager
     * @return
     */
    HashMap<String,Object>  pickingGoods(Long[] ordersSids, Integer flagStatus, Manager manager);

    /**
     * 处理平台商品发货操作
     * @param ordersSids
     * @param manager
     * @return
     */
    boolean sendOrders(Long[]ordersSids,Manager manager,String logisticsNo,String logisticsCompany);

    /**
     * 拆分订单（拣货时用）
     * @return
     */
    Map<String,Object> sliptOrders(Long[] orderGoodsSids,Long ordersSid,Manager manager);

    /**
     * 处理退款请求，用于分单时缺货的订单
     * @return
     */
    HashMap<String,Object> handleRefundOrders(Long[] ordersSids, Integer flagStatus, Manager manager);
    /**
     * 处理退换货请求，用于平台
     * @return
     */
    HashMap<String,Object> handleReturnedGoods(Long[] ordersSids, boolean flagStatus, Manager manager,String reason);

    /**
     * 处理退换货请求，用于供应商端
     * @return
     */
    HashMap<String,Object> supplierHandleReturnedGoods(Long[] ordersSids, boolean flagStatus, Supplier supplier,String reason);

    /**
     * 删除一段时间以后还未付款订单
     * @return
     */
    List<Long> deleteByNoPaymentOrders(Date targetTime);
}

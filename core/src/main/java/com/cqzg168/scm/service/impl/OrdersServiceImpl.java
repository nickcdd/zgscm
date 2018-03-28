package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.repository.OrdersRepository;
import com.cqzg168.scm.service.*;
import com.cqzg168.scm.utils.Constant;
import com.cqzg168.scm.utils.DateUtil;
import com.cqzg168.scm.utils.RSAUtils;
import com.cqzg168.scm.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.Path;
import javax.persistence.criteria.Predicate;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class OrdersServiceImpl extends BaseServiceImpl<Orders, OrdersRepository> implements OrdersService {
    @Autowired
    private RefundOrderService refundOrderService;
    @Autowired
    private OrdersGoodsService ordersGoodsService;
    @Autowired
    private ShoppingCartService shoppingCartService;
    @Autowired
    private ShopKeeperService shopKeeperService;
    @Autowired
    private OrdersLogService ordersLogService;
    @Value("${orders_total_pirce_estimate}")
    String systemTotalPrice;
    @Autowired
    CxfUtilsService cxfUtilsService;

    private OrdersRepository repository;

    @Value("${public_key}")
    private String publicKey;
    @Value("${order_pay_notify_url}")
    private String notifyUrl;
    @Value("${order_pay_return_url}")
    private String returnUrl;
    @Value("${order_pay_body}")
    private String body;
    @Value("${order_pay_subject}")
    private String subject;
    @Value("${order_pay_url}")
    private String url;

    @Autowired
    @Override
    public void setRepository(OrdersRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    /**
     * 查询单个商户收款订单
     *
     * @param startTime 开始时间
     * @param endTime   结束时间
     * @param orderNo
     * @param pageable  分页对象
     * @return
     */
    @Override
    public Page<Orders> findOrdersByShopkeeperGathering(String startTime, String endTime, Long orderNo, Long sid, Integer status, Integer type, Pageable pageable) {
        SimpleDateFormat sdf = new SimpleDateFormat(Constant.STR_FULL_DATE_TIME);
        Specification<Orders> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            try {
                if (!Utils.isEmpty(startTime)) {
                    predicates.add(cb.greaterThanOrEqualTo(root.get("createTime"), sdf.parse(startTime)));
                }
                if (!Utils.isEmpty(endTime)) {
                    predicates.add(cb.lessThanOrEqualTo(root.get("createTime"), sdf.parse(endTime)));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (!Utils.isNull(orderNo)) {
                predicates.add(cb.equal(root.get("sid"), orderNo));
            }
            predicates.add(cb.equal(root.get("type"), type));
            predicates.add(cb.equal(root.get("status"), status));
            Path<ShopKeeper> shopKeeperPath = root.get("shopKeeper");
            predicates.add(cb.equal(shopKeeperPath.get("sid"), sid));
            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };
        return repository.findAll(specification, pageable);
    }

    @Override
    public Page<Orders> findOrdersByShopkeeperShopping(String startTime, String endTime, Long orderNo, Long sid, Integer status, Integer type, Pageable pageable) {
        SimpleDateFormat sdf = new SimpleDateFormat(Constant.STR_FULL_DATE_TIME);
        Specification<Orders> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            try {
                if (!Utils.isEmpty(startTime)) {
                    predicates.add(cb.greaterThanOrEqualTo(root.get("createTime"), sdf.parse(startTime)));
                }
                if (!Utils.isEmpty(endTime)) {
                    predicates.add(cb.lessThanOrEqualTo(root.get("createTime"), sdf.parse(endTime)));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (!Utils.isNull(orderNo)) {
                predicates.add(cb.equal(root.get("sid"), orderNo));
            }
            predicates.add(cb.isNull(root.get("parentOrderSid")));
            predicates.add(cb.equal(root.get("type"), type));
            if (Utils.isNull(status)) {
                predicates.add(cb.gt(root.get("status"), -1));
            } else {
                predicates.add(cb.equal(root.get("status"), status));
            }
            Path<ShopKeeper> shopKeeperPath = root.get("shopKeeper");
            predicates.add(cb.equal(shopKeeperPath.get("sid"), sid));
            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };
        return repository.findAll(specification, pageable);
    }

    @Override
    public Page<Orders> findOrdersByShopKepperProcurementPage(Long sid, String startTime, String endTime, Integer type, Integer status, Pageable pageable) {
        SimpleDateFormat sdf = new SimpleDateFormat(Constant.STR_FULL_DATE_TIME);
        Specification<Orders> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("supplierSid"), sid));
            try {
                if (!Utils.isEmpty(startTime)) {
                    predicates.add(cb.greaterThanOrEqualTo(root.get("createTime"), sdf.parse(startTime)));
                }
                if (!Utils.isEmpty(endTime)) {
                    predicates.add(cb.lessThanOrEqualTo(root.get("createTime"), sdf.parse(endTime)));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (!Utils.isNull(status)) {
                predicates.add(cb.equal(root.get("status"), status));
            } else {
                CriteriaBuilder.In in = cb.in(root.get("status"));
                in.value(2);
                in.value(3);
                in.value(4);
                predicates.add(in);
            }
            predicates.add(cb.equal(root.get("type"), type));
            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };
        return repository.findAll(specification, pageable);
    }

    @Override
    public Page<Orders> findByPage(String shopKeeperName, String goodsName, String startDate, String endDate, Integer status, Pageable pageable) {
        DateUtil timeUtil = new DateUtil();

        Specification<Orders> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("type"), 1));
            if (!Utils.isNull(status)) {
                predicates.add(cb.equal(root.get("status"), status));
            } else {

                predicates.add(cb.greaterThanOrEqualTo(root.get("status"), 0));
            }
            if (!Utils.isEmpty(startDate) && !Utils.isEmpty(endDate)) {
                try {
                    Date dateStrat = DateUtil.stringToDate(startDate, "yyyy-MM-dd HH:mm");
                    Date dateEnd = DateUtil.stringToDate(endDate, "yyyy-MM-dd HH:mm");
                    predicates.add(cb.between(root.get("createTime"), dateStrat, dateEnd));

                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }

            if (!Utils.isEmpty(shopKeeperName)) {
                //                predicates.add(cb.like(root.get("shopKeeperCname"), "%" + q + "%"));
                Path<ShopKeeper> shopKeeperPath = root.get("shopKeeper");
                predicates.add(cb.like(shopKeeperPath.get("cname"), "%" + shopKeeperName + "%"));

            }
            if (!Utils.isEmpty(goodsName)) {

                List<Orders> list = this.ordersGoodsService.findByGoodsName("%" + goodsName + "%");
                CriteriaBuilder.In<Long> in = cb.in(root.get("sid"));
                if (list.size() > 0) {
                    for (Orders o : list) {
                        if (!Utils.isNull(o.getParentOrderSid())) {
                            in.value(o.getParentOrderSid());
                        }
                        in.value(o.getSid());
                    }
                    predicates.add(in);
                } else {
                    Predicate orderSid = cb.equal(root.get("sid"), 0L);
                    predicates.add(orderSid);
                }
            }
            //查询父id为空的订单
            predicates.add(cb.isNull(root.get("parentOrderSid")));
            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };

        return repository.findAll(specification, pageable);
    }

    /**
     * 查询需要平台发货订单
     *
     * @param shopKeeperName
     * @param goodsName
     * @param startDate
     * @param endDate
     * @param status
     * @param pageable
     * @return
     */
    @Override
    public Page<Orders> findSendOrdersByPage(Long supplierSid,String shopKeeperName, String goodsName, String startDate, String endDate, Integer status, Pageable pageable) {
        DateUtil timeUtil = new DateUtil();

        Specification<Orders> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("supplierSid"), -1));
            predicates.add(cb.equal(root.get("type"), 1));
            if (!Utils.isNull(status)) {
                predicates.add(cb.equal(root.get("status"), status));
            } else {

                //                predicates.add(cb.greaterThanOrEqualTo(root.get("status"), 0));
                predicates.add(cb.between(root.get("status"), 2, 4));
            }
            if (!Utils.isEmpty(startDate) && !Utils.isEmpty(endDate)) {
                try {
                    Date dateStrat = DateUtil.stringToDate(startDate, "yyyy-MM-dd HH:mm");
                    Date dateEnd = DateUtil.stringToDate(endDate, "yyyy-MM-dd HH:mm");
                    predicates.add(cb.between(root.get("createTime"), dateStrat, dateEnd));

                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }

            if (!Utils.isEmpty(shopKeeperName)) {
                Path<ShopKeeper> shopKeeperPath = root.get("shopKeeper");
                predicates.add(cb.like(shopKeeperPath.get("cname"), "%" + shopKeeperName + "%"));
            }
            if (!Utils.isEmpty(goodsName)) {
                List<Orders> list = this.ordersGoodsService.findByGoodsName("%" + goodsName + "%");
                CriteriaBuilder.In<Long> in = cb.in(root.get("sid"));
                if (list.size() > 0) {
                    for (Orders o : list) {
                        if (!Utils.isNull(o.getParentOrderSid())) {
                            in.value(o.getParentOrderSid());
                        }
                        in.value(o.getSid());
                    }
                    predicates.add(in);
                } else {
                    Predicate orderSid = cb.equal(root.get("sid"), 0L);
                    predicates.add(orderSid);
                }
            }
            //查询父id为空的订单
            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };

        return repository.findAll(specification, pageable);
    }

    @Override
    public Orders saveOrders(ShopKeeper shopKeeper, List<ShoppingCart> shoppingCarts, ReceivingAddress receivingAddress, Long sid) {
        BigDecimal totalPrice = shoppingCartService.totalPrice(shoppingCarts);
        Orders orders = new Orders();
        if (!Utils.isNull(sid)) {
            //父订单sid不为空，说明进行了分单，供货商相同(没有分单的供应商信息在分单方法中)
            orders.setParentOrderSid(sid);
            if (shoppingCarts.get(0).getGoods().getSupplier() != null ) {
                orders.setSupplierCname(shoppingCarts.get(0).getGoods().getSupplier().getCname());
                orders.setSupplierSid(shoppingCarts.get(0).getGoods().getSupplier().getSid());
            }
        }
        orders.setShopKeeper(shopKeeper);
        orders.setTotalAmount(totalPrice);
        orders.setPayAmount(totalPrice);
        orders.setType(1);
        orders.setProvince(receivingAddress.getProvince());
        orders.setCity(receivingAddress.getCity());
        orders.setArea(receivingAddress.getArea());
        orders.setAddress(receivingAddress.getAddress());
        repository.save(orders);
        return orders;
    }

    /**
     * 商户下单 分单
     *
     * @param orders
     * @param shopKeeper
     * @param shoppingCarts
     * @param receivingAddress
     */
    @Override
    public void saveOrdersBySupplier(Orders orders, ShopKeeper shopKeeper, List<ShoppingCart> shoppingCarts, ReceivingAddress receivingAddress) {
        Map<Long, List<ShoppingCart>> shoppingCartMap = new HashMap<>();
        for (ShoppingCart shoppingCart : shoppingCarts) {
            if (shoppingCart.getGoods().getSupplier() != null ) {
                if (!shoppingCartMap.containsKey(shoppingCart.getGoods().getSupplier().getSid())) {
                    shoppingCartMap.put(shoppingCart.getGoods().getSupplier().getSid(), new ArrayList<ShoppingCart>());
                }
                shoppingCartMap.get(shoppingCart.getGoods().getSupplier().getSid()).add(shoppingCart);
            }
        }
        if (shoppingCartMap.size() > 1) {
            Iterator iterator = shoppingCartMap.entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry entry = (Map.Entry) iterator.next();
                List<ShoppingCart> shoppingCartTempList = (List<ShoppingCart>) entry.getValue();
                Orders ordersTemp = saveOrders(shopKeeper, shoppingCartTempList, receivingAddress, orders.getSid());
                ordersGoodsService.saveOrdersGoods(ordersTemp, shoppingCartTempList);
            }
        }else {
            ordersGoodsService.saveOrdersGoods(orders, shoppingCarts);
            orders.setSupplierCname(shoppingCarts.get(0).getGoods().getSupplier().getCname());
            orders.setSupplierSid(shoppingCarts.get(0).getGoods().getSupplier().getSid());
            repository.save(orders);
        }
    }

    @Override
    public Page<Orders> findBySupplier(Long supplierSid, String startDate, String endDate, Integer status, List<Integer> defaultStatus, Pageable pageable) {
        Specification<Orders> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (!Utils.isNull(status)) {
                predicates.add(cb.equal(root.get("status"), status));
            } else {
                if (!Utils.isEmpty(defaultStatus) && defaultStatus.size() > 0) {
                    CriteriaBuilder.In<Integer> in = cb.in(root.get("status"));
                    for (Integer integer : defaultStatus) {
                        in.value(integer);
                    }
                    predicates.add(in);
                }
            }
            if (!Utils.isEmpty(startDate) && !Utils.isEmpty(endDate)) {
                try {
                    Date dateStrat = DateUtil.stringToDate(startDate, "yyyy-MM-dd HH:mm");
                    Date dateEnd = DateUtil.stringToDate(endDate, "yyyy-MM-dd HH:mm");
                    predicates.add(cb.between(root.get("createTime"), dateStrat, dateEnd));

                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
            predicates.add(cb.equal(root.get("supplierSid"), supplierSid));
            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };
        return repository.findAll(specification, pageable);
    }

    @Override
    public Map<String, Object> countOrders(List<Orders> list) {
        Map<String, Object> resultMap = new HashMap<>();
        BigDecimal totalAmount = new BigDecimal("0");
        int totalQuantity = 0;
        for (Orders orders : list) {
            if (!Utils.isEmpty(orders.getOrdersGoodsList())) {
                for (OrdersGoods ordersGoods : orders.getOrdersGoodsList()) {
                    totalAmount = totalAmount.add(ordersGoods.getGoodsSpecificationCost().multiply(new BigDecimal(ordersGoods.getGoodsCount())));
                }
                totalQuantity += 1;
            }
        }
        resultMap.put("totalAmount", totalAmount);
        resultMap.put("totalQuantity", totalQuantity);

        return resultMap;
    }
    /**
     * 确认收货子订单  修改父订单状态
     *
     * @param parentOrderSid
     */
    @Override
    public void parentOrdersTakeGoods(Long parentOrderSid) {
        if (parentOrderSid != null) {
            boolean flag = true;
            Orders parentOrders = repository.findOne(parentOrderSid);
            for (Orders tempOrders : parentOrders.getChildrenOrders()) {
                if (tempOrders.getStatus() == 3) {
                    flag = false;
                }
            }
            if (flag) {
                parentOrders.setStatus(4);
                repository.save(parentOrders);
                ordersLogService.saveOrdersLog(-1L, parentOrders.getSid(), 3, 4, "商户确认收货");
            }
        }
    }

    /**
     * 单商户 当天的下单总金额
     *
     * @param startTime
     * @param endTime
     * @param shopKeeper
     * @return
     */
    @Override
    public BigDecimal todayOrdersAmountMoney(Date startTime, Date endTime, ShopKeeper shopKeeper) {
        return repository.todayOrdersAmountMoney(startTime, endTime, shopKeeper);
    }

    /**
     * 后台端查询退款订单
     *
     * @param shopKeeperName
     * @param goodsName
     * @param startDate
     * @param endDate
     * @param status
     * @param pageable
     * @return
     */

    @Override
    public Page<Orders> findRefundOrdersByPage(Long supplierSid,List<Integer> defaultStatus, String shopKeeperName, String goodsName, String startDate, String endDate, Integer status, Pageable pageable) {
        DateUtil timeUtil = new DateUtil();

        Specification<Orders> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
//            predicates.add(cb.isNotNull(root.get("supplierSid")));
            predicates.add(cb.equal(root.get("supplierSid"),supplierSid));
            predicates.add(cb.equal(root.get("type"), 1));
            if (!Utils.isNull(status)) {

                predicates.add(cb.equal(root.get("status"), status));
            } else {

                if (!Utils.isEmpty(defaultStatus) && defaultStatus.size() > 0) {
                    CriteriaBuilder.In<Integer> in = cb.in(root.get("status"));
                    for (Integer integer : defaultStatus) {

                        in.value(integer);
                    }
                    predicates.add(in);

                }
            }
            if (!Utils.isEmpty(startDate) && !Utils.isEmpty(endDate)) {
                try {
                    Date dateStrat = DateUtil.stringToDate(startDate, "yyyy-MM-dd HH:mm");
                    Date dateEnd = DateUtil.stringToDate(endDate, "yyyy-MM-dd HH:mm");
                    predicates.add(cb.between(root.get("createTime"), dateStrat, dateEnd));

                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }

            if (!Utils.isEmpty(shopKeeperName)) {
                Path<ShopKeeper> shopKeeperPath = root.get("shopKeeper");
                predicates.add(cb.like(shopKeeperPath.get("cname"), "%" + shopKeeperName + "%"));
            }
            if (!Utils.isEmpty(goodsName)) {
                List<Orders> list = this.ordersGoodsService.findByGoodsName("%" + goodsName + "%");
                CriteriaBuilder.In<Long> in = cb.in(root.get("sid"));
                if (list.size() > 0) {
                    for (Orders o : list) {
                        if (!Utils.isNull(o.getParentOrderSid())) {
                            in.value(o.getParentOrderSid());
                        }
                        in.value(o.getSid());
                    }
                    predicates.add(in);
                } else {
                    Predicate orderSid = cb.equal(root.get("sid"), 0L);
                    predicates.add(orderSid);
                }
            }
            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };

        return repository.findAll(specification, pageable);
    }

    /**
     * 退款审核处理
     *
     * @param ordersSids
     * @param flag
     * @return
     */
    @Override
    public boolean reviewRefundOrders(Long[] ordersSids, boolean flag, Manager manager) {
        boolean resultFlag = false;
        try {
            if (ordersSids.length > 0) {
                for (int i = 0; i < ordersSids.length; i++) {
                    Orders orders = repository.findOne(ordersSids[i]);
                    if (!Utils.isNull(orders)) {
                        Integer srcStatus = orders.getStatus();
                        if (flag) {
                            //true通过退款请求
                            orders.setStatus(6);
                            repository.save(orders);
                            ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, orders.getStatus(), manager.getCname() + ":通过退款审核");
                            if (!Utils.isNull(orders.getParentOrderSid())) {
                                Orders parentOrders = repository.findOne(orders.getParentOrderSid());
                                if (!Utils.isEmpty(parentOrders.getChildrenOrders())) {
                                    boolean flagStatus = true;
                                    for (Orders o : parentOrders.getChildrenOrders()) {
                                        if (o.getStatus() != 6) {
                                            flagStatus = false;
                                            break;
                                        }
                                    }
                                    if (flagStatus) {
                                        //所有子订单都已是已退款状态，修改父订单状态
                                        Integer srcParentStatus = parentOrders.getStatus();
                                        parentOrders.setStatus(6);
                                        repository.save(parentOrders);
                                        ordersLogService.saveOrdersLog(manager.getSid(), parentOrders.getSid(), srcParentStatus, parentOrders.getStatus(), manager.getCname() + ":通过退款审核");
                                    } else {
                                        //TODO
                                    }

                                }
                            }
                        } else {
                            //false未通过退款请求
                            orders.setStatus(7);
                            repository.save(orders);
                            ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, orders.getStatus(), manager.getCname() + ":未通过退款审核");

                        }
                    }

                }
                resultFlag = true;
            } else {
                resultFlag = false;
            }

        } catch (Exception e) {
            resultFlag = false;
        }
        return resultFlag;
    }

    @Override
    public HashMap<String, Object> pickingGoods(Long[] ordersSids, Integer flagStatus, Manager manager) {
        HashMap<String, Object> map = new HashMap<>();
        boolean resultFlag = false;
        Integer successCount = 0;
        Integer failCount = 0;
        Integer sendCount = 0;
        try {

            if (!Utils.isNull(ordersSids)) {

                for (int i = 0; i < ordersSids.length; i++) {
                    Orders orders = repository.findOne(ordersSids[i]);
                    //                    Integer srcStatus=orders.getStatus();
                    if (flagStatus == 1) {
                        Integer srcStatus = orders.getStatus();
                        orders.setStatus(2);
                        repository.save(orders);
                        ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, 2, manager.getCname() + "：有货，待发货");
                        sendCount++;
                    } else if (flagStatus == 0) {
                        if (!Utils.isNull(orders.getParentOrderSid())) {
                            //有父订单
                            Orders parentOrders = repository.findOne(orders.getParentOrderSid());
                            BigDecimal totalPrice = new BigDecimal(0);
                            for (Orders o : parentOrders.getChildrenOrders()) {
                                if (o.getSid() != orders.getSid())
                                    totalPrice = totalPrice.add(o.getTotalAmount());
                            }
                            if (totalPrice.compareTo(new BigDecimal(systemTotalPrice)) == -1) {
                                //剩余订单金额小于1000 父子订单都退款
                                //退款操作
                                //                                boolean refundFlag = this.refundOrders(parentOrders.getSid(), parentOrders.getPayAmount(), parentOrders.getChannel(), orders.getShopKeeper());
                                Map<String,Object> resultMap=this.refundOrders(parentOrders.getSid(), parentOrders.getPayAmount(), parentOrders.getChannel(), orders.getShopKeeper());
                                boolean refundFlag = (boolean) resultMap.get("flag");
                                if (refundFlag) {
                                    //退款成功，修改订单状态
                                    parentOrders.setStatus(6);
                                    repository.save(parentOrders);
                                    Integer srcStatus1 = parentOrders.getStatus();
                                    String msg="";
                                    if(resultMap.containsKey("msg")){
                                        msg= resultMap.get("msg").toString();
                                    }
                                    ordersLogService.saveOrdersLog(manager.getSid(), parentOrders.getSid(), srcStatus1, 6, manager.getCname() + "：因" + orders.getSid() + "缺货已退款"+msg);
                                    for (Orders o : parentOrders.getChildrenOrders()) {
                                        Integer srcStatus2 = o.getStatus();
                                        o.setStatus(6);
                                        repository.save(o);
                                        ordersLogService.saveOrdersLog(manager.getSid(), o.getSid(), srcStatus2, 6, manager.getCname() + "：因" + orders.getSid() + "缺货已退款");
                                    }
                                    successCount += 1;
                                } else {
                                    //退款失败  不做操作
                                    failCount += 1;
                                }
                            } else {
                                //剩余子订单金额大于1000，只需退款当前订单
                                //                                boolean refundFlag = this.refundOrders(parentOrders.getSid(), orders.getPayAmount(), parentOrders.getChannel(), orders.getShopKeeper());
                                Map<String,Object> resultMap=this.refundOrders(parentOrders.getSid(), orders.getPayAmount(), parentOrders.getChannel(), orders.getShopKeeper());
                                boolean refundFlag = (boolean) resultMap.get("flag");
                                if (refundFlag) {
                                    Integer srcStatus = orders.getStatus();
                                    orders.setStatus(6);
                                    repository.save(orders);
                                    String msg="";
                                    if(resultMap.containsKey("msg")){
                                        msg= resultMap.get("msg").toString();
                                    }
                                    ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, 6, manager.getCname() + "：因缺货已退款"+msg);
                                    successCount += 1;
                                } else {
                                    failCount += 1;
                                }
                            }

                        } else {
                            //无父订单
                            //                            boolean refundFlag = this.refundOrders(orders.getSid(), orders.getPayAmount(), orders.getChannel(), orders.getShopKeeper());
                            Map<String,Object> resultMap=this.refundOrders(orders.getSid(), orders.getPayAmount(), orders.getChannel(), orders.getShopKeeper());
                            boolean refundFlag = (boolean) resultMap.get("flag");
                            if (refundFlag) {
                                Integer srcStatus = orders.getStatus();
                                orders.setStatus(6);
                                repository.save(orders);
                                String msg="";
                                if(resultMap.containsKey("msg")){
                                    msg= resultMap.get("msg").toString();
                                }
                                ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, 6, manager.getCname() + "：因缺货已退款"+msg);
                                successCount += 1;
                            } else {
                                failCount += 1;
                            }
                        }
                    }

                }
                resultFlag = true;
            } else {
                resultFlag = false;
            }

        } catch (Exception e) {
            resultFlag = false;
        }
        map.put("resultFlag", resultFlag);
        map.put("successCount", successCount);
        map.put("failCount", failCount);
        map.put("sendCount", sendCount);
        return map;
    }

    @Override
    public boolean sendOrders(Long[] ordersSids, Manager manager, String logisticsNo, String logisticsCompany) {
        boolean resultFlag = false;
        try {

            if (!Utils.isNull(ordersSids)) {
                for (int i = 0; i < ordersSids.length; i++) {
                    Orders orders = repository.findOne(ordersSids[i]);
                    Integer srcStatus = orders.getStatus();
                    orders.setStatus(3);
                    orders.setLogisticsCompany(logisticsCompany);
                    orders.setLogisticsNo(logisticsNo);
                    repository.save(orders);
                    ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, 3, manager.getCname() + "：发货");
                    if (!Utils.isNull(orders.getParentOrderSid())) {
                        Orders parentOrder = repository.findOne(orders.getParentOrderSid());
                        if (!Utils.isEmpty(parentOrder.getChildrenOrders())) {
                            boolean flag = true;
                            if (flag) {
                                Integer srcStatus1 = parentOrder.getStatus();
                                parentOrder.setStatus(3);
                                ordersLogService.saveOrdersLog(manager.getSid(), parentOrder.getSid(), srcStatus1, 3, manager.getCname() + "：发货");
                            }

                        }
                    }

                }
                resultFlag = true;
            } else {
                resultFlag = false;
            }

        } catch (Exception e) {
            resultFlag = false;
        }
        return resultFlag;
    }

    @Override
    public Map<String, Object> sliptOrders(Long[] orderGoodsSids, Long ordersSid, Manager manager) {
        Map<String, Object> map    = new HashMap<>();
        String              msg    = "";
        boolean             flag   = false;
        Orders              orders = repository.findOne(ordersSid);

        if (!Utils.isNull(orders)) {
            Integer srcOrderStatus = orders.getStatus();
            //            System.out.println("orderlength" + orderGoodsSids.length);
            if (orderGoodsSids.length > 0) {
                if (orderGoodsSids.length == orders.getOrdersGoodsList().size()) {
                    //所有商品都有货，不需要分单

                    boolean statusFlag = true;
                    int     i          = 1;
                    for (OrdersGoods orderGoods : orders.getOrdersGoodsList()) {
                        Object[]   params = new Object[5];
                        String     spbm   = orderGoods.getGoodsSpecification().getGoodsBm();
                        BigDecimal sj     = orderGoods.getGoodsSpecificationPrice().divide(new BigDecimal(orderGoods.getGoodsSpecification().getSaleCount()), 2, BigDecimal.ROUND_HALF_UP);
                        String     jcddh  = orders.getSid().toString();
                        Integer    sl     = orderGoods.getGoodsCount() * orderGoods.getGoodsSpecification().getSaleCount();
                        String     result = spbm + "," + sl.toString() + "," + sj.toString() + "," + jcddh;
                        //                        params[0] = spbm;
                        //                        params[1] = sl;
                        //                        params[2] = sj;
                        //                        params[3] = orders.getSid().intValue();
                        //                        params[4] = i;
                        //                        String resultStr = cxfUtilsService.callWebService("sppfd", params);
                        //
                        //                        String[] arr = resultStr.split(",");
                        String[] arr = new String[] {"0"};
                        if (arr[0].equals("0")) {

                            i++;
                        } else {

                            statusFlag = false;
                            break;
                        }
                    }
                    if (!statusFlag) {
                        flag = false;
                        msg = "订单" + ordersSid + "减库存失败";
                    } else {
                        orders.setStatus(3);
                        repository.save(orders);
                        ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcOrderStatus, orders.getStatus(), manager.getCname() + ":平台商品全部有货，已发货");
                        if (!Utils.isNull(orders.getParentOrderSid())) {
                            //修改父订单状态
                            Orders parentOrders = repository.findOne(orders.getParentOrderSid());
                            if (!Utils.isNull(parentOrders)) {
                                boolean updateFlag = true;
                                for (Orders o : parentOrders.getChildrenOrders()) {
                                    if (o.getStatus() != 3) {
                                        updateFlag = false;
                                        break;
                                    }
                                }
                                if (updateFlag) {
                                    Integer scrParentStatus = parentOrders.getStatus();
                                    parentOrders.setStatus(3);
                                    repository.save(parentOrders);
                                    ordersLogService.saveOrdersLog(manager.getSid(), parentOrders.getSid(), scrParentStatus, parentOrders.getStatus(), manager.getCname() + ":所有子订单已发货");
                                }
                            }
                        }
                        flag = true;
                        msg = "订单" + ordersSid + "操作成功，整个订单已发货";
                    }
                } else {
                    List<OrdersGoods> sendList = new ArrayList<>();
                    //无货需要退款的ordergoods
                    List<OrdersGoods> refundList         = new ArrayList<>();
                    List<Long>        orderGoodsSidsList = Arrays.asList(orderGoodsSids);
                    for (OrdersGoods ordersGoods : orders.getOrdersGoodsList()) {
                        if (orderGoodsSidsList.contains(ordersGoods.getSid())) {
                            //有货
                            sendList.add(ordersGoods);
                        } else {
                            //无货
                            refundList.add(ordersGoods);
                        }
                    }

                    Integer    count  = 0;
                    BigDecimal amount = new BigDecimal("0");
                    for (OrdersGoods og : refundList) {
                        amount = amount.add(og.getGoodsSpecificationPrice().multiply(new BigDecimal(og.getGoodsCount())));
                        count += og.getGoodsCount();
                    }
                    BigDecimal leftAmount = orders.getPayAmount().subtract(amount);
                    if (leftAmount.compareTo(new BigDecimal(0)) == -1) {
                        //余下商品的总额不足规定最低订单金额，整个订单退款
                        orders.setStatus(5);
                        repository.save(orders);
                        ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcOrderStatus, orders.getStatus(), manager.getCname() + "：因余下商品总金额小于规定金额，整个订单待退款");
                        if (!Utils.isNull(orders.getParentOrderSid())) {
                            //修改父订单状态
                            Orders parentOrders = repository.findOne(orders.getParentOrderSid());
                            if (!Utils.isNull(parentOrders)) {
                                boolean updateFlag = true;
                                for (Orders o : parentOrders.getChildrenOrders()) {
                                    if (o.getStatus() != 5 ) {
                                        updateFlag = false;
                                        break;
                                    }
                                }
                                if (updateFlag) {
                                    Integer scrParentStatus = parentOrders.getStatus();
                                    parentOrders.setStatus(5);
                                    repository.save(parentOrders);
                                    ordersLogService.saveOrdersLog(manager.getSid(), parentOrders.getSid(), scrParentStatus, parentOrders.getStatus(), manager.getCname() + ":因平台订单待退款");
                                }
                            }
                        }
                        flag = true;
                        msg = "订单" + ordersSid + "操作成功，该订单剩余商品金额小于规定金额，整个订单做退款处理";
                    } else {
                        if (!Utils.isNull(orders.getParentOrderSid())) {
                            //订单是子订单的情况
                            Orders parentOrders = repository.findOne(orders.getParentOrderSid());
                            if (!Utils.isNull(parentOrders)) {
                                boolean statusFlag = true;
                                //先减去库存
                                int i = 1;
                                for (OrdersGoods og : sendList) {
                                    //减库存
                                    Object[]   params = new Object[5];
                                    String     spbm   = og.getGoodsSpecification().getGoodsBm();
                                    BigDecimal sj     = og.getGoodsSpecificationPrice().divide(new BigDecimal(og.getGoodsSpecification().getSaleCount()), 2, BigDecimal.ROUND_HALF_UP);
                                    String     jcddh  = orders.getSid().toString();
                                    Integer    sl     = og.getGoodsCount() * og.getGoodsSpecification().getSaleCount();
                                    String     result = spbm + "," + sl.toString() + "," + sj.toString() + "," + jcddh;
                                    //                            params[0] = spbm;
                                    //                            params[1] = sl;
                                    //                            params[2] = sj;
                                    //                            params[3] = orders.getSid().intValue();
                                    //                            params[4] = i;
                                    //                            String   resultStr = cxfUtilsService.callWebService("sppfd", params);
                                    //                            String[] arr       = resultStr.split(",");
                                    String[] arr = new String[] {"0"};
                                    if (arr[0].equals("0")) {
                                        i++;
                                    } else {
                                        statusFlag = false;
                                        break;
                                    }

                                }
                                if (statusFlag) {
                                    //减库存成功
                                    //生成退款订单
                                    Orders refundOrders = new Orders();
                                    refundOrders.setPayAmount(amount);
                                    refundOrders.setTotalAmount(amount);
                                    refundOrders.setParentOrderSid(orders.getParentOrderSid());
                                    refundOrders.setStatus(5);
                                    refundOrders.setShopKeeper(orders.getShopKeeper());
                                    refundOrders.setType(orders.getType());
                                    refundOrders.setProvince(orders.getProvince());
                                    refundOrders.setCity(orders.getCity());
                                    refundOrders.setArea(orders.getArea());
                                    refundOrders.setAddress(orders.getAddress());
                                    refundOrders.setSupplierSid(orders.getSupplierSid());
                                    refundOrders.setSupplierCname(orders.getSupplierCname());

                                    refundOrders = repository.save(refundOrders);
                                    ordersLogService.saveOrdersLog(manager.getSid(), refundOrders.getSid(), srcOrderStatus, refundOrders.getStatus(), manager.getCname() + "：订单部分商品去缺货，需退款" + refundOrders.getPayAmount());
                                    for (OrdersGoods og : refundList) {
                                        //                    og.setSid(null);
                                        og.setOrders(refundOrders);
                                    }
                                    ordersGoodsService.save(refundList);
                                    //生成发货订单
                                    //                                    Orders sendOrders = new Orders();
                                    //                                    sendOrders.setPayAmount(leftAmount);
                                    //                                    sendOrders.setTotalAmount(leftAmount);
                                    //                                    sendOrders.setParentOrderSid(ordersSid);
                                    //                                    sendOrders.setStatus(3);
                                    //                                    sendOrders.setShopKeeper(orders.getShopKeeper());
                                    //                                    sendOrders.setType(orders.getType());
                                    //                                    sendOrders.setProvince(orders.getProvince());
                                    //                                    sendOrders.setCity(orders.getCity());
                                    //                                    sendOrders.setArea(orders.getArea());
                                    //                                    sendOrders.setAddress(orders.getAddress());
                                    //                                    sendOrders.setSupplierSid(orders.getSupplierSid());
                                    //                                    sendOrders.setSupplierCname(orders.getSupplierCname());

                                    //                                    sendOrders = repository.save(sendOrders);
                                    //                                    ordersLogService.saveOrdersLog(manager.getSid(), sendOrders.getSid(), srcOrderStatus, sendOrders.getStatus(), manager.getCname() + "：部分商品去有货，已发货");
                                    //                                    for (OrdersGoods og : sendList) {
                                    //                                        og.setOrders(sendOrders);
                                    //                                    }
                                    //                                    ordersGoodsService.save(sendList);
                                    orders.setTotalAmount(leftAmount);
                                    orders.setPayAmount(leftAmount);
                                    orders.setStatus(3);
                                    //                                    orders.setSupplierCname("");
                                    //                                    orders.setSupplierSid(null);
                                    repository.save(orders);
                                    ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcOrderStatus, orders.getStatus(), manager.getCname() + "：该订单部分商品已退款，剩余商品已发货");
                                    if (!Utils.isNull(parentOrders)) {
                                        boolean updateFlag = true;
                                        for (Orders o : parentOrders.getChildrenOrders()) {
                                            if (o.getStatus() != 3 && !o.getSid().equals(orders.getSid()) && !o.getSid().equals(refundOrders.getSid())) {
                                                updateFlag = false;
                                                break;
                                            }
                                        }
                                        if (updateFlag) {
                                            Integer scrParentStatus = parentOrders.getStatus();
                                            parentOrders.setStatus(3);
                                            repository.save(parentOrders);
                                            ordersLogService.saveOrdersLog(manager.getSid(), parentOrders.getSid(), scrParentStatus, parentOrders.getStatus(), manager.getCname() + ":所有子订单已发货");
                                        }
                                    }
                                    flag = true;
                                    msg = "订单" + ordersSid + "操作成功，已拆分订单";
                                } else {
                                    //减库存失败
                                    flag = false;
                                    msg = "订单" + ordersSid + "减库存失败";
                                }
                            }
                        } else {
                            //订单为父订单的情况

                            boolean statusFlag = true;
                            //先减去库存
                            int i = 1;
                            for (OrdersGoods og : sendList) {
                                //减库存
                                Object[]   params = new Object[5];
                                String     spbm   = og.getGoodsSpecification().getGoodsBm();
                                BigDecimal sj     = og.getGoodsSpecificationPrice().divide(new BigDecimal(og.getGoodsSpecification().getSaleCount()), 2, BigDecimal.ROUND_HALF_UP);
                                String     jcddh  = orders.getSid().toString();
                                Integer    sl     = og.getGoodsCount() * og.getGoodsSpecification().getSaleCount();
                                String     result = spbm + "," + sl.toString() + "," + sj.toString() + "," + jcddh;
                                //                            params[0] = spbm;
                                //                            params[1] = sl;
                                //                            params[2] = sj;
                                //                            params[3] = orders.getSid().intValue();
                                //                            params[4] = i;
                                //                            String   resultStr = cxfUtilsService.callWebService("sppfd", params);
                                //                            String[] arr       = resultStr.split(",");
                                String[] arr = new String[] {"0"};
                                if (arr[0].equals("0")) {
                                    i++;
                                } else {
                                    statusFlag = false;
                                    break;
                                }

                            }
                            if (statusFlag) {
                                //减库存成功
                                //生成退款订单
                                Orders refundOrders = new Orders();
                                refundOrders.setPayAmount(amount);
                                refundOrders.setTotalAmount(amount);
                                refundOrders.setParentOrderSid(ordersSid);
                                refundOrders.setStatus(5);
                                refundOrders.setShopKeeper(orders.getShopKeeper());
                                refundOrders.setType(orders.getType());
                                refundOrders.setProvince(orders.getProvince());
                                refundOrders.setCity(orders.getCity());
                                refundOrders.setArea(orders.getArea());
                                refundOrders.setAddress(orders.getAddress());
                                refundOrders.setSupplierSid(orders.getSupplierSid());
                                refundOrders.setSupplierCname(orders.getSupplierCname());

                                refundOrders = repository.save(refundOrders);
                                ordersLogService.saveOrdersLog(manager.getSid(), refundOrders.getSid(), srcOrderStatus, refundOrders.getStatus(), manager.getCname() + "：订单部分商品去缺货，需退款" + refundOrders.getPayAmount());
                                for (OrdersGoods og : refundList) {
                                    //                    og.setSid(null);
                                    og.setOrders(refundOrders);
                                }
                                ordersGoodsService.save(refundList);
                                //生成发货订单
                                Orders sendOrders = new Orders();
                                sendOrders.setPayAmount(leftAmount);
                                sendOrders.setTotalAmount(leftAmount);
                                sendOrders.setParentOrderSid(ordersSid);
                                sendOrders.setStatus(3);
                                sendOrders.setShopKeeper(orders.getShopKeeper());
                                sendOrders.setType(orders.getType());
                                sendOrders.setProvince(orders.getProvince());
                                sendOrders.setCity(orders.getCity());
                                sendOrders.setArea(orders.getArea());
                                sendOrders.setAddress(orders.getAddress());
                                sendOrders.setSupplierSid(orders.getSupplierSid());
                                sendOrders.setSupplierCname(orders.getSupplierCname());

                                sendOrders = repository.save(sendOrders);
                                ordersLogService.saveOrdersLog(manager.getSid(), sendOrders.getSid(), srcOrderStatus, sendOrders.getStatus(), manager.getCname() + "：部分商品去有货，已发货");
                                for (OrdersGoods og : sendList) {
                                    og.setOrders(sendOrders);
                                }
                                ordersGoodsService.save(sendList);
                                orders.setStatus(3);
                                orders.setSupplierCname("");
                                orders.setSupplierSid(null);
                                repository.save(orders);
                                ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcOrderStatus, orders.getStatus(), manager.getCname() + "：该订单已拆分");
                                flag = true;
                                msg = "订单" + ordersSid + "操作成功，已拆分订单";
                            } else {
                                //减库存失败
                                flag = false;
                                msg = "订单" + ordersSid + "减库存失败";
                            }
                        }
                    }
                }

            } else {
                //所有商品都缺货
                orders.setStatus(5);
                repository.save(orders);
                ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcOrderStatus, orders.getStatus(), manager.getCname() + "：整个订单商品都缺货，需退款" + orders.getPayAmount());
                flag = true;
                msg = "订单" + ordersSid + "操作成功，整个订单需退款处理";
            }
        } else {
            flag = false;
            msg = "没有找到订单" + ordersSid;
        } map.put("flag", flag);
        map.put("msg", msg);
        return map;
    }

    @Override
    public HashMap<String, Object> handleRefundOrders(Long[] ordersSids, Integer flagStatus, Manager manager) {
        HashMap<String, Object> map = new HashMap<>();
        boolean resultFlag = false;
        Integer successCount = 0;
        Integer failCount = 0;

        try {

            if (!Utils.isNull(ordersSids)) {

                for (int i = 0; i < ordersSids.length; i++) {
                    Orders orders = repository.findOne(ordersSids[i]);
                    if (!Utils.isNull(orders)) {
                        Integer srcStatus = orders.getStatus();
                        if (!Utils.isNull(orders.getParentOrderSid())) {
                            Orders parentOrder = repository.findOne(orders.getParentOrderSid());
                            //                            boolean flag = this.refundOrders(parentOrder.getSid(), orders.getPayAmount(), parentOrder.getChannel(), parentOrder.getShopKeeper());
                            Map<String,Object> resultMap=this.refundOrders(parentOrder.getSid(), orders.getPayAmount(), parentOrder.getChannel(), parentOrder.getShopKeeper());
                            boolean flag = (boolean) resultMap.get("flag");
                            if (flag) {
                                orders.setStatus(6);
                                repository.save(orders);
                                String msg="";
                                if(resultMap.containsKey("msg")){
                                    msg= resultMap.get("msg").toString();
                                }
                                ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, orders.getStatus(), manager.getCname() + "退款成功"+msg);

                                boolean status = true;
                                for (Orders o : parentOrder.getChildrenOrders()) {
                                    if (o.getSid() != orders.getSid()) {
                                        //判断不是当前订单的其他子订单是否为已退款状态
                                        if (o.getStatus() != 6) {
                                            status = false;
                                            break;
                                        }
                                    }
                                }
                                if (status) {
                                    Integer parentStatus = parentOrder.getStatus();
                                    parentOrder.setStatus(6);
                                    repository.save(parentOrder);
                                    ordersLogService.saveOrdersLog(manager.getSid(), parentOrder.getSid(), parentStatus, orders.getStatus(), manager.getCname() + "子订单已全部退款成功，父订单改为退款状态");
                                }
                                successCount += 1;
                            } else {
                                failCount += 1;
                            }
                        } else {
                            //没有父订单
                            //                            boolean flag = this.refundOrders(orders.getSid(), orders.getPayAmount(), orders.getChannel(), orders.getShopKeeper());
                            Map<String,Object> resultMap=this.refundOrders(orders.getSid(), orders.getPayAmount(), orders.getChannel(), orders.getShopKeeper());
                            boolean flag = (boolean) resultMap.get("flag");
                            if (flag) {

                                orders.setStatus(6);
                                repository.save(orders);
                                String msg="";
                                if(resultMap.containsKey("msg")){
                                    msg= resultMap.get("msg").toString();
                                }
                                ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, orders.getStatus(), manager.getCname() + "退款成功"+msg);
                                successCount += 1;
                            } else {
                                failCount += 1;
                            }
                        }

                    } else {
                        failCount += 1;
                    }
                }
                resultFlag = true;
            } else {
                resultFlag = false;
            }

        } catch (Exception e) {
            resultFlag = false;
        }
        map.put("resultFlag", resultFlag);
        map.put("successCount", successCount);
        map.put("failCount", failCount);

        return map;
    }

    @Override
    public HashMap<String, Object> handleReturnedGoods(Long[] ordersSids, boolean flagStatus, Manager manager, String reason) {
        HashMap<String, Object> map = new HashMap<>();
        boolean resultFlag = false;
        Integer successCount = 0;
        Integer failCount = 0;
        try {
            if (!Utils.isNull(ordersSids)) {
                for (int i = 0; i < ordersSids.length; i++) {
                    Orders orders = repository.findOne(ordersSids[i]);
                    if (!Utils.isNull(orders)) {
                        Integer srcStatus = orders.getStatus();
                        if (!Utils.isNull(orders.getParentOrderSid())) {
                            Orders parentOrders = repository.findOne(orders.getParentOrderSid());
                            if (srcStatus == 9) {
                                if (flagStatus) {
                                    //通过换货请求
                                    orders.setStatus(10);
                                    repository.save(orders);
                                    ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, orders.getStatus(), manager.getCname() + "：通过换货申请");
                                    Integer srcParentStatus = parentOrders.getStatus();
                                    parentOrders.setStatus(3);
                                    repository.save(parentOrders);
                                    ordersLogService.saveOrdersLog(manager.getSid(), parentOrders.getSid(), srcParentStatus, parentOrders.getStatus(), manager.getCname() + "：子订单换货成功");
                                    successCount += 1;
                                } else {
                                    //不通过换货请求
                                    orders.setStatus(3);
                                    repository.save(orders);
                                    ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, orders.getStatus(), manager.getCname() + "：未通过换货申请," + reason);
                                    Integer srcParentStatus = parentOrders.getStatus();
                                    parentOrders.setStatus(3);
                                    repository.save(parentOrders);
                                    ordersLogService.saveOrdersLog(manager.getSid(), parentOrders.getSid(), srcParentStatus, parentOrders.getStatus(), manager.getCname() + "：子订单未通过换货申请");
                                    successCount += 1;
                                }
                            } else if (srcStatus == 8) {
                                if (flagStatus) {
                                    //通过退货请求
                                    //退款
                                    //                                    boolean flag = this.refundOrders(orders.getSid(), orders.getPayAmount(), parentOrders.getChannel(), parentOrders.getShopKeeper());
                                    Map<String,Object> resultMap=this.refundOrders(parentOrders.getSid(), orders.getPayAmount(), parentOrders.getChannel(), parentOrders.getShopKeeper());
                                    boolean flag = (boolean) resultMap.get("flag");
                                    if (flag) {

                                        orders.setStatus(6);
                                        repository.save(orders);
                                        String msg="";
                                        if(resultMap.containsKey("msg")){
                                            msg= resultMap.get("msg").toString();
                                        }
                                        ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, orders.getStatus(), manager.getCname() + "：通过退货申请，退款成功"+msg);
                                        Integer srcParentStatus = parentOrders.getStatus();
                                        parentOrders.setStatus(6);
                                        repository.save(parentOrders);
                                        ordersLogService.saveOrdersLog(manager.getSid(), parentOrders.getSid(), srcParentStatus, parentOrders.getStatus(), manager.getCname() + "：子订单退货成功");
                                        successCount += 1;
                                    } else {
                                        failCount += 1;
                                    }
                                } else {
                                    //不通过退货请求
                                    orders.setStatus(3);
                                    repository.save(orders);
                                    ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, orders.getStatus(), manager.getCname() + "：未通过退货申请," + reason);
                                    Integer srcParentStatus = parentOrders.getStatus();
                                    parentOrders.setStatus(3);
                                    repository.save(parentOrders);
                                    ordersLogService.saveOrdersLog(manager.getSid(), parentOrders.getSid(), srcParentStatus, parentOrders.getStatus(), manager.getCname() + "：子订单退货未通过");
                                    successCount += 1;
                                }
                            }
                        } else {
                            //没有被分单
                            if (srcStatus == 9) {
                                if (flagStatus) {
                                    //通过换货请求
                                    orders.setStatus(3);
                                    repository.save(orders);
                                    ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, orders.getStatus(), manager.getCname() + "：通过换货申请");
                                    successCount += 1;
                                } else {
                                    //不通过换货请求
                                    orders.setStatus(3);
                                    repository.save(orders);
                                    ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, orders.getStatus(), manager.getCname() + "：未通过换货申请," + reason);
                                    successCount += 1;
                                }
                            } else if (srcStatus == 8) {
                                if (flagStatus) {
                                    //通过退货请求
                                    //退款
                                    //                                    boolean flag = this.refundOrders(orders.getSid(), orders.getPayAmount(), orders.getChannel(), orders.getShopKeeper());
                                    Map<String,Object> resultMap= this.refundOrders(orders.getSid(), orders.getPayAmount(), orders.getChannel(), orders.getShopKeeper());
                                    boolean flag = (boolean) resultMap.get("flag");
                                    if (flag) {

                                        orders.setStatus(6);
                                        repository.save(orders);
                                        String msg="";
                                        if(resultMap.containsKey("msg")){
                                            msg= resultMap.get("msg").toString();
                                        }
                                        ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, orders.getStatus(), manager.getCname() + "：通过退货申请，退款成功"+msg);

                                        successCount += 1;
                                    } else {
                                        failCount += 1;
                                    }
                                } else {
                                    //不通过退货请求
                                    orders.setStatus(3);
                                    repository.save(orders);
                                    ordersLogService.saveOrdersLog(manager.getSid(), orders.getSid(), srcStatus, orders.getStatus(), manager.getCname() + "：未通过退货申请," + reason);
                                    successCount += 1;
                                }
                            }
                        }

                    } else {
                        failCount += 1;
                    }

                }
                resultFlag = true;
            } else {
                resultFlag = false;
            }

        } catch (Exception e) {
            resultFlag = false;
        }
        map.put("resultFlag", resultFlag);
        map.put("successCount", successCount);
        map.put("failCount", failCount);
        return map;
    }

    @Override
    public HashMap<String, Object> supplierHandleReturnedGoods(Long[] ordersSids, boolean flagStatus, Supplier supplier, String reason) {
        HashMap<String, Object> map = new HashMap<>();
        boolean resultFlag = false;
        Integer successCount = 0;
        Integer failCount = 0;
        try {
            if (!Utils.isNull(ordersSids)) {
                for (int i = 0; i < ordersSids.length; i++) {
                    Orders orders = repository.findOne(ordersSids[i]);
                    if (!Utils.isNull(orders)) {
                        Integer srcStatus = orders.getStatus();
                        if (!Utils.isNull(orders.getParentOrderSid())) {
                            Orders parentOrders = repository.findOne(orders.getParentOrderSid());
                            if (srcStatus == 9) {
                                if (flagStatus) {
                                    //通过换货请求
                                    orders.setStatus(10);
                                    repository.save(orders);
                                    ordersLogService.saveOrdersLog(supplier.getSid(), orders.getSid(), srcStatus, orders.getStatus(), supplier.getCname() + "：通过换货申请");
                                    Integer srcParentStatus = parentOrders.getStatus();
                                    parentOrders.setStatus(3);
                                    repository.save(parentOrders);
                                    ordersLogService.saveOrdersLog(supplier.getSid(), parentOrders.getSid(), srcParentStatus, parentOrders.getStatus(), supplier.getCname() + "：子订单换货成功");
                                    successCount += 1;
                                } else {
                                    //不通过换货请求
                                    orders.setStatus(3);
                                    repository.save(orders);
                                    ordersLogService.saveOrdersLog(supplier.getSid(), orders.getSid(), srcStatus, orders.getStatus(), supplier.getCname() + "：未通过换货申请," + reason);
                                    Integer srcParentStatus = parentOrders.getStatus();
                                    parentOrders.setStatus(3);
                                    repository.save(parentOrders);
                                    ordersLogService.saveOrdersLog(supplier.getSid(), parentOrders.getSid(), srcParentStatus, parentOrders.getStatus(), supplier.getCname() + "：子订单未通过换货申请");
                                    successCount += 1;
                                }
                            } else if (srcStatus == 8) {
                                if (flagStatus) {
                                    //通过退货请求
                                    //退款
                                    //                                    boolean flag = this.refundOrders(orders.getSid(), orders.getPayAmount(), parentOrders.getChannel(), parentOrders.getShopKeeper());
                                    Map<String,Object> resultMap=this.refundOrders(parentOrders.getSid(), orders.getPayAmount(), parentOrders.getChannel(), parentOrders.getShopKeeper());
                                    boolean flag = (boolean) resultMap.get("flag");
                                    if (flag) {

                                        orders.setStatus(6);
                                        repository.save(orders);
                                        String msg="";
                                        if(resultMap.containsKey("msg")){
                                            msg= resultMap.get("msg").toString();
                                        }
                                        ordersLogService.saveOrdersLog(supplier.getSid(), orders.getSid(), srcStatus, orders.getStatus(), supplier.getCname() + "：通过退货申请，退款成功"+msg);
                                        Integer srcParentStatus = parentOrders.getStatus();
                                        parentOrders.setStatus(6);
                                        repository.save(parentOrders);
                                        ordersLogService.saveOrdersLog(supplier.getSid(), parentOrders.getSid(), srcParentStatus, parentOrders.getStatus(), supplier.getCname() + "：子订单退货成功");
                                        successCount += 1;
                                    } else {
                                        failCount += 1;
                                    }
                                } else {
                                    //不通过退货请求
                                    orders.setStatus(3);
                                    repository.save(orders);
                                    ordersLogService.saveOrdersLog(supplier.getSid(), orders.getSid(), srcStatus, orders.getStatus(), supplier.getCname() + "：未通过退货申请," + reason);
                                    Integer srcParentStatus = parentOrders.getStatus();
                                    parentOrders.setStatus(3);
                                    repository.save(parentOrders);
                                    ordersLogService.saveOrdersLog(supplier.getSid(), parentOrders.getSid(), srcParentStatus, parentOrders.getStatus(), supplier.getCname() + "：子订单退货未通过");
                                    successCount += 1;
                                }
                            }
                        } else {
                            //没有被分单
                            if (srcStatus == 9) {
                                if (flagStatus) {
                                    //通过换货请求
                                    orders.setStatus(3);
                                    repository.save(orders);
                                    ordersLogService.saveOrdersLog(supplier.getSid(), orders.getSid(), srcStatus, orders.getStatus(), supplier.getCname() + "：通过换货申请");
                                    successCount += 1;
                                } else {
                                    //不通过换货请求
                                    orders.setStatus(3);
                                    repository.save(orders);
                                    ordersLogService.saveOrdersLog(supplier.getSid(), orders.getSid(), srcStatus, orders.getStatus(), supplier.getCname() + "：未通过换货申请," + reason);
                                    successCount += 1;
                                }
                            } else if (srcStatus == 8) {
                                if (flagStatus) {
                                    //通过退货请求
                                    //退款
                                    //                                    boolean flag = this.refundOrders(orders.getSid(), orders.getPayAmount(), orders.getChannel(), orders.getShopKeeper());
                                    Map<String,Object> resultMap= this.refundOrders(orders.getSid(), orders.getPayAmount(), orders.getChannel(), orders.getShopKeeper());
                                    boolean flag = (boolean) resultMap.get("flag");
                                    if (flag) {

                                        orders.setStatus(6);
                                        repository.save(orders);
                                        String msg="";
                                        if(resultMap.containsKey("msg")){
                                            msg= resultMap.get("msg").toString();
                                        }
                                        ordersLogService.saveOrdersLog(supplier.getSid(), orders.getSid(), srcStatus, orders.getStatus(), supplier.getCname() + "：通过退货申请，退款成功"+msg);

                                        successCount += 1;
                                    } else {
                                        failCount += 1;
                                    }
                                } else {
                                    //不通过退货请求
                                    orders.setStatus(3);
                                    repository.save(orders);
                                    ordersLogService.saveOrdersLog(supplier.getSid(), orders.getSid(), srcStatus, orders.getStatus(), supplier.getCname() + "：未通过退货申请," + reason);
                                    successCount += 1;
                                }
                            }
                        }

                    } else {
                        failCount += 1;
                    }

                }
                resultFlag = true;
            } else {
                resultFlag = false;
            }

        } catch (Exception e) {
            resultFlag = false;
        }
        map.put("resultFlag", resultFlag);
        map.put("successCount", successCount);
        map.put("failCount", failCount);
        return map;
    }

    /**
     * 判断支付方式
     *
     * @param ordersSid
     * @param amount
     * @param channel
     * @return
     */
    public  Map<String,Object> refundOrders(Long ordersSid, BigDecimal amount, Integer channel, ShopKeeper shopKeeper) {

        //        boolean flag = false;
        Map<String,Object> map=new HashMap<>();
        if (!Utils.isNull(channel)) {

            if (channel == 3) {
                //                map = refundOrderService.refundToCredit(ordersSid, amount, shopKeeper);
                map = refundOrderService.refundToWeChatOrAlipay(ordersSid, amount);
            } else if (channel == 1) {
                map = refundOrderService.refundToWeChatOrAlipay(ordersSid, amount);
            } else if (channel == 2) {
                map = refundOrderService.refundToWeChatOrAlipay(ordersSid, amount);
            }
            //            else if(channel == 4){
            //                Orders orders=repository.findOne(ordersSid);
            //                if(!Utils.isNull(orders)){
            //                    if(!Utils.isNull(orders.getParentOrderSid())){
            //                        Orders parentOrders=repository.findOne(orders.getParentOrderSid());
            //                        if(!Utils.isNull(parentOrders)){
            //                            map=refundOrderService.refundToBankCard(parentOrders.getBillNo(),amount);
            //                        }else{
            ////                            flag=false;
            //                            map.put("flag",false);
            //                        }
            //
            //                    }else{
            //                       map=refundOrderService.refundToBankCard(orders.getBillNo(),amount);
            //                    }
            //                }
            //                else{
            ////                    flag=false;
            //                    map.put("flag",false);
            //                }
            //            }
            else if(channel == 4){
                map = refundOrderService.refundToCredit(ordersSid, amount, shopKeeper);
            }
            else {
                //                flag = false;
                map.put("flag",false);
            }
        }
        return map ;
    }
    @Override
    public List<Long> deleteByNoPaymentOrders(Date targetTime) {
        return repository.deleteByNoPaymentOrders(targetTime);
    }
}

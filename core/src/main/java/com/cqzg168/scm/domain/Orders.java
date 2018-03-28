package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * 订单实体类
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "orders")
public class Orders extends BaseDomain {
    private static final long serialVersionUID = 1669376238664845663L;
    /**
     * 商户SID
     */
//    @Column(nullable = false)
//    private Long       shopKeeperSid;
    @ManyToOne(targetEntity = ShopKeeper.class, cascade = {CascadeType.MERGE, CascadeType.REFRESH})
    @JoinColumn(name = "shop_keeper_sid", referencedColumnName = "sid", nullable = false)
    private ShopKeeper shopKeeper;
    /**
     * 应付金额
     */
    @Column(nullable = false)
    private BigDecimal totalAmount;
    /**
     * 实付金额
     */
    @Column(nullable = false)
    private BigDecimal payAmount;
    /**
     * 订单类别：1、采购订单；2、收款订单
     */
    @Column(nullable = false)
    private Integer type;
    /**
     * 支付渠道
     */
    @Column
    private Integer channel;
    /**
     * 父单订单号
     */
    @Column
    private Long parentOrderSid;
    /**
     * 省
     */
    @Column(nullable = false)
    private String province;
    /**
     * 市
     */
    @Column(nullable = false)
    private String city;
    /**
     * 区
     */
    @Column(nullable = false)
    private String area;
    /**
     * 收货地址
     */
    @Column(nullable = false)
    private String address;
    /**
     * 物流单号
     */
    @Column
    private String logisticsNo;

    /**
     * 物流公司
     */
    @Column
    private String logisticsCompany;
    /**
     * 供货商SID
     */
    @Column
    private Long supplierSid;
    /**
     * 供货商名称
     */
    @Column
    private String supplierCname;
    /**
     * 是否冻结
     */
    @Column
    private Integer freeze;

    @OneToMany(mappedBy = "orders")
    private List<OrdersGoods> ordersGoodsList;

    @OneToMany
    @JoinColumn(name = "parentOrderSid")
    private List<Orders> childrenOrders = new ArrayList<>();
    /**
     * 商品日志
     */
    @OneToMany
    @JoinColumn(name = "ordersSid")
    @OrderBy("createTime DESC ")
    private List<OrdersLog> ordersLogs;

    /**
     * 支付订单号
     */
    @Column
    private String billNo;

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getPayAmount() {
        return payAmount;
    }

    public void setPayAmount(BigDecimal payAmount) {
        this.payAmount = payAmount;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public Integer getChannel() {
        return channel;
    }

    public void setChannel(Integer channel) {
        this.channel = channel;
    }

    public Long getParentOrderSid() {
        return parentOrderSid;
    }

    public void setParentOrderSid(Long parentOrderSid) {
        this.parentOrderSid = parentOrderSid;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getLogisticsNo() {
        return logisticsNo;
    }

    public void setLogisticsNo(String logisticsNo) {
        this.logisticsNo = logisticsNo;
    }

    public Long getSupplierSid() {
        return supplierSid;
    }

    public void setSupplierSid(Long supplierSid) {
        this.supplierSid = supplierSid;
    }

    public String getSupplierCname() {
        return supplierCname;
    }

    public void setSupplierCname(String supplierCname) {
        this.supplierCname = supplierCname;
    }

    public List<OrdersGoods> getOrdersGoodsList() {
        return ordersGoodsList;
    }

    public void setOrdersGoodsList(List<OrdersGoods> ordersGoodsList) {
        this.ordersGoodsList = ordersGoodsList;
    }

    public Integer getFreeze() {
        return freeze;
    }

    public void setFreeze(Integer freeze) {
        this.freeze = freeze;
    }

    public ShopKeeper getShopKeeper() {
        return shopKeeper;
    }

    public void setShopKeeper(ShopKeeper shopKeeper) {
        this.shopKeeper = shopKeeper;
    }

    public List<Orders> getChildrenOrders() {
        return childrenOrders;
    }

    public void setChildrenOrders(List<Orders> childrenOrders) {
        this.childrenOrders = childrenOrders;
    }

    public String getLogisticsCompany() {
        return logisticsCompany;
    }

    public void setLogisticsCompany(String logisticsCompany) {
        this.logisticsCompany = logisticsCompany;
    }

    public List<OrdersLog> getOrdersLogs() {
        return ordersLogs;
    }

    public void setOrdersLogs(List<OrdersLog> ordersLogs) {
        this.ordersLogs = ordersLogs;
    }

    public String getBillNo() {
        return billNo;
    }

    public void setBillNo(String billNo) {
        this.billNo = billNo;
    }
}

package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Constant;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * 商品实体类
 * Created by think on 2017/4/26.
 */
@Entity
@Table(name = Constant.TABLE_PREFIX + "goods")
public class Goods extends BaseDomain {

    private static final long serialVersionUID = 2525773239065729784L;
    /**
     * 商品名称
     */
    @Column(nullable = false)
    private String cname;

    /**
     * 大类SID
     */
//    @Column( nullable = false)
//    private Long firstCategorySid;
    @ManyToOne(targetEntity = GoodsCategory.class, cascade = {CascadeType.MERGE, CascadeType.MERGE})
    @JoinColumn(name = "first_category_sid", referencedColumnName = "sid", nullable = false)
    private GoodsCategory goodsCategoryOne;
    /**
     * 小类SID
     */
//    @Column( nullable = false)
//    private Long secondCategorySid;
    @ManyToOne(targetEntity = GoodsCategory.class, cascade = {CascadeType.MERGE, CascadeType.REFRESH})
    @JoinColumn(name = "second_category_sid", referencedColumnName = "sid", nullable = false)
    private GoodsCategory goodsCategoryTwo;
//    /**
//     * 供应商列表
//     */
//    @ManyToMany(fetch = FetchType.EAGER)
//    @JoinTable(name = Constant.TABLE_PREFIX + "goods_supplier", joinColumns = {@JoinColumn(name = "goods_sid")}, inverseJoinColumns = {@JoinColumn(name = "supplier_sid")})
//    private List<Supplier> supplierList = new ArrayList<>();
    /**
     * 供应商
     */
    @ManyToOne(targetEntity = Supplier.class, cascade = {CascadeType.MERGE, CascadeType.REFRESH})
    @JoinColumn(name = "supplier_sid", referencedColumnName = "sid", nullable = false)
    private Supplier supplier;
    /**
     * 商品规格
     */
    @OneToMany
    @JoinColumn(name = "goodsSid")
    private List<GoodsSpecification> goodsSpecifications;

    /**
     * 商品图片
     *
     * @return
     */
    @OneToMany
    @JoinColumn(name = "goodsSid")
    private List<GoodsFile> goodsFiles;
    /**
     * 是否自由商品
     */
    @Column
    private Integer freeGoods=0;
    /**
     * 商品条码
     */
    @Column
    private String goodsBarcode;
    /**
     * 商品统一编码
     */
    @Column
    private String unifiedCode;
    /**
     * 商品日志
     */
    @OneToMany
    @JoinColumn(name = "goodsSid")
    @OrderBy("createTime DESC ")
    private List<GoodsLog> goodsLogs;

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

//    public Long getFirstCategorySid() {
//        return firstCategorySid;
//    }
//
//    public void setFirstCategorySid(Long firstCategorySid) {
//        this.firstCategorySid = firstCategorySid;
//    }
//
//    public Long getSecondCategorySid() {
//        return secondCategorySid;
//    }
//
//    public void setSecondCategorySid(Long secondCategorySid) {
//        this.secondCategorySid = secondCategorySid;
//    }

//    public List<Supplier> getSupplierList() {
//        return supplierList;
//    }
//
//    public void setSupplierList(List<Supplier> supplierList) {
//        this.supplierList = supplierList;
//    }

    public GoodsCategory getGoodsCategoryOne() {
        return goodsCategoryOne;
    }

    public void setGoodsCategoryOne(GoodsCategory goodsCategoryOne) {
        this.goodsCategoryOne = goodsCategoryOne;
    }

    public GoodsCategory getGoodsCategoryTwo() {
        return goodsCategoryTwo;
    }

    public void setGoodsCategoryTwo(GoodsCategory goodsCategoryTwo) {
        this.goodsCategoryTwo = goodsCategoryTwo;
    }

    public List<GoodsSpecification> getGoodsSpecifications() {
        return goodsSpecifications;
    }

    public void setGoodsSpecifications(List<GoodsSpecification> goodsSpecifications) {
        this.goodsSpecifications = goodsSpecifications;
    }

    public List<GoodsFile> getGoodsFiles() {
        return goodsFiles;
    }

    public void setGoodsFiles(List<GoodsFile> goodsFiles) {
        this.goodsFiles = goodsFiles;
    }

    public Integer getFreeGoods() {
        return freeGoods;
    }

    public void setFreeGoods(Integer freeGoods) {
        this.freeGoods = freeGoods;
    }

    public List<GoodsLog> getGoodsLogs() {
        return goodsLogs;
    }

    public void setGoodsLogs(List<GoodsLog> goodsLogs) {
        this.goodsLogs = goodsLogs;
    }

    public String getGoodsBarcode() {
        return goodsBarcode;
    }

    public void setGoodsBarcode(String goodsBarcode) {
        this.goodsBarcode = goodsBarcode;
    }

    public String getUnifiedCode() {
        return unifiedCode;
    }

    public void setUnifiedCode(String unifiedCode) {
        this.unifiedCode = unifiedCode;
    }

    public Supplier getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }

    public Goods(){};
    public Goods(Long sid,String cname){
        super();
        this.sid=sid;
        this.cname=cname;
    }
}

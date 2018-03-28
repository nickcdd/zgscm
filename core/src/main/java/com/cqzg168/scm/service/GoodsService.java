package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.Goods;
import com.cqzg168.scm.domain.Supplier;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
public interface GoodsService extends BaseService<Goods> {
    /**
     * 分页查询
     *
     * @param q
     * @param bigCategory
     * @param smallCategory
     * @param price
     * @param freeGoods
     * @param defaultStatus
     * @param status
     * @param pageable
     * @return
     */
    Page<Goods> findGoodsByPage(Long supplierSid,String q, String bigCategory, String smallCategory, String price, Integer freeGoods, List<Integer> defaultStatus, Integer status, Pageable pageable);

    /**
     * 分页查询所有商品
     *
     * @param cname
     * @param bigCategory
     * @param smallCategory
     * @param status
     * @param pageable
     * @return
     */
    Page<Goods> findAllGoodsPage(String cname, String bigCategory, String smallCategory, Integer status, Pageable pageable);

    /**
     * 分页查询单个供应商所有商品
     *
     * @param cname
     * @param supplierSid
     * @param status
     * @param pageable
     * @return
     */
    Page<Goods> findBySuppliergoodsPage(String cname, Long supplierSid, Integer status, Pageable pageable);

    Page<Goods> findBycategorySid(String cname, Long categorySid, Integer status, Pageable pageable);


    /**
     * 批量修改状态
     *
     * @param goodsSids
     * @param status
     * @return
     */
    boolean batchUpdateStatus(Long managerSid, List<Long> goodsSids, Integer status, String note);

    /**
     * 根据统一编码查询商品
     *
     * @param unifiedCode
     * @return
     */
    List<Goods> findByUnifiedCode(String unifiedCode);

    /**
     * 根据商品名称查询
     * @param cname
     * @return
     */
    List<Goods> findByCname(String cname);

    /**
     * 根据商品名称模糊查询
     * @param goodsName
     * @return
     */
    List<Goods> findByGoodsName(String goodsName);
    List<Goods> findByLikeGoodsName(String goodsName,Long supplierSid);

    Goods findBySid(Long sid);
}

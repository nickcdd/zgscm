package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.GoodsSpecification;

import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
public interface GoodsSpecificationService extends BaseService<GoodsSpecification> {

    boolean saveOrUpdate(Long sid, String result);

    /**
     * 根据商品规格商品sid查询商品
     *
     * @param goodsSid
     * @param cname
     * @return
     */
    GoodsSpecification findGoodsSpecificationByCname(Long goodsSid, String cname);

    List<GoodsSpecification> findByGoodsBm(String goodsBm);

    List<GoodsSpecification> findByGoodsSid(Long goodsSid);
}

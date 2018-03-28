package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.GoodsSpecification;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 商品规格数据操作接口
 * Created by think on 2017/4/27.
 */
@Repository
public interface GoodsSpecificationRepository extends BaseRepository<GoodsSpecification> {

    /**
     * 根据商品规格商品sid查询商品
     *
     * @param goodsSid
     * @param cname
     * @return
     */
    @Query("select g from GoodsSpecification g where g.goodsSid = ?1 and g.cname = ?2 and g.status = 1")
    GoodsSpecification findGoodsSpecificationByCname(Long goodsSid, String cname);

    List<GoodsSpecification> findByGoodsBm(String goodsBm);

    @Query("select new GoodsSpecification(g.sid,g.cname,g.goodsBm,g.barcode) from GoodsSpecification g where g.goodsSid = ?1  and g.status = 1")
    List<GoodsSpecification> findByGoodsSid(Long goodsSid);
}

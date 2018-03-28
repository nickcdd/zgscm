package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.GoodsCategory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
public interface GoodsCategoryService extends BaseService<GoodsCategory> {
    /**
     * 分页商品类别列表
     *
     * @param q
     * @param pageable
     * @return
     */
    Page<GoodsCategory> findByPage(String q, int status, Pageable pageable);

    /**
     * 查询商品类别
     *
     * @param sid
     * @return
     */
    List<GoodsCategory> findGoodsCategory(Long sid, Long parentSid, Integer status);

    /**
     * 根据父id查询
     *
     * @param parentSid
     * @return
     */
    List<GoodsCategory> findByParentSid(Long parentSid);

    /**
     * 根据上级id和状态查询
     *
     * @param parentSid
     * @param status
     * @return
     */
    List<GoodsCategory> findByParentSidAndStatus(Long parentSid, int status);

    List<GoodsCategory> findByCname(String cname);
}

package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.Goods;
import com.cqzg168.scm.domain.Supplier;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 商品数据操作接口
 * Created by think on 2017/4/27.
 */
@Repository
public interface GoodsRepository extends BaseRepository<Goods> {

    List<Goods> findByUnifiedCode(String unifiedCode);
    List<Goods> findByCname(String cname);
    @Query("select g from Goods g  where g.cname like CONCAT('%',:goodsName,'%') ")
    List<Goods> findByGoodsName(@Param("goodsName") String goodsName);

    @Query("select new Goods(g.sid,g.cname) from Goods g  where g.cname like CONCAT('%',:goodsName,'%') and g.supplier.sid=:supplierSid")
    List<Goods> findByLikeGoodsName(@Param("goodsName") String goodsName,@Param("supplierSid")Long supplierSid);

    Goods findBySid(Long sid);
}

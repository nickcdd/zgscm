package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.AfterSale;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by jackytsu on 2017/3/15.
 */
@Repository
public interface AfterSaleRepository extends BaseRepository<AfterSale> {

    @Query("select a from AfterSale a where a.ordersSid = ?1 and a.status = 1")
    List<AfterSale> afterSales(Long orderid);
}

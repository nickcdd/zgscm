package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.*;
import com.cqzg168.scm.dto.InventoryDto;
import com.cqzg168.scm.dto.InventoryVo;
import com.cqzg168.scm.repository.InventoryRepository;
import com.cqzg168.scm.service.*;
import com.cqzg168.scm.utils.DateUtil;
import com.cqzg168.scm.utils.Utils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.Path;
import javax.persistence.criteria.Predicate;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class InventoryServiceImpl extends BaseServiceImpl<Inventory, InventoryRepository> implements InventoryService {
    private InventoryRepository       repository;
    @Autowired
    private GoodsService              goodsService;
    @Autowired
    private CxfUtilsService           cxfUtilsService;
    @Autowired
    private GoodsSpecificationService goodsSpecificationService;
    @Value("${yuntong_cwbm_one}")
    private String                    yuntongCwbmOne;
    @Autowired
    @Override
    public void setRepository(InventoryRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }
    @PersistenceContext
    private EntityManager em;

    @Override
    public Page<Inventory> findEnventoryByPage(Long supplierSid,String goodsName, String storageSid, Pageable pageable) {
        Specification<Inventory> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (!Utils.isEmpty(goodsName)) {
//                List<Goods> list=goodsService.findByGoodsName(goodsName);
//                CriteriaBuilder.In<Long> in = cb.in(root.get("sid"));
//                if(list.size()>0){
//                    for(Goods goods:list){
//                        List<GoodsSpecification> specificationList=goods.getGoodsSpecifications();
//                        if(specificationList.size()>0){
//                            for(GoodsSpecification goodsSpecification:specificationList){
//                                List<Inventory> inventoryList=goodsSpecification.getInventoryList();
//                                if(inventoryList.size()>0){
//                                    for(Inventory inventory:inventoryList){
//                                        in.value(inventory.getSid());
//                                    }
//                                    predicates.add(in);
//                                }
//                            }
//                        }
//                    }
//                }
                Path<Goods> goods = root.get("goods");
                predicates.add(cb.like(goods.get("cname"),"%" + goodsName + "%"));
            }
            if(!Utils.isNull(supplierSid)){
                Path<Goods> goods = root.get("goods");
                Path<Supplier> supplierPath=goods.get("supplier");
                predicates.add(cb.equal(supplierPath.get("sid"),supplierSid));
            }
            if (!Utils.isEmpty(storageSid)) {
                Path<Storage> storage = root.get("storage");
                predicates.add(cb.equal(storage.get("sid"), Long.parseLong(storageSid)));
            }
            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };

        return repository.findAll(specification, pageable);
    }

    /**
     * 根据商品规格sid 查询 商品库存
     * @param goodsSpecification
     * @return
     */
    @Override
    public Inventory findBySpecificationSidInventory(GoodsSpecification goodsSpecification){
        return  repository.findBySpecificationSidInventory(goodsSpecification);
    }
    @Override
    public List<Inventory> checkInventory(Long goodsSid, Long specificationSid, Long storageSid) {
        return repository.checkInventory(goodsSid,specificationSid,storageSid);
    }
    /**
     * 获得商品库存
     *
     * @param goodsBm
     * @return
     */
    @Override
    public Long getGoodsInventory(String goodsBm, Long goodsSpecificationSid) {
        GoodsSpecification goodsSpecification = goodsSpecificationService.findOne(goodsSpecificationSid);
        Goods              goods              = goodsService.findOne(goodsSpecification.getGoodsSid());
        Long               inventory = 0L;
        //判断是否平台商品
        if (goods.getSupplier().getSid() == -1) {
            if (Utils.isEmpty(goodsBm)) {
                return 0L;
            }
            String[] params = new String[2];
            params[0] = goodsBm;
            params[1] = yuntongCwbmOne;
            String     s          = "getspkcsl";
            String     result     = cxfUtilsService.callWebService(s, params);
            BigDecimal bigDecimal = new BigDecimal(result);
            inventory = bigDecimal.longValue();
            Integer saleCount = goodsSpecification.getSaleCount();
            if (saleCount != null) {
                inventory = inventory / saleCount;
            }
        }else {
            Inventory inventoryDomian = repository.findBySpecificationSidInventory(goodsSpecification);
            if(inventoryDomian != null){
                inventory = (long) inventoryDomian.getAmount();
            }
        }
        //真实库存 减去订单还未发货的商品
        Long tureInventory = inventory - getOrdersGoodsAmount(goodsSpecificationSid);
        if (tureInventory > 0) {
            return tureInventory;
        } else {
            return 0L;
        }

    }
    protected Long getOrdersGoodsAmount(Long goodsSpecificationSid) {
        Query query = null;
        //获得 订单状态为2、7 。商品为传入商品规格id的商品数量
        String hql = "SELECT SUM(og.goodsCount) FROM OrdersGoods og,Orders o where og.orders.sid = o.sid and o.status in (1,2,7) and og.status = 1 and og.goodsSpecification.sid = :goodsSpecificationSid";
        query = em.createQuery(hql);
        query.setParameter("goodsSpecificationSid", goodsSpecificationSid);
        Object result       = query.getSingleResult();
        Long   resultAmount = 0L;
        if (result != null) {
            resultAmount = (Long) result;
        }
        return resultAmount;
    }
}

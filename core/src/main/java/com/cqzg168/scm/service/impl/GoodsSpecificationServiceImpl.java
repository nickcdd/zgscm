package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.GoodsSpecification;
import com.cqzg168.scm.repository.GoodsSpecificationRepository;
import com.cqzg168.scm.service.GoodsSpecificationService;
import com.cqzg168.scm.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class GoodsSpecificationServiceImpl extends BaseServiceImpl<GoodsSpecification, GoodsSpecificationRepository> implements GoodsSpecificationService {
    private GoodsSpecificationRepository repository;

    @Autowired
    @Override
    public void setRepository(GoodsSpecificationRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    @Override
    public boolean saveOrUpdate(Long sid, String result) {
        //先以；分割
        String[] goodsSpecificationArrayOne = result.split(";");
        for (int i = 0; i < goodsSpecificationArrayOne.length; i++) {
            String[] goodsSpecificationArrayTwo = goodsSpecificationArrayOne[i].split(",", -1);
//            System.out.println(">>>>>>>>>>>>>>>>>" + goodsSpecificationArrayTwo.length);
            GoodsSpecification goodsSpecification = new GoodsSpecification();
            if (!Utils.isEmpty(goodsSpecificationArrayTwo[0])) {
                goodsSpecification = repository.findOne(Long.parseLong(goodsSpecificationArrayTwo[0]));
                goodsSpecification.setSid(Long.parseLong(goodsSpecificationArrayTwo[0]));
            }
            if (!Utils.isEmpty(goodsSpecificationArrayTwo[1])) {
                goodsSpecification.setCname(goodsSpecificationArrayTwo[1]);
            }
            if (!Utils.isEmpty(goodsSpecificationArrayTwo[2])) {
                goodsSpecification.setCost(new BigDecimal(goodsSpecificationArrayTwo[2]));
            }
            if (!Utils.isEmpty(goodsSpecificationArrayTwo[3])) {
                goodsSpecification.setPrice(new BigDecimal(goodsSpecificationArrayTwo[3]));
            }
            if (!Utils.isEmpty(goodsSpecificationArrayTwo[4])) {
                goodsSpecification.setSuggestPrice(new BigDecimal(goodsSpecificationArrayTwo[4]));
            }
            if (!Utils.isEmpty(goodsSpecificationArrayTwo[5])) {
                goodsSpecification.setStatus(Integer.parseInt(goodsSpecificationArrayTwo[5]));
            }

            if (!Utils.isEmpty(goodsSpecificationArrayTwo[6])) {
                goodsSpecification.setGoodsBm(goodsSpecificationArrayTwo[6]);
            }else{
                goodsSpecification.setGoodsBm("");
            }
            if (!Utils.isEmpty(goodsSpecificationArrayTwo[7])) {
                goodsSpecification.setSaleCount(Integer.parseInt(goodsSpecificationArrayTwo[7]));
            }else{
//                goodsSpecification.setGoodsBm("");
            }


            goodsSpecification.setGoodsSid(sid);
            goodsSpecification.setStatus(Integer.parseInt(goodsSpecificationArrayTwo[5]));
            repository.save(goodsSpecification);
        }

        return true;
    }

    @Override
    public GoodsSpecification findGoodsSpecificationByCname(Long goodsSid, String cname) {
        return repository.findGoodsSpecificationByCname(goodsSid, cname);
    }

    @Override
    public List<GoodsSpecification> findByGoodsBm(String goodsBm) {
        return repository.findByGoodsBm(goodsBm);
    }

    @Override
    public List<GoodsSpecification> findByGoodsSid(Long goodsSid) {
        return repository.findByGoodsSid(goodsSid);
    }

    public static void main(String[] args) {
        String resutl = ",1,2,3,";
        String[] list = resutl.split(",", -1);
        System.out.println(" >>>>>>>" + list.length);
        for (String s : list) {
            System.out.println("?" + s);
        }
    }
}

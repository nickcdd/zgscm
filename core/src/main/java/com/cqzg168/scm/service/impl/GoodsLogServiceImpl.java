package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.GoodsLog;
import com.cqzg168.scm.repository.GoodsLogRepository;
import com.cqzg168.scm.service.GoodsLogService;
import com.cqzg168.scm.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class GoodsLogServiceImpl extends BaseServiceImpl<GoodsLog, GoodsLogRepository> implements GoodsLogService {
    private GoodsLogRepository repository;

    @Autowired
    @Override
    public void setRepository(GoodsLogRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    @Override
    public boolean writeGoodsLog(Long managerSid,Long goodsSid, int srcStatus, int targetStatus, String note) {
        try{
            GoodsLog goodsLog =new GoodsLog();
            goodsLog.setManagerSid(managerSid);
            goodsLog.setGoodsSid(goodsSid);
            goodsLog.setSrcStatus(srcStatus);
            goodsLog.setTargetStatus(targetStatus);
            if(!Utils.isEmpty(note)){
                goodsLog.setNote(note);
            }
            repository.save(goodsLog);

        }catch (Exception e){
            e.printStackTrace();
            return false;
        }
        return false;
    }
}

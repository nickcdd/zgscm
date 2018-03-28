package com.cqzg168.scm.reseller.schedule;

import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.service.RebateService;
import com.cqzg168.scm.service.ResellerRebateService;
import com.cqzg168.scm.service.ShopKeeperService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.logging.Logger;

/**
 * Created by jackytsu on 2017/5/14.
 */
@Transactional
@Component
public class ResellerRebateTask {

    /*private final Logger logger = Logger.getLogger(ResellerRebateTask.class.getName());

    @Autowired
    private ShopKeeperService shopKeeperService;
    @Autowired
    private ResellerRebateService resellerRebateService;

    @Scheduled(cron = "0 0 0 * * ?")
    public void run() {
        List<ShopKeeper> shopKeeperList = shopKeeperService.findAllByStatus();


        for (ShopKeeper shopKeeper : shopKeeperList) {
            resellerRebateService.resellerRebate(shopKeeper.getSid());
        }

        logger.info("分销商返利定时任务执行完毕！");
    }*/
}

package com.cqzg168.scm.shopkeeper.schedule;

import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.service.RebateService;
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
public class ShopKeeperSettleAccountTask {

   /* private final Logger logger = Logger.getLogger(ShopKeeperSettleAccountTask.class.getName());

    @Autowired
    private ShopKeeperService shopKeeperService;
    @Autowired
    private RebateService rebateService;

    @Scheduled(cron = "0 0 0 * * ?")
    public void run() {
        List<ShopKeeper> shopKeeperList = shopKeeperService.findAll();

        logger.info("开始执行解冻商户冻结余额定时任务！");

        for (ShopKeeper shopKeeper : shopKeeperList) {
            logger.info(String.format("开始解冻商户余额：SID：%s，名称：%s", shopKeeper.getSid(), shopKeeper.getCname()));
            shopKeeperService.unfrozenBlance(shopKeeper.getSid());
            rebateService.rebateLogic(shopKeeper);
            logger.info("解冻完毕！");
        }

        logger.info("解冻商户冻结余额定时任务执行完毕！");
    }*/
}

package com.cqzg168.scm.utils;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

/**
 * Created by jackytsu on 2017/5/14.
 */
@Component
@PropertySource("classpath:/rebate.properties")
@ConfigurationProperties(prefix = "rebate")
public class RebateConfig {
    /**
     * 返利比例
     */
    private BigDecimal[] rate;
    /**
     * 每天返利限额
     */
    private BigDecimal[] perDayLimit;
    /**
     * 每商户返利限额
     */
    private BigDecimal[] perShopKepper;
    /**
     * 所有商户返现总金额
     */
    private BigDecimal[] max;

    public BigDecimal[] getRate() {
        return rate;
    }

    public void setRate(BigDecimal[] rate) {
        this.rate = rate;
    }

    public BigDecimal[] getPerDayLimit() {
        return perDayLimit;
    }

    public void setPerDayLimit(BigDecimal[] perDayLimit) {
        this.perDayLimit = perDayLimit;
    }

    public BigDecimal[] getPerShopKepper() {
        return perShopKepper;
    }

    public void setPerShopKepper(BigDecimal[] perShopKepper) {
        this.perShopKepper = perShopKepper;
    }

    public BigDecimal[] getMax() {
        return max;
    }

    public void setMax(BigDecimal[] max) {
        this.max = max;
    }
}

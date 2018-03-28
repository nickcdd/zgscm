package com.cqzg168.scm.dto;

import com.cqzg168.scm.domain.Inventory;

/**
 * Created by Administrator on 2017/7/28 0028.
 */
public class InventoryDto extends Inventory {
    private InventoryVo inventoryVo;

    public InventoryDto() {

        super();
    }

    public InventoryVo getInventoryVo() {
        return inventoryVo;
    }

    public void setInventoryVo(InventoryVo inventoryVo) {
        this.inventoryVo = inventoryVo;
    }
}

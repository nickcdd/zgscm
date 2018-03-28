package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.Storage;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

/**
 * Created by think on 2017/4/27.
 */
public interface StorageService extends BaseService<Storage> {

    /**
     * 分页查询 仓储
     *
     * @param cname
     * @param code
     * @param province
     * @param city
     * @param area
     * @param pageable
     * @return
     */
    Page<Storage> findStoragePage(String cname, String code, String province, String city, String area, Pageable pageable);
}

package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.Supplier;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
public interface SupplierService extends BaseService<Supplier> {
    /**
     * 分页查询供应商列表
     *
     * @param q
     * @param pageable
     * @return
     */
    Page<Supplier> findByPage(String q, String province, String city, String area, Pageable pageable);

    /**
     * 上传供应商头像
     *
     * @param myavatar
     * @return
     */
    String uploadAvatar(MultipartFile myavatar) throws IOException;

    /**
     * 删除头像
     *
     * @param avatarUrl
     * @return
     */
    boolean deleteAvatar(String avatarUrl);

    /**
     * 不分页得到所有供应商
     *
     * @return
     */
    List<Supplier> findAllSupplier();

    /**
     * 根据用户名和密码查询供应商
     *
     * @param telephone 电话号码
     * @param password  密码
     * @return
     */
    Supplier findByTelephoneAndPassword(String telephone, String password);

    /**
     * 验证手机号是否已经注册
     * @param telephone
     * @return
     */
    boolean findByTelephone(String telephone,Long sid);
}

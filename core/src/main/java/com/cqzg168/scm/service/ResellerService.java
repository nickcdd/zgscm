package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.Reseller;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

/**
 * Created by think on 2017/4/27.
 */
public interface ResellerService extends BaseService<Reseller> {

    Page<Reseller> findByPage(String q, Pageable pageable);

    /**
     * 验证手机号是否已经注册
     *
     * @param telephone
     * @return
     */
    boolean findByTelephone(String telephone, Long sid);

    /**
     * 根据用户名和密码查询商户
     *
     * @param telephone 电话号码
     * @param password  密码
     * @return
     */
    Reseller findByTelephoneAndPassword(String telephone, String password);

    /**
     * 头像上传
     *
     * @param reseller
     * @param avatar
     * @throws Exception
     */
    void upAvatar(Reseller reseller, MultipartFile avatar) throws Exception;

    /**
     * 上传分销商头像
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
     * 修改分销商号码验证
     * @param sid
     * @param telephone
     * @return
     */
    Reseller findByTelephoneAndIsNotSid(Long sid, String telephone);
}

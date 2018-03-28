package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.ShopKeeper;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

/**
 * Created by think on 2017/4/27.
 */
public interface ShopKeeperService extends BaseService<ShopKeeper> {
    /**
     * 根据用户名和密码查询商户
     *
     * @param telephone
     * @param password
     * @return
     */
    ShopKeeper findByTelephoneAndPassword(String telephone, String password);

    /**
     * 修改商户号码验证
     * @param sid
     * @param telephone
     * @return
     */
    ShopKeeper findByTelephoneAndIsNotSid(Long sid, String telephone);

    /**
     * 根据用手机号码查询商户
     *
     * @param telephone
     * @return
     */
    ShopKeeper findShopKeeperByTelephone(String telephone);

    /**
     * 分页查询商户列表
     *
     * @param q
     * @param pageable
     * @return
     */
    Page<ShopKeeper> findByPage(String q, String province, String city, String area, Pageable pageable);

    /**
     * 头像上传
     *
     * @param shopKeeper
     * @param avatar
     * @throws Exception
     */
    void upAvatar(ShopKeeper shopKeeper, MultipartFile avatar) throws Exception;

    /**
     * 上传商户头像
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
     * 更新指定商户冻结余额
     *
     * @param sid
     */
    void updateFrozenBalance(Long sid);

    /**
     * 解冻商户冻结余额
     *
     * @param sid
     */
    void unfrozenBlance(Long sid);

    /**
     * 统计商户总数
     *
     * @return
     */
    List<Integer> shopKeeperTotalByLevel();

    /**
     * 验证手机号是否已经注册
     *
     * @param telephone
     * @return
     */
    boolean findByTelephone(String telephone, Long sid);

    /**
     * 查询所有有效商户
     * @return
     */
    List<ShopKeeper> findAllByStatus();
}

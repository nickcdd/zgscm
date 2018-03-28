package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.ShopKeeper;
import com.cqzg168.scm.repository.OrdersRepository;
import com.cqzg168.scm.repository.ShopKeeperRepository;
import com.cqzg168.scm.service.ShopKeeperService;
import com.cqzg168.scm.utils.RebateConfig;
import com.cqzg168.scm.utils.Utils;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.persistence.criteria.Predicate;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class ShopKeeperServiceImpl extends BaseServiceImpl<ShopKeeper, ShopKeeperRepository> implements ShopKeeperService {

    private ShopKeeperRepository repository;

    @Autowired
    private OrdersRepository ordersRepository;

    @Autowired
    private RebateConfig rebateConfig;

    //上传图片路径
    @Value("${upload_path}")
    private String uploadPath;

    @Autowired
    @Override
    public void setRepository(ShopKeeperRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    @Override
    public ShopKeeper findByTelephoneAndPassword(String telephone, String password) {
        return repository.findByTelephoneAndPassword(telephone, password);
    }

    /**
     * 修改商户号码验证
     *
     * @param sid
     * @param telephone
     * @return
     */
    @Override
    public ShopKeeper findByTelephoneAndIsNotSid(Long sid, String telephone) {
        return repository.findByTelephoneAndIsNotSid(sid, telephone);
    }

    /**
     * 根据用手机号码查询商户
     *
     * @param telephone
     * @return
     */
    public ShopKeeper findShopKeeperByTelephone(String telephone) {
        return repository.findShopKeeperByTelephone(telephone);
    }

    @Override
    public Page<ShopKeeper> findByPage(String q, String province, String city, String area, Pageable pageable) {
        Specification<ShopKeeper> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (!Utils.isEmpty(q)) {

                predicates.add(cb.like(root.get("cname"), "%" + q + "%"));
            }
            if (!Utils.isEmpty(province)) {
                predicates.add(cb.equal(root.get("province"), province));
            }
            if (!Utils.isEmpty(city)) {
                predicates.add(cb.equal(root.get("city"), city));
            }
            if (!Utils.isEmpty(area)) {
                predicates.add(cb.equal(root.get("area"), area));
            }

            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };

        return repository.findAll(specification, pageable);
    }

    @Override
    public void upAvatar(ShopKeeper shopKeeper, MultipartFile avatar) throws Exception {
        File dir = new File(uploadPath + "/shopKeeperAvatar");
        if (!dir.exists()) {
            dir.mkdirs();
        }
        MultipartFile file = (MultipartFile) avatar;
        // 图片原始名称
        String originalFilename = file.getOriginalFilename();
        // 新的图片名称
        String newFileName = UUID.randomUUID() + originalFilename.substring(originalFilename.lastIndexOf("."));
        // 新图片
        File newFile = new File(dir.getAbsolutePath(), newFileName);
        newFile.createNewFile();
        // 将内存中的数据写入磁盘
        file.transferTo(newFile);

        //删除原有头像
        if (shopKeeper.getAvatar() != null && shopKeeper.getAvatar() != "") {
            String urlArray[] = shopKeeper.getAvatar().split("/");
            String oldAvatar = urlArray[urlArray.length - 1];
            File fileOld = new File(uploadPath + "/shopKeeperAvatar/" + oldAvatar);//文件路径
            fileOld.delete();
        }
        //将新图片路径放入数据库
        shopKeeper.setAvatar("/attachment/shopKeeperAvatar/" + newFileName);
        repository.save(shopKeeper);
    }

    @Override
    public String uploadAvatar(MultipartFile myavatar) throws IOException {
        String fileOriginalName = myavatar.getOriginalFilename();
        //新图片名称
        String newFileName = UUID.randomUUID() + fileOriginalName.substring(fileOriginalName.lastIndexOf("."));

        File dir = new File(uploadPath + "/shopKeeperAvatar");
        if (!dir.exists()) {
            dir.mkdirs();
        }
        File newFile = new File(dir.getAbsolutePath() + File.separator + newFileName);

        newFile.createNewFile();

        myavatar.transferTo(newFile);

        return "shopKeeperAvatar/" + newFileName;
    }

    @Override
    public boolean deleteAvatar(String avatarUrl) {
        try {
            File file = new File(uploadPath + "shopKeeperAvatar/" + avatarUrl);//文件路径
            file.delete();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Transactional
    @Override
    public void updateFrozenBalance(Long sid) {
        ShopKeeper shopKeeper = repository.findOne(sid);
        Long frozenBalance = ordersRepository.sumFreezeOrdersByShopKeeperSid(shopKeeper);
        if (frozenBalance == null || frozenBalance < 0) {
            frozenBalance = 0L;
        }

        repository.updateFrozenBalance(new BigDecimal(frozenBalance), sid);
    }

    @Transactional
    @Override
    public void unfrozenBlance(Long sid) {
        ShopKeeper shopKeeper = repository.findOne(sid);
        DateTime today = DateTime.now().withTimeAtStartOfDay().minusDays(3);

        Long unfrozenBalance = ordersRepository.sumFreezeOrdersByShopKeeperSidAndCreateTime(shopKeeper, today.toDate());
        BigDecimal unfrozenBalanceAmount = BigDecimal.ZERO;

        if (unfrozenBalance != null) {
            unfrozenBalanceAmount = new BigDecimal(unfrozenBalance);
        }

        repository.updateFrozenBalanceAndBalance(unfrozenBalanceAmount, sid);

        ordersRepository.updateFreezeOrdersByShopKeeperSidAndCreateTime(shopKeeper, today.toDate());
    }

    /**
     * 统计商户总数
     *
     * @return
     */
    @Override
    public List<Integer> shopKeeperTotalByLevel() {
        return repository.shopKeeperTotalByLevel();
    }

    @Override
    public boolean findByTelephone(String telephone, Long sid) {
        ShopKeeper shopKeeper = repository.findByTelephone(telephone.trim());
        if (!Utils.isNull(shopKeeper)) {

            if (!Utils.isNull(sid)) {
                if (shopKeeper.getSid().equals(sid)) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        } else {

            return true;
        }
    }

    /**
     * 查询所有有效商户
     * @return
     */
    @Override
    public List<ShopKeeper> findAllByStatus(){
        return repository.findAllByStatus();
    }
}

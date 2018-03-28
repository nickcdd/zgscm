package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.Reseller;
import com.cqzg168.scm.repository.ResellerRepository;
import com.cqzg168.scm.service.ResellerService;
import com.cqzg168.scm.utils.Utils;
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
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class ResellerServiceImpl extends BaseServiceImpl<Reseller, ResellerRepository> implements ResellerService {
    private ResellerRepository repository;

    //上传图片路径
    @Value("${upload_path}")
    private String uploadPath;

    @Autowired
    @Override
    public void setRepository(ResellerRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    @Override
    public Page<Reseller> findByPage(String q, Pageable pageable) {
        Specification<Reseller> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (!Utils.isEmpty(q)) {

                predicates.add(cb.like(root.get("cname"), "%" + q + "%"));
            }

            return query.where(predicates.toArray(new Predicate[]{})).getRestriction();
        };

        return repository.findAll(specification, pageable);
    }

    @Override
    public boolean findByTelephone(String telephone, Long sid) {
        Reseller reseller = repository.findByTelephone(telephone.trim());
        if (!Utils.isNull(reseller)) {

            if (!Utils.isNull(sid)) {
                if (reseller.getSid().equals(sid)) {
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
     * 根据用户名和密码查询商户
     *
     * @param telephone 电话号码
     * @param password  密码
     * @return
     */
    @Override
    public Reseller findByTelephoneAndPassword(String telephone, String password) {
        return repository.findByTelephoneAndPassword(telephone, password);
    }

    @Override
    public void upAvatar(Reseller reseller, MultipartFile avatar) throws Exception {
        File dir = new File(uploadPath + "/resellerAvatar");
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
        if (reseller.getAvatar() != null && reseller.getAvatar() != "") {
            String urlArray[] = reseller.getAvatar().split("/");
            String oldAvatar = urlArray[urlArray.length - 1];
            File fileOld = new File(uploadPath + "/resellerAvatar/" + oldAvatar);//文件路径
            fileOld.delete();
        }
        //将新图片路径放入数据库
        reseller.setAvatar("/attachment/resellerAvatar/" + newFileName);
        repository.save(reseller);
    }

    @Override
    public String uploadAvatar(MultipartFile myavatar) throws IOException {
        String fileOriginalName = myavatar.getOriginalFilename();
        //新图片名称
        String newFileName = UUID.randomUUID() + fileOriginalName.substring(fileOriginalName.lastIndexOf("."));

        File dir = new File(uploadPath + "/resellerAvatar");
        if (!dir.exists()) {
            dir.mkdirs();
        }
        File newFile = new File(dir.getAbsolutePath() + File.separator + newFileName);

        newFile.createNewFile();

        myavatar.transferTo(newFile);

        return "resellerAvatar/" + newFileName;
    }

    @Override
    public boolean deleteAvatar(String avatarUrl) {
        try {
            File file = new File(uploadPath + "resellerAvatar/" + avatarUrl);//文件路径
            file.delete();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 修改分销商号码验证
     *
     * @param sid
     * @param telephone
     * @return
     */
    @Override
    public Reseller findByTelephoneAndIsNotSid(Long sid, String telephone) {
        return repository.findByTelephoneAndIsNotSid(sid, telephone);
    }
}

package com.cqzg168.scm.service.impl;


import com.cqzg168.scm.domain.Supplier;
import com.cqzg168.scm.repository.SupplierRepository;
import com.cqzg168.scm.service.SupplierService;
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
public class SupplierServiceImpl extends BaseServiceImpl<Supplier, SupplierRepository> implements SupplierService {
    //上传图片路径
    @Value("${upload_path}")
    private String uploadPath;
    private SupplierRepository repository;

    @Autowired
    @Override
    public void setRepository(SupplierRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    @Override
    public Page<Supplier> findByPage(String q, String province, String city, String area, Pageable pageable) {
        Specification<Supplier> specification = (root, query, cb) -> {
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
    public String uploadAvatar(MultipartFile myavatar) throws IOException {

        String fileOriginalName = myavatar.getOriginalFilename();
        //新图片名称
        String newFileName = UUID.randomUUID() + fileOriginalName.substring(fileOriginalName.lastIndexOf("."));

        File dir = new File(uploadPath + "/supplierAvatar");
        if (!dir.exists()) {
            dir.mkdirs();
        }
        File newFile = new File(dir.getAbsolutePath() + File.separator + newFileName);

        newFile.createNewFile();

        myavatar.transferTo(newFile);

        return "supplierAvatar/" + newFileName;
    }

    @Override
    public boolean deleteAvatar(String avatarUrl) {
        try {
            File file = new File(uploadPath + "supplierAvatar/" + avatarUrl);//文件路径
            file.delete();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public List<Supplier> findAllSupplier() {


        return repository.findAllSupplier();
    }

    @Override
    public Supplier findByTelephoneAndPassword(String telephone, String password) {
        return repository.findByTelephoneAndPassword(telephone, password);
    }

    @Override
    public boolean findByTelephone(String telephone,Long sid) {
        Supplier supplier=repository.findByTelephone(telephone.trim());
        if(!Utils.isNull(supplier)){

            if(!Utils.isNull(sid)) {
                if (supplier.getSid().equals(sid)) {
                    return true;
                }else{
                    return false;
                }
            }else{
                return false;
            }
        }else{
            return true;
        }

    }

}

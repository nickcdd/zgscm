package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.AfterSale;
import com.cqzg168.scm.repository.AfterSaleRepository;
import com.cqzg168.scm.service.AfterSaleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class AfterSaleServiceImpl extends BaseServiceImpl<AfterSale, AfterSaleRepository> implements AfterSaleService {
    private AfterSaleRepository repository;

    @Autowired
    @Override
    public void setRepository(AfterSaleRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    //上传图片路径
    @Value("${upload_path}")
    private String uploadPath;

    @Override
    public void uplaodPicture(Long orderid, MultipartFile[] myavatars) throws IOException {

        if (myavatars != null && myavatars.length > 0) {
            for (MultipartFile myavatar : myavatars) {
                AfterSale afterSale = new AfterSale();
                afterSale.setOrdersSid(orderid);
                String fileOriginaName = myavatar.getOriginalFilename();
                //新图片名称
                String newFileName = UUID.randomUUID() + fileOriginaName.substring(fileOriginaName.lastIndexOf("."));
                File dir = new File(uploadPath + "afterSalePhoto");
                if (!dir.exists()) {
                    dir.mkdir();
                }
                File newFile = new File(dir.getAbsolutePath(), newFileName);
                newFile.createNewFile();
                //数据写入磁盘
                myavatar.transferTo(newFile);
                afterSale.setPhoto("/attachment/afterSalePhoto/" + newFileName);
                repository.save(afterSale);
            }
        }
    }

    @Override
    public List<AfterSale> afterSales(Long orderid) {
        return repository.afterSales(orderid);
    }
}

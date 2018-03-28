package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.GoodsFile;
import com.cqzg168.scm.repository.GoodsFileRepository;
import com.cqzg168.scm.service.GoodsFileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

/**
 * Created by think on 2017/4/27.
 */
@Service
@Transactional
public class GoodsFileServiceImpl extends BaseServiceImpl<GoodsFile, GoodsFileRepository> implements GoodsFileService {
    //上传图片路径
    @Value("${upload_path}")
    private String uploadPath;
    private GoodsFileRepository repository;

    @Autowired
    @Override
    public void setRepository(GoodsFileRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    @Override
    public String uploadGoodsFile(MultipartFile myavatar) throws IOException {
        String fileOriginalName = myavatar.getOriginalFilename();
        //新图片名称
        String newFileName = UUID.randomUUID() + fileOriginalName.substring(fileOriginalName.lastIndexOf("."));

        File dir = new File(uploadPath + "/goodsFile");
        if (!dir.exists()) {
            dir.mkdirs();
        }
        File newFile = new File(dir.getAbsolutePath() + File.separator + newFileName);

        newFile.createNewFile();

        myavatar.transferTo(newFile);

        return "goodsFile/" + newFileName;
    }

    @Override
    public boolean deleteImg(String fileUrl) {
        try {
            File file = new File(uploadPath + "GoodsFile/" + fileUrl);//文件路径
            file.delete();
            return true;
        } catch (Exception e) {
            return false;
        }

    }
}

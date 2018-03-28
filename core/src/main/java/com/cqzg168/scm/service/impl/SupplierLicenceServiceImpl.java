package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.SupplierLicence;
import com.cqzg168.scm.repository.SupplierLicenceRepository;
import com.cqzg168.scm.service.SupplierLicenceService;
import com.cqzg168.scm.utils.Utils;
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
public class SupplierLicenceServiceImpl extends BaseServiceImpl<SupplierLicence, SupplierLicenceRepository> implements SupplierLicenceService {
    //上传图片路径
    @Value("${upload_path}")
    private String uploadPath;
    private SupplierLicenceRepository repository;

    @Autowired
    @Override
    public void setRepository(SupplierLicenceRepository repository) {
        this.repository = repository;
        baseRepository = repository;
    }

    @Override
    public String uploadLicence(MultipartFile uploadLicence) throws IOException {
        String fileOriginalName = uploadLicence.getOriginalFilename();
        //新图片名称
        String newFileName = UUID.randomUUID() + fileOriginalName.substring(fileOriginalName.lastIndexOf("."));

        File dir = new File(uploadPath + "/supplierLicence");
        if (!dir.exists()) {
            dir.mkdirs();
        }
        File newFile = new File(dir.getAbsolutePath() + File.separator + newFileName);

        newFile.createNewFile();

        uploadLicence.transferTo(newFile);

        return "supplierLicence/" + newFileName;
    }

    @Override
    public boolean deleteLicence(String licenceUrl) {
        try {
            File file = new File(uploadPath + "supplierLicence/" + licenceUrl);//文件路径
            file.delete();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public boolean updateUrls(Long supplierSid, String updateLicenceStr, MultipartFile[] updateLicences) throws IOException {
        String[] licenceArray = updateLicenceStr.split(";");
        //判断长度是否相等，不等说明界面js取值有误，不做修改操作
        if (licenceArray.length == updateLicences.length) {
            for (int i = 0; i < licenceArray.length; i++) {
                String[] licence = licenceArray[i].split(",");
                //界面只会拼接supplierLicence的三个属性
                if (licence.length != 3) {
                    continue;
                } else {
                    SupplierLicence supplierLicence = repository.findOne(Long.parseLong(licence[0]));
                    //判断supplierLicence是否存在
                    if (!Utils.isNull(supplierLicence)) {
                        //判断supplierSid是否一致，不一致不修改
                        if (supplierLicence.getSupplierSid() == supplierSid) {
                            supplierLicence.setCname(licence[1]);
                            supplierLicence.setStatus(Integer.parseInt(licence[2]));
                            //判断是否上传了对应的判断图片
                            if (updateLicences[i] != null && updateLicences[i].getOriginalFilename() != null && updateLicences[i].getOriginalFilename().length() > 0) {

                                //判断url是否为空，不为空先删除原url的图片
                                if (!Utils.isEmpty(supplierLicence.getUrl())) {
                                    String[] urlArray = supplierLicence.getUrl().split("/");
                                    if (this.deleteLicence(urlArray[urlArray.length - 1])) {
                                        String url = this.uploadLicence(updateLicences[i]);
                                        supplierLicence.setUrl("/attachment/" + url);
                                    }
                                } else {
                                    //原url为空直接上传图片
                                    String url = this.uploadLicence(updateLicences[i]);
                                    supplierLicence.setUrl("/attachment/" + url);
                                }
                            }
                            this.save(supplierLicence);
                        } else {
                            continue;
                        }
                    } else {
                        continue;
                    }
                }
            }

            return true;
        } else {
            return false;
        }


    }

    @Override
    public boolean saveUrls(Long supplierSid, String addLicenceStr, MultipartFile[] addLicences) throws IOException {
        String[] licenceArray = addLicenceStr.split(";");
        //判断长度是否相等，不等说明界面js取值有误，不做修改操作
        if (licenceArray.length == addLicences.length) {
            for (int i = 0; i < licenceArray.length; i++) {
                String[] licence = licenceArray[i].split(",");
                //界面只会拼接supplierLicence的两个个属性
                if (licence.length != 2) {
                    continue;
                } else {
                    if (addLicences[i] != null && addLicences[i].getOriginalFilename() != null && addLicences[i].getOriginalFilename().length() > 0) {
                        SupplierLicence supplierLicence = new SupplierLicence();
                        String url = this.uploadLicence(addLicences[i]);
                        supplierLicence.setUrl("/attachment/" + url);
                        supplierLicence.setCname(licence[0]);
                        supplierLicence.setStatus(Integer.parseInt(licence[1]));
                        supplierLicence.setSupplierSid(supplierSid);
                        this.save(supplierLicence);
                    } else {
                        continue;
                    }
                }
            }
            return true;
        } else {
            return false;
        }

    }
}

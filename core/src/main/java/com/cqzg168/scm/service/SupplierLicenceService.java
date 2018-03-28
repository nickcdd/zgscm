package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.SupplierLicence;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

/**
 * Created by think on 2017/4/27.
 */
public interface SupplierLicenceService extends BaseService<SupplierLicence> {
    /**
     * 上传供应商证照
     *
     * @param uploadLicence
     * @return
     */
    String uploadLicence(MultipartFile uploadLicence) throws IOException;

    /**
     * 删除供应商证照
     *
     * @param licenceUrl
     * @return
     */
    boolean deleteLicence(String licenceUrl);

    /**
     * 修改已经存在的图片
     * @param supplierSid
     * @param updateLicenceStr
     * @param updateLicences
     * @return
     * @throws IOException
     */
    boolean updateUrls(Long supplierSid,String updateLicenceStr,MultipartFile[] updateLicences) throws IOException;

    /**
     * 新增图片
     * @param supplierSid
     * @param addLicenceStr
     * @param addLicences
     * @return
     * @throws IOException
     */
    boolean saveUrls(Long supplierSid,String addLicenceStr,MultipartFile[] addLicences) throws IOException;

}

package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.AfterSale;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;


/**
 * Created by think on 2017/4/27.
 */
public interface AfterSaleService extends BaseService<AfterSale> {


    void uplaodPicture(Long orderid, MultipartFile[] myavatar) throws IOException;

    List<AfterSale> afterSales(Long orderid);

}

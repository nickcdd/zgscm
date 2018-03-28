package com.cqzg168.scm.service;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

/**
 * Created by Administrator on 2017/6/30 0030.
 */
public interface WsdlService {
    /**
     * 生成wsdl
     *
     * @param
     * @return
     */
    boolean createWsdl(String str) throws IOException;

    /**
     * 删除wsdl
     *
     * @param
     * @return
     */
    boolean deleteWsdl(String Str);
}

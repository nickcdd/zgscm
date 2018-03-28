package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.GoodsFile;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

/**
 * Created by think on 2017/4/27.
 */
public interface GoodsFileService extends BaseService<GoodsFile> {
    /**
     * 上传商品图片
     *
     * @param myavatar
     * @return
     */
    String uploadGoodsFile(MultipartFile myavatar) throws IOException;

    /**
     * 删除商品图片
     *
     * @param fileUrl
     * @return
     */
    boolean deleteImg(String fileUrl);
}

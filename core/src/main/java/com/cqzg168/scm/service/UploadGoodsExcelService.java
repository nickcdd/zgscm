package com.cqzg168.scm.service;

import com.cqzg168.scm.domain.Goods;
import com.cqzg168.scm.domain.Manager;
import com.cqzg168.scm.dto.GoodsDto;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/7/3 0003.
 */
public interface UploadGoodsExcelService {
    /**
     * 上传商品excel导入文件
     * @param file
     * @return
     */
    HashMap<String,Object> uploadExcelFile(MultipartFile file,Manager manager);

    /**
     * 生成失败数据excel
     * @param list
     * @param path
     * @return
     */
    boolean createExcelAndSaveFile(List<GoodsDto> list, String path) throws IOException;
}

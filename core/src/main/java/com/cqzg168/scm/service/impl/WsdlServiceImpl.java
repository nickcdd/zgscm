package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.service.WsdlService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.UUID;

/**
 * Created by Administrator on 2017/6/30 0030.
 */
@Service
@Transactional
public class WsdlServiceImpl implements WsdlService {
    //上传图片路径
    @Value("${upload_path}")
    private String uploadPath;
    @Override
    public boolean createWsdl(String str) throws IOException {
        try
        {

            //新图片名称
            String newFileName = "service.xml";

            File dir = new File(uploadPath + "/wsdl");
            if (!dir.exists()) {
                dir.mkdirs();
            }
            File newFile = new File(dir.getAbsolutePath() + File.separator + newFileName);

            newFile.createNewFile();
            FileWriter fileWriter = new FileWriter(newFile);
//             写文件
            fileWriter.write(str);
            // 关闭
            fileWriter.close();

            return true;
        }
        catch (IOException e)
        {
            //
            e.printStackTrace();
            return false;
        }

    }

    @Override
    public boolean deleteWsdl(String Str) {
        try {
            File file = new File(uploadPath + "wsdl/service.xml");//文件路径
            file.delete();
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}

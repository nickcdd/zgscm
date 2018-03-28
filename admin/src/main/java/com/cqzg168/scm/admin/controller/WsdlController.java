package com.cqzg168.scm.admin.controller;

import com.cqzg168.scm.service.WsdlService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import javax.wsdl.Definition;
import javax.wsdl.WSDLException;
import javax.wsdl.factory.WSDLFactory;
import javax.wsdl.xml.WSDLReader;
import javax.wsdl.xml.WSDLWriter;
import java.io.*;

/**
 * Created by Administrator on 2017/6/30 0030.
 */
@Controller
@RequestMapping("/wsdl")
public class WsdlController extends BaseController {
    @Autowired
    WsdlService wsdlService;
    @Value("${yuntong_wsdl_url}")
    private String yuntongWsdlUrl;

    @RequiresPermissions("wsdl:reload")
    @RequestMapping(value = "/yuntongWsdl", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String yuntongWsdl() throws DocumentException {


        boolean removeFlag = wsdlService.deleteWsdl("");
        if (removeFlag) {
            System.out.println("WSDL文件删除成功");
        } else {
            System.out.println("WSDL文件删除失败");
        }
        InputStream inputStream = getUrlInputStream(yuntongWsdlUrl);

        String result = convertStreamToString(inputStream);

        String reg = "<s:element ref=\"s:schema\"/>";
        result = result.replaceAll(reg, "");
        try {
            boolean flag = wsdlService.createWsdl(result);
            if (flag) {
                return "true";
            } else {
                return "false";
            }

        } catch (IOException e) {
            e.printStackTrace();
            return "false";
        }

    }

    /**
     * 根据wsdlurl,返回网页内容
     *
     * @param wsdlUrl
     * @return
     */
    public static InputStream getUrlInputStream(String wsdlUrl) {
        InputStream inputStream = null;
        ByteArrayOutputStream bos = new ByteArrayOutputStream();//定义字符数组输出流对象
        Definition definition = null;
        WSDLFactory wsdlFactory = null;

        try {
            wsdlFactory = WSDLFactory.newInstance();
            WSDLReader reader = wsdlFactory.newWSDLReader();
            definition = reader.readWSDL(wsdlUrl);
            WSDLWriter wsdlWriter = wsdlFactory.newWSDLWriter();

            Writer wr = new OutputStreamWriter(bos, "gbk");
            wsdlWriter.writeWSDL(definition, wr);
            inputStream = new ByteArrayInputStream(bos.toString().getBytes());
        } catch (WSDLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return inputStream;
    }

    /**
     * 将输入流转换成String类型
     *
     * @param inputStream
     * @return
     */
    public static String convertStreamToString(InputStream inputStream) {

        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
        StringBuilder sb = new StringBuilder();

        String line = null;
        try {
            while ((line = reader.readLine()) != null) {
                sb.append(line + "\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                inputStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return sb.toString();
    }


    /**
     * 将inputStream 转换成byte数组
     *
     * @param input
     * @return
     * @throws IOException
     */
    public static byte[] toByteArray(InputStream input) throws IOException {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        byte[] buffer = new byte[4096];
        int n = 0;
        while (-1 != (n = input.read(buffer))) {
            output.write(buffer, 0, n);
        }
        return output.toByteArray();
    }
}

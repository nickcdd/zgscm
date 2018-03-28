package com.cqzg168.scm.service.impl;
import com.cqzg168.scm.service.CxfUtilsService;
import com.cqzg168.scm.service.WsdlService;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.jaxws.CXFService;
import org.apache.cxf.jaxws.endpoint.dynamic.JaxWsDynamicClientFactory;
import org.dom4j.DocumentException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import javax.wsdl.Definition;
import javax.wsdl.WSDLException;
import javax.wsdl.factory.WSDLFactory;
import javax.wsdl.xml.WSDLReader;
import javax.wsdl.xml.WSDLWriter;
import java.io.*;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/6/30 0030.
 */
@Service
@Transactional
public class CxfUtilsServiceImpl implements CxfUtilsService {
    @Autowired
    WsdlService wsdlService;
    @Value("${upload_path}")
    private String uploadPath;
    @Value("${yuntong_wsdl_url}")
    private  String yuntongWsdlUrl;



    /**
     * 测试模拟调用接口
     */

    public String testRest() {

        RestTemplate restTemplate = new RestTemplate();

        String result=restTemplate.postForObject("http://localhost:8080/wsdl/yuntongWsdl", null, String.class);
        System.out.println("result   "+result);
        return result;
    }


    @Override
    public  String callWebService(String methodName, Object[] params)  {

            try {
            JaxWsDynamicClientFactory dcf = JaxWsDynamicClientFactory.newInstance();
            Client client = dcf.createClient(uploadPath+"/wsdl/service.xml");
            Object[] objects = new Object[0];



                objects = client.invoke(methodName, params);



                return objects[0].toString();
            } catch (Exception e) {
                e.printStackTrace();
                return  "false";
            }finally{

            }

    }



    public String yuntongWsdl()  {


        try {

        InputStream inputStream = getUrlInputStream(yuntongWsdlUrl);

        String result = convertStreamToString(inputStream);

        String reg="<s:element ref=\"s:schema\"/>";
        result=result.replaceAll(reg,"");

            boolean  flag=wsdlService.createWsdl(result);
            if(flag){
                return "true";
            }else{
                return "false";
            }

        } catch (IOException e) {
            e.printStackTrace();
            return "false";
        }

    }
    /**
     * 根据wsdlurl,返回网页内容
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

}

package com.cqzg168.scm.service;

import org.dom4j.DocumentException;

import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/6/30 0030.
 */
public interface CxfUtilsService {

     String  callWebService(String methodName,Object[] params);
}

package com.cqzg168.scm.shopkeeper.util;

import java.lang.reflect.Field;

/**
 * Created by admin on 2017/5/3.
 */
public class ClassUtils {
    /**
     * 对比两个类不同属性值做出赋值
     * @param sourceBean
     * @param targetBean
     * @param <T>
     * @return
     */
    public static  <T> T combineSydwCore(T sourceBean,T targetBean){
        Class sourceBeanClass = sourceBean.getClass();
        Class targetBeanClass = targetBean.getClass();

        Field[] sourceFields = sourceBeanClass.getDeclaredFields();
        Field[] targetFields = targetBeanClass.getDeclaredFields();
        for(int i=0; i<sourceFields.length; i++){
            Field sourceField = sourceFields[i];
            Field targetField = targetFields[i];
            sourceField.setAccessible(true);
            targetField.setAccessible(true);
            try {
                if(sourceField.get(sourceBean) != null && !sourceField.get(sourceBean).equals(targetField.get(targetBean))){
                    targetField.set(targetBean,sourceField.get(sourceBean));
                }
            } catch (IllegalArgumentException | IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        return targetBean;
    }
}

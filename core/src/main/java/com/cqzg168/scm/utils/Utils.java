package com.cqzg168.scm.utils;

import com.cqzg168.scm.domain.BaseDomain;
import com.cqzg168.scm.domain.BaseDomainInterface;
import com.fasterxml.jackson.annotation.JsonIgnore;
import org.json.JSONArray;
import org.json.JSONObject;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.security.MessageDigest;
import java.util.*;

/**
 * 实用工具类 Created by jackytsu on 2017/3/14.
 */
public class Utils {

    /**
     * 获取字符串的MD5值
     *
     * @param str
     * @return
     */
    public static String getMD5String(Object str) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");

            if (str instanceof String) {
                md.update(((String) str).getBytes("UTF-8"));
            } else if (str instanceof char[]) {
                md.update(String.valueOf(((char[]) str)).getBytes("UTF-8"));
            }

            StringBuffer buf = new StringBuffer();
            for (byte b : md.digest()) {
                buf.append(String.format("%02x", b & 0xff));
            }
            return buf.toString();
        } catch (Exception e) {
            e.printStackTrace();

            return "";
        }
    }

    /**
     * 判断对象是否为空
     *
     * @param obj
     * @return
     */
    public static boolean isNull(Object obj) {
        return null == obj;
    }

    /**
     * 判断字符串是否为空
     *
     * @param str
     * @return
     */
    public static boolean isEmpty(String str) {
        return isNull(str) || str.trim().length() == 0;
    }

    /**
     * 判断集合是否为空
     *
     * @param collection
     * @return
     */
    public static boolean isEmpty(Collection<?> collection) {
        return isNull(collection) || collection.size() == 0;
    }

    /**
     * 判断数组是否为空
     *
     * @param array
     * @return
     */
    public static boolean isEmpty(Object[] array) {
        return isNull(array) || array.length == 0;
    }

    /**
     * 将对象反射为 Map<String, Object>
     *
     * @param o
     * @param includeFields
     * @param excludeFields
     * @return
     */
    public static Map<String, Object> toMap(BaseDomainInterface o, String[] includeFields, String[] excludeFields) {
        Map<String, Object> result = new HashMap<String, Object>();

        if (Utils.isNull(includeFields)) {
            includeFields = new String[] {};
        }

        if (Utils.isNull(excludeFields)) {
            excludeFields = new String[] {};
        }

        Class<?> cls = o.getClass();
        while (!cls.getName().equals(BaseDomain.class.getName()) && !Utils.isNull(cls)) {
            getFieldValue(o, cls, result, includeFields, excludeFields);
            cls = cls.getSuperclass();
        }

        if (!Utils.isNull(cls) && cls.getName().equals(BaseDomain.class.getName())) {
            getFieldValue(o, cls, result, includeFields, excludeFields);
        }

        return result;
    }

    /**
     * 将对象反射为 JSONObject
     *
     * @param o
     * @param includeFields
     * @param excludeFields
     * @return
     */
    public static JSONObject toJSON(BaseDomainInterface o, String[] includeFields, String[] excludeFields) {
        JSONObject result = new JSONObject();

        if (Utils.isNull(includeFields)) {
            includeFields = new String[] {};
        }

        if (Utils.isNull(excludeFields)) {
            excludeFields = new String[] {};
        }

        Class<?> cls = o.getClass();
        while (!cls.getName().equals(BaseDomain.class.getName()) && !Utils.isNull(cls)) {
            getFieldValue(o, cls, result, includeFields, excludeFields);
            cls = cls.getSuperclass();
        }

        if (!Utils.isNull(cls) && cls.getName().equals(BaseDomain.class.getName())) {
            getFieldValue(o, cls, result, includeFields, excludeFields);
        }

        return result;
    }

    private static void getFieldValue(Object from, Class<?> cls, Map<String, Object> result, String[] includeFields, String[] excludeFields) {
        List<String> iFields = Arrays.asList(includeFields);
        List<String> eFields = Arrays.asList(excludeFields);

        for (Field field : cls.getDeclaredFields()) {
            if (field.getName().equals("serialVersionUID")) {
                continue;
            }

            if ((!Utils.isEmpty(iFields) && !iFields.contains(field.getName())) || (!Utils.isEmpty(eFields) && eFields.contains(field.getName()))) {
                continue;
            }

            boolean isIgnore = false;
            for (Annotation anno : field.getAnnotations()) {
                if (anno instanceof JsonIgnore) {
                    isIgnore = true;
                    break;
                }
            }

            if (isIgnore) {
                continue;
            }

            field.setAccessible(true);
            try {
                Object obj = field.get(from);
                if (obj instanceof BaseDomainInterface) {
                    result.put(field.getName(), ((BaseDomainInterface) obj).toMap());
                } else if (obj instanceof Collection) {
                    Collection<Object> array = new ArrayList<Object>();
                    for (Object o : (Collection<?>) obj) {
                        if (o instanceof BaseDomainInterface) {
                            array.add(((BaseDomainInterface) o).toMap());
                        } else {
                            array.add(o);
                        }
                    }
                    result.put(field.getName(), array);
                } else {
                    result.put(field.getName(), obj);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private static void getFieldValue(Object from, Class<?> cls, JSONObject result, String[] includeFields, String[] excludeFields) {
        List<String> iFields = Arrays.asList(includeFields);
        List<String> eFields = Arrays.asList(excludeFields);

        for (Field field : cls.getDeclaredFields()) {
            if (field.getName().equals("serialVersionUID")) {
                continue;
            }

            if ((!Utils.isEmpty(iFields) && !iFields.contains(field.getName())) || (!Utils.isEmpty(eFields) && eFields.contains(field.getName()))) {
                continue;
            }

            boolean isIgnore = false;
            for (Annotation anno : field.getAnnotations()) {
                if (anno instanceof JsonIgnore) {
                    isIgnore = true;
                    break;
                }
            }

            if (isIgnore) {
                continue;
            }

            field.setAccessible(true);
            try {
                Object obj = field.get(from);
                if (obj instanceof BaseDomainInterface) {
                    result.putOpt(field.getName(), ((BaseDomainInterface) obj).toJSON());
                } else if (obj instanceof Collection) {
                    JSONArray array = new JSONArray();
                    for (Object o : (Collection<?>) obj) {
                        if (o instanceof BaseDomainInterface) {
                            array.put(((BaseDomainInterface) o).toJSON());
                        } else {
                            array.put(o);
                        }
                    }
                    result.putOpt(field.getName(), array);
                } else {
                    if (obj instanceof Date) {
                        result.putOpt(field.getName(), Constant.SF_FULL_DATE_TIME.format(obj));
                    } else {
                        result.putOpt(field.getName(), obj);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 格式化输出
     *
     * @param format
     * @param values
     * @return
     */
    public static String sout(String format, Object... values) {
        return String.format(format, values);
    }

}

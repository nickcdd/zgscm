package com.cqzg168.scm.domain;

import org.json.JSONObject;

import java.io.Serializable;
import java.util.Map;

/**
 * 实体类基础接口
 * Created by jackytsu on 2017/3/14.
 */
public interface BaseDomainInterface extends Serializable {
    /**
     * 实体转换为 Map
     *
     * @return
     */
    Map<String, Object> toMap();

    /**
     * 实体转换为 Map
     *
     * @param fields 指定包含的字段名称数组
     * @return
     */
    Map<String, Object> toMapWithInclude(String[] fields);

    /**
     * 实体转换为 Map
     *
     * @param fields 指定排除的字段名称数组
     * @return
     */
    Map<String, Object> toMapWithExclude(String[] fields);

    /**
     * 实体转换为 JSON
     *
     * @return
     */
    JSONObject toJSON();

    /**
     * 实体转换为 JSON
     *
     * @param fields 指定包含的字段名称数组
     * @return
     */
    JSONObject toJSONWithInclude(String[] fields);

    /**
     * 实体转换为 JSON
     *
     * @param fields 指定排除的字段名称数组
     * @return
     */
    JSONObject toJSONWithExclude(String[] fields);
}

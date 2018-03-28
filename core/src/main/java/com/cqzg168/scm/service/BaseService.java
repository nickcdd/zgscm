package com.cqzg168.scm.service;

import java.util.List;

/**
 * 基础 Service 封装接口
 * Created by jackytsu on 2017/3/15.
 */
public interface BaseService<T> {
    /**
     * 根据主键查询单一实体对象方法
     *
     * @param sid
     * @return
     */
    T findOne(Long sid);

    /**
     * 新增或修改实体对象方法
     *
     * @param t
     * @return
     */
    T save(T t);

    /**
     * 批量新增或修改实体对象方法
     *
     * @param entities
     * @return
     */
    List<T> save(List<T> entities);

    /**
     * 逻辑删除单个对象
     *
     * @param sid
     */
    void remove(Long sid);

    /**
     * 逻辑删除多个对象
     *
     * @param sids
     */
    void remove(List<Long> sids);

    /**
     * 逻辑删除多个对象
     *
     * @param sids
     */
    void remove(Long[] sids);

    /**
     * 将单个对象状态置为无效
     *
     * @param sid
     */
    void disable(Long sid);

    /**
     * 将多个对象状态置为无效
     *
     * @param sids
     */
    void disable(List<Long> sids);

    /**
     * 将多个对象状态置为无效
     *
     * @param sids
     */
    void disable(Long[] sids);

    /**
     * 将单个对象状态置为有效
     *
     * @param sid
     */
    void enable(Long sid);

    /**
     * 将多个对象状态置为有效
     *
     * @param sids
     */
    void enable(List<Long> sids);

    /**
     * 将多个对象状态置为有效
     *
     * @param sids
     */
    void enable(Long[] sids);

    /**
     * 设置单个对象状态
     *
     * @param status
     * @param sid
     */
    void updateStatus(Integer status, Long sid);

    /**
     * 设置多个对象状态
     *
     * @param status
     * @param sids
     */
    void updateStatus(Integer status, List<Long> sids);

    /**
     * 设置多个对象状态
     *
     * @param status
     * @param sids
     */
    void updateStatus(Integer status, Long[] sids);

    /**
     * 查询指定状态的数据列表
     *
     * @param status
     * @return
     */
    List<T> findAllByStatus(Integer status);

    /**
     * 查询指定状态的数据列表
     *
     * @param status
     * @return
     */
    List<T> findAllByStatus(Integer[] status);

    /**
     * 查询不等于指定状态的数据列表
     *
     * @param status
     * @return
     */
    List<T> findAllByNotStatus(Integer status);

    /**
     * 查询不等于指定状态的数据列表
     *
     * @param status
     * @return
     */
    List<T> findAllByNotStatus(Integer[] status);

    /**
     * 查询所有记录列表
     *
     * @return
     */
    List<T> findAll();

    /**
     * 根据指定 SID 查询列表
     *
     * @param sids
     * @return
     */
    List<T> findBySids(List<Long> sids);
}

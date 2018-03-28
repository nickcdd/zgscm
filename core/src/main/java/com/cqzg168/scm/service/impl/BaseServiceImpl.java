package com.cqzg168.scm.service.impl;

import com.cqzg168.scm.domain.BaseDomain;
import com.cqzg168.scm.repository.BaseRepository;
import com.cqzg168.scm.service.BaseService;
import com.cqzg168.scm.utils.Utils;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.PostConstruct;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.Predicate;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

/**
 * 基础 Service 实现封装类
 * Created by jackytsu on 2017/3/15.
 */
@Transactional
public abstract class BaseServiceImpl<T extends BaseDomain, R extends BaseRepository<?>> implements BaseService<T> {

    private static final String REPO_CLS_NAME = BaseRepository.class.getName();

    /**
     * 默认排序
     */
    protected Sort DEFAULT_SORT;

    /**
     * 更新记录状态 SQL
     */
    private String SQL_UPDATE_STATUS_SINGLE = "UPDATE %s SET status = :status where sid = :sid";
    private String SQL_UPDATE_STATUS_BATCH  = "UPDATE %s SET status = :status where sid in (:sids)";

    /**
     * 实体表名
     */
    private String TABLE_NAME;

    @PersistenceContext
    private EntityManager em;

    protected BaseRepository<T> baseRepository;

    public abstract void setRepository(R repository);

    @PostConstruct
    public void init() {
        Type[] types = baseRepository.getClass().getGenericInterfaces();
        if (null != types && types.length > 0) {
            Type type = types[0];
            try {
                Class<?> cls = Class.forName(type.getTypeName());
                types = cls.getGenericInterfaces();
                if (null != types && types.length > 0) {
                    type = types[0];
                    String name = type.getTypeName().replace(REPO_CLS_NAME + "<", "").replace(">", "");
                    cls = Class.forName(name);
                    Method method = cls.getMethod("getTableName");
                    if (null != method) {
                        TABLE_NAME = String.valueOf(method.invoke(cls.newInstance()));
                        SQL_UPDATE_STATUS_SINGLE = String.format(SQL_UPDATE_STATUS_SINGLE, TABLE_NAME);
                        SQL_UPDATE_STATUS_BATCH = String.format(SQL_UPDATE_STATUS_BATCH, TABLE_NAME);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public T findOne(Long sid) {
        return baseRepository.findOne(sid);
    }

    @Override
    public T save(T t) {
        return baseRepository.save(t);
    }

    @Override
    public List<T> save(List<T> entities) {
        return baseRepository.save(entities);
    }

    @Override
    public void remove(Long sid) {
        setStatus(-1, sid);
    }

    @Override
    public void remove(List<Long> sids) {
        setStatus(-1, sids);
    }

    @Override
    public void remove(Long[] sids) {
        setStatus(-1, sids);
    }

    @Override
    public void disable(Long sid) {
        setStatus(0, sid);
    }

    @Override
    public void disable(List<Long> sids) {
        setStatus(0, sids);
    }

    @Override
    public void disable(Long[] sids) {
        setStatus(0, sids);
    }

    @Override
    public void enable(Long sid) {
        setStatus(1, sid);
    }

    @Override
    public void enable(List<Long> sids) {
        setStatus(1, sids);
    }

    @Override
    public void enable(Long[] sids) {
        setStatus(1, sids);
    }

    @Override
    public void updateStatus(Integer status, Long sid) {
        setStatus(status, sid);
    }

    @Override
    public void updateStatus(Integer status, List<Long> sids) {
        setStatus(status, sids);
    }

    @Override
    public void updateStatus(Integer status, Long[] sids) {
        setStatus(status, sids);
    }

    @Override
    public List<T> findAllByStatus(Integer status) {
        return baseRepository.findAll(getFindStatusSpecification(status, true), DEFAULT_SORT);
    }

    @Override
    public List<T> findAllByStatus(Integer[] status) {
        return baseRepository.findAll(getFindStatusSpecification(status, true), DEFAULT_SORT);
    }

    @Override
    public List<T> findAllByNotStatus(Integer status) {
        return baseRepository.findAll(getFindStatusSpecification(status, false), DEFAULT_SORT);
    }

    @Override
    public List<T> findAllByNotStatus(Integer[] status) {
        return baseRepository.findAll(getFindStatusSpecification(status, false), DEFAULT_SORT);
    }

    @Override
    public List<T> findAll() {
        return baseRepository.findAll(DEFAULT_SORT);
    }

    @Override
    public List<T> findBySids(List<Long> sids) {
        Specification<T> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            CriteriaBuilder.In<Long> sidIn = cb.in(root.get("sid"));
            for (Long sid : sids) {
                sidIn.value(sid);
            }
            predicates.add(sidIn);

            return query.where(predicates.toArray(new Predicate[] {})).getRestriction();
        };

        return baseRepository.findAll(specification, DEFAULT_SORT);
    }

    /**
     * 更新记录状态
     *
     * @param status
     * @param sid
     */
    protected void setStatus(Integer status, Object sid) {
        if (!Utils.isEmpty(TABLE_NAME)) {
            Query query = null;
            if (sid instanceof Long[] || sid instanceof List<?>) {
                query = em.createNativeQuery(SQL_UPDATE_STATUS_BATCH);

                List<String> sids = new ArrayList<>();
                if (sid instanceof Long[]) {
                    for (Long s : (Long[]) sid) {
                        sids.add(String.valueOf(s));
                    }
                } else {
                    for (Object s : (List<?>) sid) {
                        sids.add(String.valueOf(s));
                    }
                }
                query.setParameter("sids", sids);
            } else {
                query = em.createNativeQuery(SQL_UPDATE_STATUS_SINGLE);
                query.setParameter("sid", sid);
            }
            query.setParameter("status", status);
            query.executeUpdate();
        }
    }

    /**
     * 设置状态查询条件
     *
     * @param status
     * @param isEqual
     * @return
     */
    protected Specification<T> getFindStatusSpecification(Object status, final boolean isEqual) {
        Specification<T> specification = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (status instanceof Integer) {
                if (isEqual) {
                    predicates.add(cb.equal(root.get("status"), status));
                } else {
                    predicates.add(cb.notEqual(root.get("status"), status));
                }
            } else if (status instanceof Integer[]) {
                CriteriaBuilder.In<Integer> statusIn = cb.in(root.get("status"));
                for (Integer s : (Integer[]) status) {
                    statusIn.value(s);
                }
                if (isEqual) {
                    predicates.add(statusIn);
                } else {
                    predicates.add(cb.not(statusIn));
                }
            }

            return query.where(predicates.toArray(new Predicate[] {})).getRestriction();
        };

        return specification;
    }
}

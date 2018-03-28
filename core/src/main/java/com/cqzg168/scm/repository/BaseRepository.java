package com.cqzg168.scm.repository;

import com.cqzg168.scm.domain.BaseDomain;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.NoRepositoryBean;

/**
 * 基础 Repository 封装接口
 * Created by jackytsu on 2017/3/15.
 */
@NoRepositoryBean
public interface BaseRepository<T extends BaseDomain> extends JpaRepository<T, Long>, JpaSpecificationExecutor<T> {
}

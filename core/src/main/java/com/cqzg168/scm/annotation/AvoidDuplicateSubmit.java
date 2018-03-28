package com.cqzg168.scm.annotation;

import org.springframework.stereotype.Component;

import java.lang.annotation.*;

/**
 * 防止重复提交标注，用于方法上
 * 在新建页面方法上，设置needSaveToken()为true，此时拦截器会在Session中保存一个token，
 * 保存方法需要验证重复提交的，设置needRemoveToken为true
 * 此时会在拦截器中验证是否重复提交
 * <p>
 * Created by jackytsu on 2017/5/23.
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component
public @interface AvoidDuplicateSubmit {
    /**
     * 在 Session 中生成 Token 并通过 Cookie 传给页面
     *
     * @return
     */
    boolean needSaveToken() default false;

    /**
     * 验证 Token 并删除
     *
     * @return
     */
    boolean needRemoveToken() default false;
}

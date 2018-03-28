package com.cqzg168.scm.reseller.shiro.exception;

import org.apache.shiro.authc.AuthenticationException;

/**
 * Created by jackytsu on 2017/4/28.
 */
public class IncorrectCaptchaException extends AuthenticationException {

    public IncorrectCaptchaException() {
        super();
    }

    public IncorrectCaptchaException(String message, Throwable cause) {
        super(message, cause);
    }

    public IncorrectCaptchaException(String message) {
        super(message);
    }

    public IncorrectCaptchaException(Throwable cause) {
        super(cause);
    }
}

package com.cqzg168.scm.domain;

import org.json.JSONObject;

/**
 * Ajax 请求返回封装
 * Created by jackytsu on 2017/3/16.
 */
public class AjaxResult {
    /**
     * 消息
     */
    public String msg;

    /**
     * 状态
     */
    public boolean success;

    /**
     * 数据
     */
    private Object record;

    /**
     * 错误代码
     */
    private String errCode;

    /**
     * 返回成功
     *
     * @param msg
     * @param record
     * @return
     */
    public static AjaxResult ajaxSuccessResult(String msg, Object record) {
        AjaxResult result = new AjaxResult();
        result.setSuccess(true);
        result.setMsg(msg);
        result.setRecord(record);
        return result;
    }

    /**
     * 返回失败
     *
     * @param msg
     * @param record
     * @return
     */
    public static AjaxResult ajaxFailResult(String msg, Object record) {
        AjaxResult result = new AjaxResult();
        result.setSuccess(false);
        result.setMsg(msg);
        result.setRecord(record);
        return result;
    }

    public static AjaxResult ajaxFailResult(String errCode, String msg) {
        AjaxResult result = new AjaxResult();
        result.setSuccess(false);
        result.setErrCode(errCode);
        result.setMsg(msg);
        return result;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public Object getRecord() {
        return record;
    }

    public void setRecord(Object record) {
        this.record = record;
    }

    public String getErrCode() {
        return errCode;
    }

    public void setErrCode(String errCode) {
        this.errCode = errCode;
    }

    public String toString() {
        JSONObject json = new JSONObject();

        try {
            json.putOpt("success", this.success);
            json.putOpt("msg", this.msg);
            json.putOpt("record", this.record);
            json.putOpt("errCode", this.errCode);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return json.toString();
    }
}

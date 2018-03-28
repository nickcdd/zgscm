package com.cqzg168.scm.domain;

import com.cqzg168.scm.utils.Utils;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.core.convert.converter.Converter;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * 针对 BootstrapTable 进行适配的 PAGE 封装
 *
 * @param <T>
 * @author jackytsu
 */
public class PageWrapper<T> implements Page<T>, Serializable {

    private static final long serialVersionUID = -6515248412866633432L;

    private final Page<T> page;

    private final JSONObject pageInfo;

    private List<T> recordList = new ArrayList<T>();

    public PageWrapper(Page<T> page) {
        this.page = page;
        this.pageInfo = new JSONObject();
        try {
            this.pageInfo.putOpt("total", getTotal());
            this.pageInfo.putOpt("totalPages", getTotalPages());
            this.pageInfo.putOpt("page", getNumber());
            this.pageInfo.putOpt("pageSize", getSize());
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @SuppressWarnings("unchecked")
    public PageWrapper(Page<?> page, List<T> recordList) {
        this((Page<T>) page);
        this.recordList = recordList;
    }

    public List<T> getRows() {
        return Utils.isEmpty(this.recordList) ? this.page.getContent() : this.recordList;
    }

    public long getTotal() {
        return this.page.getTotalElements();
    }

    @Override
    public int getNumber() {
        return this.page.getNumber();
    }

    @Override
    public int getSize() {
        return this.page.getSize();
    }

    @Override
    public int getNumberOfElements() {
        return this.page.getNumberOfElements();
    }

    @Override
    public boolean hasContent() {
        return this.page.hasContent();
    }

    @Override
    public Sort getSort() {
        return this.page.getSort();
    }

    @Override
    public boolean isFirst() {
        return this.page.isFirst();
    }

    @Override
    public boolean isLast() {
        return this.page.isLast();
    }

    @Override
    public boolean hasNext() {
        return this.page.hasNext();
    }

    @Override
    public boolean hasPrevious() {
        return this.page.hasPrevious();
    }

    @Override
    public Pageable nextPageable() {
        return this.page.nextPageable();
    }

    @Override
    public Pageable previousPageable() {
        return this.page.previousPageable();
    }

    @Override
    public Iterator<T> iterator() {
        return this.page.iterator();
    }

    @Override
    public int getTotalPages() {
        return this.page.getTotalPages();
    }

    @Override
    public long getTotalElements() {
        return this.page.getTotalElements();
    }

    public String getPageInfo() {
        return this.pageInfo.toString();
    }

    public void setRecordList(List<T> recordList) {
        this.recordList = recordList;
    }

    @Override
    public List<T> getContent() {
        return this.page.getContent();
    }

    @Override
    public <S> Page<S> map(Converter<? super T, ? extends S> converter) {
        return null;
    }
}

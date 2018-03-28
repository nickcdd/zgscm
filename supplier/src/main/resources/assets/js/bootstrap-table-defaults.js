/**
 * BootstrapTable 组件渲染方法
 */
function BTServerPageHook(req) {
    if (this.$el.data('inited')) {
        this.$form.find('[name="page"]').val(req.data.page);
        this.$form.find('[name="size"]').val(req.data.size);
        this.$form.get(0).submit();
    } else {
        var pageInfo = this.$el.data('pageInfo');
        req.success({
            total: pageInfo && pageInfo.total || 0
        });

        this.$el.data('inited', true);
        this.$form = this.$el.parents('form');
    }
}

/**
 * BootstrapTable 组件日期格式化输出方法
 *
 * @param v
 *            当前字段值
 * @param d
 *            当前行数据对象
 * @param i
 *            当前行索引值
 * @returns {String}
 */
function BTDateFormatter(v, d, i) {
    var date = new Date(v), str = [];

    str.push(date.getFullYear(), '-');

    var month = date.getMonth() + 1;
    str.push(month > 9 ? month : '0' + month, '-');

    str.push(date.getDate());
    return str.join('');
}

/**
 * BootstrapTable 组件日期时间格式化输出方法
 *
 * @param v
 *            当前字段值
 * @param d
 *            当前行数据对象
 * @param i
 *            当前行索引值
 * @returns {String}
 */
function BTDateTimeFormatter(v, d, i) {
    var date = new Date(v), str = [];

    str.push(date.getFullYear(), '-');

    var month = date.getMonth() + 1;
    str.push(month > 9 ? month : '0' + month, '-');

    str.push(date.getDate(), ' ');

    var hours = date.getHours();
    str.push(hours > 9 ? hours : '0' + hours, ':');

    var minutes = date.getMinutes();
    str.push(minutes > 9 ? minutes : '0' + minutes, ':');

    var seconds = date.getSeconds();
    str.push(seconds > 9 ? seconds : '0' + seconds);
    return str.join('');
}

// 覆盖 BootstrapTable 组件默认配置
$.extend(jQuery.fn.bootstrapTable.defaults, {
    queryParamsType: '',
    idField: 'sid',
    pageList: [5, 10, 20, 50],
    pagination: true,
    paginationLoop: false,
    sidePagination: 'server',
    ajax: BTServerPageHook,
    striped: true,
    dataField: 'content',
    queryParams: function (params) {
        return {
            q: params.searchText,
            page: params.pageNumber - 1,
            size: params.pageSize
        };
    },
    responseHandler: function (res) {
        if (jQuery.fn.bootstrapTable.defaults.ajax) {
            return res;
        } else {
            if (res.success) {
                return $.extend(res.record, {
                    total: res.record.totalElements
                });
            } else {
                return {
                    total: 0
                };
            }
        }
    }
});

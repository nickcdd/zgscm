<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />
    <meta name="nav-url" content="/role/index">
    <script type="text/javascript">
        $(function () {
            var $form = $('form');
            $(document).on('click', '.btn-detail', function () {
                var $t = $(this), sid = $t.data('sid');
                $.getJSON('detail?sid=' + sid, function (result) {
                    if (result.success) {
                        $form.clearForm(true);
                        $form.formJSON('set', result.record);

                        var permissions = result.record.permissions.split(',');
                        $.each(permissions, function () {
                            $('input[value="' + this + '"]', $form).prop('checked', true);
                        });
                    } else {
                        showInfoFun(result.msg);
                    }
                });
            });

            $(document).on('click', '.btn-remove', function () {
                var $t = $(this), sid = $t.data('sid');
                confirmFun('remove?sid=' + sid, '该操作将无法撤消，是否继续？');
            });

            $('.btn-reset').click(function () {
                $form.clearForm(true);
            });

            $form.submit(function () {
                if ($form.valid()) {
                    var $permissions = $('.permission-list :checkbox:checked[value]');
                    if ($permissions.length === 0) {
                        showInfoFun('请至少选择一个权限。', 'warning');
                        return false;
                    }

                    var permissions = [];
                    $permissions.each(function () {
                        permissions.push($(this).val());
                    });

                    $('[name="permissions"]').val(permissions.join(','));
                }

                return true;
            });

            $('.check-all').click(function () {
                var $t = $(this), $parents = $t.closest('div.box');
                $(':checkbox', $parents).prop('checked', $t.is(':checked'));
            });

            $form.clearForm(true);
        });
    </script>
</head>
<body>
<div class="row">
    <div class="col-md-6">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">系统用户</h3>
            </div>
            <div class="box-body">
                <div class="bootstrap-table">
                    <div class="fixed-table-container" style="padding-bottom: 0px;">
                        <div class="fixed-table-body">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th width="25%">
                                            <div class="th-inner">角色名称</div>
                                        </th>
                                        <th width="25%">
                                            <div class="th-inner">权限列表</div>
                                        </th>
                                        <th width="25%">
                                            <div class="th-inner">备注</div>
                                        </th>
                                        <th width="25%">
                                            <div class="th-inner">操作</div>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                <#list roles as r>
                                    <tr>
                                        <td style="text-align: center;">${r.cname!''}</td>
                                        <td style="text-align: left;">
                                            <#list r.permissionList as p >
                                                <#if permissionMap[p]??>
                                                ${permissionMap[p]}<#if p_has_next>、</#if>
                                                </#if>
                                            </#list>
                                        </td>
                                        <td style="text-align: left;">${r.note!''}</td>
                                        <td style="text-align: center;">
                                            <button type="button" class="btn btn-info btn-xs btn-detail" data-sid="${r.sid?c}">
                                                <i class="fa fa-edit fa-fw"></i> 详情
                                            </button>
                                            <@shiro.hasPermission name="manager:save">
                                                <#if r.status == 0>
                                                    <a class="btn btn-success btn-xs" href="enable?sid=${r.sid?c}">
                                                        <i class="fa fa-check fa-fw"></i> 启用
                                                    </a>
                                                <#else>
                                                    <a class="btn btn-warning btn-xs" href="disable?sid=${r.sid?c}">
                                                        <i class="fa fa-ban fa-fw"></i> 禁用
                                                    </a>
                                                </#if>
                                            </@shiro.hasPermission>
                                            <@shiro.hasPermission name="manager:remove">
                                                <button type="button" class="btn btn-danger btn-xs btn-remove" data-sid="${r.sid?c}">
                                                    <i class="fa fa-trash fa-fw"></i> 删除
                                                </button>
                                            </@shiro.hasPermission>
                                        </td>
                                    </tr>
                                </#list>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-6">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title">用户详情</h3>
            </div>
            <form class="form-horizontal" method="post" action="save" data-toggle="validator" role="form">
                <input type="hidden" name="sid" />
                <input type="hidden" name="permissions" />

                <div class="box-body">

                    <div class="form-group has-feedback">
                        <label for="cname" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;角色名称</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="cname" name="cname" placeholder="角色名称" required="required" maxlength="12" />
                            <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                            <div class="help-block with-errors"></div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="note" class="col-sm-3 control-label">备注</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="note" name="note" placeholder="备注" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="note" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;权限列表</label>
                        <div class="col-sm-9 permission-list">
                        <#list permissions as p>
                            <div class="box box-success">
                                <div class="box-header with-border">
                                    <h4>
                                        <label class="checkbox-inline">
                                            <input type="checkbox" class="check-all" />${p.cname}
                                        </label>
                                    </h4>
                                </div>
                                <div class="box-body">
                                    <div class="row">
                                        <#list p.permissions?keys as key>
                                            <div class="checkbox col-sm-4">
                                                <label>
                                                    <input type="checkbox" value="${p.module}:${key}" />${p.permissions[key]}
                                                </label>
                                            </div>
                                        </#list>
                                    </div>
                                </div>
                            </div>
                        </#list>
                        </div>
                    </div>
                </div>
                <div class="box-footer">
                    <button type="submit" class="btn btn-primary pull-right">
                        <i class="fa fa-save"></i> 保存
                    </button>
                    <button type="button" class="btn btn-info pull-right btn-reset">
                        <i class="fa fa-eraser"></i> 重置
                    </button>
                </div>
            </form>
        </div>
    </div>

</div>
</body>
</html>
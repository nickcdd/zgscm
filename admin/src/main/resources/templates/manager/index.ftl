<!DOCTYPE html>
<html>
<head>
<#include "/_head_with_table.ftl" />
    <meta name="nav-url" content="/manager/index">
    <script type="text/javascript">
        $(function () {
            var $form = $('form');
            $(document).on('click', '.btn-detail', function () {
                var $t = $(this), sid = $t.data('sid');
                $.getJSON('detail?sid=' + sid, function (result) {
                    if (result.success) {
                        $form.clearForm(true);
                        $form.formJSON('set', result.record);

                        $.each(result.record.roleList, function () {
                            $('#tbody-roles input[value="' + this.sid + '"]').prop('checked', true);
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
                    var data = $form.formJSON('get');

                    if (!data.sid && !data.password) {
                        showInfoFun('创建管理员时密码不能为空。', 'warning');
                        return false;
                    }

                    if ($('#tbody-roles :checkbox:checked').length === 0) {
                        showInfoFun('请至少选择一个角色。', 'warning');
                        return false;
                    }

                }

                return true;
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

                <form role="search-form">
                    <input type="hidden" name="page" />
                    <input type="hidden" name="size" />

                    <table data-toggle="table" data-page-info='${pageInfo}' data-page-number="${pageInfo.page}" data-page-size="${pageInfo.pageSize}">
                        <thead>
                            <tr>
                                <th width="25%">
                                    <div class="th-inner">用户名</div>
                                </th>
                                <th width="25%">
                                    <div class="th-inner">真实姓名</div>
                                </th>
                                <th width="25%">
                                    <div class="th-inner">授权角色</div>
                                </th>
                                <th width="25%">
                                    <div class="th-inner">操作</div>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                        <#list managers as m>
                            <tr>
                                <td style="text-align: center;">${m.username!''}</td>
                                <td style="text-align: center;">${m.cname!''}</td>
                                <td style="text-align: left;">${m.roleNames!''}</td>
                                <td style="text-align: center;">
                                    <button type="button" class="btn btn-info btn-xs btn-detail" data-sid="${m.sid?c}">
                                        <i class="fa fa-edit fa-fw"></i> 详情
                                    </button>
                                    <@shiro.hasPermission name="manager:save">
                                        <#if m.status == 0>
                                            <a class="btn btn-success btn-xs" href="enable?sid=${m.sid?c}">
                                                <i class="fa fa-check fa-fw"></i> 启用
                                            </a>
                                        <#else>
                                            <a class="btn btn-warning btn-xs" href="disable?sid=${m.sid?c}">
                                                <i class="fa fa-ban fa-fw"></i> 禁用
                                            </a>
                                        </#if>
                                    </@shiro.hasPermission>
                                    <@shiro.hasPermission name="manager:remove">
                                        <button type="button" class="btn btn-danger btn-xs btn-remove" data-sid="${m.sid?c}">
                                            <i class="fa fa-edit fa-fw"></i> 删除
                                        </button>
                                    </@shiro.hasPermission>
                                </td>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </form>

            </div>
        </div>
    </div>

    <div class="col-md-6">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title" id="title">用户详情</h3>
            </div>
            <form class="form-horizontal" method="post" action="save" data-toggle="validator" role="form">
                <input type="hidden" name="sid" />

                <div class="box-body">

                    <div class="form-group has-feedback">
                        <label for="username" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;用户名</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="username" name="username"
                                   placeholder="用户名，最多12个字" required="required" maxlength="12" autocomplete="false" />
                            <span class="glyphicon form-control-feedback" aria-hidden="true"></span>
                            <div class="help-block with-errors"></div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password" class="col-sm-3 control-label">密码</label>
                        <div class="col-sm-9">
                            <input type="password" class="form-control" id="password" name="password"
                                   placeholder="如果留空则表示不修改密码。" rangelength="[6,16]" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="cname" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;真实姓名</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="cname" name="cname" placeholder="真实姓名"
                                   required="required" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="note" class="col-sm-3 control-label"><span style="color: red;">&nbsp;*</span>&nbsp;&nbsp;拥有角色</label>
                        <div class="col-sm-9">
                            <div class="bootstrap-table">
                                <div class="fixed-table-container" style="padding-bottom: 0px;">
                                    <div class="fixed-table-body">
                                        <table class="table table-striped table-hover" id="role-table">
                                            <thead>
                                                <tr>
                                                    <th width="10%">
                                                        <div class="th-inner"><input type="checkbox" id="checkAll" />
                                                        </div>
                                                    </th>
                                                    <th width="30%">
                                                        <div class="th-inner">角色名称</div>
                                                    </th>
                                                    <th width="60%">
                                                        <div class="th-inner">备注</div>
                                                    </th>
                                                </tr>
                                            </thead>
                                            <tbody id="tbody-roles">
                                            <#list roles as r>
                                                <tr>
                                                    <td style="text-align: center;">
                                                        <input type="checkbox" name="roleList[${r_index}].sid"
                                                               value="${r.sid?c}" />
                                                    </td>
                                                    <td style="text-align: center;">${r.cname!''}</td>
                                                    <td style="text-align: center;">${r.note!''}</td>
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
            <@shiro.hasPermission name="manager:save">
                <div class="box-footer">
                    <button type="submit" class="btn btn-primary pull-right">
                        <i class="fa fa-save"></i> 保存
                    </button>
                    <button type="button" class="btn btn-info pull-right btn-reset">
                        <i class="fa fa-eraser"></i> 重置
                    </button>
                </div>
            </@shiro.hasPermission>
            </form>
        </div>
    </div>

</div>
</body>
</html>
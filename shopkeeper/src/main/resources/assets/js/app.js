$(function () {
    var CURRENT_NAV_URL = $('meta[name="nav-url"]').attr('content');
    if (CURRENT_NAV_URL) {
        $('.main-sidebar a').each(function () {
            var href = $(this).attr('href');

            if (href == CURRENT_NAV_URL) {
                $(this).parents('li').addClass('active');
            }
        });
    }

    $('form[data-toggle="validator"]').each(function () {
        $(this).validate({
            ignore: '.ignore',
            highlight: function (element) {
                $(element).closest('.form-group').addClass('has-error');
            },
            unhighlight: function (element) {
                $(element).closest('.form-group').removeClass('has-error');
            },
            errorElement: 'span',
            errorClass: 'help-block',
            errorPlacement: function (error, element) {
                if (element.parent('.input-group').length) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
            }
        });
    });

    $(document).on('click', '.btn.btn-return', function () {
        history.back();
        return false;
    });
});

var showInfoFun = function (msg, type, iconType) {
    if (type == null) {
        type = 'info';
    }
    if (iconType == null) {
        iconType = type;
    }
    var str = [], fid = 'info_flash_' + new Date().getTime();
    type = type || 'info';
    str.push('<div class="alert alert-', type, ' alert-dismissible flash-alert fade" role="alert" id="', fid, '">');
    str.push('<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>');
    str.push('<h4><i class="icon fa fa-', iconType, '"></i>消息</h4>', msg);
    str.push('</div>');

    var $div = $(str.join('')).appendTo('body').addClass('in');
    setTimeout(function () {
        $('#' + fid).fadeOut('fast', function () {
            $('#' + fid).alert('close');
        });
    }, 1000 * 3);
};
/*
 * 删除确认框
 */
var removeConfirmFun = function (sid, url) {
    var str = [];
    str.push('<div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">');
    str.push('<div class="modal-dialog">');
    str.push('<div class="modal-content">');
    str.push('<div class="modal-header">');
    str.push('<h4 class="modal-title" id="myModalLabel">操作确认</h4></div>');
    str.push('<div class="modal-body">');

    str.push('您将进行删除操作，该操作一但执行将无法恢复，是否继续？');

    str.push('</div>');
    str.push('<div class="modal-footer">');
    str.push('<button type="button" class="btn btn-default" data-dismiss="modal">否</button>');

    str.push('<a href="', url, '?sid=', sid, '" class="btn btn-primary">是</a>');

    str.push('</div></div></div></div>');

    $(str.join('')).appendTo('body').modal().on('hidden.bs.modal', function (e) {
        console.log(arguments);
        $(this).remove();
    }).on('hide.bs.modal', function (e) {
        console.log(arguments);
    });
};
/*
 * 确认框
 */
var confirmFun = function (url, msg) {
    var str = [];
    str.push('<div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">');
    str.push('<div class="modal-dialog">');
    str.push('<div class="modal-content">');
    str.push('<div class="modal-header">');
    str.push('<h4 class="modal-title" id="myModalLabel">操作确认</h4></div>');
    str.push('<div class="modal-body">');

    str.push(msg);

    str.push('</div>');
    str.push('<div class="modal-footer">');
    str.push('<button type="button" class="btn btn-default" data-dismiss="modal">否</button>');
    str.push('<a href="', url, '" class="btn btn-primary">是</a>');
    str.push('</div></div></div></div>');

    $(str.join('')).appendTo('body').modal().on('hidden.bs.modal', function (e) {
        console.log(arguments);
        $(this).remove();
    }).on('hide.bs.modal', function (e) {
        console.log(arguments);
    });
};
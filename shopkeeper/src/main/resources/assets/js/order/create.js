var processResults = function (data) {
    var result = [];
    if (data.success) {
        $.each(data.record.content || data.record, function () {
            result.push($.extend({
                id: this.sid
            }, this));
        });
    }

    return {
        results: result
    };
};

var escapeMarkup = function (markup) {
    return markup;
};

var loadCarSelect = function (sid) {
    $.getJSON('/a/customer/findCar?sid=' + sid, function (result) {
        var options = [];
        if (result.success) {
            $.each(result.record, function () {
                console.log(this);
                options.push('<option value="', this.sid, '" data-year="', this.carYearSid, '">', this.carYearCname, '</option>');
            });
        } else {
            showInfoFun(result.msg, 'danger');
        }

        $('#carSid').html(options.join(''));
    });
};

var loadAddressSelect = function (sid) {
    $.getJSON('/a/customer/findAddress?sid=' + sid, function (result) {
        var options = [];
        if (result.success) {
            $.each(result.record, function () {
                options.push('<option value="', this.sid, '">', this.province, ' ', this.city, ' ', this.area, ' ', this.address, '</option>');
            });
        } else {
            showInfoFun(result.msg, 'danger');
        }

        $('#addressSid').html(options.join(''));
    });
};

var initCarAndAddressFun = function () {
    $('[name="carBrandSid"]').select2({
        language: 'zh-CN',
        ajax: {
            url: "/a/carBrand/page",
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    q: params.term || ''
                };
            },
            processResults: processResults,
            cache: false
        },
        escapeMarkup: escapeMarkup,
        templateResult: function (data) {
            if (data.loading) return data.text;

            if (data.text) {
                return data.text;
            } else {
                return '<label>' + data.cname + '</label>';
            }
        },
        templateSelection: function (data) {
            if (data.text) {
                return data.text;
            } else {
                return data.cname;
            }
        }
    }).change(function () {
        var $t = $(this);
        $.getJSON('/a/carModel/findByCarBrandSid?brandSid=' + $t.val(), function (result) {
            if (result.success) {
                var options = [];
                $.each(result.record, function () {
                    options.push('<option value="', this.sid, '">', this.cname, '</option>');
                });

                $t.parents('p').next('p').find('select').removeAttr('disabled').html(options.join('')).change();
            } else {
                showInfoFun(result.msg, 'danger');
            }
        });
    });

    $('[name="carModelSid"]').change(function () {
        var $t = $(this);
        $.getJSON('/a/carYear/findByModelSid?modelSid=' + $t.val(), function (result) {
            if (result.success) {
                var options = [];
                $.each(result.record, function () {
                    options.push('<option value="', this.sid, '">', this.cname, '</option>');
                });

                $t.parents('p').next('p').find('select').removeAttr('disabled').html(options.join(''));
            } else {
                showInfoFun(result.msg, 'danger');
            }
        });
    });

    $('[name="province"]').change(function () {
        var $t = $(this), $opt = $t.find(':selected');
        $.getJSON('/a/area/find?type=2&parentSid=' + $opt.data('sid'), function (result) {
            if (result.success) {
                var options = [];
                $.each(result.record, function () {
                    options.push('<option value="', this.sid, '" data-sid="', this.sid, '">', this.cname, '</option>');
                });

                $t.parents('p').next('p').find('select').removeAttr('disabled').html(options.join('')).change();
            } else {
                showInfoFun(result.msg, 'danger');
            }
        });
    }).change();

    $('[name="city"]').change(function () {
        var $t = $(this), $opt = $t.find(':selected');
        $.getJSON('/a/area/find?type=3&parentSid=' + $opt.data('sid'), function (result) {
            if (result.success) {
                var options = [];
                $.each(result.record, function () {
                    options.push('<option value="', this.sid, '">', this.cname, '</option>');
                });

                $t.parents('p').next('p').find('select').removeAttr('disabled').html(options.join(''));
            } else {
                showInfoFun(result.msg, 'danger');
            }
        });
    });
};

var selectService = function (service) {
    var $divService = $('#div-service');
    var sids = [];

    $('.service-item-wrapper', $divService).each(function () {
        sids.push($(this).data('service'));
    });

    if ($.inArray(service.sid, sids) > -1) {
        showInfoFun('不能选择重复的服务项', 'warning');
        return;
    }

    $divService.append($.templates('#tpl-service').render($.extend({
        partTypeMap: partTypeMap
    }, service)));
};

var selectPackage = function (package) {
    console.log(package);
};

$(function () {
    $.views.tags("partTypeMap", function (val) {
        return partTypeMap[val.key] ? partTypeMap[val.key].cname : '';
    });
    $.views.tags("options", function (val) {
        var html = ['<option value="', val.part.sid, '">'];
        html.push(val.part.cname, ' ', val.part.model, ' ', val.part.specification);
        html.push('</option>');

        return html.join('');
    });

    $('.date').datetimepicker({
        minView: 0,
        minuteStep: 30,
        format: "yyyy-mm-dd hh:ii",
        pickerPosition: "top-left"
    });

    var $customerSid = $('#customerSid');
    $customerSid.select2({
        language: 'zh-CN',
        ajax: {
            url: "/a/customer/find",
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    q: params.term || ''
                };
            },
            processResults: processResults,
            cache: false
        },
        escapeMarkup: escapeMarkup,
        templateResult: function (data) {
            if (data.loading) return data.text;

            if (data.text) {
                return data.text;
            } else {
                return '<label>' + data.cname + ' ' + data.telephone + '</label>';
            }
        },
        templateSelection: function (data) {
            if (data.text) {
                return data.text;
            } else {
                return data.cname + ' ' + data.telephone;
            }
        }
    }).change(function () {
        var $carSid = $('#carSid'), $addressSid = $('#addressSid');

        if ($customerSid.val()) {
            loadCarSelect($customerSid.val());
            loadAddressSelect($customerSid.val());

            $carSid.removeAttr('disabled');
            $addressSid.removeAttr('disabled');
        } else {
            $carSid.attr('disabled', true);
            $addressSid.attr('disabled', true);
        }
    });

    $('#btn-customer').click(function () {
        if ($('#div-select-customer').is(':visible')) {
            $('#div-car-address').load('createCarAndAddress');

            $('#btn-customer').removeClass('btn-primary').addClass('btn-info').html('<i class="fa fa-minus"></i>');
            $('#div-select-customer').hide();
            $('#div-new-customer').removeClass('hidden');
        } else {
            $('#div-car-address').load('carAndAddress');

            $('#btn-customer').removeClass('btn-info').addClass('btn-primary').html('<i class="fa fa-plus"></i>');
            $('#div-select-customer').show();
            $('#div-new-customer').addClass('hidden');
        }
    });

    var $dlgService = $('#dlg-service'), $dlgContent = $('.modal-body', $dlgService);
    $('#btn-service').click(function () {
        var carYearSid = $('#carSid option:selected').data('year') || $('[name="carYearSid"]').val();

        if (carYearSid) {
            $dlgService.modal('show');
            $dlgContent.html('<i class="fa fa-refresh fa-spin fa-3x fa-fw"></i><span class="sr-only">加载中……</span>').load('dlgService?carYearSid=' + carYearSid);
        } else {
            showInfoFun('请先选择一款车款。');
        }
    });

});
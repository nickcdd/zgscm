<#--
<#assign USER = VIEW_UTILS.getSessionAttribute(SESSION_KEY.CURRENT_USER) />
<#assign bankCards = VIEW_UTILS.getSessionAttribute("bankCards") />
<style>
    input[type="number"]::-webkit-outer-spin-button,
    input[type="number"]::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }
    input[type="number"] {
        -moz-appearance: textfield;
    }
</style>
<div class="modal fade" id="tixian_Modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="myModalLabel">
                    <div class="nav-tabs-custom">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#tixian_toBank_tab" data-toggle="tab" aria-expanded="true">提现到银行卡</a>
                            </li>
                            <li class=""><a href="#addBank_tab" data-toggle="tab" aria-expanded="false">添加银行卡</a></li>
                        </ul>
                    </div>
                </h4>
            </div>
            <div class="modal-body">
                <div class="tab-content">
                    <div class="tab-pane active" id="tixian_toBank_tab">
                        <div class=" row">
                            <div class=" col-xs-8 col-xs-offset-2">
                                <form action="/withdrawApply/save" id="withdrawApplyForm" role="form"
                                      data-toggle="validator">
                                    <div class="row clearfix" type="button" id="dropdownMenu2" data-toggle="dropdown">
                                    <#if bankCards ??>
                                        <#list bankCards as card>
                                            <#if card_index == 0>
                                                <div class="col-xs-5 form-group">
                                                    <img id="currentBankName"
                                                         src="/assets/img/bankImg/${card.bankName}.png"
                                                         class="img-thumbnail">
                                                </div>
                                                <div class="col-xs-5"><p id="currentBankCardNo" class="text-info">尾号
                                                    ： ${card.cardNo?substring(card.cardNo?length-4,card.cardNo?length)}</p>
                                                    <p class="text-info">姓名：
                                                        <#if USER.realName ??>
                                                        ${USER.realName}
                                                        </#if>
                                                    </p></div>
                                                <div class="col-xs-2 form-group">
                                                    <span class="caret" style="margin-top:30%;"></span>
                                                </div>
                                                <input id="bankName" type="hidden" name="bankName"
                                                       value="${card.bankName}">
                                                <input id="cardNo" type="hidden" name="cardNo" value="${card.cardNo}">
                                            </#if>
                                        </#list>
                                    </#if>
                                    </div>
                                    <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu2"
                                        style="margin-top:-40%;margin-left:3.5%">
                                    <#if bankCards ??>
                                        <#list bankCards as card>
                                            <li role="presentation"
                                                onclick="changeBankCard('${card.bankName}',${card.cardNo})">
                                                <a role="menuitem" tabindex="-1">
                                                    <div class="row clearfix menuitem">
                                                        <div class="col-xs-5 form-group">
                                                            <img src="/assets/img/bankImg/${card.bankName}.png"
                                                                 class="img-thumbnail">
                                                        </div>
                                                        <div class="col-xs-5"><p class="text-info">尾号
                                                            ： ${card.cardNo?substring(card.cardNo?length-4,card.cardNo?length)}</p>
                                                            <p class="text-info">姓名：
                                                                <#if USER.realName ??>
                                                                ${USER.realName}
                                                                </#if>
                                                            </p></div>
                                                    </div>
                                                </a>
                                            </li>
                                        </#list>
                                    </#if>
                                    </ul>
                                    <div class="row clearfix ">
                                        <div class="col-xs-12">

                                            <div class="form-group ">
                                                <input type="number"
                                                       id="inputBalance"
                                                       name="amount" class="form-control input-lg" placeholder="请输入提现金额"
                                                       required>
                                                <p class="text-info ">可提现余额
                                                    <strong id="balance">
                                                        <#if USER.balance ??>
                                                            ${USER.balance?c}
                                                        </#if>
                                                    </strong>元
                                                </p>
                                            </div>
                                            <div class="form-group ">
                                                <button type="button" onclick="submitTixian()"
                                                        class="btn btn-primary btn-lg btn-block ">确认提现
                                                </button>
                                            </div>

                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane" id="addBank_tab">
                        <p>为了您的安全，即日起只能添加快捷卡才能进行提现。</p>
                        <div class="row form-group">
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=ABC"><img src="/assets/img/bankImg/ABC.png"
                                                                                    class="img-thumbnail"></a>
                            </div>
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=BJBANK"><img
                                        src="/assets/img/bankImg/BJBANK.png" class="img-thumbnail"></a>
                            </div>
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=BOC"><img src="/assets/img/bankImg/BOC.png"
                                                                                    class="img-thumbnail"></a>
                            </div>
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=CCB"><img src="/assets/img/bankImg/CCB.png"
                                                                                    class="img-thumbnail"></a>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=CCQTGB"><img
                                        src="/assets/img/bankImg/CCQTGB.png" class="img-thumbnail"></a>
                            </div>
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=CDCB"><img src="/assets/img/bankImg/CDCB.png"
                                                                                     class="img-thumbnail"></a>
                            </div>
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=CIB"><img src="/assets/img/bankImg/CIB.png"
                                                                                    class="img-thumbnail"></a>
                            </div>
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=CITIC"><img
                                        src="/assets/img/bankImg/CITIC.png" class="img-thumbnail"></a>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=CMB"><img src="/assets/img/bankImg/CMB.png"
                                                                                    class="img-thumbnail"></a>
                            </div>
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=CMBC"><img src="/assets/img/bankImg/CMBC.png"
                                                                                     class="img-thumbnail"></a>
                            </div>
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=COMM"><img src="/assets/img/bankImg/COMM.png"
                                                                                     class="img-thumbnail"></a>
                            </div>
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=CQBANK"><img
                                        src="/assets/img/bankImg/CQBANK.png" class="img-thumbnail"></a>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=CRCBANK"><img
                                        src="/assets/img/bankImg/CRCBANK.png" class="img-thumbnail"></a>
                            </div>
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=GDB"><img src="/assets/img/bankImg/GDB.png"
                                                                                    class="img-thumbnail"></a>
                            </div>
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=HXBANK"><img
                                        src="/assets/img/bankImg/HXBANK.png" class="img-thumbnail"></a>
                            </div>
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=ICBC"><img src="/assets/img/bankImg/ICBC.png"
                                                                                     class="img-thumbnail"></a>
                            </div>
                        </div>
                        <div class="row form-group">
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=PINGAN"><img
                                        src="/assets/img/bankImg/PINGAN.png" class="img-thumbnail"></a>
                            </div>
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=PSBC"><img src="/assets/img/bankImg/PSBC.png"
                                                                                     class="img-thumbnail"></a>
                            </div>
                            <div class="col-xs-3">
                                <a href="/shopKeeperCard/add?bankCardName=SPDB"><img src="/assets/img/bankImg/SPDB.png"
                                                                                     class="img-thumbnail"></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    /**
     * 修改相应的银行卡显示效果和提现表单的银行卡值
     * @param currentBankName
     * @param currentBankCardNo
     */
    function changeBankCard(currentBankName, currentBankCardNo) {
        var temp = currentBankCardNo + "";
        var cardNoMantissa = temp.substring(temp.length - 4, temp.length);
        $("#currentBankName").attr('src', "/assets/img/bankImg/" + currentBankName + ".png");
        $("#currentBankCardNo").html("尾号：" + cardNoMantissa);
        $("#bankName").val(currentBankName);
        $("#cardNo").val(currentBankCardNo);
    }
    function submitTixian() {
        if ($("#bankName").val() == undefined) {
            showInfoFun('请先添加一张银行卡。', 'info');
            return false;
        }
        var balance = $("#balance").text();
        if(balance == undefined || balance == null || balance == ""){
            balance = 0;
        }
        var inputBalance = $("#inputBalance").val();
        balance = parseFloat(balance,10);
        inputBalance = parseFloat(inputBalance,10);
        if(balance < inputBalance){
            showInfoFun('输入提现金额应小于可提现金额。', 'info');
            return false;
        }
        $("#withdrawApplyForm").submit();
    }
</script>
-->

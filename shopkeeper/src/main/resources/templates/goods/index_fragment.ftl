<#if goods ?? && goods.totalElements gt 0>
    <#list goods.content as good>
    <div style="height: 70px;margin: 1% 0 0 0">
        <a href="/goods/detail?sid=${good.sid?c}">
            <div style="width: 25%;float: left;height: 50px;">
                <#if good.goodsFiles ??>
                    <#if good.goodsFiles?size == 0>
                        <img style="max-height: 70px;" src="/assets/img/goods/img-goods-default.png" />
                    </#if>
                    <#list good.goodsFiles as goodsfile>
                        <#if goodsfile_index == 0>
                            <img style="max-height: 70px;max-width: 100%;" src="${goodsfile.url}" onerror="checkImgFun(this);" />
                        <#else>
                            <img style="max-height: 70px;" src="/assets/img/goods/img-goods-default.png" />
                        </#if>
                    </#list>
                <#else>
                    <img style="max-height: 70px;" src="/assets/img/goods/img-goods-default.png" />
                </#if>
            </div>
        </a>
        <#if good.goodsSpecifications ??>
            <#list good.goodsSpecifications as pecifications>
                <#if pecifications_index == 0>
                    <#assign minPrice = pecifications.price maxPirce = pecifications.price>
                </#if>
                <#if minPrice gt pecifications.price>
                    <#assign minPrice = pecifications.price>
                </#if>
                <#if maxPirce lt pecifications.price>
                    <#assign maxPirce = pecifications.price>
                </#if>
            </#list>
            <div style="width: 70%;float: left;margin: 0 0 0 5%">
                <a href="/goods/detail?sid=${good.sid?c}">
                    <h5 class="nowrap">${good.cname}</h5>
                <#-- <p>商品简介;预留..</p>-->
                </a>
                <#if minPrice == maxPirce>
                    <div style="width: 40%;text-align: left;float: left">
                        <span class="text-red">￥#{minPrice;m2M2}</span>
                    </div>
                <#else >
                    <div><span class="text-red">￥#{minPrice;m2M2}</span> ~
                        <span class="text-red">#{maxPirce;m2M2}</span></div>
                    <div style="width: 40%;text-align: left;float: left">&nbsp;</div>
                </#if>
                <div style="width: 60%;text-align: right;float: left">
                    <#if good.goodsSpecifications ??>
                        <#if good.goodsSpecifications?size gt 1>
                            <button type="button" class="btn btn-warning btn-xs" onclick="modelPecification('${good.sid?c}')">
                                选规格
                            </button>
                        <#else >
                            <#list good.goodsSpecifications as goodsSpecification>
                                <#assign tempFlag = 'false'>
                                <#assign goodsAmountFlag = 0>
                                <#if shopKeeperCards ??>
                                    <#list shopKeeperCards as shopKeeperCard>
                                        <#if shopKeeperCard.goodsSpecification.sid == goodsSpecification.sid>
                                            <#assign tempFlag = 'true'>
                                            <#assign goodsAmountFlag = shopKeeperCard.goodsAmount>
                                        </#if>
                                    </#list>
                                </#if>
                                <#if tempFlag == 'true'>
                                    <i class="glyphicon glyphicon-minus showClass but-subtract-click" data-sid="${goodsSpecification.sid?c}"></i>&nbsp;
                                    <span class="showClass goods_count">${goodsAmountFlag}</span>&nbsp;
                                    <i class="glyphicon glyphicon-plus but-add-click" data-sid="${goodsSpecification.sid?c}"></i>
                                <#else>
                                    <i class="glyphicon glyphicon-minus hideClass but-subtract-click" data-sid="${goodsSpecification.sid?c}"></i>&nbsp;
                                    <span class="hideClass goods_count">0</span>&nbsp;
                                    <i class="glyphicon glyphicon-plus but-add-click" data-sid="${goodsSpecification.sid?c}"></i>
                                </#if>
                            </#list>
                        </#if>
                    </#if>
                </div>
            </div>
        </#if>
    </div>
    </#list>
    <#if !goods.last>
    <a class="hospitaltitel-center next" href="javascript: void(0);" data-page="${goods.number + 1}" data-sid="${categorySid?c}">
        <div style="width: 100%;text-align: center">点击加载更多</div>
    </a>
    <div class="record_content"></div>
    </#if>
<#else >
<p style="text-align: center;">没有商品记录！</p>
</#if>

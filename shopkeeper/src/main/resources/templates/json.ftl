<#-- json.ftl
  --
  -- Generates JSON of data model items.
  --
  -- Usage:
  -- <#import "json.ftl" as json>
  --
  -- <@json.stringify your_model_here />
  --
  -->


<#-- The black_list contains bad hash keys. Any hash key which matches a
  -- black_list entry is prevented from being displayed.
  -->
<#assign black_list = ["class"] />


<#--
  -- The main macro.
  -->

<#macro stringify data escape="none"><@compress single_line=true>
    <#assign generated_json><@rawStringify data /></#assign>
    <#if escape == "html">
    ${generated_json?html}
    <#elseif escape == "js_string">
    ${generated_json?js_string}
    <#else>
    ${generated_json}
    </#if>
</@compress></#macro>

<#-- private helper macros. it's not recommended to use these macros from
  -- outside the macro library.
  -->

<#macro rawStringify data>
    <#if data?is_enumerable>
        <@printList data,[] />
    <#elseif data?is_hash_ex>
        <@printHashEx data,[] />
    </#if>
</#macro>

<#macro printList list has_next_array>
    <#local counter=0 />
    <#local highestIndex = list?size - 1 />
    <#t>[<#list list as item>
    <#if !item?if_exists?is_method><#if !item?if_exists?is_hash_ex || !omit(counter?string)>
        <@printListItem item?if_exists,has_next_array+[item_has_next], counter />
        <#if counter < highestIndex>,</#if><#local counter = counter + 1/></#if></#if>
</#list>]
</#macro>

<#macro printHashEx hash has_next_array>
    <#local isFirst=true />
    <#t>{<#list hash?keys as key>
    <#if key?is_string>
        <#assign k=key />
    <#else>
        <#assign k=key?c />
    </#if>
    <#if !hash[k]?if_exists?is_method><#if !hash[k]?if_exists?is_hash_ex || !omit(k?string)><#if !isFirst>,</#if>
        <@printItem hash[k]?if_exists,has_next_array+[key_has_next], k />
        <#local isFirst = false /></#if></#if>
</#list>}
</#macro>

<#macro printItem item has_next_array key>
    <#if item?is_enumerable>
        <#t>"${key?js_string}":<@printList item, has_next_array />
    <#elseif item?is_hash_ex>
        <#t>"${key?js_string}":<@printHashEx item, has_next_array />
    <#elseif item?is_number>
        <#t>"${key?js_string}":${item?string.computer}
    <#elseif item?is_string>
        <#t>"${key?js_string}":"${item?js_string}"
    <#elseif item?is_boolean>
        <#t>"${key?js_string}":${item?string}
    <#elseif item?is_date>
        <#t>"${key?js_string}":"${item?string("yyyy-MM-dd'T'HH:mm:sszzzz")}"
    <#else>
        <#t>"${key?js_string}":"x0"
    </#if>
</#macro>

<#macro printListItem item has_next_array key>
    <#if item?is_enumerable>
        <#t><@printList item, has_next_array />
    <#elseif item?is_hash_ex>
        <#t><@printHashEx item, has_next_array />
    <#elseif item?is_number>
        <#t>${item?string.computer}
    <#elseif item?is_string>
        <#t>"${item?js_string}"
    <#elseif item?is_boolean>
        <#t>${item?string}
    <#elseif item?is_date>
        <#t>"${item?string("yyyy-MM-dd'T'HH:mm:sszzzz")}"
    <#else>
        <#t>"x1"
    </#if>
</#macro>

<#function omit key>
    <#local what = key?lower_case>
    <#list black_list as item>
        <#if what?index_of(item) gte 0>
            <#return true>
        </#if>
    </#list>
    <#return false>
</#function>

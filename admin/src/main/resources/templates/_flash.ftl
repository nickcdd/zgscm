<#import "/spring.ftl" as spring />
<#if ERROR_MESSAGE??>
	<#assign fid="err_flash_" + .now?long?c />
	<div class="alert alert-danger alert-dismissible alert-dismissible flash-alert fade in" id="${fid}">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
		<h4><i class="icon fa fa-ban"></i>消息</h4><@spring.messageText ERROR_MESSAGE, ERROR_MESSAGE />
	</div>
	<script type="text/javascript">
		setTimeout(function() {
			$('#${fid}').on('closed.bs.alert', function() {
				$('#${fid}').remove();
			}).alert('close');
		}, 1000 * 3);
	</script>
</#if>
<#if INFO_MESSAGE??>
	<#assign fid="info_flash_" + .now?long?c />
	<div class="alert alert-info alert-dismissible alert-dismissible flash-alert fade in" id="${fid}">
		<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
		<h4><i class="icon fa fa-info"></i>消息</h4><@spring.messageText INFO_MESSAGE, INFO_MESSAGE />
	</div>
	<script type="text/javascript">
		setTimeout(function() {
			$('#${fid}').on('closed.bs.alert', function() {
				$('#${fid}').remove();
			}).alert('close');
		}, 1000 * 3);
	</script>
</#if>

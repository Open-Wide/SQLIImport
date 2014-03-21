<style type="text/css">
    @import url({'stylesheets/sqiimport.css'|ezdesign});
</style>

<form enctype="multipart/form-data" action={'/sqliimport/addimport'|ezurl} method="post">
	<div class="context-block">
		{if is_set( $error_message )}
			<div class="message-error">
				<h2>{'Input did not validate'|i18n( 'design/admin/settings' )}</h2>
				<p>{$error_message}</p>
			</div>
		{/if}
		<div class="box-header">
			<div class="box-tc">
				<div class="box-ml">
					<div class="box-mr">
						<div class="box-tl">
							<div class="box-tr">
								<h1 class="context-title">{'Request a new immediate import'|i18n( 'extension/sqliimport' )}</h1>
								{* DESIGN: Mainline *}<div class="header-mainline"></div>
								{* DESIGN: Header END *}
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	{* DESIGN: Content START *}
	<div class="box-ml">
		<div class="box-mr">
			<div class="box-content">
				<div class="block">
					<h4>{'Import handler'|i18n( 'extension/sqliimport' )}</h4>
					<p>
						<select name="ImportHandler" id="ImportHandler">
							{foreach $importHandlers as $handlerName => $handler}
								<option value="{$handler}"{if $handler|eq( $current_import_handler )} selected="selected"{/if}>{$handlerName}</option>

							{/foreach}
						</select>
					</p>
					<p>&nbsp;</p>
					<div id="ImportOptions"></div>
					{* DESIGN: Content END *}
				</div>
			</div>
		</div>
	</div>

	{* Buttons. *}
	<div class="controlbar">
		{* DESIGN: Control bar START *}
		<div class="box-bc">
			<div class="box-ml">
				<div class="box-mr">
					<div class="box-tc">
						<div class="box-bl">
							<div class="box-br">
								<div class="block">
									<input class="button" type="submit" name="RequestImportButton" value="{'Request a new immediate import'|i18n( 'extension/sqliimport' )}" />
								</div>
								{* DESIGN: Control bar END *}
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>

<div id="ImportHandlersOptions">
	{foreach $importHandlers as $handlerName => $handler}
		<div id="{$handler}-ImportHandlersOptions">
			{if ezini_hasvariable( concat($handler, '-HandlerSettings'), 'Options' , 'sqliimport.ini' )}
				<h4>{'Options'|i18n( 'extension/sqliimport' )}</h4>
				<div class="ImportHandlersOptions">
					{def $handlerOptionList = ezini( concat($handler, '-HandlerSettings'), 'Options' , 'sqliimport.ini' )}
					{if ezini_hasvariable( concat($handler, '-HandlerSettings'), 'OptionNames' , 'sqliimport.ini' )}
						{def $handlerOptionName = ezini( concat($handler, '-HandlerSettings'), 'OptionNames' , 'sqliimport.ini' )}
					{/if}
					{foreach $handlerOptionList as $option}
						<div class="block">
							<h5>{if and( $handlerOptionName, is_set( $handlerOptionName[$option] ) )}{$handlerOptionName[$option]}{else}{$option}{/if}</h5>
							{* Render the different attribute types each tool can have *}
							{switch match=cond( $option|wash|ends_with( 'NodeID' ), 'node',
                                $option|wash|ends_with( 'ClassIdentifier' ), 'classidentifier',
                                $option|wash|ends_with( 'File' ), 'file',
                                $option|wash|ends_with( 'Check' ), 'check',
                                $option|wash|ends_with( 'Select' ), 'select',
                                'other' )}
							{case match='node'}
							{let used_node=fetch( 'content', 'node', hash( 'node_id', $import_options[$option] ) )}
							{if $used_node}
								{$used_node.object.content_class.identifier|class_icon( small, $used_node.object.content_class.name|wash )}&nbsp;{$used_node.name|wash} ({$import_options[$option]})
							{else}
								{$import_options[$option]|wash()}
							{/if}
							{/let}
							<input type="submit" name="BrowseButton[{$option}]" value="{'Browse'|i18n( 'extension/sqliimport' )}" />
							<input type="hidden" name="ImportOptions[{$option}]" value="{$import_options[$option]|wash()}">
							{/case}
							{case match='classidentifier'}
							{let class_list=fetch( 'class', 'list', hash( 'sort_by', array( 'name', true() ) ) )}
							<select name="ImportOptions[{$option}]">
								<option value=""></option>
								{section var=class loop=$class_list}
									<option value="{$class.identifier|wash}" {if $import_options[$option]|eq($class.identifier)}selected="selected"{/if}>{$class.name|wash}</option>
								{/section}
							</select>
							{/let}
							{/case}
							{case match='file'}
							{if $import_options[$option]}
								<a href="/{$import_options[$option]}" target="_blank">{$import_options[$option]|wash()}</a>
								<input name="ImportOptions[{$option}]" type="hidden" value="{$import_options[$option]}" />
							{/if}
							<input type="hidden" name="MAX_FILE_SIZE" value="0" />
							<input type="hidden" name="FileOptions[]" value="{$option}" />
							<input name="UploadFile_{$option}" type="file" />
							{/case}
							{case match='check'}
							<label for="ImportOptions[{$option}]_yes"><input type="radio" name="ImportOptions[{$option}]" id="ImportOptions[{$option}]_yes" value="yes" />{'Yes'|i18n( 'extension/sqliimport' )}</label>
							<label for="ImportOptions[{$option}]_no"><input type="radio" name="ImportOptions[{$option}]" id="ImportOptions[{$option}]_no" value="no" />{'No'|i18n( 'extension/sqliimport' )}</label>
								{/case}
								{case}
							<input type="text" name="ImportOptions[{$option}]" size="20" value="{$import_options[$option]|wash()}" />
							{/case}
							{case match='select'}
							{let option_list=ezini( concat($handler, '-HandlerSettings'), $option , 'sqliimport.ini' )}
							<select name="ImportOptions[{$option}]">
								<option value=""></option>
								{foreach $option_list as $identifier => $name}
									<option value="{$identifier|wash}" {if $import_options[$option]|eq($identifier)}selected="selected"{/if}>{$name|wash}</option>
								{/foreach}
							</select>
							{/let}
							{/case}
							{/switch}
						</div>
						<p>&nbsp;</p>
					{/foreach}
				</div>
				{undef $handlerOptionList $handlerOptionName}
			{/if}
		</div>
	{/foreach}
</div>
<script type="text/javascript">
	{literal}
		$(document).ready(function() {
			$("#ImportOptions").html($("#" + $("#ImportHandler").val() + "-ImportHandlersOptions").html());
			$("#ImportHandler").change(function() {
				$("#ImportOptions").html($("#" + $(this).val() + "-ImportHandlersOptions").html());
			});
		});
    {/literal}
</script>
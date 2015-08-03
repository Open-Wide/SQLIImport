<style type="text/css">
    @import url({'stylesheets/sqiimport.css'|ezdesign});
</style>
{if is_set( $error_message )}
    <div class="message-error">
        <h2>{'Input did not validate'|i18n( 'design/admin/settings' )}</h2>
        <p>{$error_message}</p>
    </div>
{/if}

<form enctype="multipart/form-data" action={concat( '/sqliimport/addscheduled/', $import_id )|ezurl} method="post">
    <div class="box-header">
        <div class="box-tc">
            <div class="box-ml">
                <div class="box-mr">
                    <div class="box-tl">
                        <div class="box-tr">
                            <h1 class="context-title">{'Schedule an import'|i18n( 'extension/sqliimport' )}</h1>
                            {* DESIGN: Mainline *}<div class="header-mainline"></div>
                            {* DESIGN: Header END *}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {* DESIGN: Content START *}
    <div class="box-ml"><div class="box-mr"><div class="box-content">
                <div class="block">
                    <h4>{'Import label'|i18n( 'extension/sqliimport' )}</h4>
                    <p>
                        <input type="text" name="ScheduledLabel" value="{$import_label}" />
                    </p>
                    <p>&nbsp;</p>

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

                    <h4>{'Choose a start date (YYYY-mm-dd)'|i18n( 'extension/sqliimport' )}</h4>
                    <p>
                        <input type="text" name="ScheduledDate" value="{if is_set( $import_date )}{$import_date}{else}YYYY-mm-dd{/if}" id="ScheduledDate" />

                        {'Hour'|i18n( 'extension/sqliimport' )}
                        <select name="ScheduledHour">
                            {for 0 to 23 as $hour}
                                <option value="{$hour}"{if and( is_set( $import_hour ), eq( $import_hour, $hour ) )} selected="selected"{/if}>{$hour}</option>

                            {/for}
                        </select>

                        {def $quarters = array( 0, 15, 30, 45 )}
                        {'Minutes'|i18n( 'extension/sqliimport' )}
                        <select name="ScheduledMinute">
                            {foreach $quarters as $quarter}
                                <option value="{$quarter}"{if and( is_set( $import_minute ), eq( $import_minute, $quarter ) )} selected="selected"{/if}>{$quarter}</option>
                            {/foreach}
                        </select>
                    </p>
                    <p>&nbsp;</p>

                    <h4>{'Frequency'|i18n( 'extension/sqliimport/schedulefrequency' )}</h4>
                    <p>
                        <input type="radio" name="ScheduledFrequency" value="none"    {if or( is_unset( $import_frequency ), $import_frequency|eq( 'none' ) )} checked="checked"{/if}/>{'None'|i18n( 'extension/sqliimport/schedulefrequency' )}
                        <input type="radio" name="ScheduledFrequency" value="hourly"  {if and( is_set( $import_frequency ), $import_frequency|eq( 'hourly' ) )} checked="checked"{/if}/>{'Hourly'|i18n( 'extension/sqliimport/schedulefrequency' )}
                        <input type="radio" name="ScheduledFrequency" value="daily"   {if and( is_set( $import_frequency ), $import_frequency|eq( 'daily' ) )} checked="checked"{/if}/>{'Daily'|i18n( 'extension/sqliimport/schedulefrequency' )}
                        <input type="radio" name="ScheduledFrequency" value="weekly"  {if and( is_set( $import_frequency ), $import_frequency|eq( 'weekly' ) )} checked="checked"{/if}/>{'Weekly'|i18n( 'extension/sqliimport/schedulefrequency' )}
                        <input type="radio" name="ScheduledFrequency" value="monthly" {if and( is_set( $import_frequency ), $import_frequency|eq( 'monthly' ) )} checked="checked"{/if}/>{'Monthly'|i18n( 'extension/sqliimport/schedulefrequency' )}

                        {* Manual frequency *}
                        <br />
                        <input type="radio" name="ScheduledFrequency" value="manual"  {if and( is_set( $import_frequency ), $import_frequency|eq( 'manual' ) )} checked="checked"{/if} onclick="document.getElementById('ManualScheduledFrequency').removeAttribute('disabled')" />{'Every'|i18n( 'extension/sqliimport/schedulefrequency' )} :
                        <input type="text" id="ManualScheduledFrequency" name="ManualScheduledFrequency" size="5" value="{cond( is_set( $manual_frequency ), $manual_frequency, 0 )}" {if or( is_unset( $import_frequency ), $import_frequency|ne( 'manual' ) )} disabled="disabled"{/if} /> {'minutes (not less than 5min)'|i18n( 'extension/sqliimport/schedulefrequency' )}
                    </p>
                    <p>&nbsp;</p>

                    <h4>{'Activate import'|i18n( 'extension/sqliimport' )}</h4>
                    <p>
                        <input type="checkbox" name="ScheduledActive"{if $import_is_active} checked="checked"{/if} />
                    </p>
                    {* DESIGN: Content END *}
                </div>
            </div></div></div>

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
                                    <input class="button" type="submit" name="RequestScheduledImportButton" value="{'Add a scheduled import'|i18n( 'extension/sqliimport' )}" />
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
                            {def $used_node=fetch( 'content', 'node', hash( 'node_id', $import_options[$option] ) )}
                            {if $used_node}
                                {$used_node.object.content_class.identifier|class_icon( small, $used_node.object.content_class.name|wash )}&nbsp;{$used_node.name|wash} ({$import_options[$option]})
                            {else}
                                {$import_options[$option]|wash()}
                            {/if}
                            {undef $used_node}
                            <input type="submit" name="BrowseButton[{$option}]" value="{'Browse'|i18n( 'extension/sqliimport' )}" />
                            <input type="hidden" name="ImportOptions[{$option}]" value="{$import_options[$option]|wash()}">
                            {/case}
                            {case match='classidentifier'}
                            {def $class_list=fetch( 'class', 'list', hash( 'sort_by', array( 'name', true() ) ) )}
                            <select name="ImportOptions[{$option}]">
                                <option value=""></option>
                                {foreach $class_list as $class}
                                    <option value="{$class.identifier|wash}">{$class.name|wash}</option>
                                {/foreach}
                            </select>
                            {undef $class_list}
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
                            {def $option_list=ezini( concat($handler, '-HandlerSettings'), $option , 'sqliimport.ini' )}
                            <select name="ImportOptions[{$option}]">
                                <option value=""></option>
                                {foreach $option_list as $identifier => $name}
                                    <option value="{$identifier|wash}" {if $import_options[$option]|eq($identifier)}selected="selected"{/if}>{$name|wash}</option>
                                {/foreach}
                            </select>
                            {undef $option_list}
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

<!-- JSCalendar settings -->
<style type="text/css">
    @import url({'stylesheets/jscal2.css'|ezdesign});
    @import url({'stylesheets/border-radius.css'|ezdesign});
    @import url({'stylesheets/steel/steel.css'|ezdesign});
</style>
<script type="text/javascript" src={'javascript/jscal2.js'|ezdesign}></script>
<script type="text/javascript" src={concat( 'javascript/lang/en.js'|i18n( 'extension/sqliimport' ) )|ezdesign}></script>
<script type="text/javascript">
    Calendar.setup({ldelim}
            trigger: 'ScheduledDate',
            inputField: 'ScheduledDate',
            onSelect: function () {ldelim}
                        this.hide();
    {rdelim},
    {rdelim});
    {literal}
        $(document).ready(function () {
            $("#ImportOptions").html($("#" + $("#ImportHandler").val() + "-ImportHandlersOptions").html());
            $("#ImportHandler").change(function () {
                $("#ImportOptions").html($("#" + $(this).val() + "-ImportHandlersOptions").html());
            });
        });
    {/literal}
</script>
{include uri='design:parts/ini_menu.tpl' ini_section='Leftmenu_sqliimport' i18n_hash=hash(
    'Import management',  'Import management'|i18n( 'extension/sqliimport' ),
    'list',               'Import list'|i18n( 'extension/sqliimport'),
    'scheduledlist',      'Scheduled import(s)'|i18n( 'extension/sqliimport'),
    'addimport',          'Request a new immediate import'|i18n( 'extension/sqliimport'),
    'purgelist',          'Purge import history'|i18n( 'extension/sqliimport' )
)}
<div id="widthcontrol-links" class="widthcontrol">
    <p>
        {switch match=ezpreference( 'admin_left_menu_size' )}
        {case match='medium'}
        <a href={'/user/preferences/set/admin_left_menu_size/small'|ezurl} title="{'Change the left menu width to small size.'|i18n( 'design/admin/parts/user/menu' )}">{'Small'|i18n( 'design/admin/parts/user/menu' )}</a>
        <span class="current">{'Medium'|i18n( 'design/admin/parts/user/menu' )}</span>
        <a href={'/user/preferences/set/admin_left_menu_size/large'|ezurl} title="{'Change the left menu width to large size.'|i18n( 'design/admin/parts/user/menu' )}">{'Large'|i18n( 'design/admin/parts/user/menu' )}</a>
        {/case}

        {case match='large'}
        <a href={'/user/preferences/set/admin_left_menu_size/small'|ezurl} title="{'Change the left menu width to small size.'|i18n( 'design/admin/parts/user/menu' )}">{'Small'|i18n( 'design/admin/parts/user/menu' )}</a>
        <a href={'/user/preferences/set/admin_left_menu_size/medium'|ezurl} title="{'Change the left menu width to medium size.'|i18n( 'design/admin/parts/user/menu' )}">{'Medium'|i18n( 'design/admin/parts/user/menu' )}</a>
        <span class="current">{'Large'|i18n( 'design/admin/parts/user/menu' )}</span>
        {/case}

        {case in=array( 'small', '' )}
        <span class="current">{'Small'|i18n( 'design/admin/parts/user/menu' )}</span>
        <a href={'/user/preferences/set/admin_left_menu_size/medium'|ezurl} title="{'Change the left menu width to medium size.'|i18n( 'design/admin/parts/user/menu' )}">{'Medium'|i18n( 'design/admin/parts/user/menu' )}</a>
        <a href={'/user/preferences/set/admin_left_menu_size/large'|ezurl} title="{'Change the left menu width to large size.'|i18n( 'design/admin/parts/user/menu' )}">{'Large'|i18n( 'design/admin/parts/user/menu' )}</a>
        {/case}

        {case}
        <a href={'/user/preferences/set/admin_left_menu_size/small'|ezurl} title="{'Change the left menu width to small size.'|i18n( 'design/admin/parts/user/menu' )}">{'Small'|i18n( 'design/admin/parts/user/menu' )}</a>
        <a href={'/user/preferences/set/admin_left_menu_size/medium'|ezurl} title="{'Change the left menu width to medium size.'|i18n( 'design/admin/parts/user/menu' )}">{'Medium'|i18n( 'design/admin/parts/user/menu' )}</a>
        <a href={'/user/preferences/set/admin_left_menu_size/large'|ezurl} title="{'Change the left menu width to large size.'|i18n( 'design/admin/parts/user/menu' )}">{'Large'|i18n( 'design/admin/parts/user/menu' )}</a>
        {/case}
        {/switch}
    </p>
</div>

{* This is the border placed to the left for draging width, js will handle disabling the one above and enabling this *}
<div id="widthcontrol-handler" class="hide">
    <div class="widthcontrol-grippy"></div>
</div>
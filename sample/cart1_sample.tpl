<div>
    {* Listing of other orderpages *}
    {foreach from=$categories item=i name=categories name=cats}
        <span >
            {if $i.id == $current_cat}<strong>{$i.name}</strong>  
            {else}
                <a href="{$ca_url}cart/{$i.slug}/&amp;step={$step}{if $addhosting}&amp;addhosting=1{/if}">{$i.name}</a>
            {/if}
        </span>
    {/foreach}
</div>


{if count($currencies)>1}
    {* Form that enables quick currency change *}
    <form action="" method="post" id="currform">
        <p align="right">
            <input name="action" type="hidden" value="changecurr">
            {$lang.Currency} 
            <select name="currency" class="styled span2" onchange="$('#currform').submit()">
                {foreach from=$currencies item=crx}
                    <option value="{$crx.id}" {if !$selcur && $crx.id==0}selected="selected"{elseif $selcur==$crx.id}selected="selected"{/if}>{if $crx.code}{$crx.code}{else}{$crx.iso}{/if}</option>
                {/foreach}
            </select>
        </p>
    </form>
{/if}


<table border="0" width="100%">
    <thead>
        <tr>
            <th>{$lang.service}</th>
            <th>{$lang.order}</th>
        </tr>
    </thead>
    <tbody class="table table-bordered table-striped">
        {foreach from=$products item=prod}
            <tr>
                <td>
                    <strong>{$prod.name}</strong>
                    {if $prod.description!=''}<br/>{$prod.description}
                    {/if}
                    <br/>
                    <form name="" action="" method="post">
                        <input name="action" type="hidden" value="add">
                        <input name="id" type="hidden" value="{$prod.id}">
                        {include file='common/price.tpl' allprices='cycle' product=$prod}
                    </form>
                </td>
                <td class="subbmit-btn">
                    <a href="#" class="padded btn" onclick="$(this).parent().parent().find('form').submit(); return false;" >{$lang.ordernow}</a> 
                </td>
            </tr>
        {/foreach}
    </tbody>
</table>


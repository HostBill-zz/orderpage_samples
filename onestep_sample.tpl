{*
@@author:: HostBill team
@@name:: Sample one-step template
@@description:: Orderpage example description
@@thumb:: url/to/thumbnail.png
@@img:: url/to/preview.png
*}

{literal}
    <style>
        .cart-item div{
            display: inline;
            margin: 0 0 0 5px;
        }
        .cart-item{
            padding: 10px 0;
        }
    </style>
    <script type="text/javascript">

function mainsubmit(formel) {
    /*
        Called when submitting order
    */
    var v=$('input[name="gateway"]:checked');
    if(v.length>0) {
        $(formel).append("<input type='hidden' name='gateway' value='"+v.val()+"' />");
    }
    if($('input[name=domain]').length > 0 && $('input[name=domain]').attr('type') != 'radio')
        $(formel).append("<input type='hidden' name='domain' value='"+$('input[name=domain]').val()+"' />");
    return true;
}
function on_submit() {
    /*
        This function handles domain form
    */
	if($("input[value='illregister']").is(':checked')) {
        ajax_update('index.php?cmd=checkdomain&action=checkdomain&product_id='+$('#product_id').val()+'&product_cycle='+$('#product_cycle').val()+'&'+$('.tld_register').serialize(),{layer:'ajax',sld:$('#sld_register').val()},'#updater2',true);
	} else if ($("input[value='illtransfer']").is(':checked')) {
        ajax_update('index.php?cmd=checkdomain&action=checkdomain&transfer=true&sld='+$('#sld_transfer').val()+'&tld='+$('#tld_transfer').val()+'&product_id='+$('#product_id').val()+'&product_cycle='+$('#product_cycle').val(),{layer:'ajax'},'#updater2',true);
	} else if ($("input[value='illupdate']").is(':checked')) {
		ajax_update('index.php?cmd=cart&domain=illupdate&sld_update='+$('#sld_update').val()+'&tld_update='+$('#tld_update').val(),{layer:'ajax'},'#configer');
		$('#load-img').show();
	} else if ($("input[value='illsub']").is(':checked')) {
		ajax_update('index.php?cmd=cart&domain=illsub&sld_subdomain='+$('#sld_subdomain').val(),{layer:'ajax'},'#configer');
		$('#load-img').show();
	}

	return false;
}
function onsubmit_2() {
    /*
        Handle second step of domain bulk register
    */
    $('#load-img').show();
    ajax_update('index.php?cmd=cart&'+$('#domainform2').serialize(),{
        layer:'ajax'
    },'#configer');
    return false;
}

function applyCoupon() {
    var f = $('#promoform').serialize();
    ajax_update('?cmd=cart&addcoupon=true&'+f,{},'#configer');
    return false;
}
function simulateCart(forms, domaincheck) {
    /*
        Sends configuration data on each change made in forms and updates order prices/summary tab
    */
    $('#load-img').show();
    var urx = '?cmd=cart&';
    if(domaincheck) urx += '_domainupdate=1&';
    ajax_update(urx,$('#cartform').serializeArray(),'#configer');
}
function bindSimulateCart(){
    $('input, select','#cartform').bind('change',function(){ if($(this).attr('onchange').length == 0) simulateCart(); });
}
function removeCoupon() {
    ajax_update('?cmd=cart&removecoupon=true',{},'#configer');
    return false;
}
    
function tabbme(el) {
	$(el).parent().find('li').removeClass('on');
	$('#options div.slidme').hide().find('input[type=radio]').removeAttr('checked');
	$('#options div.'+$(el).attr('class')).show().find('input[type=radio]').attr('checked','checked');
	$(el).addClass('on');
}
    
function changeProduct(pid) {
    /*
        Change product, and load its configuration options
    */
    if(pid==$('#pidi').val())
        return;
    $('#pidi').val(pid);

    $('#errors').slideUp('fast',function(){
        $(this).find('span').remove();
    });
    $('#load-img').show();
    $.post('?cmd=cart&cat_id={/literal}{$current_cat}{literal}',{
        id: pid
    },function(data){
        var r = parse_response(data);

        $('#configer').html(r);
    });
}   
    </script>
{/literal}
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

<br />
<div class="newbox1">
    <input id="pidi" value="0" type="hidden" />
    {* Product listing, we will set our selected product id for later in hidden input above, and get its configuration by ajax*}
    <table border="0" width="100%">
        <tbody class="table table-striped table-bordered">
            {foreach from=$products item=prod}
                <tr>
                    <td>
                        <strong>{$prod.name}</strong>
                        <span class="right"> <a href="#" class="padded btn" onclick="changeProduct('{$prod.id}'); return false;" >{$lang.ordernow}</a>  </span>
                    </td>
                </tr>
            {/foreach}
        </tbody>
    </table>
</div>

<div id="configer">
    {* 
        All configuration changes made by user will refresh this bit of page, updating order summary and price
        to catch those changes we use 'onchange' event
    *}
    {include file='ajax.onestep_sample.tpl'}
</div>

<form action="?cmd=cart&cat_id={$current_cat}" method="post" id="orderform" onsubmit="return mainsubmit(this)">
    {* This form will be submitted when client cliks 'Checkout' button *}
    <input type="hidden" name="make" value="order" />
    {if $gateways}
        <div id="gatewayform" {if $tax && $tax.total==0}style="display:none"{elseif $credit && $credit.total==0}style="display:none"{elseif $subtotal.total==0}style="display:none"{/if}>
            {$gatewayhtml}
        </div>
        <div class="clear"></div>
    {/if}
    {if $logged=="1"}
        <h3 class="modern">{$lang.ContactInfo}</h3>
        <div class="newbox1">
            {include file="drawclientinfo.tpl"}
        </div>
    {else}
        <div class="newbox1header">
            <h3 class="modern">{$lang.ContactInfo}</h3>
            <ul class="wbox_menu tabbme">
                <li {if !isset($submit) || $submit.cust_method=='newone'}class="t1 on"{else}class="t1"{/if} onclick="{literal}ajax_update('index.php?cmd=signup',{layer:'ajax'},'#updater',true);$(this).parent().find('li.t2').removeClass('on');$(this).addClass('on');{/literal}" >
                    {$lang.newclient}</li>
                <li {if $submit.cust_method=='login'}class="t2 on"{else}class="t2"{/if} onclick="{literal}ajax_update('index.php?cmd=login',{layer:'ajax'},'#updater',true);$(this).parent().find('li.t1').removeClass('on');$(this).addClass('on');{/literal}" >
                    {$lang.alreadyclient}
                </li>
            </ul>
        </div>
        <div class="newbox1">
            <div id="updater" >
                {if $submit.cust_method=='login'}
                    {include file='ajax.login.tpl}
                {else}
                    {include file='ajax.signup.tpl}
                {/if}
            </div>
        </div>
    {/if}
    <div class="newbox1header">
        <h3 class="modern">{$lang.cart_add}</h3>
    </div>
    <div class="newbox1">
        <textarea id="c_notes" {if !$submit.notes}onblur="if (this.value=='')this.value='{$lang.c_tarea}';" onfocus="if(this.value=='{$lang.c_tarea}')this.value='';"{/if} style="width:98%" rows="3"  name="notes">{if $submit.notes}{$submit.notes}{else}{$lang.c_tarea}{/if}</textarea>
    </div>
    <p align="right">
        <br />
        {if $tos}
            <input type="checkbox" value="1" name="tos"/> 
            {$lang.tos1} <a href="{$tos}" target="_blank">{$lang.tos2}</a>
        {/if}
        <a href="#" onclick="$('#orderform').submit();return false;" id="checksubmit">{$lang.checkout}</a>
    </p>
</form>

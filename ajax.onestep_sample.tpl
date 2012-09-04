{if $product}
    <div class="descbox">
        <div class="infopricetag left">
            <strong>{$product.name}</strong><br />
            <form id="cart2" action="" method="post">
                <input type="hidden" name="cat_id" value="{$current_cat}" />
                {include file='common/price.tpl' allprices='cycle' product=$product}
            </form>	
            <div id="load-img" style="display:none;" ><center><img src="{$template_dir}img/ajax-loading.gif" /></center></div>
        </div>
        <div class="right">
            <strong>{$lang.total_today}</strong><br />
            <span style="vertical-align: top; font-size: 20px;">{$currency.sign}</span>
            {if $tax}<span class="cart_total">{$tax.total|price:$currency:false}</span>
            {elseif $credit}<span class="cart_total">{$credit.total|price:$currency:false}</span>
            {else}<span class="cart_total">{$subtotal.total|price:$currency:false}</span>
            {/if}
        </div>
        <div class="clear"></div>
    </div>
{/if}

{if $product.description!=''}
    <div style="margin-bottom:20px" class="clear">{$product.description}</div>
{/if}	
<div class="left mright20" style="width:520px;">

    {if ($cart_contents[0].domainoptions.register)=='1' && ($allowregister || $allowtransfer || $allowown || $subdomain)}
        <div class="newbox1header">
            <h3 class="modern">{$lang.mydomains}</h3>
            <ul class="wbox_menu tabbme">
                {if $allowregister}
                    <li class="t1 {if $contents[2].action=='register' || !$contents[2]}on{/if}" onclick="tabbme(this);">{$lang.register}</li>
                {/if}
                {if $allowtransfer}
                    <li class="t2 {if $contents[2].action=='transfer'}on{/if}" onclick="tabbme(this);">{$lang.transfer}</li>
                {/if}
                {if $allowown}
                    <li class="t3 {if $contents[2].action=='own' && !$subdomain}on{/if}" onclick="tabbme(this);">{$lang.alreadyhave}</li>
                {/if}
                {if $subdomain}
                    <li class="t4 {if $contents[2].action=='own' && $subdomain}on{/if}" onclick="tabbme(this);">{$lang.subdomain}</li>
                {/if}
            </ul>
        </div>
        <div class="newbox1">
            {include file='common/onestep_domains.tpl'}
        </div>
    {/if}

    <form id="cartform" action="" method="post">
        <input type="hidden" name="cat_id" value="{$current_cat}" />
        {if   $product.hostname ||  $product.extra.enableos || $addons || $custom }
            <h3 class="modern">{$lang.config_options}</h3>
            <div class="newbox1" style="width:510px;">
                {if ($product.hostname) && !($cart_contents[0].domainoptions.register=='1' ||  $allowown || $subdomain)}
                    {include file='common/onestep_domains.tpl'}
                {/if}
                {if $custom} 
                    {include file='common/onestep_forms.tpl'}
                {/if}
                {if $subproducts}
                    {include file='common/onestep_subproducts.tpl'}
                {/if}
                {if $addons}
                    {include file='common/onestep_addons.tpl'}
                {/if}
                <small>{$lang.field_marked_required}</small>
            </div>
        {/if}
    </form>
</div>


<div style="width:320px;font-size:11px;" class="right">
    <h3 class="modern">{$lang.ordersummary}</h3>
    <div class="newbox1" >
        <table cellspacing="0" cellpadding="3" border="0"  width="100%" class="ttable">
            <tbody>
                <tr>
                    <th width="55%">{$lang.Description}</th>
                    <th width="45%">{$lang.price}</th>
                </tr>
                {if $product}
                    <tr >
                        <td>{$contents[0].category_name} - <strong>{$contents[0].name}</strong> {if $contents[0].domain}({$contents[0].domain}){/if}<br/>
                        </td>
                        <td align="center">
                            {if $contents[0].price==0}<strong>{$lang.Free}</strong>
                            {elseif $contents[0].prorata_amount}
                                <strong> {$contents[0].prorata_amount|price:$currency}</strong>
                                ({$lang.prorata} {$contents[0].prorata_date|dateformat:$date_format})
                            {else}<strong>{$contents[0].price|price:$currency}</strong>
                            {/if}
                            {if $contents[0].setup!=0} + {$contents[0].setup|price:$currency} {$lang.setupfee}
                            {/if}
                        </td>
                    </tr>
                {/if}
                {if $cart_contents[1]}
                    {foreach from=$cart_contents[1] item=cstom2}
                        {foreach from=$cstom2 item=cstom}
                            {if $cstom.total>0}
                                <tr >
                                    <td valign="top" class="blighter fs11" style="padding-left:15px">{$cstom.fullname}  {if $cstom.qty>1}x {$cstom.qty}{/if}<br/>
                                    </td>	 
                                    <td align="center" class="blighter fs11">
                                        <strong>
                                            {if $cstom.price==0}{$lang.Free}
                                            {elseif $cstom.prorata_amount}{$cstom.prorata_amount|price:$currency}
                                            {else}{$cstom.price|price:$currency}
                                            {/if} 
                                            {if $cstom.setup!=0} + {$cstom.setup|price:$currency} {$lang.setupfee}
                                            {/if}
                                        </strong>
                                    </td>
                                </tr>
                            {/if}
                        {/foreach}
                    {/foreach}
                {/if}
                {if $contents[3]}

                    {foreach from=$contents[3] item=addon}
                        <tr >
                            <td>{$lang.addon} <strong>{$addon.name}</strong></td>
                            <td align="center">{if $addon.price==0}<strong>{$lang.Free}</strong>{elseif $addon.prorata_amount}<strong>{$addon.prorata_amount|price:$currency}</strong> ({$lang.prorata} {$addon.prorata_date|dateformat:$date_format}){else}<strong>{$addon.price|price:$currency}</strong>{/if}{if $addon.setup!=0} + {$addon.setup|price:$currency} {$lang.setupfee}{/if}</td>
                        </tr>
                    {/foreach}
                {/if}	
                {if $contents[2] && $contents[2][0].action!='own'}
                    {foreach from=$contents[2] item=domenka key=kk}
                        <tr >
                            <td>
                                <strong>{if $domenka.action=='register'}{$lang.domainregister}{elseif $domenka.action=='transfer'}{$lang.domaintransfer}{/if}</strong> - {$domenka.name} - {$domenka.period} {$lang.years}
                                <br/>
                                {if $domenka.dns}&raquo; {$lang.dnsmanage} (+ {$domenka.dns|price:$currency})<br/>
                                {/if}
                                {if $domenka.idp}&raquo; {$lang.idprotect}(+ {$domenka.idp|price:$currency})<br/>
                                {/if}
                                {if $domenka.email}&raquo; {$lang.emailfwd} (+ {$domenka.email|price:$currency})<br/>
                                {/if}
                            </td>
                            <td align="center"><strong>{$domenka.price|price:$currency}</strong></td>
                        </tr>
                    {/foreach}
                {/if}

                {if $contents[4]}
                    {foreach from=$contents[4] item=subprod}
                        <tr >
                            <td>{$subprod.category_name} - <strong>{$subprod.name}</strong></td>
                            <td align="center">
                                {if $subprod.price==0}<strong>{$lang.Free}</strong>
                                {elseif $subprod.prorata_amount}
                                    <strong> {$subprod.prorata_amount|price:$currency}</strong>
                                    ({$lang.prorata} {$subprod.prorata_date|dateformat:$date_format})
                                {else}<strong>{$subprod.price|price:$currency}</strong>
                                {/if}
                                {if $subprod.setup!=0} + {$subprod.setup|price:$currency} {$lang.setupfee}
                                {/if}
                            </td>
                        </tr>
                    {/foreach}
                {/if}
                {if $tax}
                    {if $subtotal.coupon}  
                        <tr >
                            <td align="right">{$lang.discount}</td>
                            <td align="center"><strong>- {$subtotal.discount|price:$currency}</strong></td>
                        </tr>  
                    {/if}
                    {if $tax.tax1 && $tax.taxed1!=0}
                        <tr >
                            <td align="right">{$tax.tax1name} @ {$tax.tax1}%  </td>
                            <td align="center">{$tax.taxed1|price:$currency}</td>
                        </tr>
                    {/if}
                    {if $tax.tax2  && $tax.taxed2!=0}
                        <tr >
                            <td align="right">{$tax.tax2name} @ {$tax.tax2}%  </td>
                            <td align="center">{$tax.taxed2|price:$currency}</td>
                        </tr>
                    {/if}
                    {if $tax.credit!=0}
                        <tr>
                            <td align="right"><strong>{$lang.credit}</strong> </td>
                            <td align="center"><strong>{$tax.credit|price:$currency}</strong></td>
                        </tr>
                    {/if}
                {elseif $credit}
                    {if  $credit.credit!=0}
                        <tr>
                            <td align="right"><strong>{$lang.credit}</strong> </td>
                            <td align="center"><strong>{$credit.credit|price:$currency}</strong></td>
                        </tr>
                    {/if}

                    {if $subtotal.coupon}  
                        <tr >
                            <td align="right">{$lang.discount}</td>
                            <td align="center"><strong>- {$subtotal.discount|price:$currency}</strong></td>
                        </tr>  
                    {/if}
                {else}
                    {if $subtotal.coupon}  
                        <tr >
                            <td align="right">{$lang.discount}</td>
                            <td align="center"><strong>- {$subtotal.discount|price:$currency}</strong></td>
                        </tr>  
                    {/if}
                {/if}
                {if !empty($tax.recurring)}
                    <tr >
                        <td align="right">{$lang.total_recurring}</td>
                        <td align="center"> 
                            {foreach from=$tax.recurring item=rec key=k}
                                {$rec|price:$currency} {$lang.$k}<br/>
                            {/foreach} </td>
                    </tr>
                {elseif !empty($subtotal.recurring)}
                    <tr >
                        <td align="right">{$lang.total_recurring}</td>
                        <td align="center"> 
                            {foreach from=$subtotal.recurring item=rec key=k}
                                {$rec|price:$currency} {$lang.$k}<br />
                            {/foreach} 
                        </td>
                    </tr>
                {/if}
                <tr>
                    <td colspan="2" align="right">
                        {if !$subtotal.coupon}
                            <div style="text-align:right">
                                <a href="#" onclick="$(this).hide();$('#promocode').show();return false;">
                                    <strong>{$lang.usecoupon}</strong>
                                </a>
                            </div>
                            <div id="promocode" style="display:none;text-align:right">
                                <form action="" method="post" id="promoform" onsubmit="return applyCoupon();">
                                    <input type="hidden" name="addcoupon" value="true" />
                                    Code: <input type="text" class="styled" name="promocode"/> <input type="submit" value="&raquo;" style="font-weight:bold" class="padded btn"/></form>
                            </div>
                        {/if}
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <div {if $tax && $tax.total==0}style="display:none"{elseif $credit && $credit.total==0}style="display:none"{elseif $subtotal.total==0}style="display:none"{/if}>
        <h3 class="modern">{$lang.choose_payment}</h3>
        <div class="newbox1">
            {if $gateways}
                <form action="" method="post" id="gatewaylist" onchange="simulateCart('#gatewaylist');">
                    {foreach from=$gateways item=module key=mid name=payloop}
                        <div class="left" style="margin:0 2px">
                            <input  onclick="$('#gatewayform').show();ajax_update('?cmd=cart&action=getgatewayhtml&gateway_id='+$(this).val(), '', '#gatewayform',true)" type="radio" name="gateway" value="{$mid}" {if $submit && $submit.gateway==$mid || $mid==$paygateid}checked="checked"{elseif $smarty.foreach.payloop.first}checked="checked"{/if}/> {$module} 
                        </div>
                    {/foreach}
                </form>
                <div class="clear"></div>
            {/if}
        </div>
    </div>
</div>
<div class="clear"></div>

<script type="text/javascript">
    bindSimulateCart();
</script>
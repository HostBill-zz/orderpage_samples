{*
@@author:: HostBill team
@@name:: Sample wizard orderpage
@@description:: Sample description
@@thumb:: sample/sample_thumb.png
@@img:: sample/sample_preview.png
*}
<script type="text/javascript" src="{$orderpage_dir}common/cart.js?step={$step}"></script>
{if $step==0}
    {* Initial step, before client chooses any package *}
    {include file='sample/cart1_sample.tpl'}
{elseif $step==1}
    {* Product selected in ealier step has domains, here we will show domain registration/transfer/subdomain options *}
	{include file='sample/cart2_sample.tpl'}
{elseif $step==2}
    {* Domains selected in earlier step need additional configuration, this step enables setting their periods, additional required fields and contact information. *}
	{include file='sample/cart3_sample.tpl'}
{elseif $step==3}
    {* This step is responsible for product configuration and additonal options like addons, subproduct, and custom forms *}
	{include file='sample/cart4_sample.tpl'}
{elseif $step==4} 
    {* In this step we display order summary, allow not logged in clients to create account or login if he already has one and, display Terms of service if enabled*}
	{include file='sample/cart5_sample.tpl'}
{elseif $step==5} 
    {* At this point order was already created, we can display any post order information here *}
	{include file='sample/cart6_sample.tpl'}
{/if}
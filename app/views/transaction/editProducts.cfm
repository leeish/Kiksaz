<ul>
<cfoutput query="items">
<li>#productid# - #productname# - #linkTo(text="Remove",action="removeProduct",key=productid,params="transaction=#params.key#")#</li>
</cfoutput>
</ul>
<cfoutput>
#linkTo(text="Back", action="view")#
</cfoutput>
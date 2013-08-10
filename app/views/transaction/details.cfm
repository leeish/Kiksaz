<ul>
<cfoutput query="items">
<li>#productid# - #productname#</li>
</cfoutput>
</ul>
<cfoutput>
#linkTo(text="Back", action="view")#
</cfoutput>
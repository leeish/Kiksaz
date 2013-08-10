<ul>
<cfoutput query="transactions">
<li>#linkTo(text=name,action="details",key=transactionid)#</li>
</cfoutput>
</ul>
<cfoutput>
#linkTo(text="back",controller="dashboard",action="index")#
</cfoutput>
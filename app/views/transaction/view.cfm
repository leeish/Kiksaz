<ul>
<cfoutput query="transactions">
<li>#name#
	<ul>
		<li>#linkTo(text="View Details",action="details",key=transactionid)#</li>
		<li>#linkTo(text="Add More",action="edit",key=transactionid,params="edit=add")#</li>
		<li>#linkTo(text="Edit",action="edit",key=transactionid,params="edit=edit")#</li>
		<li>#linkTo(text="Remove Items",action="editProducts",key=transactionid)#</li>
	</ul></li>
</cfoutput>
</ul>
<cfoutput>
#linkTo(text="back",controller="dashboard",action="index")#
</cfoutput>
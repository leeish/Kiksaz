<cfoutput>
	#linkTo(controller="transaction",action="new",text="Create New Transaction")#<br/>
	<cfif transactions.recordcount GT 0>
		#linkTo(controller="transaction",action="view",text="View Existing Transactions")#<br/>
		#linkTo(controller="transaction",action="amend",text="Add To Existing Transactions")#<br/>
	</cfif>
	#linkTo(href="javascript:",text="Log Out of Snap Bought",onClick="logOutApp()")#
</cfoutput>
<cfcomponent extends="Model">
<cffunction name="init">
	<cfset belongsTo(name='transaction',foreignKey="transactionid")>
</cffunction>
</cfcomponent>
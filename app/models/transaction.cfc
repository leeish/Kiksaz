<cfcomponent extends="Model">
<cffunction name="init">
	<cfset belongsTo(name='store',foreignKey="storeid")>
	<cfset hasMany(name='transactionpart',foreignKey="transactionid")>
</cffunction>
</cfcomponent>
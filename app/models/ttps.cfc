<cfcomponent extends="Model">
<cffunction name="init">
<cfset table('ttps')>
<cfset belongsTo(name='products',foreignKey="productid")>
</cffunction>
</cfcomponent>
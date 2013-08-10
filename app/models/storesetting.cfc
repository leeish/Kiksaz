<cfcomponent extends="Model">
<cffunction name="init">

</cffunction>

<cffunction name="getRegExByStore">
	<cfargument name="storeid" required="yes" type="numeric">
	<cfquery name="regex" datasource="amazon">
		SELECT storesettingvalue
		FROM storesettings ss
		INNER JOIN settingtypes st ON st.settingtypeid = ss.settingtypeid
		WHERE st.settingtypename = 'regex'
		AND ss.storeid = <cfqueryparam cfsqltype="numeric" value="#arguments.storeid#">
	</cfquery>
	<cfreturn regex.storesettingvalue>
</cffunction>
</cfcomponent>
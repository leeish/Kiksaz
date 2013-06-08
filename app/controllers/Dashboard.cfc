<cfcomponent extends="Controller">
	
	<!--- SET FILTERS, RESPONSE TYPES, CHECKS ETC --->
	<cffunction name="init">
    	<cfset provides("html,json")>
		<cfset filters("restrictAccess")>
	</cffunction>
	
	<cffunction name="restrictAccess">
		<cfif !loginCheck()>
			<cfset flashInsert(msg="Please login first!")>
			<cfset redirectTo(route="login")>
		</cfif>
	</cffunction>
	
	<cffunction name="submitReceipt">
		<!--- Stop trying if no text given --->
		<cfif params.receipt == ''>
			<cfset flashInsert(error="You must submit something for processing")>
			<cfset redirectTo(action='index')>
		</cfif>
		<cfset text = params.receipt>
		<cfset renderPage(action='index')>
	</cffunction>
</cfcomponent>
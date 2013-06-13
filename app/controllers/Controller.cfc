<!---
	This is the parent controller file that all your controllers should extend.
	You can add functions to this file to make them globally available in all your controllers.
	Do not delete this file.
--->
<cfcomponent extends="Wheels">
	
	<cffunction name="init">
		<cfif !loginCheck()>
			<cfset flashInsert(msg="Please login first!")>
			<cfset redirectTo(route="login")>
		</cfif>
	</cffunction>
</cfcomponent>

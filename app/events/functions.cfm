<!--- Place functions here that should be globally available in your application. --->
<cffunction name="loginCheck" returntype="boolean" access="public">
	<cfif !StructKeyExists(SESSION,'user') OR !StructKeyExists(SESSION.user,'loggedIn') OR !SESSION.user.loggedIn>
		<cfreturn false>
	</cfif>
	<cfreturn true>
</cffunction>
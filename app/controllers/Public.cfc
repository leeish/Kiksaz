<cfcomponent extends="Controller">
	
	<!--- SET FILTERS, RESPONSE TYPES, CHECKS ETC --->
	<cffunction name="init">
    	<cfset provides("html,json")>
		<cfif loginCheck()>
			<cfset redirectTo(controller="dashboard", action="index")>
		</cfif>
	</cffunction>
	
	<cffunction name="tryLogin">
		<cfparam name="params.accessToken" default=""/>
		<cfparam name="params.user" default=""/>
		<cfif params.user == '' || params.accessToken == ''>
			<cfset renderWith(data={status="error",message="Login Error. Please Try Again."},layout="false")>
		</cfif>
		<cfset SESSION.user = {}>
		<cfset SESSION.user.userID = params.user>
		<cfset SESSION.user.token = params.token>
		<cfset SESSION.user.loggedIn = true>
		<cfset renderWith(data={status="success",message="Logged In."},layout="false")>
	</cffunction>
</cfcomponent>
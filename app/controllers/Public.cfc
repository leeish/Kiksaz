<cfcomponent extends="Controller">
	
	<!--- SET FILTERS, RESPONSE TYPES, CHECKS ETC --->
	<cffunction name="init">
    	<cfset provides("html,json")>
		<cfset filters("checkLogin")>
	</cffunction>
	
	<cffunction name="checkLogin">
		<cfif loginCheck()>
			<cfset redirectTo(route="home")>
		</cfif>
	</cffunction>
	
	<cffunction name="tryLogin">
		<cfparam name="params.UserName" default=""/>
		<cfparam name="params.password" default=""/>
		<cfif params.UserName == 'projectkiksaz' && params.password == 'ablb1210'>
			<cfset SESSION.user.loggedin = true/>
			<cfset redirectTo(route="home")>
		</cfif>
		<cfset flashInsert(error="Login Invalid")>
		<cfset renderPage(action="login")>
	</cffunction>
</cfcomponent>
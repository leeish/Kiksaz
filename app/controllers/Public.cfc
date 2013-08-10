<cfcomponent extends="Controller">
	
	<!--- SET FILTERS, RESPONSE TYPES, CHECKS ETC --->
	<cffunction name="init">
    	<cfset provides("html,json")>
		<cfif loginCheck()>
			<cfset redirectTo(controller="dashboard", action="index")>
		</cfif>
	</cffunction>
	
	<cffunction name="tryLogin">
		<cfparam name="params.type" default=""/>
		<cfparam name="params.user" default=""/>
		<cfif params.user == '' || params.type == ''>
			<cfset flashInsert(error="Login Error, please try again.")>
			<cfset renderWith(data={status="error",message="Login Error. Please Try Again."},layout="false")>
		</cfif>
		<cftry>
		<cfset user = model('User').findOne(WHERE="externalid = #params.user# AND externalsource = '#params.type#'")>
		<cfif isObject(user)>
			<cfif sessionSetup(userid=user.userid,externalsource=user.externalsource)>
				<cfset renderWith(data={status="success",message="Logged In."},layout="false")>
			<cfelse>
				<cfset renderWith(data={status="error",message="An error occured. Please make sure you allow cookies."},layout="false")>
			</cfif>
		<cfelse>
			<cfset renderWith(data={status="wait",message="Signup Required"},layout="false")>
		</cfif>
			<cfcatch>
				<cfset flashInsert(error="#cfcatch.message#")>
				<cfset renderWith(data={status="error",message="#cfcatch.message#"},layout="false")>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="submitUser">
		<cfparam name="params.email" default="">
		<cfparam name="params.firstname" default="">
		<cfparam name="params.lastname" default="">
		<cfparam name="params.id" default="">
		<cfparam name="params.type" default="">
		<cfif params.email eq '' || params.firstname eq '' || params.lastname eq '' || params.id eq '' || params.type eq ''>
			<cfset flashInsert(error="All Fields are Required")>
			<cfset renderPage(action="signup")>
		<cfelse>
			<cfset user = model('User').findOne(WHERE="externalid = #params.id# AND externalsource = '#params.type#'")>
			<cfif isObject(user)>
				<cfif sessionSetup(userid=user.userid,externalsource=user.externalsource)>
					<cfset redirectTo(controller="dashboard",action="index")>
				<cfelse>
					<cfset flashInsert(error="An error occured. Please make sure you allow cookies.")>
					<cfset renderPage(action="signup")>
				</cfif>
			<cfelse>
				<cfset user = model('User').new()>
				<cfset user.firstname = params.firstname>
				<cfset user.lastname = params.lastname>
				<cfset user.email = params.email>
				<cfset user.externalid = params.id>
				<cfset user.externalsource = params.type>
				<cfset user.save()>
				<cfif user.hasErrors()>
					<cfset flashInsert(error="There was a problem signing up, please try again.")>
					<cfset renderPage(action="signup")>
				<cfelse>
					<cfif sessionSetup(userid=user.userid,externalsource=user.externalsource)>
						<cfset redirectTo(controller="dashboard",action="index")>
					<cfelse>
						<cfset flashInsert(error="An error occured. Please make sure you allow cookies.")>
						<cfset renderPage(action="signup")>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>
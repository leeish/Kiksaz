<cfcomponent extends="Controller">
	
	<!--- SET FILTERS, RESPONSE TYPES, CHECKS ETC --->
	<cffunction name="init">
    	<cfset provides("html,json")>
		<cfset filters("restricted")>
		<cfset filters("setup")>
	</cffunction>
	
	<cffunction name="setup">
		<cfset images = directoryList(path="/app/users/uploaded/",listInfo="query")>
		<cfset omnis = directoryList(path="/app/users/processed/",listInfo="query")>
	</cffunction>
	
	<cffunction name="logout">
		<cfset StructClear(SESSION)>
		<cfset redirectTo(route="login",message="Logged Out")>
	</cffunction>
	
	<cffunction name="index">
		<cfset transactions = model('Transaction').findAll(WHERE="userid = #SESSION.user.userid#")>
	</cffunction>
	
	<cffunction name="submitReceipt">
		<!--- Stop trying if no text given --->
		<cfif !structKeyExists(params,'receipt') || params.receipt == ''>
			<cfset flashInsert(error="You must submit something for processing")>
			<cfset redirectTo(action='index')>
		</cfif>
		<cfif !directoryExists('/app/users/uploaded/')>
			<cfset DirectoryCreate('/app/users/uploaded/')>
			<cfif !directoryExists('/app/users/uploaded/')>
				<cfset flashInsert(error="There was a problem saving the file. The required directory could not be created")>
				<cfset redirectTo(action="index")>
			</cfif>
		</cfif>
		<cfset stamp = dateFormat(now(),'mmddyy')&timeformat(now(),'HHmmss')>
		<cffile action="upload" destination="/app/users/uploaded/1_1_#stamp#.jpg" fileField="receipt">
		<cfset redirectTo(action="index")>
	</cffunction>
</cfcomponent>
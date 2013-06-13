<cfcomponent extends="Controller">
	
	<!--- SET FILTERS, RESPONSE TYPES, CHECKS ETC --->
	<cffunction name="init">
    	<cfset provides("html,json")>
		<cfset filters("setup")>
	</cffunction>
	
	<cffunction name="setup">
		<cfset images = directoryList(path="/app/users/uploaded/",listInfo="query")>
		<cfset omnis = directoryList(path="/app/users/processed/",listInfo="query")>
	</cffunction>
	
	<cffunction name="index">
		
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
				<cfset redirectTo(route="home")>
			</cfif>
		</cfif>
		<cfset stamp = dateFormat(now(),'mmddyy')&timeformat(now(),'HHmmss')>
		<cffile action="upload" destination="/app/users/uploaded/1_1_#stamp#.jpg" fileField="receipt">
		<cfset redirectTo(route="login")>
	</cffunction>
	
	<cffunction name="processReceipt">
		<cffile action="read" file="/app/users/processed/#params.key#" variable="text">
		<cfset upcs = findUPCFromText(text)>
		<cfset renderPage(action="index")>
	</cffunction>
	
	<cffunction name="findUPCFromText" returntype="array">
		<cfargument name="text" required="yes" type="string">
		<cfargument name="store" required="yes" type="string" default="Wal-mart">
		<cfswitch expression="#store#">
			<cfcase value="Wal-mart">
				<cfreturn processWalMartReceipt(ARGUMENTS.text) />
			</cfcase>
			<cfdefaultcase>
				<cfreturn {"upc" = ARGUMENTS.text}>
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="processWalMartReceipt" returntype="array">
		<cfargument name="text" required="yes" type="string">
		<cfset var upcs = preg_match_all('(?m)^([^\n\f\r]*?)\s+(\d{12})(?=\D|$)',ARGUMENTS.text)>
		<cfreturn upcs>
	</cffunction>
</cfcomponent>
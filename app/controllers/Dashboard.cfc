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
		<cfif !structKeyExists(params,'receipt') || params.receipt == ''>
			<cfset flashInsert(error="You must submit something for processing")>
			<cfset redirectTo(action='index')>
		</cfif>
		<!---><cffile action="upload" destination="/Kiksaz/testFiles/text.txt" fileField="receipt" result="file" nameConflict="Overwrite">--->
		<cffile action="read" file="/Kiksaz/testFiles/text.txt" variable="text" charset="us-ascii">
		<cfset writeoutput(text)>
		<cfset upcs = findUPCFromText(text)>
		<cfset renderPage(action='index')>
	</cffunction>
	
	<cffunction name="findUPCFromText" returntype="struct">
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
	
	<cffunction name="processWalMartReceipt" returntype="struct">
		<cfargument name="text" required="yes" type="string">
		<cfdump var="#ARGUMENTS.text#">
		<cfset var upcs = preg_match_all('(?m)^([^\n\f\r]*?)\s+(\d{12})(?=\D|$)',ARGUMENTS.text)>
		<cfdump var="#upcs#"><cfabort/>
		
	</cffunction>
</cfcomponent>
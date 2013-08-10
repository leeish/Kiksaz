<cfcomponent extends="Controller">
	
	<!--- SET FILTERS, RESPONSE TYPES, CHECKS ETC --->
	<cffunction name="init">
    	<cfset provides("html,json")>
		<cfif !loginCheck()>
			<cfset redirectTo(controller="dashboard", action="index")>
		</cfif>
	</cffunction>
	
	<cffunction name="new">
		<cfset stores = model("store").findAll()>
	</cffunction>
	
	<cffunction name="view">
		<cfset transactions = model('Transaction').findAll(WHERE="userid = #SESSION.user.userid#")>
	</cffunction>
	
	<cffunction name="details">
		<cfset items = model('ttps').findAll(WHERE="transactionid = #params.key#",include="products")>
	</cffunction>
	<cffunction name="createTransaction">
		<!--- Stop trying if no text given --->
		<cfif !structKeyExists(params,'receipt') || params.receipt == ''>
			<cfset flashInsert(error="You must submit an image for processing")>
			<cfset redirectTo(action='new')>
		</cfif>
		<cfif !directoryExists('/app/users/uploaded/')>
			<cfset DirectoryCreate('/app/users/uploaded/')>
			<cfif !directoryExists('/app/users/uploaded/')>
				<cfset flashInsert(error="There was a problem saving the file. The required directory could not be created")>
				<cfset redirectTo(action="new")>
			</cfif>
		</cfif>
		<cfset stamp = dateFormat(now(),'mmddyy')&timeformat(now(),'HHmmss')>
		<cfset transaction = model('Transaction').new()>
		<cfset transaction.storeid = params.store>
		<cfset transaction.userid = SESSION.user.userid>
		<cfset transaction.name = params.name>
		<cfset transaction.save()>
		<cfif transaction.hasErrors()>
			<cfset flashInsert(error="There was a problem creating your transaction.")>
			<cfset redirectTo(action="new")>
		<cfelse>
			<cffile action="upload" destination="/app/users/uploaded/#transaction.transactionid#_1_#stamp#.jpg" fileField="receipt">
			<cfset redirectTo(controller="dashboard",action="index")>
		</cfif>
	</cffunction>
</cfcomponent>
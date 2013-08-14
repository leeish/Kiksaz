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
	
	<cffunction name="amend">
		<cfset transactions = model('Transaction').findAll(WHERE="userid = #SESSION.user.userid#")>
	</cffunction>
	<cffunction name="edit">
		<cfset transaction = model('Transaction').findByKey(key=params.key,include="store")>
	</cffunction>
	<cffunction name="checkForReceipt">
		<cfif !structKeyExists(params,'receipt') || params.receipt == ''>
			<cfset flashInsert(error="You must submit an image for processing")>
			<cfset redirectTo(back='true')>
		</cfif>
	</cffunction>
	<cffunction name="checkForUploadDir">
		<cfif !directoryExists('/app/users/uploaded/')>
			<cfset DirectoryCreate('/app/users/uploaded/')>
			<cfif !directoryExists('/app/users/uploaded/')>
				<cfset flashInsert(error="There was a problem saving the file. The required directory could not be created")>
				<cfset redirectTo(back="true")>
			</cfif>
		</cfif>
		<cfif !directoryExists('/app/users/complete/')>
			<cfset DirectoryCreate('/app/users/complete/')>
			<cfif !directoryExists('/app/users/complete/')>
				<cfset flashInsert(error="There was a problem saving the file. The required directory could not be created")>
				<cfset redirectTo(back="true")>
			</cfif>
		</cfif>
	</cffunction>
	<cffunction name="editTransactionName">
		<cfset transaction = model('Transaction').findByKey(params.transaction.transactionid)>
		<cfset transaction.name = params.transaction.name>
		<cfset transaction.save()>
		<cfset flashInsert(success="The transaction has been renamed: '#transaction.name#'.")>
		<cfset redirectTo(action="view")>
	</cffunction>
	<cffunction name="editProducts">
		<cfset items = model('ttps').findAll(WHERE="transactionid = #params.key#",include="products")>
	</cffunction>
	<cffunction name="removeProduct">
		<cfset item = model('ttps').findOne(WHERE="transactionid = #params.transaction# AND productid = '#params.key#'")>
		<cfset item.delete()/>
		<cfif item.hasErrors()>
			<cfset flashInsert(error="There was an error removing the entry.")>
			<cfset redirectTo(action="editProducts",key=params.transaction)>
		<cfelse>
			<cfset flashInsert(success="Item Deleted.")>
			<cfset redirectTo(action="editProducts",key=params.transaction)>
		</cfif>
		<cfdump var="#params#"><cfabort>
	</cffunction>
	<cffunction name="createTransaction">
		<!--- Stop trying if no text given --->
		<cfset checkForReceipt()>
		<cfset checkforUploadDir()>
		
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
	<cffunction name="addToTransaction">
		<cfset checkForReceipt()>
		<cfset checkforUploadDir()>
		<cfset stamp = dateFormat(now(),'mmddyy')&timeformat(now(),'HHmmss')>
		<cfset transaction = model('Transaction').findByKey(key=params.transaction.transactionid,include="transactionpart")>
		<cfset part = arrayLen(transaction.transactionpart)+1 />
		<cfif transaction.hasErrors()>
			<cfset flashInsert(error="There was a problem creating your transaction.")>
			<cfset redirectTo(back="true")>
		<cfelse>
			<cffile action="upload" destination="/app/users/uploaded/#transaction.transactionid#_#part#_#stamp#.jpg" fileField="receipt">
			<cfset redirectTo(controller="transaction",action="amend",key=transaction.transactionid)>
		</cfif>
	</cffunction>
</cfcomponent>
<cfcomponent extends="Controller">
	
	<!--- SET FILTERS, RESPONSE TYPES, CHECKS ETC --->
	<cffunction name="init">
    	<cfset provides("html,json")>
		<cfif URL.auth != 'ablb1210'>
			<cfset renderNothing() />
			<cfabort>
		</cfif>
	</cffunction>
	
	<cffunction name="processReceipts">
		<cfdirectory directory="/app/users/processed/" action="list" name="dir">
		<cfif dir.recordcount GT 0>
			<cfloop query="dir">
				<cftry>
				<cfset transaction = model('Transaction').findByKey(Left(name,1))>
				<cffile action="read" file="/app/users/processed/#name#" variable="text">
				<cfset transaction.receipt = text>
				<cfset transaction.save()>
				<cfset part = model('TransactionPart').new()>
				<cfset part.transactionid = transaction.transactionid>
				<cfset part.image = replace(name,'.txt','')>
				<cfset part.receipt = text>
				<cfset part.date = now()>
				<cfset part.save()>
				<cffile action="move" source="/app/users/processed/#name#" destination="/app/users/complete/#name#">
				<cfset findUPCFromText(part,transaction.storeid)>
				<cfcatch>
					<cfdump var="#cfcatch#">
					<cfabort>
				</cfcatch>
				</cftry>
			</cfloop>
		</cfif>
		<cfset renderNothing()>
	</cffunction>
	
	<cffunction name="findUPCFromText" returntype="void">
		<cfargument name="part" required="yes" type="struct">
		<cfargument name="storeid" required="yes" type="numeric">
		<cfset regex = model('storesetting').getRegExByStore(arguments.storeid)>
		<cfif regex != ''>
			<cfset upcs = processRegexReceipt(part.receipt,regex) />
		</cfif>
		<cfset saveUPCData(part,upcs)>
		<cfreturn>
	</cffunction>
	
	<cffunction name="processRegexReceipt" returntype="array">
		<cfargument name="text" required="yes" type="string">
		<cfargument name="regex" required="yes" type="string">
		<cfset var upcs = preg_match_all(ARGUMENTS.regex,ARGUMENTS.text)>
		<cfreturn upcs>
	</cffunction>
	
	<cffunction name="saveUPCData" returntype="boolean">
		<cfargument name="part" required="yes" type="struct">
		<cfargument name="upcs" required="yes" type="array">
		<cfset var transactionid = part.transactionid>
		<cfloop from="1" to="#arraylen(upcs[1])#" index="i">
			<cfquery datasource="amazon" name="count">
				SELECT * FROM products WHERE productid = '#upcs[3][i]#'
			</cfquery>
			<cfif count.recordcount LT 1>
				<cfset product = model('Product').new()>
				<cfset product.productid = upcs[3][i]>
				<cfset product.productname = upcs[2][i]>
				<cfset product.productimportdate = now()>
				<cfset product.sourceid = 1>
				<cfset product.save()>
			<cfelse>
				<cfset product = model('Product').findByKey(upcs[3][i])>
			</cfif>
			<cfset var ttp = model('ttps').new()>
			<cfset ttp.transactionid = transactionid>
			<cfset ttp.productid = product.productid>
			<cfset ttp.save()>
		</cfloop>
		<cfreturn true>
	</cffunction>
</cfcomponent>
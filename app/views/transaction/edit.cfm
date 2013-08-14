<cfif params.edit eq "add"><cfoutput>
	#startFormTag(action="addToTransaction",multipart="true")#
		Transaction: #transaction.name#<br/>
		#HiddenField(objectName="transaction",property="transactionid")#
		Store: #transaction.store.storename#
		#hiddenField(label="Store",objectName="transaction",property="storeid")#<br/>
		#fileFieldTag(label="Upload Receipt", name="receipt")#
		#submitTag(value="Submit")#
	#endFormTag()#
</cfoutput>
<cfoutput>
#linkTo(text="back",href="#CGI.http_referer#")#
</cfoutput>
</cfif>
<cfif params.edit eq "edit"><cfoutput>
	#startFormTag(action="editTransactionName",multipart="true")#
		#TextField(objectName="transaction",property="name")#<br/>
		#HiddenField(objectName="transaction",property="transactionid")#
		Store: #transaction.store.storename#
		#hiddenField(label="Store",objectName="transaction",property="storeid")#<br/>
		#submitTag(value="Submit")#
	#endFormTag()#
</cfoutput>
<cfoutput>
#linkTo(text="back",href="#CGI.http_referer#")#
</cfoutput>
</cfif>
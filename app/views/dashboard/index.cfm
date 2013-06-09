<cfoutput>
	#startFormTag(action="submitReceipt", multipart="true")#
		#fileFieldTag(label="Upload Receipt", name="receipt")#
		#submitTag(value="Submit")#
	#endFormTag()#
</cfoutput>
<cfif isDefined('text')>
	<cfdump var="#text#">
	<cfdump var="#upcs#">
</cfif>
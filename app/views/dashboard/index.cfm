<cfoutput>
	#startFormTag(action="submitReceipt")#
		#textAreaTag(name="receipt",label="Paste OCR Result")#<br/>
		#submitTag(value="Submit")#
	#endFormTag()#
</cfoutput>
<cfif isDefined('text')>
	<cfdump var="#text#">
</cfif>
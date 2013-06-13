<cfoutput>
	#startFormTag(action="submitReceipt", multipart="true")#
		#fileFieldTag(label="Upload Receipt", name="receipt")#
		#submitTag(value="Submit")#
	#endFormTag()#
</cfoutput>
<h2>Uploaded Files</h2>
<table>
<tr>
	<th>PATH</th>
	<th>FILE</th>
</tr>
<cfoutput query="images">
	<tr>
		<td>#directory#</td>
		<td>#linkTo(text=name, href='/app/users/uploaded/'&name)#</td>
	</tr>
</cfoutput>
</table>
<h2>Processed Files</h2>
<p>Click on a link below to process the file and see the UPC results</p>
<table>
<tr>
	<th>PATH</th>
	<th>FILE</th>
</tr>
<cfoutput query="omnis">
	<tr>
		<td>#directory#</td>
		<td>#linkTo(text=name, action="processReceipt", key=name)#</td>
	</tr>
</cfoutput>
</table>
<cfif isDefined('text')>
	<cfdump var="#text#">
	<cfdump var="#upcs#">
</cfif>
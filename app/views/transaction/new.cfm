<cfoutput>
	#startFormTag(action="createTransaction",multipart="true")#
		#textFieldTag(label="Transaction Name",name="name",placeHolder="Transaction Name")#<br/>
		#selectTag(label="Store",name="store",options=stores,valueField="storeid",textField="storename")#<br/>
		#fileFieldTag(label="Upload Receipt", name="receipt")#
		#submitTag(value="Submit")#
	#endFormTag()#
</cfoutput>
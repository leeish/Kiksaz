<h1>Login Page</h1>
<cfoutput>
	#startFormTag(action="tryLogin")#
		#textFieldTag(label="User Name", placeHolder="User Name", name="UserName")#<br/>
		#passwordFieldTag(label="Password", placeHolder="Password", name="Password")#<br/>
		#submitTag(value="Login")#
	#endFormTag()#
</cfoutput>
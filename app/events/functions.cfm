<!--- Place functions here that should be globally available in your application. --->
<cffunction name="loginCheck" returntype="boolean" access="public">
	<cfif !StructKeyExists(SESSION,'user') OR !StructKeyExists(SESSION.user,'loggedIn') OR !SESSION.user.loggedIn>
		<cfreturn false>
	</cfif>
	<cfreturn true>
</cffunction>

<cffunction name="preg_match_all">
	<cfargument name="regex" type="string" required="yes">
	<cfargument name="str" type="string" required="yes">
	<cfset var results = arraynew(2)>
	<cfset var pos = 1>
	<cfset var loop = 1>
	<cfset var match = "">
	<cfset var x = 1>
	<cfloop condition="#REFindNoCase(ARGUMENTS.regex, ARGUMENTS.str, pos)#">
		<cfset match = REFindNoCase(ARGUMENTS.regex, ARGUMENTS.str, pos,TRUE)>
		<cfloop from="1" to="#arrayLen(match.pos)#" step="1" index="x">
			<cfif match.len[x]>
				<cfset results[x][loop] = mid(ARGUMENTS.str,match.pos[x],match.len[x])>
			<cfelse>
				<cfset results[x][loop] = ''>
			</cfif>
		</cfloop>
		<cfset pos = match.pos[1] + match.len[1]>
		<cfset loop = loop + 1>
	</cfloop>
	<cfreturn results>
</cffunction>
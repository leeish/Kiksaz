<!doctype html>
<html>
	<head>
		<title>SnapBought</title>
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.min.js"></script>
		<cfoutput>
			#styleSheetLinkTag('main')#
		</cfoutput>
	</head>
	<body>
		<cfif NOT flashIsEmpty()>
			<div id="flash-messages">
				<cfif flashKeyExists("error")>
					<p class="errorMessage">
						<cfoutput>#flash("error")#</cfoutput>
					</p>
				</cfif>
				<cfif flashKeyExists("success")>
					<p class="successMessage">
						<cfoutput>#flash("success")#</cfoutput>
					</p>
				</cfif>
			</div>
		</cfif>
		<script type="text/javascript">
			$('#flash-messages').fadeIn(500).delay(7000).fadeOut();
			$('.closeFlash a').live('click', function(){
				$(this).parent().parent().hide();
			});
	
			$("#flash-messages").css('left', $(window).width()/2 - $("#flash-messages").width()/2);
		</script>
		<cfoutput>#includeContent()#</cfoutput>
	</body>
</html>
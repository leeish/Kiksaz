<!doctype html>
<html>
	<head>
		<title>SnapBought</title>
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.min.js"></script>
		<cfoutput>
			<script type="text/javascript">
				var appId = '#(get("environment")=="production")?"518734988197681":"702130816471169"#';
				window.fbAsyncInit = function() {
					FB.init({
				      	appId      : appId, // App ID
				      	channelUrl : '#APPLICATION.wheels.webpath#channel.html', // Channel File
				      	status     : true, // check login status
				    	cookie     : true, // enable cookies to allow the server to access the session
				    	xfbml      : true  // parse XFBML
					});
					$(window).trigger('readyfblogin');
			    };
			    // Load the SDK asynchronously
				(function(d){
					var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
				    if (d.getElementById(id)) {return;}
				    js = d.createElement('script'); js.id = id; js.async = true;
				    js.src = "//connect.facebook.net/en_US/all.js";
				    ref.parentNode.insertBefore(js, ref);
				}(document));
			</script>
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
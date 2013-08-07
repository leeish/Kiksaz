<h1>Login Page</h1>
<cfoutput>
<script>
// Additional JS functions here
$(window).bind('readyfblogin',function() {
    // Additional init code here
	FB.Event.subscribe('auth.authResponseChange', function(response) {
		
    	// Here we specify what we do with the response anytime this event occurs.
    	var accessToken = response.authResponse.accessToken;
    	var expiresIn = response.authResponse.expiresIn;
    	var signedRequest = response.authResponse.signedRequest;
    	var userID = response.authResponse.userID;
    	
    	if (response.status === 'connected') {
    		// The response object is returned with a status field that lets the app know the current
    	  	// login status of the person. In this case, we're handling the situation where they 
    	  	// have logged in to the app.
    	  	loginUser(accessToken,userID);
    	  	$('.app-logout').show();
    	} else if (response.status === 'not_authorized') {
    	 	// In this case, the person is logged into Facebook, but not into the app, so we call
    	  	// FB.login() to prompt them to do so. 
    	  	// In real-life usage, you wouldn't want to immediately prompt someone to login 
    	  	// like this, for two reasons:
    	  	// (1) JavaScript created popup windows are blocked by most browsers unless they 
    	  	// result from direct interaction from people using the app (such as a mouse click)
    	  	// (2) it is a bad experience to be continually prompted to login upon page load.
    	  	FB.login();
    	} else {
    	  	// In this case, the person is not logged into Facebook, so we call the login() 
    	  	// function to prompt them to do so. Note that at this stage there is no indication
    	  	// of whether they are logged into the app. If they aren't then they'll see the Login
    	  	// dialog right after they log in to Facebook. 
    	  	// The same caveats as above apply to the FB.login() call here.
    	  	FB.login();
    	}
	});
});

// Here we run a very simple test of the Graph API after login is successful. 
// This testAPI() function is only called in those cases. 
function loginUser(accessToken,userID) {
	console.log('Welcome!  Fetching your information.... ');
	$.post('#URLFor(action="tryLogin",params="format=json")#',
		{
			user: userID,
			token: accessToken
		},
		function(data){
			if(data.status=="error"){
				alert('Login Error. TODO: Handle This');
			}
			if(data.status=="success"){
				window.location = '#URLFor(route="home")#';
			}
		},
		'json'
	);
}
</script>
<fb:login-button show-faces="true" width="200" max-rows="1"></fb:login-button><br/>
</cfoutput>
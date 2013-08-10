<h1>Login Page</h1>
<cfoutput>
<script>
$(document).ready(function(){
	$('##login').click(function() {
		FB.getLoginStatus(function(response){
			if(response.status !== 'connected'){
				FB.login();
			} else {
				loginUser(response.authResponse.accessToken,response.authResponse.userID);
			}
		});
	});
});
function loginUser(accessToken,userID) {
	$.post('#URLFor(action="tryLogin",params="format=json")#',
		{
			user: userID,
			type: 'Facebook'
		},
		function(data){
			console.log(data);
			if(data.status=="error"){
				alert('Login Error. TODO: Handle This');
			}
			if(data.status=="success"){
				window.location = '#URLFor(controller="dashboard",action="index")#';
			}
			if(data.status=="wait"){
				window.location = '#URLFor(action="signup")#';
			}
		},
		'json'
	);
}
</script>
<div id="login">Login</div>
<cfset test = new Query(datasource='amazon',sql="SELECT * FROM users").execute().getResult()>
<cfdump var="#test#">
</cfoutput>
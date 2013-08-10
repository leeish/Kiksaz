<script type="text/javascript">
$(document).ready(function(){
	$(window).bind('readyfblogin',function(){
		// Additional JS functions here
	    // Additional init code here
		FB.getLoginStatus(function(response){
			if(response.status !== 'connected'){
				window.location = '#URLFor(action="login")#';
			} else {
				FB.api('/me', function(response) {
	      			$('#firstname').val(response.first_name);
	      			$('#lastname').val(response.last_name);
	      			$('#id').val(response.id);
	      			$('#type').val('Facebook');
	    		});
			}
		});
	});
});
</script>
<cfoutput>
	#startFormTag(action="submitUser")#
		#textFieldTag(
			label="First Name", name="firstname", value="", placeholder="First Name"
		)#
		#textFieldTag(
			label="Last Name", name="lastname", value="", placeholder="Last Name"
		)#
		#textFieldTag(
			label="Email", name="email", value="", placeholder="Email Address"
		)#
		#hiddenFieldTag(
			value="", name="id"
		)#
		#hiddenFieldTag(
			value="", name="type"
		)#
		#submitTag(value="Finish")#
	#endFormTag()#
</cfoutput>
<!---Form processing begins here--->
<cfif structkeyExists(form,'submitLogin')>
	<!---Create an instance of the authentication service component--->
	<cfset authenticationService = createobject("component",'components.authenticationService') />
	<!---server side data validation--->
	<cfset errorMessages = authenticationService.validateUser(form.userLogin,form.userPassword) />
	<cfif ArrayisEmpty(errorMessages)>
		<!---proceed to the login procedure--->
		<cfset isUserLoggedIn = authenticationService.doLogin(form.userLogin,form.userPassword) />
	</cfif>
</cfif>
<cf_HeaderFooter title="Authorization">
<!---Form processing end here--->
<cfform id="frmConnexion">
    <cfif structKeyExists(variables,'errorMessages') AND NOT ArrayIsEmpty(errorMessages)>
    	<cfoutput>
    		<cfloop array="#errorMessages#" item="message">
    			<p class="error-message">#message#</p>
    		</cfloop>
    	</cfoutput>
    </cfif>
    <cfif structKeyExists(variables,'isUserLoggedIn') AND isUserLoggedIn EQ false>
    	<p class="error-message">User not found, try again!</p>
    </cfif>
    <cfif structKeyExists(session,'stLoggedInUser')>
    	<!---Refresh page--->
		<p>You're in!</p>
    <cfelse>
    	<div class="form form-login">
	    	<label class="label form-login__label" for="userLogin">Username</label>
	        <cfinput class="input form-login__input" type="text" name="userLogin" id="userLogin" required="true"  message="Please enter login" />
			<label class="label form-login__label" for="userPassword">Password</label>
	        <cfinput class="input form-login__input" type="password" name="userPassword" id="userPassword" required="true" message="Please enter a password" />
	    	<cfinput class="btn-submit form-login__btn-submit" type="submit" name="submitLogin" id="submitLogin" value="Login" />
	    	<a class="btn form-login__btn" href="newUser.cfm">Register</a>
	    </div>
    </cfif>
</cfform>
</cf_HeaderFooter>
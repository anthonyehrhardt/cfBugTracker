<!---Form processing begins here--->
<cfif structKeyExists(form,'editUserSubmit')>
	<!---Server side form validation--->
	<cfset errorMessages = application.userService.validateUserUpdate(form.userFirstName,form.userLastName) />
	<!---Continue form processing if the errorMessages array is empty--->
	<cfif arrayIsEmpty(errorMessages)>
		<cfset application.userService.updateUser(form.userFirstName,form.userLastName,form.userID) />
		<cfset variables.formSubmitComplete = true />
	</cfif>
</cfif>
<!---Form processing ends here--->

<!---Get user to update--->
<cfset userToUpdate = application.userService.getUserByID(session.stLoggedInUser.userID) />
<cf_HeaderFooter title="Profile">
		<h1 class="page-heading">Your profile</h1>
		<cfform class="form">
			<!---Output error messages if any--->
			<cfif structKeyExists(variables,'errorMessages') AND NOT arrayIsEmpty(errorMessages)>
				<cfoutput>
					<cfloop array="#errorMessages#" index="message">
						<p class="error-message">#message#</p>
					</cfloop>
				</cfoutput>
			</cfif>
			<!---Output feedback message if form has been successfully submitted--->
			<cfif structKeyExists(variables,'formSubmitComplete') AND variables.formSubmitComplete>
				<p class="feedback">Your profile has been updated!!</p>
			</cfif>
				<!---First name text field--->
				<div class="form__group">
					<label class="label form__label" for="userFirstName">First Name:</label>
					<cfinput class="input form__input" name="userFirstName" id="userFirstName" value="#userToUpdate.firstname#" required="true" message="Please enter a name"  />
				</div>
				<!---Last name text field--->
				<div class="form__group">
					<label class="label form__label" for="userLastName">LastName:</label>
					<cfinput class="input form__input" name="userLastName" id="userLastName" value="#userToUpdate.lastname#" required="true" message="Please enter last name"  />
				</div>
				<!---Login text field--->
				<div class="form__group">
					<label class="label form__label" for="userEmail">Login:</label>
					<cfinput class="input form__input" name="userLogin" id="userEmail" value="#userToUpdate.loginname#" required="true" message="Please enter your login" disabled />
				</div>
				<!---User id hidden field--->
				<cfinput name="userID" value="#userToUpdate.id#" type="hidden" />
				<!---Submit button--->
				<input class="btn-submit form__btn-submit" type="submit" name="editUserSubmit" id="editUserSubmit" value="Submit" />
		</cfform>
</cf_HeaderFooter>
<cf_HeaderFooter title="New User">
<!---Validate user--->
<cfif structKeyExists(form, 'newUserSubmit')>
	<cfset errorMessages = application.userService.validateUser(form.userFirstName,form.userLastName,form.userLogin,form.userPassword,form.userPasswordConfirm) />
	<cfif ArrayIsEmpty(errorMessages)>
		<cfset application.userService.addUser(form.userFirstName,form.userLastName,form.userLogin,form.userPassword) />
		<cfset userIsInserted = true />
	</cfif>
</cfif>

<cfif isDefined('userIsInserted')>
	<div class="success-message">
		<p>New user registered!</p>
		<cfif NOT structKeyExists(session,'stLoggedInUser')>
			<p><a class="btn success-message__btn" href="Bugs.cfm">Enter</a></p>
		</cfif>
	</div>
<cfelse>
	<h1 class="page-heading">New User Registration</h1>
	<cfform class="form form-new-user">
		<cfif isDefined('errorMessages') AND NOT ArrayIsEmpty(errorMessages)>
			<cfoutput >
				<cfloop array="#errorMessages#" index="message">
					<p class="error-message">#message#</p>
				</cfloop>
			</cfoutput>
		</cfif>
		<div class="form__group">
			<label class="label form__label">Name:</label>
			<cfinput class="input form__input" type="text" name="userFirstName" id="userFirstName" required="true" message="Please enter your name" />
		</div>
		<div class="form__group">
			<label class="label form__label">Lastname:</label>
			<cfinput class="input form__input" type="text" name="userLastName" id="userLastName" required="true" message="Please enter your last name" />
		</div>
		<div class="form__group">
			<label class="label form__label">Login:</label>
			<cfinput class="input form__input" type="text" name="userLogin" id="userLogin" required="true" message="Please enter login" />
			</div>
		<div class="form__group">
			<label class="label form__label">Password:</label>
			<cfinput class="input form__input" type="password" name="userPassword" id="userPassword" required="true" message="Please enter the desired password" />
		</div>
		<div class="form__group">
			<label class="label form__label">Confirm password:</label>
			<cfinput class="input form__input" type="password" name="userPasswordConfirm" id="userPasswordConfirm" required="true" message="Please repeat password" />
		</div>
		<input class="form__btn-submit btn-submit" type="submit" name="newUserSubmit" id="newUserSubmit" value="Register" />
	</cfform>
</cfif>
</cf_HeaderFooter>
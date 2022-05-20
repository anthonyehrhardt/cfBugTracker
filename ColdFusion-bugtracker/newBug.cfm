<!---Add bug properties label arrays--->
<cfinclude template="includes/bugConst.cfm">
<!---Form processing script starts here--->
<cfif structKeyExists(form, 'newBugSubmit')>
	<cfset errorMessages = application.bugService.validateBug(form.descriptionBrief, form.bugPriority, form.bugSeverity) />
	<cfif ArrayIsEmpty(errorMessages)>
		<cfset application.bugService.addBug(form.descriptionBrief, form.descriptionFull, session.stLoggedInUser.userID, form.bugPriority, form.bugSeverity) />
		<cfset bugIsInserted = true />
	</cfif>
</cfif>
<cf_HeaderFooter title="New bug">
<cfif isDefined('bugIsInserted')>
	<p>New bug added!</p>
<cfelse>
	<cfform class="form">
		<cfif isDefined('errorMessages') AND NOT ArrayIsEmpty(errorMessages)>
			<cfoutput >
				<cfloop array="#errorMessages#" index="message">
					<p class="errorMessage">#message#</p>
				</cfloop>
			</cfoutput>
		</cfif>
		<div class="form__group">
			<label class="label form__label" for="descriptionBrief">Short description:</label>
			<cfinput class="input form__input" type="text" name="descriptionBrief" id="descriptionBrief" required="true" message="Please add a short description" />
		</div>
		<div class="form__group">
			<label class="label form__label" for="bugPriority">Priority:</label>
			<cfselect class="select form__select" name="bugPriority" id="bugPriority" >
				<option value="0">Not selected</option>
				<cfoutput>
					<cfloop from="1" to="#arrayLen(priority)#" index="i">
						<option value="#i#">#priority[i]#</option>
					</cfloop>
				</cfoutput>
			</cfselect>
		</div>
		<div class="form__group">
			<label class="label form__label" for="bugSeverity">Severity:</label>
			<cfselect class="select form__select" name="bugSeverity" id="bugSeverity">
				<option value="0">Not selected</option>
				<cfoutput>
					<cfloop from="1" to="#arrayLen(severity)#" index="i">
						<option value="#i#">#severity[i]#</option>
					</cfloop>
				</cfoutput>
			</cfselect>
		</div>
		<div class="form__group">
			<label class="label label_long form__label" for="descriptionFull">Detailed description: </label>
			<textarea class="textarea" name="descriptionFull" id="descriptionFull"></textarea>
		</div>
		<input class="btn-submit form__btn-submit" type="submit" name="newBugSubmit" id="newBugSubmit" value="Save" />
	</cfform>
</cfif>
</cf_HeaderFooter>
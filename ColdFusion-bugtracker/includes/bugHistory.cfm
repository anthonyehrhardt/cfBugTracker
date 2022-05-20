<!---Form processing script starts here--->
<cfif structKeyExists(form, 'editBugSubmit')>
	<cfset errorMessages = application.bugService.validateBugEdit(form.bugEditStatus, form.bugEditPriority, form.bugEditSeverity, form.bugEditComment) />
	<cfif ArrayIsEmpty(errorMessages)>
		<cfset application.bugService.updateBug(form.bugEditStatus, form.bugEditPriority, form.bugEditSeverity, #url.BugID#) />
		<cfset application.bugHistoryService.addBugHistory(#url.BugID#, singleBug.bugStatus, LSParseNumber(form.bugEditStatus), form.bugEditComment, session.stLoggedInUser.userID) />
		<cfset bugIsEdited = true />
	</cfif>
</cfif>
<cfif isDefined('bugIsEdited')>
	<cflocation url="?BugID=#url.BugID#" >
<cfelse>
	<cfset editStatus = application.bugHistoryService.getEditStatus(#singleBug.bugStatus#, status) />
	<h2 class="page-sub-heading">Редактировать</h2>
	<cfform class="form form_wide" action="?bugID=#url.BugID#&edit=true">
		<cfif isDefined('errorMessages') AND NOT ArrayIsEmpty(errorMessages)>
			<cfoutput >
				<cfloop array="#errorMessages#" index="message">
					<p class="errorMessage">#message#</p>
				</cfloop>
			</cfoutput>
		</cfif>
		<div class="form__group">
			<label class="label label_short label_taline_right" for="bugEditStatus">Статус:</label>
			<cfselect class="select form__select select_short" name="bugEditStatus" id="bugEditStatus">
				<cfoutput>
					<option value="#singleBug.bugStatus#">#status[singleBug.bugStatus]#</option>
					<cfloop collection="#editStatus#" item="key">
						<option value="#key#">#editStatus[key]#</option>
					</cfloop>
				</cfoutput>
			</cfselect>
			<br class="large-screen-hidden-text small-screen-hidden-text">
			<label class="label label_short label_taline_right" for="bugEditPriority">Приоритет:</label>
			<cfselect class="select form__select select_short" name="bugEditPriority" id="bugEditPriority">
				<option value="0">Not selected</option>
				<cfoutput>
					<cfloop from="1" to="#arrayLen(priority)#" index="i">
						<option value="#i#">#priority[i]#</option>
					</cfloop>
				</cfoutput>
			</cfselect>
			<br class="large-screen-hidden-text small-screen-hidden-text">
			<label class="label label_short label_taline_right" for="bugEditSeverity">Критичность:</label>
			<cfselect class="select form__select select_short" name="bugEditSeverity" id="bugEditSeverity">
				<option value="0">Nort selected</option>
				<cfoutput>
					<cfloop from="1" to="#arrayLen(severity)#" index="i">
						<option value="#i#">#severity[i]#</option>
					</cfloop>
				</cfoutput>
			</cfselect>
		</div>
		<div class="form__group">
			<label class="label" for="bugEditComment">Comment: </label>
			<cftextarea class="textarea" name="bugEditComment" id="bugEditComment" required="true" message="Пожалуйста, напишите комментарий!" />
		</div>
		<input class="btn-submit" type="submit" name="editBugSubmit" id="editBugSubmit" value="Save" />
	</cfform>
</cfif>
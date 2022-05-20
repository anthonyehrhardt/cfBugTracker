<cfinclude template="includes/bugConst.cfm">
<cfif isDefined('url.BugID')>
	<cfset singleBug = application.bugService.getBugByID(#url.BugID#) />
	<cf_HeaderFooter title="Bug №#url.BugID#">
		<cfif singleBug.recordCount EQ 0>
			<cfoutput >
				<p>No numbern№#url.BugID#</p>
			</cfoutput>
		<cfelse>
			<cfoutput >
				<h1 class="page-heading">Bug №#url.BugID#</h1>
			</cfoutput>
			<cfoutput query="singleBug">
				<div class="bug-information">
					<div class="bug-information__group">
						<span class="bug-information__property">Creator:</span>
						<span class="bug-information__value">#firstname# #lastname#</span>
					</div><div class="bug-information__group">
						<span class="bug-information__property">date of creation:</span>
						<span class="bug-information__value">#DateFormat(date, 'yyyy-mm-dd')#</span>
					</div><div class="bug-information__group">
						<span class="bug-information__property">Status:</span>
						<span class="bug-information__value">#status[bugStatus]#</span>
					</div><div class="bug-information__group">
						<span class="bug-information__property">Priority:</span>
						<span class="bug-information__value">#priority[bugPriority]#</span>
					</div><div class="bug-information__group">
						<span class="bug-information__property">SeverityBug:</span>
						<span class="bug-information__value">#severity[bugSeverity]#</span>
					</div>
					<div class="bug-information__group bug-information__group_wide">
						<span class="bug-information__property">Short description:</span>
						<span class="bug-information__value">#description_brief#</span>
					</div>
					<div class="bug-information__group bug-information__group_wide">
						<span class="bug-information__property">Detailed description:</span>
						<span class="bug-information__value">#description_full#</span>
					</div>
					<cfif NOT isDefined('url.edit')>
						<a class="btn bug-information__btn" href="?BugID=#url.BugID#&edit=true">Edit</a>
					</cfif>
				</div>
			</cfoutput>
			<cfif isDefined('url.edit') AND url.edit EQ true>
				<cfinclude template="includes/bugHistory.cfm" >
			</cfif>
			<cfset bugHistory = application.bugHistoryService.getHistoryByBugID(#url.BugID#) />
			<h2 class="page-sub-heading">History of changes</h2>
			<cfif bugHistory.recordCount EQ 0>
				<cfoutput >
					<p>No Changes</p>
				</cfoutput>
			<cfelse>
				<cfset i = 0 />
				<table class="table">
					<tbody class="table__body">
						<tr class="table__row table__row_small-screen-hidden table__row_medium-screen-hidden">
							<th class="table__cell">№</th>
							<th class="table__cell">Date of change</th>
							<th class="table__cell">User</th>
							<th class="table__cell">Status change</th>
							<th class="table__cell">Comment</th>
						</tr>
						<cfoutput query="bugHistory">
						<cfset i = i + 1 />
						<tr class="table__row">
							<td class="table__cell">
								<strong>
									<span class="large-screen-hidden-text">Change No.</span>
									#i#
								</strong>
							</td>
							<td class="table__cell">
								<span class="label table__label">date of creation:</span>
								#DateFormat(date, 'yyyy-mm-dd')#
							</td>
							<td class="table__cell">
								<span class="label table__label">User:</span>
								#firstname# #lastname#
							</td>
							<td class="table__cell">
								<span class="label table__label">Status change:</span>
								#action[bugAction]#
							</td>
							<td class="table__cell">
								<span class="label table__label">Comment:</span>
								#comment#
							</td>
						</tr>
						</cfoutput>
					</tbody>
				</table>
			</cfif>
		</cfif>
	</cf_HeaderFooter>
<cfelse>
	<cfparam name="url.column" default="2" >
	<cfparam name="url.sort" default="DESC">
	<cfset bugs = application.bugService.getAllBugs(#url.column#, #url.sort#) />
	<cf_HeaderFooter title="All bugs">
		<h1 class="page-heading">All reported bugs</h1>
		<cfif bugs.recordCount EQ 0>
			<p>There are currently no entries</p>
		<cfelse>
			<table class="table">
				<tbody class="table__body">
					<tr class="table__row">
						<th class="table__cell">
							<span class="large-screen-hidden-text">Sorting:</span>
							<span class="small-screen-hidden-text medium-screen-hidden-text">id</span>
						</th>
						<th class="table__cell">
							Creator<br class="small-screen-hidden-text medium-screen-hidden-text">
							<a class="sort-arrow" href="?column=1&sort=ASC" title="Sort ascending">&uarr;</a>
							<a class="sort-arrow" href="?column=1&sort=DESC" title="Sort Descending">&darr;</a>
						</th>
						<th class="table__cell">
							date of creation<br class="small-screen-hidden-text medium-screen-hidden-text">
							<a class="sort-arrow" href="?column=2&sort=ASC" title="Sort ascending">&uarr;</a>
							<a class="sort-arrow" href="?column=2&sort=DESC" title="Sort Descending">&darr;</a>
						</th>
						<th class="table__cell">
							Status<br class="small-screen-hidden-text medium-screen-hidden-text">
							<a class="sort-arrow" href="?column=3&sort=ASC" title="Sort ascending">&uarr;</a>
							<a class="sort-arrow" href="?column=3&sort=DESC" title="Sort Descending">&darr;</a>
						</th>
						<th class="table__cell">
							Priority<br class="small-screen-hidden-text medium-screen-hidden-text">
							<a class="sort-arrow" href="?column=4&sort=ASC" title="Sort ascending">&uarr;</a>
							<a class="sort-arrow" href="?column=4&sort=DESC" title="Sort Descending">&darr;</a>
						</th>
						<th class="table__cell">
							Severity<br class="small-screen-hidden-text medium-screen-hidden-text">
							<a class="sort-arrow" href="?column=5&sort=ASC" title="Sort ascending">&uarr;</a>
							<a class="sort-arrow" href="?column=5&sort=DESC" title="Sort Descending">&darr;</a>
						</th>
						<th class="table__cell table__cell_small-screen-hidden table__cell_medium-screen-hidden">Short description</th>
						<th class="table__cell table__cell_small-screen-hidden table__cell_medium-screen-hidden">detailed information</th>
					</tr>
					<cfoutput query="bugs">
						<tr class="table__row">
							<td class="table__cell">
								<strong>
									<span class="large-screen-hidden-text">Mistake №</span>
									#id#
								</strong>
							</td>
							<td class="table__cell">
								<span class="label table__label">Author:</span>
								#firstname# #lastname#
							</td>
							<td class="table__cell">
								<span class="label table__label">Date of creation:</span>
								#DateFormat(date, 'yyyy-mm-dd')#
							</td>
							<td class="table__cell">
								<span class="label table__label">Status:</span>
								#status[bugStatus]#
							</td>
							<td class="table__cell">
								<span class="label table__label">Priority:</span>
								#priority[bugPriority]#
							</td>
							<td class="table__cell">
								<span class="label table__label">Severity:</span>
								#severity[bugSeverity]#
							</td>
							<td class="table__cell">
								<span class="label table__label">Short description:</span>
								#description_brief#
							</td>
							<td class="table__cell">
								<a class="btn table__btn" href="?BugID=#id#"More</a>
							</td>
						</tr>
					</cfoutput>
				</tbody>
			</table>
		</cfif>
	</cf_HeaderFooter>
</cfif>
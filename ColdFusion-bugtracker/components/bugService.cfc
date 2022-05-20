<cfcomponent output="false">
	<!---addBug() method--->
	<cffunction name="addBug" access="public" output="false" returntype="void">
		<cfargument name="bugDescriptionBrief" type="string" required="true" />
		<cfargument name="bugDescriptionFull" type="string" required="true" />
		<cfargument name="user" type="string" required="true" />
		<cfargument name="bugPriority" type="numeric" required="true" />
		<cfargument name="bugSeverity" type="numeric" required="true" />
		<cfset var date = Now()>
		<cfset var bugStatus = 1>
		<cfquery>
			INSERT INTO Bugs
			(date, description_brief, description_full, user, status, priority, severity)
			VALUES
			(
				<cfqueryparam value=#date# cfsqltype="cf_sql_timestamp" />,
				<cfqueryparam value="#form.descriptionBrief#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#form.descriptionFull#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.user#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#bugStatus#" cfsqltype="cf_sql_smallint" />,
				<cfqueryparam value="#form.bugPriority#" cfsqltype="cf_sql_smallint" />,
				<cfqueryparam value="#form.bugSeverity#" cfsqltype="cf_sql_smallint" />
			)
		</cfquery>
	</cffunction>
	<!---validateBug() method--->
	<cffunction name="validateBug" access="public" output="false" returntype="array">
		<cfargument name="bugDescriptionBrief" type="string" required="true" />
		<cfargument name="bugPriority" type="numeric" required="true" />
		<cfargument name="bugSeverity" type="numeric" required="true" />
		<cfset var errorMessages = arrayNew(1) />
		<!---Validate brief description--->
		<cfif form.descriptionBrief EQ ''>
			<cfset arrayAppend(errorMessages,'Please enter a short description') />
		</cfif>
		<!---Validate priority--->
		<cfif form.bugPriority EQ 0>
			<cfset arrayAppend(errorMessages,'Select a bug priority')/>
		</cfif>
		<!---Validate severity--->
		<cfif form.bugSeverity EQ 0>
			<cfset arrayAppend(errorMessages,'Pleaase select the bug severity')/>
		</cfif>
		<cfreturn errorMessages />
	</cffunction>
	<!---getBugByID() method--->
	<cffunction name="getBugByID" access="public" output="false" returntype="query">
		<cfargument name="bugID" type="string" required="true" />
		<cfquery  name="singleBug">
			SELECT Bugs.date, Bugs.description_brief, Bugs.description_full, Bugs.status AS bugStatus, Bugs.priority AS bugPriority, Bugs.severity AS bugSeverity, Users.firstname, Users.lastname
			FROM Bugs INNER JOIN Users ON Bugs.user = Users.id
			WHERE Bugs.id = <cfqueryparam value=#arguments.bugID# cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn singleBug />
	</cffunction>
	<!---updateBug() method--->
	<cffunction name="updateBug" access="public" output="false" returntype="void">
		<cfargument name="editStatus" type="numeric" required="true" />
		<cfargument name="editPriority" type="numeric" required="true" />
		<cfargument name="editSeverity" type="numeric" required="true" />
		<cfargument name="bugID" type="numeric" required="true" />
		<cfquery>
			UPDATE Bugs
			SET
			status = <cfqueryparam value="#arguments.editStatus#" cfsqltype="cf_sql_smalling" />,
			priority = <cfqueryparam value="#arguments.editPriority#" cfsqltype="cf_sql_smalling" />,
			severity = <cfqueryparam value="#arguments.editSeverity#" cfsqltype="cf_sql_smalling" />
			WHERE id = <cfqueryparam value="#arguments.bugID#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cffunction>
	<!---validateBugEdit() method--->
	<cffunction name="validateBugEdit" access="public" output="false" returntype="array">
		<cfargument name="bugEditStatus" type="numeric" required="true" />
		<cfargument name="bugEditPriority" type="numeric" required="true" />
		<cfargument name="bugEditSeverity" type="numeric" required="true" />
		<cfargument name="bugEditComment" type="string" required="true" />
		<cfset var errorMessages = arrayNew(1) />
		<!---Validate status--->
		<cfif form.bugEditStatus EQ 0>
			<cfset arrayAppend(errorMessages,'Please select an error status') />
		</cfif>
		<!---Validate priority--->
		<cfif form.bugEditPriority EQ 0>
			<cfset arrayAppend(errorMessages,'Please select a bug priority')/>
		</cfif>
		<!---Validate severity--->
		<cfif form.bugEditSeverity EQ 0>
			<cfset arrayAppend(errorMessages,'Please select the severity of the bug')/>
		</cfif>
		<!---Validate comment--->
		<cfif form.bugEditComment EQ ''>
			<cfset arrayAppend(errorMessages,'Please write a comment')/>
		</cfif>
		<cfreturn errorMessages />
	</cffunction>
	<!---Get All bugs Method--->
	<cffunction name="getAllBugs" returntype="Query">
		<cfargument name="column" type="numeric" required="true" />
		<cfargument name="sort" type="string" required="true" />
		<cfset var columns = ['user', 'date', 'bugStatus', 'bugPriority', 'bugSeverity'] />
		<cfif arguments.column LESS THAN 1 OR arguments.column GREATER THAN ArrayLen(#columns#)>
			<cfset arguments.column = 2>
		</cfif>
		<cfif arguments.sort EQ "DESC">
			<cfquery name="allBugs">
				SELECT Bugs.id, Bugs.date, Bugs.description_brief, Bugs.status AS bugStatus, Bugs.priority AS bugPriority, Bugs.severity AS bugSeverity, Users.firstname, Users.lastname
				FROM Bugs INNER JOIN Users ON Bugs.user = Users.id
				ORDER BY #columns[arguments.column]# DESC
			</cfquery>
		<cfelse>
			<cfquery name="allBugs">
				SELECT Bugs.id, Bugs.date, Bugs.description_brief, Bugs.status AS bugStatus, Bugs.priority AS bugPriority, Bugs.severity AS bugSeverity, Users.firstname, Users.lastname
				FROM Bugs INNER JOIN Users ON Bugs.user = Users.id
				ORDER BY #columns[arguments.column]# ASC
			</cfquery>
		</cfif>
		<cfreturn allBugs/>
	</cffunction>
</cfcomponent>
<cfcomponent output="false">
	<!---addBugHistory() method--->
	<cffunction name="addBugHistory" access="public" output="false" returntype="void">
		<cfargument name="bugID" type="numeric" required="true" />
		<cfargument name="bugCurrentStatus" type="numeric" required="true" />
		<cfargument name="bugEditStatus" type="numeric" required="true" />
		<cfargument name="bugEditComment" type="string" required="true" />
		<cfargument name="user" type="string" required="true" />
		<cfif arguments.bugCurrentStatus EQ form.bugEditStatus>
			<cfset var action = 1>
		<cfelse>
			<cfset var action = form.bugEditStatus>
		</cfif>
		<cfset var id = CreateUUID()>
		<cfset var date = Now()>
		<cfquery>
			INSERT INTO BugsHistory
			(id, bug_id, date, action, comment, user)
			VALUES
			(
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.bugID#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value=#date# cfsqltype="cf_sql_timestamp" />,
				<cfqueryparam value="#action#" cfsqltype="cf_sql_smallint" />,
				<cfqueryparam value="#form.bugEditComment#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.user#" cfsqltype="cf_sql_varchar" />
			)
		</cfquery>
	</cffunction>
	<!---getEditStatus() method--->
	<cffunction name="getEditStatus" access="public" output="false" returntype="struct">
		<cfargument name="currentStatus" type="numeric" required="true" />
		<cfargument name="statusArray" type="array" required="true" />
		<cfset var editStatus = structNew()>
		<cfif arguments.currentStatus EQ 1>
			<cfset editStatus.2 = arguments.statusArray[2]> 
		</cfif>
		<cfif arguments.currentStatus EQ 2>
			<cfset editStatus.3 = arguments.statusArray[3]> 
		</cfif>
		<cfif arguments.currentStatus EQ 3>
			<cfset editStatus.2 = arguments.statusArray[2]>
			<cfset editStatus.4 = arguments.statusArray[4]> 
		</cfif>
		<cfreturn editStatus />
	</cffunction>
	<!---getHistoryByBugID() method--->
	<cffunction name="getHistoryByBugID" access="public" output="false" returntype="query">
		<cfargument name="bugID" type="string" required="true" />
		<cfquery  name="bugHistory">
			SELECT BugsHistory.date, BugsHistory.action AS bugAction, BugsHistory.comment, Users.firstname, Users.lastname
			FROM BugsHistory INNER JOIN Users ON BugsHistory.user = Users.id
			WHERE BugsHistory.bug_id = <cfqueryparam value=#arguments.bugID# cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn bugHistory />
	</cffunction>
</cfcomponent>
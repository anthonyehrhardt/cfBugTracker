<cfcomponent output="false">
	<!---validateUser() method--->
	<cffunction name="validateUser" access="public" output="false" returntype="array">
		<cfargument name="userLogin" type="string" required="true" />
		<cfargument name="userPassword" type="string" required="true" />
		
		<cfset var errorMessages = ArrayNew(1) />
		<!---Validate the login--->
		<cfif arguments.userPassword EQ ''>
			<cfset arrayAppend(errorMessages,'Please enter username') />
		</cfif>
		<!---Validate the password---->
		<cfif arguments.userPassword EQ ''>
			<cfset arrayAppend(errorMessages,'Please enter password') />
		</cfif>
		<cfreturn errorMessages />
	</cffunction>
	<!---doLogin() method--->
	<cffunction name="doLogin" access="public" output="false" returntype="boolean">
		<cfargument name="userLogin" type="string" required="true" />
		<cfargument name="userPassword" type="string" required="true" />
		
		<!---Create the isUserLoggedIn variable--->
		<cfset var isUserLoggedIn = false />
		<!---Create hashed password--->
		<cfset var passwordHash = Hash(arguments.userPassword, "SHA-512")>
		<!---Get the user data from the database--->
		<cfquery name="loginUser">
			SELECT Users.firstname, Users.lastname, Users.id, Users.loginname, Users.password, Users.deleted
			FROM Users
			WHERE Users.loginname = <cfqueryparam value="#arguments.userLogin#" cfsqltype="cf_sql_varchar" /> AND Users.password = '#passwordHash#' AND Users.deleted = 0
		</cfquery>
		<!---Check if the query returns one and only one user--->
		<cfif loginUser.recordCount EQ 1>
			<!---Log the user in--->
			<cflogin >
				<cfloginuser name="#loginUser.firstname# #loginUser.lastname#" password="#loginUser.password#" roles="user">
			</cflogin>
			<!---Save user data in the session scope--->
			<cfset session.stLoggedInUser = {'userFirstName' = loginUser.firstname, 'userLastName' = loginUser.lastname, 'userID' = loginUser.id} />
			<!---change the isUserLoggedIn variable to true--->
			<cfset var isUserLoggedIn = true />
		</cfif>
		<!---Return the isUserLoggedIn variable--->
		<cfreturn isUserLoggedIn />
	</cffunction>
	<!---doLogout() method--->
	<cffunction name="doLogout" access="public" output="false" returntype="void">
		<!---delete user data from the session scope--->
		<cfset structdelete(session,'stLoggedInUser') />
		<!---Log the user out--->
		<cflogout />
	</cffunction>

</cfcomponent>
<cfcomponent output="false">
	<!---addUser() method--->
	<cffunction name="addUser" access="public" output="false" returntype="void">
		<cfargument name="userFirstName" type="string" required="true" />
		<cfargument name="userLastName" type="string" required="true" />
		<cfargument name="userLogin" type="string" required="true" />
		<cfargument name="userPassword" type="string" required="true" />
		<cfset var id = CreateUUID()>
		<cfset var passwordHash = Hash(form.userPassword, "SHA-512" )>
		<cfquery>
			INSERT INTO Users
			(id, loginname, firstname, lastname, password)
			VALUES
			(
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#form.userLogin#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#form.userFirstName#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#form.userLastName#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#passwordHash#" cfsqltype="cf_sql_varchar" />
			)
		</cfquery>
	</cffunction>
	<!---validateUser() method--->
	<cffunction name="validateUser" access="public" output="false" returntype="array">
		<cfargument name="userFirstName" type="string" required="true" />
		<cfargument name="userLastName" type="string" required="true" />
		<cfargument name="userLogin" type="string" required="true" />
		<cfargument name="userPassword" type="string" required="true" />
		<cfargument name="userPasswordConfirm" type="string" required="true" />
		<cfset var errorMessages = arrayNew(1) />
		<!---Validate first name--->
		<cfif form.userFirstName EQ ''>
			<cfset arrayAppend(errorMessages,'Please enter your name') />
		</cfif>
		<!---Validate last name--->
		<cfif form.userLastName EQ ''>
			<cfset arrayAppend(errorMessages,'Please enter your last name') />
		</cfif>
		<!---Validate login--->
		<cfif form.userLogin EQ ''>
			<cfset arrayAppend(errorMessages,'Please enter your username to login') />
		</cfif>
		<!---Prevent login duplication--->
		<cfquery name="loginDuplication">
			SELECT *
			FROM Users
			WHERE loginname = <cfqueryparam value="#arguments.userLogin#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		<cfif loginDuplication.recordCount NEQ 0>
			<cfset arrayAppend(errorMessages,'This login already exists! Please select another')/>
		</cfif>
		<!---Validate Password--->
		<cfif form.userPassword EQ '' >
			<cfset arrayAppend(errorMessages,'Please enter the desired password')/>
		</cfif>
		<!---Validate Password confirmation--->
		<cfif form.userPasswordConfirm EQ '' >
			<cfset arrayAppend(errorMessages,'Please repeat password')/>
		</cfif>
		<!---validate password and password confirmation Match --->
		<cfif form.userPassword NEQ form.userPasswordConfirm >
			<cfset arrayAppend(errorMessages,'Passwords do not match, please try again')/>
		</cfif>
		<cfreturn errorMessages />
	</cffunction>
	<!---getUserByID() method--->
	<cffunction name="getUserByID" access="public" output="false" returntype="query">
		<cfargument name="userID" type="string" required="true" />
		<cfquery  name="singleUser">
			SELECT id, firstname, lastname, loginname, password
			FROM Users
			WHERE id = <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_varchar" /> 
		</cfquery>
		<cfreturn singleUser />
	</cffunction>
	<!---updateUser() method--->
	<cffunction name="updateUser" access="public" output="false" returntype="void">
		<cfargument name="userFirstName" type="string" required="true" />
		<cfargument name="userLastName" type="string" required="true" />
		<cfargument name="userID" type="string" required="true" />
		<cfquery>
			UPDATE Users
			SET
			firstname = <cfqueryparam value="#arguments.userFirstName#" cfsqltype="cf_sql_varchar" />,
			lastname = <cfqueryparam value="#arguments.userLastName#" cfsqltype="cf_sql_varchar" />
			WHERE id = <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		<cfset session.stLoggedInUser.userFirstName = arguments.userFirstName />
		<cfset session.stLoggedInUser.userLastName = arguments.userLastName />
	</cffunction>
	<!---validateUserUpdate() method--->
	<cffunction name="validateUserUpdate" access="public" output="false" returntype="array">
		<cfargument name="userFirstName" type="string" required="true" />
		<cfargument name="userLastName" type="string" required="true" />
		<cfset var errorMessages = arrayNew(1) />
		<!---Validate first name--->
		<cfif form.userFirstName EQ ''>
			<cfset arrayAppend(errorMessages,'Please enter your name') />
		</cfif>
		<!---Validate last name--->
		<cfif form.userLastName EQ ''>
			<cfset arrayAppend(errorMessages,'Please enter your last name') />
		</cfif>
		<cfreturn errorMessages />
	</cffunction>
	<!---Get All active Users Method--->
	<cffunction name="getAllUsers" returntype="Query">
		<cfquery name="allUsers">
			SELECT Users.firstname, Users.lastname, Users.deleted
			FROM Users
			WHERE Users.deleted = 0
			ORDER BY Users.lastname
		</cfquery>
		<cfreturn allUsers/>
	</cffunction> 
</cfcomponent>
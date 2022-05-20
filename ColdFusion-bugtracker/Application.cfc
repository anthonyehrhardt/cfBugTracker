<cfcomponent output="false">
	<cfset this.name = 'BugtrackerPrototype' />
	<cfset this.applicationTimeout = createtimespan(0,2,0,0) />
	<cfset this.datasource = 'bugs' />
	<cfset this.customTagPaths = expandPath('customTags') />
	<cfset this.sessionManagement = true />
	<cfset this.sessionTimeout = createTimespan(0,0,30,0) />
	
	
	<!---OnApplicationStart() method--->
	<cffunction name="onApplicationStart" returntype="boolean" >
		<cfset application.userService = createObject("component",'components.userService') />
		<cfset application.bugService = createObject("component",'components.bugService') />
		<cfset application.bugHistoryService = createObject("component",'components.bugHistoryService') />
		<cfreturn true />
	</cffunction>
	<!---onRequestStart() method--->
	<cffunction name="onRequestStart" returntype="boolean" >
		<cfargument name="targetPage" type="string" required="true" />
		<!---Handle the logout--->
		<cfif structKeyExists(URL,'logout')>
			<cfset createObject("component",'components.authenticationService').doLogout() />
		</cfif>
		<!---Add a login form for unauthorised user--->
		<cfif NOT listFind(arguments.targetPage,'newUser.cfm', '/')>
			<cflogin> 
				<cfif NOT IsDefined("cflogin")> 
					<cfinclude template="includes/loginForm.cfm"> 
					<cfabort> 
				<cfelse> 
					<cfloginuser name = "#cflogin.name#" password = "#cflogin.password#"
					roles = "user"/> 
				</cfif> 
			</cflogin>
		</cfif>
		<!---handle restart app parameter--->
		<cfif isDefined('url.restartApp')>
			<cfset this.onApplicationStart() />
		</cfif>
		<cfreturn true>
	</cffunction>

</cfcomponent>
<cfparam name="attributes.title" default="Welcome!" >
<cfif thistag.executionMode EQ 'start'>
<!DOCTYPE html>
<html lang="en">
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <title><cfoutput>#attributes.title# - Bugtracker prototype</cfoutput></title>
	    <link rel="stylesheet" href="styles/styles.css">
	</head>
	<body class="body">
		<header class="header">
			<cfif structKeyExists(session,'stLoggedInUser')>
			<!---Display a welcome message and navigation--->
		    	<span class="header__user-name"><cfoutput>#session.stLoggedInUser.userFirstName# #session.stLoggedInUser.userLastName#</cfoutput></span>
		    	<a class="header__button" href="Profile.cfm">My Profile</a>
		    	<a class="header__button" href="?logout">Log off</a>
		    	<nav class="main-navigation header__main-navigation">
		    		<a class="main-navigation__item" href="Bugs.cfm">Bugs</a>
		    		<a class="main-navigation__item" href="newBug.cfm">Add bug</a>
		    		<a class="main-navigation__item" href="Users.cfm">Users</a>
		    		<a class="main-navigation__item" href="newUser.cfm">Add User</a>
		    	</nav>
		    <cfelse>
		    	<p class="sign-in-message header__sign-in-message">Please log in or register in the system!</p>
	    	</cfif>
		</header>
		<main class="content">
<cfelse>
		</main>
		<footer class="footer">
			<p class="copyright">&copy; Copyright 2022 <a href="mailto:aehrhardt@gmail.com">Anthony Ehrhardt</a></p>
		</footer>
	</body>
</html>
</cfif>
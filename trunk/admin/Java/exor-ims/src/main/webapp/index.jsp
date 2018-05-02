<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Exor-IMS</title>
		<link href="/exor-ims/css/style.css" rel="stylesheet" type="text/css" />
		
		<script>
			var val = null;
			var tnsEntries = new Array();
			var parentWindow = null;
			var buttonX = null;
			var buttonY = null;
			
			var test = "null";
			
			function getTestString2(e) {
				test = getDBConnectStr();
			}
			
			function getTestString() {
				return test;
			}
			
			function getDBConnectStr() {
				var emailid = document.getElementById("emailid").value;
				var tnsName = document.getElementById("tnsName").value;				
				var returnVal = emailid.length + "$" + emailid + tnsName.length + "$" + tnsName + "test";
				
				return returnVal;
			}
			
			function setTNSName(tnsName) {
				document.getElementById("tnsName").value = tnsName;
				var emailid = document.getElementById("emailid").value;
				test = emailid.length + "$" + emailid + tnsName.length + "$" + tnsName + "test";
				document.getElementById("dbTNSForm").submit();
			}
			
			function setFocus() {
				document.getElementById("tnsName").focus();
			}
		</script>
	</head>
	
	<body onload="setFocus();">
		<div class="navbar-header pull-left logo-container">
			<a href="https://www.bentley.com">
				<img alt="Bentley" src="/exor-ims/images/bentley-logo.jpg" />
			</a>
		</div>
		<div id="back" class="divBack"></div>    
		<div id="front" class="divFront"  onclick="">
		<form id="dbTNSForm" action="" onsubmit="getTestString2(event)">
		<%@ page import="java.util.*"%>
		<%@ page import="com.auth10.federation.Claim"%>
		<%@ page import="com.auth10.federation.FederatedPrincipal"%>
		<%@ page import="com.auth10.federation.FederatedConfiguration"%>
		<%@ page import="com.auth10.federation.WSFederationFilter"%>
		<%
		
		// gets the user claims
	 	List<Claim> claims = ((FederatedPrincipal)request.getUserPrincipal()).getClaims();
	 	
	 	Iterator<Claim> itr = claims.iterator();
	 	
	 	String emailid = null;
	 	
	 	while(itr.hasNext()) {
	 		Claim claim = (Claim)itr.next();
	 		
	 		if(claim.getClaimType().endsWith("emailaddress")) {
	 			emailid = claim.getClaimValue();
	 			break;
	 		}
	 	}
	 	%>
	 			<input id="emailid" type="hidden" value='<%=emailid%>' />
	 			
	 			<font face="Times New Roman">Database: </font><input id="tnsName" type="text" class="tnsName" />
	 			<br/><br/>
	 			<input id="submitbutton" type="submit" class="exp" value="Login" />
	 		</form>
	 		</div>
	 	<%
	 	
	%>
		<a tabindex="25" class="copyright-footer" target="_blank" href='https://www.bentley.com'>
			&copy;&nbsp;<%=Calendar.getInstance().get(Calendar.YEAR) %>&nbsp;Bentley&nbsp;Systems,&nbsp;Incorporated
		</a>
	</body>
</html>

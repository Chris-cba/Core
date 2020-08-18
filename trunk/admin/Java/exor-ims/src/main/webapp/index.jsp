<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<meta http-equiv="X-UA-Compatible" content="IE=11" />
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
			
			function setTNSName(tnsName) {
				document.getElementById("tnsName").value = tnsName;
				document.getElementById("dbTNSForm").submit();
			}
			
			function setFocus() {
				document.getElementById("tnsName").focus();
			}
			
			function getClaims() { 
				var tns = document.getElementById("tnsName").value;
				
				if(tns) { 
					tns = "tnsname" + ":" + tns; 
					
					var claims = tns.length + "$" + tns; 
					var claimsElements = document.getElementsByClassName('claims'); 
					
					for(var i = 0; i < claimsElements.length; i++) {
						var claim = claimsElements[i].name + ":" + claimsElements[i].value; 
						claims += claim.length + "$" + claim; 
					}
					
					return claims; 
				} else {
					return "null"; 
				} 
			}
		</script>
	</head>
	
	<body onload="setFocus();">
		<div class="navbar-header pull-left logo-container">
			<a href="https://www.bentley.com">
				<%@ page import="java.io.*"%>
				<%@page import="javax.xml.bind.DatatypeConverter"%>
				<%
					String imageString = null;
					
					try {
						File            f         = new File(application.getRealPath("/images/bentley-logo.jpg"));
						FileInputStream fin       = new FileInputStream(f);
						byte[]          imageData = new byte[(int)f.length()];
						String          fileName  = f.getName();
						
						fin.read(imageData);
						
						imageString = DatatypeConverter.printBase64Binary(imageData);
					} catch(Exception e) {
						
					}
				%>
				<img alt="Logo Image" src="data:image/jpg;base64, <%=imageString%>" />
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
				String claimType  = claim.getClaimType(); 
				claimType  = claimType.substring(claimType.lastIndexOf("/") + 1); 
				String claimValue = claim.getClaimValue(); 
			%>
				<input type="hidden" class="claims" name="<%=claimType%>" value="<%=claimValue%>" />
			<% 
			}
			%>
				<font face="Times New Roman">Database: </font><input id="tnsName" type="text" class="tnsName" />
				<br/>
				<br/>
				<input id="submitbutton" type="submit" class="exp" value="Login" />
			</form>
	 	</div>
		
		<a tabindex="25" class="copyright-footer" target="_blank" href='https://www.bentley.com'>
			&copy;&nbsp;<%=Calendar.getInstance().get(Calendar.YEAR) %>&nbsp;Bentley&nbsp;Systems,&nbsp;Incorporated
		</a>
	</body>
</html>

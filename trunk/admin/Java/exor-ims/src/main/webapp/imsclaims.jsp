<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Exor-IMS-Claims</title>
		<link href="/exor-ims/css/style.css" rel="stylesheet" type="text/css" />
	</head>
	
	<body> 
		<div id="claims"> 
			<%@ page import="java.util.*"%>
			<%@ page import="com.auth10.federation.Claim"%>
			<%@ page import="com.auth10.federation.FederatedPrincipal"%>
			<%@ page import="com.auth10.federation.FederatedConfiguration"%>
			<%@ page import="com.auth10.federation.WSFederationFilter"%>
			<%
			response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
			response.setHeader("Pragma","no-cache"); //HTTP 1.0
			response.setDateHeader ("Expires", 0);
			
			// gets the user claims
			List<Claim> claims = ((FederatedPrincipal)request.getUserPrincipal()).getClaims();
			
			Iterator<Claim> itr = claims.iterator();
			
			String emailid = null;
			
			while(itr.hasNext()) { 
				Claim claim = (Claim)itr.next();
				
				if(claim.getClaimType().endsWith("emailaddress")) {
					emailid = claim.getClaimValue(); 
					out.print(emailid.length() + "$" + emailid); 
					
					break;
				}
			}
			%> 
	 	</div>
	</body>
</html>

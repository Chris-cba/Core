<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<meta http-equiv="X-UA-Compatible" content="IE=11" />
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Exor-IMS</title>
		<link href="/exor-ims/css/style.css" rel="stylesheet" type="text/css" />
		<script>
			function closeWindow() {
				var daddy = window.self;
				daddy.opener = window.self;
				daddy.close();
			}
		</script>
	</head>
	
	<body onload="closeWindow();">
		<div class="navbar-header pull-left logo-container"> 
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
			
			<a href="https://www.bentley.com">
				<img alt="Logo Image" src="data:image/jpg;base64, <%=imageString%>" />
			</a>
		</div>
		<div id="back" class="divBack"></div> 
		<a tabindex="25" class="copyright-footer" target="_blank" href='https://www.bentley.com'>
			&copy;&nbsp;<%=Calendar.getInstance().get(Calendar.YEAR) %>&nbsp;Bentley&nbsp;Systems,&nbsp;Incorporated
		</a>
	</body>
</html>

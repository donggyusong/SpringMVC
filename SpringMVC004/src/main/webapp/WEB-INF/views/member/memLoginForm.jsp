<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>회원 로그인 폼</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
	<script>
	$(document).ready(function(){
		if(${not empty msgType}){
			if(${msgType eq "실패 메세지"}){
				$("#messaageType").attr("class","modal-content panel-warning");
			}
			$("#myMessage").modal("show");
		}
	})
</script>

</head>
<body>
 <jsp:include page="../common/header.jsp"/>
<div class="container">
  <h2>Spring MVC03</h2>
  <div class="panel panel-default">
    <div class="panel-heading">로그인 화면</div>
    <div class="panel-body">
		<form name="frm" action="${contextPath}/memLogin.do" method="post">
				<input type="hidden"  id="memPassword" name="memPassword" value=""/>
				<table class="table table-bordered" style="text-align: center; border: 1px solid #dddddd;">
				
					<tr>
						<td style="width:110px; vertical-align:middle;">아이디</td>
						<td colspan="2"><input id="memID" name="memID" class="form-control" type='text' maxlength="20" placeholder="아이디를 입력하세요"/></td>
					</tr>
					
					<tr>
						<td style="width:110px; vertical-align:middle;">비밀번호</td>
						<td colspan="2">
							<input id="memPassword" name="memPassword" class="form-control" type="password" maxlength="20" placeholder="비밀번호를 입력하세요"/>
						</td>
					</tr>
					
					<tr>
						<td colspan="2" style="text-align:left;">
							<input type="submit" class="btn btn-primary btn-sm pull-right" value="로그인"/>
						</td>
					</tr>
					
				</table>
			</form>
		
		
		<!-- 실패 메세지를 띄울 모달창 -->
		<!-- Modal -->
			<div id="myMessage" class="modal fade" role="dialog">
			  <div class="modal-dialog" >
			
				    <!-- Modal content-->
				    <div id="messageType" class="modal-content panel-info">
				      <div class="modal-header panel-heading">
				        <button type="button" class="close" data-dismiss="modal">&times;</button>
				        <h4 class="modal-title">${msgType}</h4>
				      </div>
				      <div class="modal-body">
				        	${msg}
				      </div>
				      <div class="modal-footer">
				        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				      </div>
				    </div>
				
			  </div>
			</div>
	</div>
    <div class="panel-footer">스프1탄-송동규</div>
  </div>
</div>
</body>
</html>

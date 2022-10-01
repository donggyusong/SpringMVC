<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>회원가입 폼</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
	<script type="text/javascript">
	
		$(document).ready(function(){
			
				if(${not empty msgType}){
					if(${msgType eq "실패 메세지"}){
						$("#messaageType").attr("class","modal-content panel-warning");
					}
					
					$("#myMessage").modal("show");
				}
			
		})


		function registerCheck(){
			var memID = $("#memID").val()
			console.log(memID);
			$.ajax({
				url : "${contextPath}/memRegisterCheck.do",
				type : "get",
				data : {"memID" : memID},
				success : function(result){
					console.log(result)
					//중복유무 출력(result=1 : 사용할 수 있는 아이디, 0 : 사용할 수 없는 아이디)
					if(result==1){
						$("#checkMessage").html("사용할 수 있는 아이디입니다.")
						
						//모달창 화면 스타일을 바꿔줄거다
						$('#checkType').attr("class","modal-content panel-success")
					}else{
						$("#checkMessage").html("사용할 수 없는 아이디입니다.")
						
						//모달창 화면 스타일을 바꿔줄거다
						$('#checkType').attr("class","modal-content panel-warning");
					}
					
					$('#myModal').modal("show");
				},
				error : function(){alert("error")}
			})
		}
		
		function passwordCheck(){
			var memPassword1 = $("#memPassword1").val();
			var memPassword1 = $("#memPassword1").val();
			if(memPassword1 != memPassword2){
				$("#passMessage").html("비밀번호가 서로 일치하지 않습니다.")
				//비밀번호가 일치하지 않으면 서버에 값이 넘어가면 안된다.
				
				
			}else{
				//일치하면 아무것도 출력안함
				
				//일치하면 hidden을 넘어가는 input에 값을 넣어줄거다.
				$('#memPassword').val(memPassword1);
				
			}
		}
		
		function goInsert(){
			var memAge = $("#memAge").val()
			if(memAge == null || memAge=="" || memAge == 0){
				//나이만 굳이 jsp단에서 유효성 검사를 하는 이유가 자바단에서 하면 int형이라서 null체크가 안된다.
				alert("나이를 입력하세요");
				return false; // false를 리턴하면 이벤트가 실행이 안된다.
			}
			document.frm.submit(); //submit 버튼
		}
	</script>


</head>
<body>
	<div class="container">
	 <jsp:include page="../common/header.jsp"/>
	  <h2>Spring MVC03</h2>
	  <div class="panel panel-default">
	    <div class="panel-heading">회원가입</div>
	    <div class="panel-body">
			<form name="frm" action="${contextPath}/memRegister.do" method="post">
				<input type="hidden"  id="memPassword" name="memPassword" value=""/>
				<table class="table table-bordered" style="text-align: center; border: 1px solid #dddddd;">
					<tr>
						<td style="width:110px; vertical-align:middle;">아이디</td>
						<td colspan="2"><input id="memID" name="memID" class="form-control" type='text' maxlength="20" placeholder="아이디를 입력하세요"/></td>
						<td style="width:110px;"><button type="button" class="btn btn-primary btn-sm" onclick="registerCheck()">중복확인</button></td>
					</tr>
					<tr>
						<td style="width:110px; vertical-align:middle;">비밀번호</td>
						<td colspan="2"><input id="memPassword1" name="memPassword1" class="form-control" type='password' maxlength="20" placeholder="비밀번호를 입력하세요" onkeyup="passworkdCheck()"/></td>
					</tr>
					<tr>
						<td style="width:110px; vertical-align:middle;">비밀번호확인</td>
						<td colspan="2"><input id="memPassword2" name="memPassword2" class="form-control" type='password' maxlength="20" placeholder="비밀번호를 확인하세요" onkeyup="passworkdCheck()"/></td>
					</tr>
					<tr>
						<td style="width:110px; vertical-align:middle;">사용자 이름</td>
						<td colspan="2"><input id="memName" name="memName"  class="form-control" type='text' maxlength="20" placeholder="이름을 입력하세요"/></td>
					</tr>
					<tr>
						<td style="width:110px; vertical-align:middle;">나이</td>
						<td colspan="2"><input id="memAge" name="memAge" class="form-control" type='number' maxlength="20" placeholder="나이를 입력하세요" /></td>
					</tr>
					<tr>
						<td style="width:110px; vertical-align:middle;">성별</td>
						<td colspan="2">
								<div class="form-group" style="text-align: center; margin:0 auto;">
										<div class="btn-group" data-toggle="buttons">
											<label class="btn btn-primary active">
												<input type="radio" id="memGender" name="memGender"  autocomplete="off" value="남자" checked/>남자
											</label>
											<label class="btn btn-primary">
												<input type="radio" id="memGender" name="memGender"  autocomplete="off" value="여자" checked/>여자
											</label>
										</div>
								</div>
						</td>
					</tr>
					<tr>
						<td style="width:110px; vertical-align:middle;">이메일</td>
						<td colspan="2"><input  id="memEmail" name="memEmail" class="form-control" type='text' maxlength="20" placeholder="이메일을 입력하세요"/></td>
					</tr>
					<tr>
						<td colspan="3" style="text-align:left;">
							<span id="passMessage" style="color:red"></span>
							<input type="button" class="btn btn-primary btn-sm pull-right" value="등록" onclick="goInsert()"/>
						</td>
					</tr>
				</table>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
			</form>
		</div>
			<!-- 모달창 UI -->
		
			<!-- Modal -->
			<div id="myModal" class="modal fade" role="dialog">
			  <div class="modal-dialog" >
			
					    <!-- Modal content-->
					    <div id="checkType" class="modal-content">
					      <div class="modal-header panel-heading">
					        <button type="button" class="close" data-dismiss="modal">&times;</button>
					        <h4 class="modal-title">메세지 확인</h4>
					      </div>
					      <div class="modal-body">
					        <p id="checkMessage"></p>
					      </div>
					      <div class="modal-footer">
					        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					      </div>
					    </div>
			
			  </div>
			</div>
			
			
			<!-- 회원등록 실패 메세지를 출력하는 모달창 -->
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
		
		
	    <div class="panel-footer">스프1탄-송동규</div>
	  </div>
	</div>
	

	
	
</body>
</html>

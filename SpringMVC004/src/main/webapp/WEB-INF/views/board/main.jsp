<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Spring MVC03</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			loadList();
		})
		
		function loadList(){
			//서버와 통신을 하자 -> 게시판 리스트 가져오기
			$.ajax({
				url : "${ctx}/board/all",
				type : "get",
				dataType : "json",
				success : makeView,
				error : function(){alert("error");}
			});
		}
		function makeView(data){ // data=[{   },{   },{   }]

			console.log(data)
			var listHtml = "<table class='table table-bordered>'";
				listHtml+="<tr>";
				listHtml+="<th>번호</th>";
				listHtml+="<th>제목</th>";
				listHtml+="<th>작성자</th>";
				listHtml+="<th>조회수</th>";
				listHtml+="</tr>";
			  
			  //반복문 처리 [{  },{  },{  }]
			  $.each(data,function(index,obj){
				  listHtml+="<tr>";
				  listHtml+="<td>"+obj.idx+"</td>";
				  listHtml+="<td id='t"+obj.idx+"'><a href='javascript:goContent("+obj.idx+")'>"+obj.title+"</a></td>";
				  listHtml+="<td>"+obj.writer+"</td>";
				  listHtml+="<td>"+obj.indate.split(' ')[0]+"</td>";
				  listHtml+="<td id='cnt"+obj.idx+"'>"+obj.count+"</td>";
				  listHtml+="</tr>";
				  listHtml+="<tr id='c"+obj.idx+"' style='display:none'>";
				  listHtml+="<td>내용</td>";
				  listHtml+="<td colspan='4'>";
				  listHtml+="<textarea id='ta"+obj.idx+"' rows='7' class='form-control'>"+obj.content+"</textarea>";
				  
				  //자기 글인 경우에만 클릭가능
				  if("${mvo.memID}"==obj.memID){
					  listHtml+="<br/>";
					  listHtml+="<span id='ub"+obj.idx+"'><button class='btn btn-success btn-sm' onclick='goUpdateForm("+obj.idx+")'>수정화면</button></span>&nbsp";
					  listHtml+="<button class='btn btn-warning btn-sm' onclick='goDelete("+obj.idx+")'>삭제</button>";
				  }else{
					  listHtml+="<br/>";
					  listHtml+="<span id='ub"+obj.idx+"'><button disabled class='btn btn-success btn-sm' onclick='goUpdateForm("+obj.idx+")'>수정화면</button></span>&nbsp";
					  listHtml+="<button disabled class='btn btn-warning btn-sm' onclick='goDelete("+obj.idx+")'>삭제</button>";
				  }
				  listHtml+="</td>";
				  listHtml+="</tr>";				  
			  })
			  
			  //로그인을 해야 보이는 부분
			  if($(!empty mvo)){
				  listHtml+="<tr>";
				  listHtml+="<td>";
				  listHtml+="<button class='btn btn-primary btn-sm' onclick='goForm()'>글쓰기</button>";
				  listHtml+="</td>";
				  listHtml+="</tr>";
			  }
			  
			  listHtml+="</table>";
			  $("#view").html(listHtml);
			  
			  $("#view").css("display","block"); //감추는거
			  $("#wform").css("display","none"); //보이게 하는거
		}
		
		function goForm(){
			$("#view").css("display","none"); //감추는거
			$("#wform").css("display","block"); //보이게 하는거
		}
		
		function goList(){
			$("#view").css("display","block"); //감추는거
			$("#wform").css("display","none"); //보이게 하는거
		}
		
		function goInsert(){
			//이렇게 개별적을 form안에 있는 파라미터 값을 가져올 수 있다.
			//var title=$("#title").val();
			//var content = $("#content").val()
			//var writer = $("#writer").val()
			
			//form안에 있는 파라미터 데이터를 한꺼번에 들고오기
			var fData = $("#frm").serialize(); //콘솔에 뭐가 출력되는지 한번 보자
			
			$.ajax({
				url : "boardInser.do",
				type : "post",
				data : fData,
				success : loadList,
				error : function(){alert("error")}
			});
			
			//폼 초기화
			//$("#title").val("");
			//$("#content").val("");
			//$("#writer").val("");
			$("#fclear").trigger("click");
		}
		
		function goContent(idx){
			console.log('동기')
			
			if($("#c"+idx).css("display")=="none"){
				
				$.ajax({
					url : "${ctx}/board/"+idx,
					type : "get",
					//data : {"idx" : idx},
					dataType : "json",
					success : function(data){ // data={"content" : ~~~ }
						$("#ta"+idx).val(data.content);
					},
					error : function(){ alert("error");}
				})
				
				
				$("#c"+idx).css("display","table-row"); //tr을 보일게 하려면 block이 아니라 table-row를 값으로 줘야한다.
				$("#ta"+idx).attr("readonly",true);
			}else{
				$("#c"+idx).css("display","none"); 
				
				//조회수 카운트
				$.ajax({
					url : "board/count/"+idx,
					type : "get",
					dataType : "json",
					success : function(data){
						$("#cnt"+idx).text(data.count);
					},
					error : function(){alert("error");}
				})
			}
		}
		
		function goDelete(idx){
			$.ajax({
				url : "board/"+idx,
				type: "delete",
				data : {"idx" : idx},
				success: loadList,
				error: function(){alert("error")}
			})
		}
		
		function goUpdateForm(idx){ 
			$("#ta"+idx).attr("readonly",false) //readonly가 아니게끔 만든다.
			
			
			var title = $("#t"+idx).text()
			var newInput = "<input id='nt"+idx+"' type='text' class='form-control' value='"+title+"'/>"
			$("#t"+idx).html(newInput);
			
			var newButton = "<button id='nt"+idx+"' class='btn btn-primary btn-sm' onclick='goUpdate("+idx+")'>수정</button>"
			$("#ub"+idx).html(newButton);
		}
		
		function goUpdate(idx){
			var title = $("#nt"+idx).val();
			var content =  $("#ta"+isx).val()
			
			$.ajax({
				url : "board/update",
				type : "put",
				contentType : 'application/json;charset=utf-8',
				data : JSON.stringfy({"idx" : idx, "title" : title, "content" : content}),
				success : loadList,
				error : function(){
					alert("error");
				}
			})
		}
	</script>

</head>
<body>
<jsp:include page="../common/header.jsp"/>  
	<div class="container">
	  <h2>회원 게시판</h2>
	  <div class="panel panel-default">
	    <div class="panel-heading">Panel Heading</div>
	    <div class="panel-body" id="view">Panel Content</div>
	    <div class="panel-body" id="wform" style="display : none">
	    	<form id="frm">
	    				<input type="hidden" name="memID" id="memID" value="${mvo.memID}"/>
						<table class="table">
							<tr>
								<td>제목</td>
								<td><input type="text" id="title" name="title" class="form-control"/></td>
							</tr>
							
							<tr>
								<td>내용</td>
								<td>
									<textarea readonly rows="7"  id="content"class="form-control" name="content" ></textarea>
								</td>
							</tr>
							<tr>
								<td>작성자</td>
								<td><input type="text" id="writer" name="writer" class="form-control" value="${mvo.memName}" readonly="readonly"/></td>
							</tr>
							<tr>
								<td colspan="2">
									<button type="button" class="btn btn-success btn-sm" onclick="goInsert()">등록</button>
									<button type="reset" class="btn btn-warning btn-sm" id="fclear">취소</button>
									<button type="button" class="btn btn-info btn-sm" onclick="goList()">리스트</button>
								</td>
							</tr>
						</table>
					</form>
	    </div>
	    <div class="panel-footer">Panel Content</div>
	  </div>
	</div>
</body>
</html>

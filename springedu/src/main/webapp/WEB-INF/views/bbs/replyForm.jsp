<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<jsp:include page="/main_header.jsp" flush="false"/>
<script>
	$(function(){
	  
		//유효성체크 오류시 에러표시 css적용 
 		$("span[id$='.errors']").each(function(idx){
			if($(this).text().length > 0){
				 $(this).prev().removeClass("is-valid").addClass("is-invalid");
				 $(this).removeClass("valid-feedback").addClass("invalid-feedback");
			}
		});	
	
	  //목록으로이동
	  $("#btn1").on("click", function(e){
	  	e.preventDefault();
	  	location.href="/bbs/list";
	  });
	  //게시글 등록
	  $("#btn2").on("click", function(e){
	  	e.preventDefault();
	  	//유효성체크
	  	//if( valChk()) {
	  	//form 태그의 action="/bbs/write"
	  		$("form").submit();
	  	//}
	  });		
	  //게시글 취소
	  $("#btn3").on("click", function(e){
	  	e.preventDefault();
	  	$("form").each(function(){
	  		this.reset();
	  	})
	  });		
	  
	});
	
	function valChk(){
    //제목입력값이 없을경우
    if($("#btitle").val().length == 0){	
      alert('제목을 입력하세요!');
      $("#btitle").focus();
      return false;
    }
    
    //제목입력값 길이 체크
    if($("#btitle").val().length > 30){	
      alert('30자 이상 입력불가!');
      $("#btitle").focus();
      return false;
    }

    // 내용입력값이 없을경우
    if($("#bcontent").val().length == 0){
      alert('내용을 입력하세요!');
      $("#bcontent").focus();
      return false;
    }

    // 내용입력길이 체크
    if($("#bcontent").val().length > 100){
      alert('100자 이상 입력불가!');
      $("#bcontent").focus();
      return false;
    }

    return true;
	};
</script>
<div class="container">
    <div class="table-responsive">
    <h3 class="text-center p-3 mb-3 bg-white font-weight-bolder text-monospace">답글 작성</h3>
    <form:form modelAttribute="bbsDTO" action="/bbs/replyOk" method="post">
<%--     <form:hidden path="bid" 				value="${user.id }"  />
    <form:hidden path="bnickname" 	value="${user.nickname }" /> --%>
    <form:hidden path="bgroup" value="${bbsDTO.bgroup }"/>
    <form:hidden path="bstep" value="${bbsDTO.bstep }"/>
    <form:hidden path="bindent" value="${bbsDTO.bindent }"/>    
    <input type=hidden name="reqPage" value="${rc.reqPage }"/>    
    <table class="table table-sm" summary="게시글 작성">
       <colgroup>
         <col width="20%">
         <col width="">
       </colgroup>
       <tbody>
         <tr>
           <th>글번호</th>
           <td>${bbsDTO.bnum }
           </td>
         </tr>         
         <tr>
           <th>제목</th>
           <td>
             <form:input class="form-control is-valid" type="text" path="btitle" placeholder="제목을 입력하세요" value="[답글] : ${bbsDTO.btitle }"/>
             <form:errors class="valid-feedback" path="btitle"></form:errors>
           </td>
         </tr>
         <tr>
           <th>작성자</th>
           <td>${user.nickname }(${user.id })
           </td>
         </tr>
         <tr>
           <th>내용</th>
           <td>
             <form:textarea class="form-control is-valid" path="bcontent" rows="15" placeholder="본문내용을 입력하세요" value="[원글]:${bbsDTO.bcontent }"/>
             <form:errors class="valid-feedback" path="bcontent"></form:errors>
           </td>
         </tr>
				<tr>
					<td colspan="2" align="right">
					<button id='btn1' type="button" class="btn btn-sm btn-outline-primary">목록</button>
					<button id='btn2' type="button" class="btn btn-sm btn-outline-primary">등록</button>
					<button id='btn3' type="button" class="btn btn-sm btn-outline-primary">취소</button>
					</td>
				</tr>         
       </tbody>			
		</table>
		</form:form>
</div>
<jsp:include page="/main_footer.jsp" flush="false" />
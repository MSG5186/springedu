<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>    

<jsp:include page="/main_header.jsp" flush="false"/> 


<style>
	.errmsg, pwErr {color: #f00;}
</style>            

<script>
	$(function(){
					
		$("#pw,#pwchk").on("keyup",function(){
			if($("#pw").val() != $("#pwchk").val()) {
				console.log($(this).val());
				$(".pwErr").text('비밀번호가 틀립니다!');
				$(this).focus();
			}else{
				$(".pwErr").text('');
			}
		})
		
		// 수정버튼
		$("#modifyBtn").on("click",function(e){
			e.preventDefault();	
			$("form").submit();
		});
				
		// 수정취소버튼
		$("#modifyCancelBtn").on("click",function(e){
			e.preventDefault();	
			location.href="/member/memberList";
		});
		
	});
</script>
</head>
<body>
<%-- 	<form:form modelAttribute="mdto" action="memberJoin"> --%>
	<form:form modelAttribute="mdto" action="${pageContext.request.contextPath }/member/memberModify">
<main role="main" class="container">
		                                       
		<h2>[회원수정]</h2>
		<ul>
			<li>
				<form:label path="id">아이디</form:label>
				<form:input type="text" path="id" readonly="true"/>
				<form:errors path="id" cssClass="errmsg"></form:errors>
			</li>
			<li>
				<form:label path="pw">비밀번호</form:label>
				<form:input type="password" path="pw" />
				<form:errors path="pw" cssClass="errmsg"></form:errors>
			</li>
			<li>
				<label for="pwchk">비밀번호확인</label>
				<input type="password" id="pwchk" name='pwchk' />
				<span class="pwErr"></span>				
			</li>
			<li>
				<form:label path="tel">전화번호</form:label>
				<form:input type="tel" path="tel" />
				<form:errors path="tel" cssClass="errmsg"></form:errors>
			</li>
			<li>
				<form:label path="nickname">닉네임</form:label>
				<form:input type="text" path="nickname" />
				<form:errors path="nickname" cssClass="errmsg"></form:errors>
			</li>
			<li>
				<form:label path="gender">성별</form:label>
<%-- 				<form:radiobutton path="gender" value="남"/>남자
				<form:radiobutton path="gender" value="여"/>여자
 --%>
 				<form:radiobuttons items="${gender }" path="gender" itemLabel="label" itemValue="code"/>
 			</li>

			<li><form:label path="region">지역</form:label>
					<form:select path="region">
            <form:option value="" label="--지역선택--"/>
            <form:options items="${rCodes }" itemLabel="label" itemValue="code"/>						
					</form:select>
			</li>			
			<li>
				<form:label path="birth">생년월일</form:label>
				<form:input type="date" path="birth" />
				<form:errors path="birth" cssClass="errmsg"></form:errors>
			</li>
			<li><button id="modifyBtn">수정</button>
					<button id="modifyCancelBtn">취소</button>
			</li>
		</ul>
	</main>
	</form:form>
<jsp:include page="/main_footer.jsp" flush="false"/>
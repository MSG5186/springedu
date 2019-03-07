<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<jsp:include page="/main_header.jsp" flush="false"/>

    <style>
      .bd-placeholder-img {
        font-size: 1.125rem;
        text-anchor: middle;
      }

      @media (min-width: 768px) {
        .bd-placeholder-img-lg {
          font-size: 3.5rem;
        }
      }
      
    </style>
    <!-- Custom styles for this template -->
    <link href="/resources/ccs/floating-labels.css" rel="stylesheet">
		<style>
			.errmsg {color: #f00;}
		</style> 
		
<script>
	$(function(){
	
		$("#btn1").on("click",function(e){
			e.preventDefault();	
			$("form").submit();
		});				
	});
	
</script>
          
	<div class="container">
      <div class="row justify-content-center">
    <div class="col-4">
<form:form class="form-signin" modelAttribute="pwFind" action="${pageContext.request.contextPath }/login/findPw">
  <div class="text-center mb-4">
    <img class="mb-4" src="/resources/images/login.jpg" alt="" width="150" height="150">
        <h1 class="h3 mb-3 font-weight-normal">비밀번호 조회</h1>
    <!-- <p>Build form controls with floating labels via the <code>:placeholder-shown</code> pseudo-element. <a href="https://caniuse.com/#feat=css-placeholder-shown">Works in latest Chrome, Safari, and Firefox.</a></p> -->
  </div>

  <div class="form-label-group">
    <form:label path="id">아이디</form:label>
    <form:input type="text" path="id" class="form-control" placeholder="아이디를 입력하세요!ex)aaa@bbb.com" required="true" autofocus="true" />
    <form:errors path="id" cssClass="errmsg"></form:errors>
  </div>
  
  <div class="form-label-group">
    <form:label path="tel">전화번호</form:label>
    <form:input type="text" path="tel" class="form-control" placeholder="전화번호를 입력하세요!" required="true" autofocus="true" />
    <form:errors path="tel" cssClass="errmsg"></form:errors>
  </div>

  <div class="form-label-group">
    <form:label path="nickname">닉네임</form:label>
    <form:input type="text" path="nickname" class="form-control" placeholder="닉네임을 입력하세요!" required="true" />
    <form:errors path="nickname" cssClass="errmsg"></form:errors>    
  </div>
  
  <div>
    <label>찾은 비밀번호</label>
    <input type="text" readonly="true" value="${pw}"/>   
  </div>

  <div class="mb-3">
    <label>
    </label>
  </div>
  <button id="btn1" class="btn btn-lg btn-primary btn-block" type="submit">비밀번호 찾기</button>

</form:form>
  </div>
</div></div>
  <p class="mt-5 mb-3 text-muted text-center">&copy; 2019-2022</p>
<jsp:include page="/main_footer.jsp" flush="false" />

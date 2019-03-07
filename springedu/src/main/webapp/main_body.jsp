<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <main role="main" class="container">
  

		<hr />	
			<c:choose>
				<c:when test="${sessionScope.user ne null }">
					<b>로그아웃</b>
				</c:when>
				<c:otherwise>
					<b>로그인 하십시오</b>
				</c:otherwise>
			</c:choose>			
		<hr />		
			${user.id } <br>
			${user.pw } <br>
			${user.nickname } <br>
			${user.birth } <br>
			${user.gender } <br>
			${user.tel } <br>
			${user.region } <br>
			
			
		</main><!-- /.container -->
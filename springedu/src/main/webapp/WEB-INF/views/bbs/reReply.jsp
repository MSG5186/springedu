<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- <%@ taglib prefix="c"	uri="http://java.sun.com/jsp/jstl/core" %> --%>
<%-- <jsp:include page="/main_header.jsp" flush="false"/> --%>
 <style>
   textarea.autosize {
     min-height:1rem;
     outline:none;      /* 클릭시 경계선 없애기 */
     width:100%;
     border:none;
     border-bottom:1px solid #000;
     overflow:hidden;   /* 스크롤바 앲애기 */
       transform: scaleX(1);
   }

 </style>
<script>
	var bnum = ${bbsDTO.bnum};  //원글 10063
	var rereqPage = 1; //요청페이지 1
	
	var l_id = "${sessionScope.user.id}"; // 로긴 아이디
	var l_nickname = "${sessionScope.user.nickname}"; //로긴 닉네임 

  // 대댓글 작성 html코드 시작-----------------------------------------------
  var reply_str = '';
  reply_str += "<li data-rrnum='' data-form='write' class='list-group-item m-0 p-0'>";
  reply_str += "  <div>";
  reply_str += "    <div class='row m-0 p-0'>";
  reply_str += "      <div class='col-1'></div>";
  reply_str += "      <div class='col-11'>";
  reply_str += "        <textarea class='autosize'></textarea></div>";
  reply_str += "      <div class='col-12 text-right'>";
  reply_str += "        <a href='javascript:void(0)' class='rrclose badge badge-pill badge-light mx-0 px-2'>취소</a>";
  reply_str += "        <a href='javascript:void(0)' class='rrreply badge badge-pill badge-primary mx-0 px-2'>댓글</a>";
  reply_str += "      </div>";
  reply_str += "    </div>";
  reply_str += "  </div>";
  reply_str += "</li>";
  //대댓글 작성 html코드 끝-----------------------------------------------

  // 대댓글 수정 html코드 시작-----------------------------------------------
  var modify_str = '';
  modify_str += "<li data-rrnum='' data-form='modify' class='list-group-item m-0 p-0'>";
  modify_str += "  <div>";
  modify_str += "    <div class='row m-0 p-0'>";
  modify_str += "      <div class='col-1'></div>";
  modify_str += "      <div class='col-11'>";
  modify_str += "        <textarea class='autosize'></textarea></div>";
  modify_str += "      <div class='col-12 text-right'>";
  modify_str += "        <a href='javascript:void(0)' class='rrclose badge badge-pill badge-light mx-0 px-2'>취소</a>";
  modify_str += "        <a href='javascript:void(0)' class='rrmodify badge badge-pill badge-warning mx-0 px-2'>수정완료</a>";
  modify_str += "      </div>";
  modify_str += "    </div>";
  modify_str += "  </div>";
  modify_str += "</li>";
  //대댓글 수정 html코드 끝-----------------------------------------------
  
	$(function(){
				
		//댓글목록 보이기
		replyList(rereqPage);
		
		//댓글 글자수 제한 시작-------------------------------------
		var $rcontent = $("#rcontent");
		$rcontent.on("keyup",function(){
			var rcontent = $("#rcontent").val(); 		//댓글본문
			var cnt = rcontent.length;
			
			$("#count").html(cnt + '/100');		
			
			if(cnt > 100){
				
				$rcontent.addClass("is-invalid");
				//100자초과시 잘라내기
				rcontent = rcontent.substring(rcontent.length-100);
				$rcontent.val(rcontent);
				
				$("#count").html(rcontent.length + ' / 100');	
				return false;				
			}
			$rcontent.removeClass("is-invalid");
		});
		$rcontent.keyup();
		//댓글 글자수 제한 끝---------------------------------------
		
		// 댓글 작성
		$("#replyBtn").on("click",function() { 
			var rid = $("#rid").text();  				 		//작성자 id
			var rnickname = $("#rnickname").text(); //작성자 별칭
			var rcontent = $("#rcontent").val(); 		//댓글본문
			var cnt = rcontent.trim().length;
			//console.log(rid);
			//console.log(rcontent);
			if(cnt == 0){
				$("#rcontent").attr("placeholder","댓글입력바랍니다.")
				              .addClass("is-invalid"); 
				$("#rcontent").focus();
				return false;
			}else if(cnt > 100){
				alert('100자를 초과하였습니다.')
				$("#rcontent").focus();
				return false;
			}
			
			//AJAX 비동기 처리기술
			$.ajax({
				type : "POST",  // post, get, put, delete
				url  : "/rbbs/posts",
				headers:{
					"Content-Type" : "application/json",
					"X-HTTP-Method-Override" : "POST"
				},
				dataType : "text",
				data:JSON.stringify({
					bnum: bnum,
					rid: rid,
					rnickname: rnickname,
					rcontent: rcontent
				}),
				
				success:function(result){
					//댓글목록 호출
					//console.log(result);
					replyList(rereqPage);
				},
				error :function(xhr, status, err){
					console.log("xhr:"+xhr);
					console.log("status:"+status);
					console.log("err:"+err);
				}
			}); 
		});
 		
	});	
	
	//요청페이지에 대한 댓글목록 가져오기
	function replyList(rereqPage){
		
	var str="";
    var rrnickname ="";  // 부모댓글의 별칭
    var rrid = "";       // 부모댓글의 아이디
    
		$.ajax({
			type:"GET",
			url:"/rbbs/posts/map/"+bnum+"/"+rereqPage,
			dataType: "JSON",
			success:function(data,status,xhr){
/*   				console.log("data:"+data);
				console.log("data.item:"+data.item);
				console.log(data.pagecriteria); 
*/
				str += "<ul class='list-group list-group-flush'>";
				
				$.each(data.item,function(idx, rec){
				//	console.log("rec.isdel:" + rec.isdel);
					//rrdto null체크 : 부모글이 있는지 체크
					if(rec.rrdto !=null){
						rrnickname = '@'+rec.rrdto.rnickname; // 부모댓글의 별칭
						rrid       = rec.rrdto.rrid;      // 보모댓글의 아이디
					}
					
					//삭제유무 판단
					if(rec.isdel == 'Y'){
						//들여쓰기
						if( rec.rindent == 0){
						// 1step
							str += "<li data-rnum='"+rec.rnum+"' class='reList list-group-item m-0 p-0'>";
							str += "  <div>";
							str += "    <div class='row m-3 p-0'>";
							str += "      <div class='col-1'>";
							str += "      </div>";
							str += "      <div class='col-11'>";
							str += "        <p class='mb-0'><span class='mr-1 text-warning'>삭제된 게시물입니다.</span></p>";
							str += "      </div>";
							str += "    </div>";					
						}else{
							str += "<li data-rnum='"+rec.rnum+"' data-rrnum='"+rec.rrnum+"' class='reList list-group-item m-0 p-0'>";                   
							str += "  <div>";
							str += "    <div class='row m-3 p-0'>";
							str += "      <div class='col-1'></div>";
							str += "      <div class='col-1'>";
							str += "      </div>";
							str += "      <div class='col-10'>";
							str += "        <p class='mb-0'><span class='mr-1 text-warning'>삭제된 게시물입니다.</span></p>";
							str += "      </div>";
							str += "    </div>";		
						}
						str += "  </div>";
						str += "</li>";
						
						//console.log(str);		
						//}						
					}else{
					
						//들여쓰기
						if( rec.rindent == 0){
						// 1step
							str += "<li data-rnum='"+rec.rnum+"' class='reList list-group-item m-0 p-0'>";
							str += "  <div>";
							str += "    <div class='row m-0 p-0'>";
							str += "      <div class='col-1'>";
							str += "      <img src='/resources/images/login.jpg' class='m-1 rounded-circle' style='width:45px;'>";
							str += "      </div>";
							str += "      <div class='col-11'>";
							str += "        <h6>"+rec.rnickname+"("+rec.rid+") <small class='ml-2'><i>"+rec.rcdate+"</i></small></h6>";
							str += "        <p class='replybody'><span class='mr-1 text-primary'>"+rrnickname+"</span>"+rec.rcontent+"</p>";
							str += "      </div>";
							str += "    </div>";					
						}else{
							str += "<li data-rnum='"+rec.rnum+"' data-rrnum='"+rec.rrnum+"' class='reList list-group-item m-0 p-0'>";                   
							str += "  <div>";
							str += "    <div class='row m-0 p-0'>";
							str += "      <div class='col-1'></div>";
							str += "      <div class='col-1'>";
							str += "      <img src='/resources/images/login.jpg' class='m-1 rounded-circle' style='width:45px;'>";
							str += "      </div>";
							str += "      <div class='col-10'>";
							str += "        <h6>"+rec.rnickname+"("+rec.rid+") <small class='ml-2'><i>"+rec.rcdate+"</i></small></h6>";
							str += "        <p class='replybody'><span class='mr-1 text-primary'>"+rrnickname+"</span>"+rec.rcontent+"</p>";
							str += "      </div>";
							str += "    </div>";
						
						}
						str += "    <div class='row m-0 p-0'>";
						str += "      <div class='col-1'></div>";
						str += "      <div class='col-9 pl-4'>";
						str += "        <a href='javascript:void(0)' data-active='off' class='goodBtn badge badge-light' ";
						str += "        data-toggle='tooltip' data-placement='top' data-html='true' title='<b>호감</b>'>";
						str += "        <i class='far fa-thumbs-up mr-2'>"+rec.rgood+"</i></a>";
						str += "        <a href='javascript:void(0)' data-active='off' class='badBtn badge badge-light' ";
						str += "        data-toggle='tooltip' data-placement='top' data-html='true' title='<b>비호감</b>'>";
						str += "        <i class='far fa-thumbs-down mr-2'>"+rec.rbad+"</i></a>";
						str += "        <a href='javascript:void(0)' data-active='off' ";
						str += "        class='reReplyBtn badge badge-pill badge-primary px-2'>댓글</a>";
						str += "      </div>";
						
						if(l_id == rec.rid){
						str += "      <div class='col-2 m-0 p-0 text-right'>";
						str += "        <a href='javascript:void(0)' data-active='off' ";
						str += "        class='reModifyBtn badge badge-pill badge-warning mx-0 px-2'>수정</a>";
						str += "        <a href='javascript:void(0)' data-active='off' ";
						str += "        class='reDelBtn badge badge-pill badge-danger mx-0 px-2'>삭제</a>";
						str += "      </div>";
						}
						
						str += "    </div>";
						str += "  </div>";
						str += "</li>";
						
						//console.log(str);		
						}
				});
				str += "</ul>";
				
				//댓글 목록 삽입
				$("#replyList").html(str);
				
				// 페이지 리스트호출
				showPageList(data.pagecriteria);
				
				// 댓글목록 이벤트처리
				doActionEvent();
			},
			error :function(xhr, status, err){
				console.log("xhr:"+xhr);
				console.log("status:"+status);
				console.log("err:"+err);
			}
			
		});
		
		//페이지번호 클릭시 이벤트 처리
		$("#pageNumList").on("click", "li a", function(e){
			e.preventDefault();  					// 현재 이벤트의 기본 동작을 중단.
			e.stopImmediatePropagation(); // 현재 이벤트가 상위 및 현재 레벨에 걸린 다른 이벤트도 동작않도록 중단.
			//e.stopPropagation();        // 현재 이벤트가 상위로 전파되지 않도록 중단.
			rereqPage = $(this).attr("href");
			replyList(rereqPage);
		
		});		
	} 	
	
	// 페이징구현 
	function showPageList(pagecriteria){
		console.log(pagecriteria);

		var str="";
		
		//이전페이지여부
		if(pagecriteria.prev){		
		 //처음	
		 str += "<li class='page-item'>";
	   str += "<a class='page-link' href='1' tabindex='-1' aria-disabled='true'>◀</a></li>";
	   
	   //이전페이지
	   str += "<li class='page-item'><a class='page-link href='";
	   str +=  (pagecriteria.startPage-1);
	   str += "' tabindex='-1' aria-disabled='true'>◁</a></li>";
		}
		
		//페이지 1~10
		for( i=pagecriteria.startPage, end=pagecriteria.endPage; i<=end; i++){
		
	    <!-- 현재페이지와 요청페이지가 다르면 -->
	   	if(pagecriteria.recordCriteria.reqPage != i) {          
	   		str += "<li class='page-item'><a class='page-link' href='"+i+"'>"+i+"</a></li>";
	   	}else{
	    	<!-- 현재페이지와 요청페이지가 같으면 -->
	    	str += "<li class='page-item active'><a class='page-link' href='"+i+"'>"+i+"</a></li>";
	   	}
		}
		
		//다음페이지여부
		if(pagecriteria.next){
			//다음페이지
	    str += "<li class='page-item'><a class='page-link' href='";
	    str += (pagecriteria.endPage+1);
	    str += "'>▷</a></li>";		
	    
			//마지막
	    str += "<li class='page-item'><a class='page-link' href='";
	    str += (pagecriteria.finalEndPage);
	    str += "'>▷</a></li>";			
		}
	   
		//페이징 삽입
		$("#pageNumList").html(str);
		
	}	
	
	//댓글목록 이벤트처리
	function doActionEvent(){
		
    //대댓글 작성 클릭시
    $('.reReplyBtn').on('click',function(e){
      var $liEle = $(this).parents('li');
      var $data_rnum  =  $liEle.attr('data-rnum'); //댓글번호
      var $data_rrnum =  $liEle.next().attr('data-rrnum'); //대댓글번호
      var $data_form   = $liEle.next().attr('data-form'); //
			console.log($data_rnum);
			console.log($data_rrnum);
			console.log($data_form);
      //대댓글 양식이 없을경우만 추가
      if( $data_rnum != $data_rrnum) {
        $liEle.after(reply_str);
			
      //현재글의 대댓글은 있으나 댓글작성 중이 아닐경우
      }else if($data_rnum == $data_rrnum && $data_form == null){
        $liEle.after(reply_str);
        
      }else if($data_rnum == $data_rrnum && $data_form == 'write') {

        var $textarea = $liEle.next().find('textarea');
        var $tmp = $textarea.val();

        $liEle.next().replaceWith(reply_str);
        $liEle.next().find('textarea').val($tmp);

      }else if($data_rnum == $data_rrnum && $data_form == 'modify'){

        $liEle.next().replaceWith(reply_str);
        $liEle.next().find('textarea').val($tmp);
        
      }

      $liEle.next().attr('data-rrnum',$liEle.attr('data-rnum'));

      //대댓글 양식 높이 자동 조절
      var $textareaEle = $('textarea.autosize');
      $textareaEle.on('keyup focus', function(){
        $(this)[0].style.height = 'auto';
        $(this).css('height', $(this).prop('scrollHeight'));
        //console.log($(this).prop('scrollHeight'));
      });
      $textareaEle.trigger('focus');

      //대댓글 양식 닫기
      $('.rrclose').on('click',function(e){
        e.stopImmediatePropagation();
        $liEle.next().remove();
      });
      
   		//리댓글 등록 - bnum,rrnum,rid,rnickname,rcontent
   		$(".rrreply").on("click",function(){
   			console.log('리댓글 등록');	
   			var $li = $(this).parents("li");
   			var rrnum = $li.attr('data-rrnum');
   			var rcontent = $li.find('textarea').val();
   			//console.log("rcontent="+rcontent);
   			
   			$.ajax({
   				type:"POST",
   				url:"/rbbs/rposts",
   			//	contentType:"application/json",
     			headers:{
   					"Content-Type" : "application/json",
   					"X-HTTP-Method-Override" : "POST"
   				},
   				dataType:"text",
   				data:JSON.stringify({
						bnum : bnum,
   					rrnum : rrnum,
   					rid : l_id,
   					rnickname : l_nickname,
   					rcontent : rcontent
   				}),
        	success:function(result){
        		replyList(rereqPage);
        	},
  				error:function(xhr, status, err){
  					console.log("xhr:"+xhr);
  					console.log("status:"+status);
  					console.log("err:"+err);
  				}   				
   			});
   		});
   		      

    });

    //대댓글 수정 클릭시
    $('.reModifyBtn').on('click',function(e){
      //console.log(e.target.innerText);

      var $liEle = $(this).parents('li');
      var $data_rnum  =  $liEle.attr('data-rnum'); //댓글번호
      var $data_rrnum =  $liEle.next().attr('data-rrnum'); //대댓글번호
      var $data_form   = $liEle.next().attr('data-form'); //

      //대댓글 수정 양식이 없을경우만 추가
      if( $data_rnum != $data_rrnum) {
        var tmp = $liEle.find('p').text();
        $liEle.after(modify_str);
        $liEle.next().find('textarea').val(tmp);

        //현재글의 대댓글은 있으나 댓글수정 중이 아닐경우
      }else if($data_rnum == $data_rrnum && $data_form == null){
        var tmp = $liEle.find('p').text();
        $liEle.after(modify_str);
        $liEle.next().find('textarea').val(tmp);
      }
        else if($data_rnum == $data_rrnum && $data_form == 'write') {
        $tmp = $liEle.find('p').text();
        $liEle.next().replaceWith(modify_str);
        $liEle.next().find('textarea').val($tmp);

      }else if($data_rnum == $data_rrnum && $data_form == 'modify') {

        var $textarea = $liEle.next().find('textarea')
        var $tmp = $textarea.val();
        if($tmp.trim().length == 0 ){
          $tmp = $liEle.find('p').text();
        }

        $liEle.next().replaceWith(modify_str);
        $liEle.next().find('textarea').val($tmp);
        
      }
      
      $liEle.next().attr('data-rrnum',$liEle.attr('data-rnum'));

      //대댓글 수정 양식 높이 자동 조절
      var $textareaEle = $('textarea.autosize');
      $textareaEle.on('keyup focus', function(){
        $(this)[0].style.height = 'auto';
        $(this).css('height', $(this).prop('scrollHeight'));
      });
      $textareaEle.trigger('focus');

      //대댓글 수정 양식 닫기
      $('.rrclose').on('click',function(e){
        e.stopImmediatePropagation();
        $liEle.next().remove();
      });
      
   		//수정 rnum,rcontent
   		$(".rrmodify").on("click",function(){
   			var $li = $(this).parents("li");
   			var rnum = $li.attr("data-rrnum");
   			var rcontent = $li.find('textarea').val();   			
   			$.ajax({
   				type: "PUT",
   				url: "/rbbs/posts",
     			//	contentType:"application/json",
     			headers:{
   					"Content-Type" : "application/json",
   					"X-HTTP-Method-Override" : "POST"
   				},
   				dataType:"text",
   				data:JSON.stringify({
						rnum : rnum,
   					rcontent : rcontent
   				}),
        	success:function(result){
        		replyList(rereqPage);
        	},
  				error:function(xhr, status, err){
  					console.log("xhr:"+xhr);
  					console.log("status:"+status);
  					console.log("err:"+err);
  				}   				   				
   			});
   			
   		});

    });

    //댓글 삭제 클릭시
    $('.reDelBtn').on('click', function(){
      //삭제 toast 띄우기
      var $li = $(this).parents('li');
      var rnum = $li.attr('data-rnum');
      //console.log("rnum="+rnum);
      
      $.ajax({
      	type:"DELETE",
      	url: "/rbbs/posts/"+rnum,
/*       	headers:{
      		"Content-Type" :"application/json", //전송내용이 json포맷
      		"X-HTTP-Method-Override" :"POST" // 낮은버전브라우져에서 POST방식으로 강제변경. 
      	}, */
      	dataType:"text",
      	success:function(){
      		replyList(rereqPage);
      	},
				error:function(xhr, status, err){
					console.log("xhr:"+xhr);
					console.log("status:"+status);
					console.log("err:"+err);
				}
    	});
      	
      $('#t-del-msg').toast('show');
    });

 		//호감
 		$(".goodBtn").on("click",function(){
 			console.log('호감');	
      var $li = $(this).parents('li');
      var rnum = $li.attr('data-rnum');     
      $.ajax({
      	type:"PUT",
      	url: "/rbbs/posts/good/"+rnum,
      	dataType:"text",
      	success:function(){
      		replyList(rereqPage);
      	},
				error:function(xhr, status, err){
					console.log("xhr:"+xhr);
					console.log("status:"+status);
					console.log("err:"+err);
				}
    	}); 			
 		});
 		
 		//비호감
 		$(".badBtn").on("click",function(){
 			console.log('비호감');
      var $li = $(this).parents('li');
      var rnum = $li.attr('data-rnum');     
      $.ajax({
      	type:"PUT",
      	url: "/rbbs/posts/bad/"+rnum,
      	dataType:"text",
      	success:function(){
      		replyList(rereqPage);
      	},
				error:function(xhr, status, err){
					console.log("xhr:"+xhr);
					console.log("status:"+status);
					console.log("err:"+err);
				}
    	}); 	 			
 		}); 
        
    //tootip적용
    $("[data-toggle='tooltip']").tooltip();		
		
	}
</script>

<div class="container">
<!-- 댓글 등록 -->
<table class="table table-sm table-borderless table-dark">
  <colgroup>
    <col width="10%">
    <col width="80%">
    <col width="10%">
  </colgroup>
	<tr>
		<th>작성자</th>
		<td><span id="rnickname">${sessionScope.user.nickname}</span>/(<span id="rid">${sessionScope.user.id}</span>)</td>
		<td></td>
	</tr>
	<tr>
		<th>댓 글</th>
		<td>
			<textarea class="form-control" id="rcontent" rows="2"></textarea>
			<p class="text-right m-0" id="count"></p>
		</td>
		<td><button class="btn btn-danger btn-block btn-lg mt-2" id="replyBtn">등록</button></td>
	</tr>
</table>	

<!-- 댓글 목록 -->
<div id="replyList">
	
</div>

<!-- 댓글 페이징 -->
<div>
	<nav aria-label="Page navigation example">
 		<ul id="pageNumList" class="pagination pagination-sm justify-content-center">
 			
 		</ul>
	</nav> 		
</div>

<!-- tosts -->
<div role='alert' aria-live='assertive' aria-atomic='true' 
   class='toast' id='t-del-msg'
   data-autohide='true' data-delay='1300' >
   <!-- style='position: absolute; right: 50px; bottom: 50px;' -->
  <div class='toast-header'>
    <!--img src='...' class='rounded mr-2' alt='...'-->
    <i class='far fa-trash-alt fa-lg mr-2' style='color:#f00;'></i>
    <strong class='mr-auto'>[삭제]</strong>
    <small class='invisible'>11 mins ago</small>
    <button type='button' class='ml-2 mb-1 close' data-dismiss='toast' aria-label='Close'>
      <span aria-hidden='true'>&times;</span>
    </button>
  </div>
  <div class='toast-body'>
    댓글이 삭제되었습니다.
  </div>
</div>
</div>
<%-- <jsp:include page="/main_footer.jsp" flush="false" /> --%>
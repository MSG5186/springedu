package com.kh.myapp.member.service;

import java.util.List;

import com.kh.myapp.member.dto.MemberDTO;

public interface MemberSvc {
	//회원 등록
	public boolean insert(MemberDTO memberDTO);  
		
	//회원 수정
	public boolean modify(MemberDTO memberDTO);
	
	//회원 삭제(회원용)
	public boolean delete(String id, String pw);
	
	//회원 삭제(관리자용)
	public boolean adminDelete(String id);
	
	//회원 조회
	public MemberDTO getMember(String id);
	
	//회원 목록 조회
	public List<MemberDTO> getMemberList();
	
	//회원 아이디 조회
	public String getMemberId(String tel , String nickname);
	
	//회원 비밀번호 조회
	public String getMemberPw(String id ,String tel , String nickname);
	
	
}

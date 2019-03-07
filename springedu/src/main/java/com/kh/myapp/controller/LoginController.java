package com.kh.myapp.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kh.myapp.login.LoginCmd;
import com.kh.myapp.login.LoginSvc;
import com.kh.myapp.member.dto.MemberDTO;
import com.kh.myapp.member.service.MemberSvc;

@Controller
@RequestMapping("/login")
public class LoginController {

	private static Logger logger = LoggerFactory.getLogger(LoginController.class);
			
	@Inject
	LoginSvc loginSvc;
	@Inject
	MemberSvc memberSvc;
	
	@RequestMapping("/loginForm")
	public void loginForm(Model model) {
		model.addAttribute("login", new LoginCmd());
	}
	
	//로그인
	@RequestMapping(value="/loginOk")//,method=RequestMethod.POST)
	public String login(@Valid @ModelAttribute("login") LoginCmd login, BindingResult result,HttpSession session) {

		logger.info("String login 호출됨!");
				
		MemberDTO mdto = null;

		if(result.hasErrors()) {
			logger.info(result.toString());			
			return "/login/loginForm";
		}
		
		//1)회원 유무체크
		if (loginSvc.isMember(login.getId(), login.getPw())) {
		//2)로그인 처리
			mdto = loginSvc.login(login.getId(), login.getPw());
			session.setAttribute("user", mdto);
			logger.info("로그인 처리됨:" + login.getId());
		}else {
			return "forward:/login/loginForm";
		}
		return "redirect:/";
	}
	
	//로그아웃
	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		
		session.invalidate();
		
		return "redirect:/login/loginForm";
	}
	
	
	@RequestMapping("/memberIdFindForm")
	public void findIdForm(Model model) {
		model.addAttribute("idFind", new MemberDTO());
	}
	
	
	//아이디 찾기
	@RequestMapping(value="/findId")//,method=RequestMethod.POST)
	public String findId(@Valid @ModelAttribute("idFind") MemberDTO mdto, BindingResult result, Model model) {
		
		logger.info("String findId 호출됨!"+mdto);
		
		String id = null;
		
		if(result.hasErrors()) {
			logger.info(result.toString());			
			return "/login/loginForm";
		}
		
		
		id = memberSvc.getMemberId(mdto.getTel(), mdto.getNickname());
		
		model.addAttribute("id", id);
	
		return "/login/memberIdFindForm";
	}

	
	
	@RequestMapping("/memberPwFindForm")
	public void findPwForm(Model model) {
		model.addAttribute("pwFind", new MemberDTO());
	}
	
	
	//비밀번호 찾기
	@RequestMapping(value="/findPw")//,method=RequestMethod.POST)
	public String findPw(@Valid @ModelAttribute("pwFind") MemberDTO mdto, BindingResult result, Model model) {
		
		logger.info("String findPw 호출됨!");
		
		String pw = null;
		
		if(result.hasErrors()) {
			logger.info(result.toString());			
			return "/login/loginForm";
		}
		
		pw = memberSvc.getMemberPw(mdto.getId(), mdto.getTel(), mdto.getNickname());
		
		model.addAttribute("pw", pw);
		
		return "/login/memberPwFindForm";	
	
	}	

}
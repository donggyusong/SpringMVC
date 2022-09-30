package kr.board.controller;

import java.io.File;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import kr.board.entity.Member;
import kr.board.mapper.MemberMapper;

@Controller
public class MemberController {
	
	@Autowired
	MemberMapper memberMapper;
	
	@RequestMapping("/memJoin.do")
	public String memRegister() {
		//회원가입 요청폼 jsp
		return "member/join"; 
	}
	
	@RequestMapping("/memRegisterCheck.do")
	public @ResponseBody int memberRegisterCheck(@RequestParam("memID") String memID) {

		Member m = memberMapper.registerCheck(memID);
		
		if(m==null || memID.equals("")) {
			return 1; // 이미 존재하는 회원 또는 아이디를 입력안한 사람
		}
		
		return 0; //사용가능한 아이디
	}
	
	
	
	
	//회원가입 처리
	@RequestMapping("/memRegister.do")
	public String memRegister(Member member,
													  String memPassword1,
													  String memPassword2,
													  RedirectAttributes rttr,
													  HttpSession session) {
																													//세션 객체가 필요하면 매개변수로 받아서 쓰면 된다.
		//유효성 체크
		if(member.getMemID() == null || member.getMemID().equals("") ||
				memPassword1==null || memPassword1.equals("")||
				memPassword2==null || memPassword2.equals("")||
				member.getMemName()==null || member.getMemName().equals("")||
				member.getMemAge()==0||
				member.getMemGender() ==null || member.getMemGender().equals("")||
				member.getMemEmail()==null || member.getMemEmail().equals("")){
			
			
			
			//누락메세지를 가지고 리다이렉트를 해야한다.
			//근데 리다이렉트라서 객체 바인딩을 할 수 없다.
			//join.jsp로 메세지를 어떻게 보낼거냐? 그때 쓰는게 Spring에서는 제공해주는 RedirectAttributes가 있다.
			//이건 리다이렉트가 되었을 때 값을 리다이렉트 페이지로 한번만 전달할 수 있다.
			//이 RedirectAttributes에다가 객체 바인딩을 시키자.
			//원래 객체바인딩은 Model, HttpServletRequest, HttpSession 이런곳에 했다. 
			//근데 Model이나 HttpServletRequest에 하면 리다이렉트 할 때 객체가 새로 생성되므로 객체 바인딩을 하는게 의미가 없다.
			//HttpSession에 해도 되긴하는데 이건 회원인증할때나 쓰는거다.
			
			//객체바인딩을 한번만 할거라는게 FlashAttribute이다.
			rttr.addFlashAttribute("msgType", "실패 메세지");
			rttr.addFlashAttribute("msg", "모든 내용을 입력하세요");
			//이렇게 바인딩 해놓으면 EL로 ${msgType} 이렇게 꺼내서 쓸 수 있다.
			
			return "redirect:/memJoin.do";
		}
		
		//password1과 password2가 같지 않으면 또 경고문을 뛰어줘야 한다.
		if(!memPassword1.equals(memPassword2)) {
			rttr.addFlashAttribute("msgType", "실패 메세지");
			rttr.addFlashAttribute("msg", "비밀번호가 서로 다릅니다.");
			return "redirect:/memJoin.do";
		}
		
		member.setMemProfile("");  //지금 사진이미지는 없으므로 "" 공백을 넣었다.
												//왜냐면 아무것도 안넣으면 null이 들어가므로 null과 공백의 의미는 다르기 때문이다.
		
		
		//회원 테이블 저장하기
		int result =  memberMapper.register(member);
		
		if(result == 1) {
			//회원 가입 성공
			//-> 회원가입성공메세지
			rttr.addFlashAttribute("msgType", "성공 메세지");
			rttr.addFlashAttribute("msg", "회원가입에 성공했습니다");
			
			//회원가입이 성공하면 바로 로그인이 되게 처리를 해보자
			session.setAttribute("mvo",member);
			
			return "redirect:/"; // index.jsp로 리다이렉트
			
		}else {
			//회원 가입 실패 
			//-> 회원가입실패 메세지
			rttr.addFlashAttribute("msgType", "실패 메세지");
			rttr.addFlashAttribute("msg", "이미 존재하는 회원입니다.");
			
			//회원가입 실패시 다시 회원등록 페이지로 리다이렉트하자
			return "redirect:/memJoin.do";
		}
	}
	
	
	//로그아웃처리
	@RequestMapping("/memLogout.do")
	public String memLogout(HttpSession session) {
			session.invalidate();
			return "redirect:/";
	}
	
	//로그인 화면으로 이동
	@RequestMapping("/memLoginForm.do")
	public String memLoginForm() {
		return "member/memLoginForm"; //memLoginForm.jsp
	}
	
	//로그인 기능 구현
	@RequestMapping("/memLogin.do")
	public String memLogin(Member member, RedirectAttributes rttr, HttpSession session) {
		
		System.out.println(member.getMemID());
		System.out.println(member.getMemPassword());
		
		if(member.getMemID()==null || member.getMemPassword().equals("")||
				member.getMemPassword()==null || member.getMemPassword().equals("")) {
			rttr.addFlashAttribute("msgType","실패 메세지");
			rttr.addFlashAttribute("msg","모든 내용을 입력해주세요");
			
			return "redirect:/memLoginForm.do";
		}
		
		Member mvo = memberMapper.memLogin(member);
		System.out.println(mvo);
		if(mvo!=null) { //
			rttr.addFlashAttribute("msgType","성공 메세지");
			rttr.addFlashAttribute("msg","로그인에 성공했습니다.");
			
			session.setAttribute("mvo",mvo);
			
			return "redirect:/"; //메인으로 돌아가자
		}else {
			rttr.addFlashAttribute("msgType","실패 메세지");
			rttr.addFlashAttribute("msg","다시 로그인 해주세요");
			
			return "redirect:/memLoginForm.do";
		}
		

	}
	
	
	
	
	
	//회원정보수정화면
	@RequestMapping("/memUpdateForm.do")
	public String memUpdateForm() {
		
		return "member/memUpdateForm";
	}
	
	//회원정보업데이트
	@RequestMapping("/memUpdate.do")
	public String memUpdate(Member m, RedirectAttributes rttr,
													String memPassword1,String memPassword2, HttpSession session) {
		
		if(m.getMemID() == null || m.getMemID().equals("") ||
			memPassword1==null || memPassword1.equals("")||
			memPassword2==null || memPassword2.equals("")||
			m.getMemName()==null || m.getMemName().equals("")||
			m.getMemAge()==0||
			m.getMemGender() ==null || m.getMemGender().equals("")||
			m.getMemEmail()==null || m.getMemEmail().equals("")){
			
			
			rttr.addFlashAttribute("msgType", "실패 메세지");
			rttr.addFlashAttribute("msg", "모든 내용을 입력하세요");
			//이렇게 바인딩 해놓으면 EL로 ${msgType} 이렇게 꺼내서 쓸 수 있다.
			
			return "redirect:/memUpdateForm.do";
		}
		
		//password1과 password2가 같지 않으면 또 경고문을 뛰어줘야 한다.
		if(!memPassword1.equals(memPassword2)) {
			rttr.addFlashAttribute("msgType", "실패 메세지");
			rttr.addFlashAttribute("msg", "비밀번호가 서로 다릅니다.");
			return "redirect:/memUpdateForm.do";
		}
		
		//회원 수정 저장하기
		int result =  memberMapper.memUpdate(m);
		
		if(result == 1) {
			//회원 수정 성공
			//-> 회원수정성공메세지
			rttr.addFlashAttribute("msgType", "성공 메세지");
			rttr.addFlashAttribute("msg", "회원 정보 수정에 성공했습니다");
			
			//회원가입이 성공하면 바로 로그인이 되게 처리를 해보자
			session.setAttribute("mvo",m);
			
			return "redirect:/"; // index.jsp로 리다이렉트
			
		}else {
			//회원 수정 실패 
			//-> 회원수정실패 메세지
			rttr.addFlashAttribute("msgType", "실패 메세지");
			rttr.addFlashAttribute("msg", "회원정보 수정에 실패했습니다");
			
			//회원수정 실패시 다시 회원수정 페이지로 리다이렉트하자
			return "redirect:/memUpdateForm.do";
		}
	}
	
	
	//회원의 사진등록 화면
	@RequestMapping("/memImageForm.do")
	public String memImageForm() {
		return "member/memImageForm";
	}
	
	
	//회원사진 이미지 업로드(upload/파일이름 DB 저장)
	@RequestMapping("/memImageUpdate.do")
	public String memImageUpdate(HttpServletRequest request, RedirectAttributes rttr,HttpSession session) {
		// 파일업로드 API(cos.jar)
		MultipartRequest multi = null;
		
		//업로드할 파일 사이즈
		int fileMaxSize = 10*1024*1024; //10MB를 의미한다.
		
		//업로드할 경로 지정
		String savePath = request.getRealPath("resources/upload");
		System.out.println("savePath");
		System.out.println(savePath);
		
				
		try {
			//MultipartRequest라는 클래스가 실제 업로드를 해주는 객체이다.
			//이 객체를 생성시 정보를 넣어줘야한다.
			//파라미터 정보를 가져오기 위해 request 객체를 넣어줘야한다.
			//어디다 업로드할 지 경로
			//업로드 할 파일의 최대 크기
			//동일 이름의 파일이 업로드 될 때 리네임을 해주는 클래스인 DefaultFileRenamePolicy()
			multi = new MultipartRequest(request,savePath,fileMaxSize,"UTF-8",new DefaultFileRenamePolicy());
			
		}catch(Exception e) {
			//용량이 크거나 하면 에러가 날거다.
			e.printStackTrace();
			rttr.addFlashAttribute("msgType", "실패 메세지");
			rttr.addFlashAttribute("msg", "파일의 크기는 10MB를 넘을 수 없습니다.");
			
			//파일을 서버에 올릴려면 톰캣이 응답을 해줘야하는데 파일의 용량이 크면 톰캣이 크기를 커버 못해서 인터넷을 끊어버리고 멈춘다.
			//그래서 파일을 등록하면 "사이트에 연결할 수 없다" 하고 인터넷을 끊어버린다.
			//서버가 파일 용량을  10MB이상까지 커버를 해줘야 에러가 나서 에러 메세지가 뜨는데 그 전에 그걸 커버를 못해서 인터넷을 끊어버린다.
			//이 문제를 해결하려면 톰캣서버에 뭘 해줘야 한다. server.xml에서  63번째 줄에서 Connector 태그에서 maxSwallowSize="-1"값을 주면 된다.
			//그러면 최대한 딜레이를  시키는거다. 이게 없으면 기본값으로만 딜레이 해보다가 그게 오버가 되면 톰캣이 멈추기 때문에 이 속성을 주자.
			//인터넷에 maxswallowsize server.xml을 검색해서 공부해보자.
			// 톰캣 서버가 일단 대용량의 파일을 업로드를 할 때 그 제한을하지 않겠다는거다. 기본이 2MB인데 그걸 넘어버리면 인터넷을 끊어버린다.
			//이 제한을 해제해주고 프로그램에서 10MB가 넘었을 때 그걸 예외처리로 커버를 해주는거다.
			
			//보통 10MB 이상을 올리지도 않고 자스에서 용량체크를 해서 10MB를 못올리도록 제한을 걸 수 있다.
			return "redirect:/memImageForm.do";
		}
		//우선 여기까지한게 파일을 업로드 시킬 객체를 만들어서 파일업로드를 하고 파일 업로드 실패시 예외처리를 했다.		
		
		
		
		//이제 데이터 베이스 테이블에 기존 회원이미지 말고 새로 업로드한 회원이미지로 업데이트 하자
		
		//여기에 복붙하자
		
		return "redirect:/";
		
	}


}

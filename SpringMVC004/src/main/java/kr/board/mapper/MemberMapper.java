package kr.board.mapper;


import org.apache.ibatis.annotations.Mapper;

import kr.board.entity.AuthVO;
import kr.board.entity.Member;

@Mapper
public interface MemberMapper {
	
	//아이디 중복 체크
	public Member registerCheck(String memID);
	
	//회원 등록
	public int register(Member m); //성공이면 1, 실패면 0을 리턴해준다.
	
	//로그인 체크
	public Member memLogin(Member mvo);
	
	//회원 수정
	public int memUpdate(Member mvo);
	
	public Member getMember(String memID);
	
	public void memProfileUpdate(Member mvo);
	
	//회원 권한 저장
	public void authInsert(AuthVO auth);
	
	//회원 권한 삭제
	public void authDelete(String memID);
	
}
